Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab3GPTtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:49:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab3GPTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:49:08 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_cz1YW3_5MoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iIDwyfuVq48A:10 a=20KFwNOVAAAA:8 a=u_hYCU22_VZPHag5U9UA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374004146.6458.57.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 2/4] tracing: Turn "id"->i_private into
 call->event.type
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Jul 2013 15:49:06 -0400
In-Reply-To: <20130716185723.GA21193@redhat.com>
References: <20130716185723.GA21193@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 20:57 +0200, Oleg Nesterov wrote:
> ftrace_event_id_fops and event_id_read() is overcomplicated.
> 
> 1. Change event_create_dir() to pass "data = call->event.type"
>    to debugfs_create_file().
> 
>    This means that ftrace_event_id_fops doesn't need .open()
>    and event_id_read() can simply print (int)i_private
> 
> 2. event_id_read() has no reason to kmalloc "struct trace_seq"
>    (more than PAGE_SIZE!), it can use a small buffer.

Make #2 a separate patch. You can add it before this one.

-- Steve

> 
> Note: "if (*ppos) return 0" looks strange and unneeded,
> simple_read_from_buffer(ppos) should handle this case corrrectly.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events.c |   26 +++++++++-----------------
>  1 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index cbd1a57..cefbe85 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -962,24 +962,17 @@ static int trace_format_open(struct inode *inode, struct file *file)
>  static ssize_t
>  event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
>  {
> -	struct ftrace_event_call *call = filp->private_data;
> -	struct trace_seq *s;
> -	int r;
> +	int id = (long)ACCESS_ONCE(file_inode(filp)->i_private);
> +	char buf[32];
> +	int len;
>  
> +	if (!id)
> +		return -ENODEV;
>  	if (*ppos)
>  		return 0;
>  
> -	s = kmalloc(sizeof(*s), GFP_KERNEL);
> -	if (!s)
> -		return -ENOMEM;
> -
> -	trace_seq_init(s);
> -	trace_seq_printf(s, "%d\n", call->event.type);
> -
> -	r = simple_read_from_buffer(ubuf, cnt, ppos,
> -				    s->buffer, s->len);
> -	kfree(s);
> -	return r;
> +	len = sprintf(buf, "%d\n", id);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
>  }
>  
>  static ssize_t
> @@ -1264,7 +1257,6 @@ static const struct file_operations ftrace_event_format_fops = {
>  };
>  
>  static const struct file_operations ftrace_event_id_fops = {
> -	.open = tracing_open_generic,
>  	.read = event_id_read,
>  	.llseek = default_llseek,
>  };
> @@ -1496,8 +1488,8 @@ event_create_dir(struct dentry *parent,
>  
>  #ifdef CONFIG_PERF_EVENTS
>  	if (call->event.type && call->class->reg)
> -		trace_create_file("id", 0444, file->dir, call,
> -		 		  id);
> +		trace_create_file("id", 0444, file->dir,
> +				  (void*)(long)call->event.type, id);
>  #endif
>  
>  	/*


