Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab3B0DJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:09:15 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54627 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3B0DJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:09:12 -0500
Message-ID: <1361934532.23781.54.camel@thor.lan>
Subject: Re: [PATCH v4 00/32] ldisc patchset
From: Peter Hurley <peter@hurleysoftware.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>
Date: Tue, 26 Feb 2013 22:08:52 -0500
In-Reply-To: <5128F16E.30804@gmail.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <51261E30.9040907@gmail.com> <1361453910.10685.7.camel@thor.lan>
	 <1361558250.14402.6.camel@thor.lan> <5128DF40.7030003@gmail.com>
	 <5128F16E.30804@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-23 at 11:42 -0500, Sasha Levin wrote:
> Hi Peter,
>
> I've also got this one for the first time:
> [  484.450139] INFO: task init:1 blocked for more than 120 seconds.
> [  484.451130] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  484.452013] init            D 00000000001d7180  2688     1      0 0x00000002
> [  484.452883]  ffff8800b9acfba8 0000000000000002 00000000001d7180 ffff8800b9b10048
> [  484.453816]  ffff8800b94cb000 ffff8800b9b10000 00000000001d7180 00000000001d7180
> [  484.454529]  ffff8800b9b10000 ffff8800b9acffd8 00000000001d7180 00000000001d7180
> [  484.455232] Call Trace:
> [  484.455515]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
> [  484.456081]  [<ffffffff83db9b35>] schedule+0x55/0x60
> [  484.456636]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
> [  484.457263]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
> [  484.457866]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
> [  484.458539]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
> [  484.459223]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
> [  484.459822]  [<ffffffff83dbab61>] down_failed+0x131/0x200
> [  484.460512]  [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
> [  484.461376]  [<ffffffff83dbae03>] ldsem_down_write+0xd3/0x113
> [  484.461895]  [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
> [  484.462824]  [<ffffffff8118264d>] ? trace_hardirqs_on+0xd/0x10
> [  484.463504]  [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120
> [  484.464258]  [<ffffffff81c3df60>] tty_ldisc_hangup+0xd0/0x220
> [  484.464825]  [<ffffffff81c35bd7>] __tty_hangup+0x137/0x4f0
> [  484.465684]  [<ffffffff81c37c7c>] disassociate_ctty+0x6c/0x230
> [  484.466607]  [<ffffffff8111290c>] do_exit+0x41c/0x590
> [  484.467419]  [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
> [  484.468413]  [<ffffffff81112b4a>] do_group_exit+0x8a/0xc0
> [  484.469281]  [<ffffffff81112b92>] sys_exit_group+0x12/0x20
> [  484.470159]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
> [  484.470951] 1 lock held by init/1:
> [  484.471513]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120

Hi Sasha,

What's your setup here? Are you booting directly to a shell?

Because I'm wondering how init has a tty.
Also, init is exiting here -- upstart only exits when commanded or on
SIGSEGV or SIGABRT.

What's going on here is:
1. some process is in a blocking read from a console
   (and has an ldisc lock)
2. init is exiting
3. init being the session leader hangs up the tty
4. as part of tty hangup, waiting readers and writers are woken
5. hangup waits for all readers and writers to exit their i/o loops
   (and drop their ldisc locks)
6. the process from step 1 wakes up and re-checks
   a. input available?  no.
   b. other pty closed? no, this isn't a pty pair.
   c. file hung up? no, open consoles are not hung up.
   d. signal pending? no.
7. goes back to sleep

This is only indirectly related to the patchset in that the patchset
rightly ensures the ldisc will not be closed while in use.

The actual problem is that disassociate_tty() tries to hang up the tty
_before_ signalling processes in the (foreground) process group. This is
why the blocking reader didn't exit -- it had not received a signal
because the signal has not yet been sent.

OTOH, why try to hangup the ldisc at all if consoles are using the tty?
I'll have to think some more before I send a patch for this.

In the meantime, if this (or the other thing) happen again, I'd really
appreciate if you could get a sysrq-d for any of the ldisc/tty related
reports.

Thanks,
Peter Hurley

