Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbaDWVOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:14:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaDWVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:14:09 -0400
Date: Wed, 23 Apr 2014 14:14:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com,
        Aaron Tomlin <atomlin@redhat.com>
Subject: Re: [PATCH 2/2 v4] watchdog: Printing traces for all cpus on lockup
 detection
Message-Id: <20140423141407.6c38ee453d4c88c36fdfb062@linux-foundation.org>
In-Reply-To: <1398285605-147082-3-git-send-email-dzickus@redhat.com>
References: <1398285605-147082-1-git-send-email-dzickus@redhat.com>
	<1398285605-147082-3-git-send-email-dzickus@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 16:40:05 -0400 Don Zickus <dzickus@redhat.com> wrote:

> From: Aaron Tomlin <atomlin@redhat.com>
> 
> A 'softlockup' is defined as a bug that causes the kernel to
> loop in kernel mode for more than a predefined period to
> time, without giving other tasks a chance to run.
> 
> Currently, upon detection of this condition by the per-cpu
> watchdog task, debug information (including a stack trace)
> is sent to the system log.
> 
> On some occasions, we have observed that the "victim" rather
> than the actual "culprit" (i.e. the owner/holder of the
> contended resource) is reported to the user.
> Often this information has proven to be insufficient to
> assist debugging efforts.
> 
> To avoid loss of useful debug information, for architectures
> which support NMI, this patch makes it possible to improve
> soft lockup reporting. This is accomplished by issuing an
> NMI to each cpu to obtain a stack trace.
> 
> If NMI is not supported we just revert back to the old method.
> A sysctl and boot-time parameter is available to toggle this
> feature.
> 
> --- a/include/linux/nmi.h
> +++ b/include/linux/nmi.h
> @@ -57,6 +57,9 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *);
>  u64 hw_nmi_get_sample_period(int watchdog_thresh);
>  extern int watchdog_user_enabled;
>  extern int watchdog_thresh;
> +#ifdef CONFIG_SMP
> +extern int sysctl_softlockup_all_cpu_backtrace;
> +#endif

The ifdefs aren't really needed here.  If we omit them then error
reporting happens at link time rather than at compile time, but that's
a small price to pay for cleaning up the code.

> +		if (softlockup_all_cpu_backtrace) {
> +			/* Prevent multiple soft-lockup reports if one cpu is already
> +			 * engaged in dumping cpu back traces
> +			 */
> +			if (test_and_set_bit(0, &soft_lockup_nmi_warn)) {
> +				/* Someone else will report us. Let's give up */
> +				__this_cpu_write(soft_watchdog_warn, true);
> +				return HRTIMER_RESTART;
> +			}
> +		}

You missed my suggestion here.

   text    data     bss     dec     hex filename
   1519     524      24    2067     813 kernel/watchdog.o-before
   1471     520      16    2007     7d7 kernel/watchdog.o-after


--- a/include/linux/nmi.h~watchdog-printing-traces-for-all-cpus-on-lockup-detection-fix
+++ a/include/linux/nmi.h
@@ -57,9 +57,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
-#ifdef CONFIG_SMP
 extern int sysctl_softlockup_all_cpu_backtrace;
-#endif
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
--- a/kernel/watchdog.c~watchdog-printing-traces-for-all-cpus-on-lockup-detection-fix
+++ a/kernel/watchdog.c
@@ -31,7 +31,12 @@
 
 int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+#ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
+#else
+#define sysctl_softlockup_all_cpu_backtrace 0
+#endif
+
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
_

