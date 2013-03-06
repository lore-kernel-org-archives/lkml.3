Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3CFPqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:46:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3CFPqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:46:14 -0500
Date: Wed, 6 Mar 2013 16:44:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
Message-ID: <20130306154420.GA7697@redhat.com>
References: <201303042055.38040.maciej.rutecki@gmail.com> <1362504883-9180-1-git-send-email-msb@chromium.org> <20130305174838.GA7276@redhat.com> <CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com> <20130305180542.GA12738@redhat.com> <CACBanvr7XvXbFjphpRwKHHJKzVuA-s6sF-qkPiizBV3+uqzpJw@mail.gmail.com> <20130305232603.GA16045@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305232603.GA16045@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Henrique de Moraes Holschuh wrote:
>
> On Tue, 05 Mar 2013, Mandeep Singh Baines wrote:
> > This mutex seems wrong. Its held the entire time the kthread is
> > running. I think its used to synchronize on the exit of the kthread. A
> > completion would more appropriate in that case.
>
> From the top of the driver source:
>
> /* Acquired while the poller kthread is running, use to sync start/stop */
> static struct mutex hotkey_thread_mutex;

I simply can't understand what this "sync start/stop" means...

Ignoring hotkey_kthread(), the only user is

	static void hotkey_poll_stop_sync(void)
	{
		if (tpacpi_hotkey_task) {
			kthread_stop(tpacpi_hotkey_task);
			tpacpi_hotkey_task = NULL;
			mutex_lock(&hotkey_thread_mutex);
			/* at this point, the thread did exit */
			mutex_unlock(&hotkey_thread_mutex);
		}
	}

And I simply do not understand the comment. This thread has already exited
when kthread_stop() returns (OK, it can be running do_exit() paths but this
doesn't matter). So this mutex_lock() buys nothing afaics.

As for serializing with hotkey_poll_setup/etc, looks like this code relies
on hotkey_mutex.

So I think hotkey_thread_mutex can be simply removed?

Oleg.

