Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab3CGRzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab3CGRzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:55:19 -0500
Date: Thu, 7 Mar 2013 18:53:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/1] thinkpad-acpi: kill hotkey_thread_mutex
Message-ID: <20130307175305.GA15631@redhat.com>
References: <201303042055.38040.maciej.rutecki@gmail.com> <1362504883-9180-1-git-send-email-msb@chromium.org> <20130305174838.GA7276@redhat.com> <CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com> <20130305180542.GA12738@redhat.com> <CACBanvr7XvXbFjphpRwKHHJKzVuA-s6sF-qkPiizBV3+uqzpJw@mail.gmail.com> <20130305232603.GA16045@khazad-dum.debian.net> <20130306154420.GA7697@redhat.com> <20130306233232.GA12645@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306233232.GA12645@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Henrique de Moraes Holschuh wrote:
>
> On Wed, 06 Mar 2013, Oleg Nesterov wrote:
> >
> > 	static void hotkey_poll_stop_sync(void)
> > 	{
> > 		if (tpacpi_hotkey_task) {
> > 			kthread_stop(tpacpi_hotkey_task);
> > 			tpacpi_hotkey_task = NULL;
> > 			mutex_lock(&hotkey_thread_mutex);
> > 			/* at this point, the thread did exit */
> > 			mutex_unlock(&hotkey_thread_mutex);
> > 		}
> > 	}
> >
> > And I simply do not understand the comment. This thread has already exited
> > when kthread_stop() returns (OK, it can be running do_exit() paths but this
> > doesn't matter). So this mutex_lock() buys nothing afaics.
>
> It was added due to an oops, waaaaay back then.  If it is not needed
> anymore, and there is zero chance of the kthread still being active when
> hotkey_poll_stop_sync() ends, hotkey_thread_mutex can be simply removed.

Well, there could be another bug. Say, hotkey_poll_stop_sync() can block
on hotkey_thread_mutex if another thread was started. But at first glance
this can't happen (hotkey_mutex), and even _if_ it can this needs another
fix.

> Looks like it, if the current semanthics of ktread_stop() are syncronous.

IIRC, it always was... But at least currently it is certainly syncronous.
kthread_stop(t) does wait_for_completion(t->vfork_done), complete(vfork_done)
can't happen unless this task calls do_exit().

Hmm. I just noticed that the recent changes in kthread_stop() are not correct...
But this is offtopic and doesn't affect thinkpad_acpi.c, I'll write another
email later.

So, what do you think about (UNTESTED) 1/1 ?

Oleg.

