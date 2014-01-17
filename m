Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaAQB6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:58:46 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37162 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaAQB6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:58:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1401161521340.1084@eggly.anvils>
References: <alpine.LSU.2.11.1401161521340.1084@eggly.anvils>
Date: Fri, 17 Jan 2014 09:58:43 +0800
Message-ID: <CACVXFVO_+YYLsj1JwRW2HeeimFz841RQ_Uu3KhhSDnVLep2_5A@mail.gmail.com>
Subject: Re: [PATCH] percpu_counter: unbreak __percpu_counter_add()
From: Ming Lei <tom.leiming@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>,
        Fan Du <fan.du@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 7:26 AM, Hugh Dickins <hughd@google.com> wrote:
> Commit 74e72f894d56 ("lib/percpu_counter.c: fix __percpu_counter_add()")
> looked very plausible, but its arithmetic was badly wrong: obvious once
> you see the fix, but maddening to get there from the weird tmpfs ENOSPCs
>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>
>  lib/percpu_counter.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- 3.13-rc8+/lib/percpu_counter.c      2014-01-15 09:53:27.768111792 -0800
> +++ linux/lib/percpu_counter.c  2014-01-16 14:58:54.156555308 -0800
> @@ -82,7 +82,7 @@ void __percpu_counter_add(struct percpu_
>                 unsigned long flags;
>                 raw_spin_lock_irqsave(&fbc->lock, flags);
>                 fbc->count += count;
> -                __this_cpu_sub(*fbc->counters, count);
> +               __this_cpu_sub(*fbc->counters, count - amount);

Hammmm, you are right, thanks for the fix, and I really tested the patch
with reinserting module of 'null_blk' after lots of IOs, now I know the
reason:  the scale of my test is still too small to cover the slow path
in case of the batch of 1000000, and only the part in fast path is verified
to be OK.


Thanks,
-- 
Ming Lei
