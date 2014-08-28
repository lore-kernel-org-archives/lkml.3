Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaH1XH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:07:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaH1XHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:07:25 -0400
Date: Thu, 28 Aug 2014 16:07:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] softlockup: Make detector be aware of task switch of
 processes hogging cpu
Message-Id: <20140828160723.b174b4e03f2854d0a5146199@linux-foundation.org>
In-Reply-To: <1409201544-82371-1-git-send-email-dzickus@redhat.com>
References: <1409201544-82371-1-git-send-email-dzickus@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014 00:52:24 -0400 Don Zickus <dzickus@redhat.com> wrote:

> From: chai wen <chaiw.fnst@cn.fujitsu.com>
> 
> For now, soft lockup detector warns once for each case of process softlockup.
> But the thread 'watchdog/n' may not always get the cpu at the time slot between
> the task switch of two processes hogging that cpu to reset soft_watchdog_warn.
> 
> An example would be two processes hogging the cpu.  Process A causes the
> softlockup warning and is killed manually by a user.  Process B immediately
> becomes the new process hogging the cpu preventing the softlockup code from
> resetting the soft_watchdog_warn variable.
> 
> This case is a false negative of "warn only once for a process", as there may
> be a different process that is going to hog the cpu.  Resolve this by
> saving/checking the task pointer of the hogging process and use that to reset
> soft_watchdog_warn too.
> 

OK, this should address the PID uniqueness issue which Ingo identified.

> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -47,6 +47,7 @@ static DEFINE_PER_CPU(bool, softlockup_touch_sync);
>  static DEFINE_PER_CPU(bool, soft_watchdog_warn);
>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
>  static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
> +static DEFINE_PER_CPU(struct task_struct *, softlockup_task_ptr_saved);
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  static DEFINE_PER_CPU(bool, hard_watchdog_warn);
>  static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
> @@ -331,8 +332,20 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  			return HRTIMER_RESTART;
>  
>  		/* only warn once */
> -		if (__this_cpu_read(soft_watchdog_warn) == true)
> +		if (__this_cpu_read(soft_watchdog_warn) == true) {
> +			/*
> +			 * Handle the case where multiple processes are
> +			 * causing softlockups but the duration is small
> +			 * enough, the softlockup detector can not reset
> +			 * itself in time.  Use task pointers to detect this.
> +			 */

This comment is rather hard to follow ("the duration" of what?).  Can
you think of some words which are a bit more complete/clear?


