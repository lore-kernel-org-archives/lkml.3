Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3AUVAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:00:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab3AUVAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:00:11 -0500
Date: Mon, 21 Jan 2013 22:00:08 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-ID: <20130121210008.GB23041@quack.suse.cz>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
 <20130115233742.e8571f92.akpm@linux-foundation.org>
 <20130116101644.GA29162@quack.suse.cz>
 <20130116145005.e20f4e53.akpm@linux-foundation.org>
 <20130116235529.GA10251@quack.suse.cz>
 <20130116161118.f6e2e6a4.akpm@linux-foundation.org>
 <20130117210442.GA23984@quack.suse.cz>
 <20130117133917.0f75728e.akpm@linux-foundation.org>
 <20130117234614.GB10127@quack.suse.cz>
 <20130117155029.cb70ec95.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20130117155029.cb70ec95.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 17-01-13 15:50:29, Andrew Morton wrote:
> On Fri, 18 Jan 2013 00:46:14 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Thu 17-01-13 13:39:17, Andrew Morton wrote:
> > > On Thu, 17 Jan 2013 22:04:42 +0100
> > > Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > ...
> > > >
> > > >   So I played a bit with this. To make things easier for me I added
> > > > artificial mdelay(len*10) (effectively simulating console able to print 100
> > > > characters per second) just after call_console_drivers() so that I can
> > > > trigger issues even on a machine easily available to me. Booting actually
> > > > doesn't trigger any problems because there aren't enough things happening
> > > > in parallel on common machine during boot but
> > > >   echo t >/proc/sysrq-trigger &
> > > >   for i in /lib/modules/3.8.0-rc3-0-default/kernel/fs/*/*.ko; do 
> > > >     name=`basename $i`; name=${name%.ko}; modprobe $name
> > > >   done
> > > > easily triggers the problem (as modprobe uses both RCU & IPIs to signal all
> > > > CPUs).
> > > > 
> > > >   Adding
> > > > 	touch_nmi_watchdog();
> > > > 	touch_all_softlockup_watchdogs();
> > > > 	rcu_cpu_stall_reset();
> > > 
> > > I'm not sure that touch_all_softlockup_watchdogs() is needed? 
> > > touch_nmi_watchdog() itself calls touch_softlockup_watchdog().
> >   It is. I've tried without it and the machine died a horrible death
> > because softlockup reports added to already too heavy printk traffic. The
> > problem is that CPU doing printing cannot handle IPIs thus if someone calls
> > e.g. smp_call_function_many() that function will spin waiting for IPIs on
> > all CPUs to finish. And that doesn't happen until printing is done so
> > CPU doing smp_call_function_many() gets locked up as well.
> 
> erk.  I trust we'll have a nice comment explaining this mechanism ;)
  So I was testing the attached patch which does what we discussed. The bad
news is I was able to trigger a situation (twice) when suddently sda
disappeared and thus all IO requests failed with EIO. There is no trace of
what's happened in the kernel log. I'm guessing that disabled interrupts on
the printing CPU caused scsi layer to time out for some request and fail the
device. So where do we go from here?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--FkmkrVfFsRoUs1wW
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-printk-Avoid-softlockup-reports-during-heavy-printk-.patch"

>From 9373cb89d434519089a1a6a0955aef08c814d70f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 21 Jan 2013 20:30:20 +0100
Subject: [PATCH] printk: Avoid softlockup reports during heavy printk traffic

A CPU can be caught in console_unlock() for a long time (tens of seconds are
reported by our customers) when other CPUs are using printk heavily and serial
console makes printing slow.  This triggers softlockup warnings because
interrupts are disabled for the whole time console_unlock() runs (e.g.
vprintk() calls console_unlock() with interrupts disabled).

It doesn't trigger hardlockup reports because serial drivers already call
touch_nmi_watchdog() but that's not enough in some cases. For example if some
process uses on_each_cpu(), smp_call_function() will block until IPI on the
printing CPU is processed and that doesn't happen for tens of seconds so the
CPU where on_each_cpu() is executing is locked up as well.

Postponing the printing to a worker thread was deemed too risky (see discussion
in the thread starting with https://lkml.org/lkml/2013/1/15/438) so here we
take a less risky approach and just silence all the watchdogs. We have to be
careful not to make them completely useless by touching them too often so we
touch the watchdogs only every 1000 characters we print in one console_unlock()
call. That should really happen only during boot, when printing sysrq-t output,
or in similarly extreme situations.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 357f714..1cbae2b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -2043,6 +2043,7 @@ void console_unlock(void)
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	unsigned int printed = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -2103,8 +2104,30 @@ skip:
 
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
+		printed += len;
 		start_critical_timings();
 		local_irq_restore(flags);
+
+		/*
+		 * If we already printed too much, touch watchdogs. The limit
+		 * is set high enough so that it happens really rarely (and
+		 * printk traffic doesn't render lockup watchdogs useless) but
+		 * low enough so that even slower serial console doesn't cause
+		 * lockup reports. 9600 baud serial console prints 1000 chars
+		 * in about 1 second...
+		 */
+		if (printed > 1000) {
+			touch_nmi_watchdog();
+			/*
+			 * This is needed because other CPUs may be waiting on
+			 * this CPU to process IPI so they are stalled as well.
+			 */
+			touch_all_softlockup_watchdogs();
+			local_irq_save(flags);
+			rcu_cpu_stall_reset();
+			local_irq_restore(flags);
+			printed = 0;
+		}
 	}
 	console_locked = 0;
 	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
-- 
1.7.1


--FkmkrVfFsRoUs1wW--
