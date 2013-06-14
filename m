Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3FNOt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3FNOtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:49:25 -0400
Date: Fri, 14 Jun 2013 16:44:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130614144442.GA1943@redhat.com>
References: <51BA7578.4080108@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA7578.4080108@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, zhangwei(Jovi) wrote:
>
> Support multi-buffer on uprobe-based dynamic events by
> using ftrace_event_file.
>
> The code change is based on kprobe-based dynamic events
> multibuffer support work commited by Masami(commit 41a7dd420c)

And the change in probe_event_enable() doesn't look right, but
let me repeat I didn't read the patch carefully yet.

> +static DEFINE_MUTEX(uprobe_enable_lock);
> +
>  static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
>  {
>  	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
> @@ -607,33 +655,123 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
>  				struct mm_struct *mm);
> 
>  static int
> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
> +		   filter_func_t filter)
>  {
> +	int enabled = 0;
>  	int ret = 0;
> 
> +	mutex_lock(&uprobe_enable_lock);

Do we really need this? Can't we really on mutex_event hold by the caller?

>  	if (is_trace_uprobe_enabled(tu))
> -		return -EINTR;
> +		enabled = 1;
> +
> +	if (file) {
> +		struct ftrace_event_file **new, **old;
> +		int n = trace_uprobe_nr_files(tu);
> +
> +		old = rcu_dereference_raw(tu->files);
> +		/* 1 is for new one and 1 is for stopper */
> +		new = kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
> +			      GFP_KERNEL);
> +		if (!new) {
> +			ret = -ENOMEM;
> +			goto out_unlock;
> +		}
> +		memcpy(new, old, n * sizeof(struct ftrace_event_file *));
> +		new[n] = file;
> +		/* The last one keeps a NULL */
> +
> +		rcu_assign_pointer(tu->files, new);
> +		tu->flags |= TP_FLAG_TRACE;
> +
> +		if (old) {
> +			/* Make sure the probe is done with old files */
> +			synchronize_sched();
> +			kfree(old);
> +		}
> +	} else
> +		tu->flags |= TP_FLAG_PROFILE;

So it can set both TP_FLAG_TRACE and TP_FLAG_PROFILE, yes?

If yes, this is not right. Until we change the pre-filtering at least.
Currently TP_FLAG_TRACE/TP_FLAG_PROFILE are mutually exclusive.

I think it makes sense to remove this limitation anyway, and in fact
I do not remember why I didn't do this... But this needs a separate
change.

Oleg.

