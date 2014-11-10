Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaKJIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:25:59 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56104 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaKJIZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:25:58 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] trace, blktrace: remove trace from running list only if trace is running
References: <1415459680-1749-1-git-send-email-avanzini.arianna@gmail.com>
Date: Mon, 10 Nov 2014 17:25:56 +0900
In-Reply-To: <1415459680-1749-1-git-send-email-avanzini.arianna@gmail.com>
	(Arianna Avanzini's message of "Sat, 8 Nov 2014 16:14:40 +0100")
Message-ID: <8761env4vf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arianna,

On Sat,  8 Nov 2014 16:14:40 +0100, Arianna Avanzini wrote:
> Currently, blktrace can be started/stopped via its ioctl-based interface
> (used by the userspace blktrace tool) or via its ftrace interface. The
> function blk_trace_remove_queue(), called each time an "enable" tunable
> of the ftrace interface transitions to zero, removes unconditionally the
> trace from the running list, even if its state is not Blktrace_running.
> In fact, the state of a blk_trace is modified only by the ioctl-based
> interface, and a blk_trace is added to the running list only when its
> state transitions from Blktrace_setup or Blktrace_stopped to
> Blktrace_running. If the ioctl-based interface is not being used, the
> state of the blk_trace is undefined.
> In this case, using the sysfs tunable to stop a trace would trigger a
> removal of a blk_trace from the running list while it is not on such a
> list, leading to a null pointer dereference. This commit attempts to fix
> the issue by letting the blk_trace_remove_queue() function remove the
> blk_trace from the running list only if its state is Blktrace_running.

What about just getting rid of the list_del()?  blk_trace_setup_queue()
doesn't add it to running_trace_list and I think we should prevent mix
of ioctl and sysfs usage somehow..

Thanks,
Namhyung


>
> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
> ---
>  kernel/trace/blktrace.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index c1bd4ad..f58b617 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1493,9 +1493,11 @@ static int blk_trace_remove_queue(struct request_queue *q)
>  	if (atomic_dec_and_test(&blk_probes_ref))
>  		blk_unregister_tracepoints();
>  
> -	spin_lock_irq(&running_trace_lock);
> -	list_del(&bt->running_list);
> -	spin_unlock_irq(&running_trace_lock);
> +	if (bt->trace_state == Blktrace_running) {
> +		spin_lock_irq(&running_trace_lock);
> +		list_del(&bt->running_list);
> +		spin_unlock_irq(&running_trace_lock);
> +	}
>  	blk_trace_free(bt);
>  	return 0;
>  }
