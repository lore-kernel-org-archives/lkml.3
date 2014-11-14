Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927AbaKNCHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:07:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:26881 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933518AbaKNCHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:07:49 -0500
Date: Thu, 13 Nov 2014 21:07:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: namhyung@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC v2] trace, blktrace: don't let the sysfs interface
 remove trace from running list
Message-ID: <20141113210744.7a725036@gandalf.local.home>
In-Reply-To: <1415616049-1132-1-git-send-email-avanzini.arianna@gmail.com>
References: <8761env4vf.fsf@sejong.aot.lge.com>
	<1415616049-1132-1-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jens (Cc'd) maintains the blktrace. He can take this if he wants.

-- Steve


On Mon, 10 Nov 2014 11:40:49 +0100
Arianna Avanzini <avanzini.arianna@gmail.com> wrote:

> Currently, blktrace can be started/stopped via its ioctl-based interface
> (used by the userspace blktrace tool) or via its ftrace interface. The
> function blk_trace_remove_queue(), called each time an "enable" tunable
> of the ftrace interface transitions to zero, removes the trace from the
> running list, even if no function from the sysfs interface adds it to
> such a list. This leads to a null pointer dereference.
> This commit changes the blk_trace_remove_queue() function so that it
> does not remove the blk_trace from the running list.
> 
> v2:
>     - Now the patch removes the invocation of list_del() instead of
>       adding an useless if branch, as suggested by Namhyung Kim.
> 
> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
> ---
>  kernel/trace/blktrace.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index c1bd4ad..bd05fd2 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1493,9 +1493,6 @@ static int blk_trace_remove_queue(struct request_queue *q)
>  	if (atomic_dec_and_test(&blk_probes_ref))
>  		blk_unregister_tracepoints();
>  
> -	spin_lock_irq(&running_trace_lock);
> -	list_del(&bt->running_list);
> -	spin_unlock_irq(&running_trace_lock);
>  	blk_trace_free(bt);
>  	return 0;
>  }

