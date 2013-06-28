Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3F1Oco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3F1Ocn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:32:43 -0400
Date: Fri, 28 Jun 2013 16:27:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/kprobe: Recover old array if fails to enable
	kprobe
Message-ID: <20130628142744.GA19278@redhat.com>
References: <51CD25A6.2030907@hitachi.com> <20130628130452.1132.85665.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628130452.1132.85665.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Masami Hiramatsu wrote:
>
> @@ -232,19 +246,21 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
>  		rcu_assign_pointer(tp->files, new);
>  		tp->flags |= TP_FLAG_TRACE;
>  
> +		ret = __enable_trace_probe(tp);
> +		if (ret < 0) {
> +			/* Write back the old list */
> +			rcu_assign_pointer(tp->files, old);
> +			old = new;	/* "new" must be freed */
> +		}
> +
>  		if (old) {
>  			/* Make sure the probe is done with old files */
>  			synchronize_sched();
>  			kfree(old);
>  		}

Ah, but this conflicts with the other changes I sent. They have
your acks, and iiuc Steven is going to apply them.

Besides, this fix is not complete afaics, we should also clear
TP_FLAG_TRACE/PROFILE if __enable_trace_probe() fails.

Perhaps you can do this later, on top of the pending changes?

Or. Given that this patch assumes that enable_kprobe() must succed,
can't we make a minimal change for now?

-------------------------------------------------------------------------------
[PATCH] tracing/kprobe: WARN() if enable_kprobe() fails.

enable_trace_probe() doesn't recover tp->files/flags if enable_kprobe()
fails, this looks confusing.

However, enable_kprobe() must not fail at this time except for unknown
bug or changing the implementation of enable_kprobe(), because usual
failure cases (not registered or gone) are already filtered.

So this patch simply adds WARN_ON(ret) to document this fact, even if
it makes sense to cleanup the logic anyway later.

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_kprobe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5c070db..bb608b5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -220,6 +220,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 			ret = enable_kretprobe(&tp->rp);
 		else
 			ret = enable_kprobe(&tp->rp.kp);
+		WARN_ON(ret);
 	}
  out:
 	return ret;

