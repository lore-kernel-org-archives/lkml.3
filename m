Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3K2JZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:25:37 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34827 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3K2JZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:25:32 -0500
Date: Fri, 29 Nov 2013 14:55:21 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 03/17] tracing/kprobes: Factor out struct trace_probe
Message-ID: <20131129092521.GA9585@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
 <1385533203-10014-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1385533203-10014-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112909-9332-0000-0000-00000253E8EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Namhyung Kim <namhyung@kernel.org> [2013-11-27 15:19:49]:

> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There are functions that can be shared to both of kprobes and uprobes.
> Separate common data structure to struct trace_probe and use it from
> the shared functions.
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_kprobe.c | 396 +++++++++++++++++++++-----------------------
>  kernel/trace/trace_probe.h  |  20 +++
>  2 files changed, 213 insertions(+), 203 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index dae9541ada9e..72b76e1f2d34 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -27,18 +27,12 @@
>  /**
>   * Kprobe event core functions
>   */
> -struct trace_probe {
> +struct trace_kprobe {
>  	struct list_head	list;
>  	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
>  	unsigned long 		nhit;
> -	unsigned int		flags;	/* For TP_FLAG_* */
>  	const char		*symbol;	/* symbol name */
> -	struct ftrace_event_class	class;
> -	struct ftrace_event_call	call;
> -	struct list_head	files;
> -	ssize_t			size;		/* trace entry size */
> -	unsigned int		nr_args;
> -	struct probe_arg	args[];
> +	struct trace_probe	p;

Can I suggest to use tp instead of p to denote trace_probe?

>  };
> 
> 

<..snipped..>

> -static int register_probe_event(struct trace_probe *tp);
> -static int unregister_probe_event(struct trace_probe *tp);
> +static int register_kprobe_event(struct trace_kprobe *tk);
> +static int unregister_kprobe_event(struct trace_kprobe *tk);
> 
>  static DEFINE_MUTEX(probe_lock);
>  static LIST_HEAD(probe_list);
> @@ -107,14 +91,14 @@ static int kretprobe_dispatcher(struct kretprobe_instance *ri,
>  /*
>   * Allocate new trace_probe and initialize it (including kprobes).
>   */
> -static struct trace_probe *alloc_trace_probe(const char *group,
> +static struct trace_kprobe *alloc_trace_kprobe(const char *group,
>  					     const char *event,
>  					     void *addr,
>  					     const char *symbol,
>  					     unsigned long offs,
>  					     int nargs, bool is_return)
>  {
> -	struct trace_probe *tp;
> +	struct trace_kprobe *tp;

Nit: Here and couple of places below: Given that tk was used to
represent trace_kprobe, can we use tk everywhere. Using tp to represent
trace_probe and trace_kprobe is a bit confusing.

>  	int ret = -ENOMEM;
> 

The rest looks fine.

-- 
Thanks and Regards
Srikar Dronamraju

