Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3HAOOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:14:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab3HAOOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:14:34 -0400
Date: Thu, 1 Aug 2013 16:08:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/4] tracing/uprobes: Fail to unregister if probe
	event files are open
Message-ID: <20130801140856.GA11109@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.991525256@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704034038.991525256@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Steven Rostedt wrote:
>
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Acked-by: Oleg Nesterov <oleg@redhat.com>


Just a couple of nits in the case you are going to redo this change,

> Modules do with with the module owner set (automated
> from the VFS layer).

This logic is dead, I think.

> The ftrace buffer instances have a ref count added
> to the trace_array when the enabled file is opened

This is too.

> -static void cleanup_all_probes(void)
> +static int cleanup_all_probes(void)
>  {
>  	struct trace_uprobe *tu;
> +	int ret = 0;
>  
>  	mutex_lock(&uprobe_lock);
>  	while (!list_empty(&uprobe_list)) {
>  		tu = list_entry(uprobe_list.next, struct trace_uprobe, list);
> -		unregister_trace_uprobe(tu);
> +		ret = unregister_trace_uprobe(tu);
> +		if (ret)
> +			break;
>  	}
>  	mutex_unlock(&uprobe_lock);
> +	return ret;
>  }

Again, it is not clear what exactly we should do and I won't argue
either way. But note that (with or without this patch) this doesn't
match kprobe's release_all_trace_probes() which checks (tries to,
actually) trace_probe_is_enabled() for every probe first. Perhaps
we should cleanup this later.

>  static int probes_open(struct inode *inode, struct file *file)
>  {
> +	int ret = 0;
> +
>  	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
> -		cleanup_all_probes();
> +		ret = cleanup_all_probes();
> +	if (ret)
> +		return ret;

Cosmetic, but perhaps it would be a bit more clean to move this check
(with "int ret") under if (WRITE && TRUNC) block.

Oleg.

