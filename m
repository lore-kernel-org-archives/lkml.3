Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3CaWvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 18:51:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48981 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab3CaWu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 18:50:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 0/2] USB PM and PM QoS fixes (Re: gpf in pm_qos_remote_wakeup_show)
Date: Mon, 01 Apr 2013 00:56:31 +0200
Message-ID: <1876128.a4gSDF7byc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2829731.BFs3ri3Eud@vostro.rjw.lan>
References: <512F8980.4040809@oracle.com> <51576A0C.5030907@oracle.com> <2829731.BFs3ri3Eud@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 31, 2013 03:41:11 AM Rafael J. Wysocki wrote:
> [Moving the thread to the LKML.]
> 
> On Saturday, March 30, 2013 06:41:16 PM Sasha Levin wrote:
> > On 03/15/2013 01:06 PM, Rafael J. Wysocki wrote:
> [...]
> > >> Rafael, Is there anything you would like me to test?
> > > 
> > > Please just test 3.9-rc2 (or later).
> > 
> > Hi Rafael,
> 
> Hi,
> 
> > I got this after a bit of fuzzing, it looks related to the fix:
> 
> So the complaint is that we shouldn't call pm_qos_sysfs_remove_flags() under
> dev_pm_qos_mtx, because then it may deadlock with dev_pm_qos_update_flags()
> called from pm_qos_remote_wakeup_store(), for example.  This appears to be a
> valid one.
> 
> To avoid that, we can use a separate mutex for exposing/hiding the flags
> (and the latency limit too) that won't be acquired by dev_pm_qos_update_flags()
> or dev_pm_qos_update_request().
> 
> Can you please try the patch below?

Never mind, I have reproduced the lockdep splat and the patch fixes it for me.

Moreover, I've discovered that we call dev_pm_qos_hide_flags() from
usb_port_device_release(), which is totally incorrect.

So, I have two patches (on top of the Linus' tree) that will follow shortly:

[1/2] USB / PM: Don't try to hide PM QoS flags from usb_port_device_release()
[2/2] PM / QoS: Avoid possible deadlock related to sysfs access

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
