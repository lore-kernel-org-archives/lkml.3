Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3ILQdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:33:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3ILQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:33:49 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=8Xn6f6vUUR8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bsfkZG73aToA:10 a=pGLkceISAAAA:8 a=yNmjjCb9rB8HNEUXgLwA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=q9VEUjVdft50Nz9H:21 a=vg8MSBqdHlSUL3h5:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 12 Sep 2013 12:33:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Wang YanQing <udknight@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]trace: fix wrong help information about snapshot
Message-ID: <20130912123347.5bf5de1e@gandalf.local.home>
In-Reply-To: <20130912150401.GA3960@udknight>
References: <20130912150401.GA3960@udknight>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013 23:04:01 +0800
Wang YanQing <udknight@gmail.com> wrote:

> 
> Cat snapshot give me:
> " tracer: nop
> 
>  * Snapshot is freed *
> 
>  Snapshot commands:
>  echo 0 > snapshot : Clears and frees snapshot buffer
>  echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.
>                       Takes a snapshot of the main buffer.
>  echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
>                       (Doesn't have to be '2' works with any number that
>                        is not a '0' or '1')"
> 
> But after read the code, I found the right information about "echo 2 > snapshot"
> should looks like below:
> 
> " echo 2 > snapshot : Clears snapshot buffer (but does not free)
>                       (Doesn't have to be '2' works with any number that
>                        is not a '0' or '1')"

Actually, they both are correct:

	default:
		if (tr->allocated_snapshot) {
			if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
				tracing_reset_online_cpus(&tr->max_buffer);
			else
				tracing_reset(&tr->max_buffer,	iter->cpu_file);
		}
		break;
	}

It does nothing if it isn't allocated.

Perhaps we need it to say "(but does not allocate or free)"

-- Steve



> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  kernel/trace/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7974ba2..d0da660 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2760,7 +2760,7 @@ static void show_snapshot_main_help(struct seq_file *m)
>  	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
>  	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
>  	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
> -	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
> +	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not free)\n");
>  	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
>  	seq_printf(m, "#                       is not a '0' or '1')\n");
>  }

