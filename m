Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3IJQD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:03:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab3IJQD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:03:27 -0400
Message-ID: <1378829005.12992.30.camel@flatline.rdu.redhat.com>
Subject: Re: [RFC] audit: avoid soft lockup in audit_log_start()
From: Eric Paris <eparis@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org, rgb@redhat.com
Date: Tue, 10 Sep 2013 12:03:25 -0400
In-Reply-To: <522DDBED.2020505@openvz.org>
References: <20130828182114.6b67ea90@redhat.com>
	 <522DDBED.2020505@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 18:32 +0400, Konstantin Khlebnikov wrote:
> Luiz Capitulino wrote:
> > I'm getting the following soft lockup:
> >
> > CPU: 6 PID: 2278 Comm: killall5 Tainted: GF            3.11.0-rc7+ #1
> > Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> >   0000000000000099 ffff88011fd83de8 ffffffff815324df 0000000000002800
> >   ffffffff817d48f9 ffff88011fd83e68 ffffffff8152e669 ffff88011fd83e68
> >   ffffffff00000008 ffff88011fd83e78 ffff88011fd83e18 0000004081dac040
> > Call Trace:
> >   <IRQ>   [<ffffffff815324df>] dump_stack+0x46/0x58
> >   [<ffffffff8152e669>] panic+0xbb/0x1c4
> >   [<ffffffff810d03c3>] watchdog_timer_fn+0x163/0x170
> >   [<ffffffff8106c691>] __run_hrtimer+0x81/0x1c0
> >   [<ffffffff810d0260>] ? watchdog+0x30/0x30
> >   [<ffffffff8106cea7>] hrtimer_interrupt+0x107/0x240
> >   [<ffffffff8102f61b>] local_apic_timer_interrupt+0x3b/0x60
> >   [<ffffffff81542465>] smp_apic_timer_interrupt+0x45/0x60
> >   [<ffffffff8154124a>] apic_timer_interrupt+0x6a/0x70
> >   <EOI>   [<ffffffff810c2f5f>] ? audit_log_start+0xbf/0x430
> >   [<ffffffff810c2fe7>] ? audit_log_start+0x147/0x430
> >   [<ffffffff81079030>] ? try_to_wake_up+0x2a0/0x2a0
> >   [<ffffffff810c86be>] audit_log_exit+0x6ae/0xc30
> >   [<ffffffff81188662>] ? __alloc_fd+0x42/0x100
> >   [<ffffffff810c98e7>] __audit_syscall_exit+0x257/0x2b0
> >   [<ffffffff81540794>] sysret_audit+0x17/0x21
> >
> > The reproducer is somewhat unusual:
> >
> >   1. Install RHEL6.5 (maybe a similar older user-space will do)
> >   2. Boot the just installed system
> >   3. In this first boot you'll meet the firstboot script, which
> >      will do some setup and (depending on your answers) it will
> >      reboot the machine
> >   4. During that first reboot the system hangs while terminating
> >      all processes:
> >
> >         Sending all processes the TERM signal...
> >
> >      It's when the soft lockup above happens. And yes, I managed
> >      to get this with latest upstream kernel (HEAD fa8218def1b1)
> >
> > I'm reproducing it on a VM, but the first report was on bare-metal.
> >
> > This is what is happening:
> >
> >   1. audit_log_start() is called
> >   2. As we have SKBs waiting in audit_skb_queue and all conditions
> >      evaluate to true, we sleep in wait_for_auditd()
> >   3. Go to 2, until sleep_time gets negative and audit_log_start()
> >      just busy-waits
> >
> > Now, *why* this is happening is a mistery to me. I tried debugging
> > it, but all I could find is that at some point the kauditd thread
> > never wakes up after having called schedule(). I even tried waking
> > it up before calling wait_for_auditd(), but it didn't.
> 
> We run into the same problem in rhel6 kernel.
> 
> "readahead-collector" uses audit interface and sometimes stuck in 'stopped' state.
> 
> After commit 829199197a430dade2519d54f5545c4a094393b8
> (which was backported by RH into their kernel)
> audit emiters will block forever if userspace daemon cannot handle backlog.
> That commit just breaks timeout condition, after timeout waiting loop turns
> into busy loop until deamon dies or returns back to work.
> 
> this trivial patch should fix that problem
> 
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1215,9 +1215,10 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
> 
>                          sleep_time = timeout_start + audit_backlog_wait_time -
>                                          jiffies;
> -                       if ((long)sleep_time > 0)
> +                       if ((long)sleep_time > 0) {
>                                  wait_for_auditd(sleep_time);
> -                       continue;
> +                               continue;
> +                       }
>                  }
>                  if (audit_rate_check() && printk_ratelimit())
>                          printk(KERN_WARNING

I think this is the right(ish) fix, at least it gets at the real bug.
829199197a430dade2519d54f5545c4a094393b8 definitely is the problem.  The
60 second wait is NOT causing the soft lockup.  Instead after the 60
second wait, sleep_time, will go negative on subsequent trips through
the loop.  Since sleep_time is negative we will hit the continue and
loop FOREVER with no opportunity for progress.  Aka, softlockup...

I think it's a really ?interesting? (poor) coding style to leave
sleep_time going negative on the second trip through the loop to
indicate a timeout in wait_for_auditd().  Maybe the function should be
rewritten a bit.  Have a return code from wait_for_auditd, if it waited
60 seconds, call the failure function, if it succeeded in less the 60
seconds continue along...  At least something that makes the logic here
obvious.

I think Richard is also going to set audit_backlog_wait_time to 0 on
failure and will reset it to default on success.  To address the other
issue as well.  That is just dumb.

RGB should be taking care of it in RHEL as soon as he gets this worked
out.

-Eric

