Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3G3Bdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:33:50 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44397 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3G3Bds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:33:48 -0400
Message-ID: <51F717F9.1020702@hitachi.com>
Date: Tue, 30 Jul 2013 10:33:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] tracing: Change f_start() to take event_mutex
 and verify i_private != NULL
References: <20130726172543.GA3622@redhat.com>
In-Reply-To: <20130726172543.GA3622@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/27 2:25), Oleg Nesterov wrote:
> trace_format_open() and trace_format_seq_ops are racy, nothing
> protects ftrace_event_call from trace_remove_event_call().
> 
> Change f_start() to take event_mutex and verify i_private != NULL,
> change f_stop() to drop this lock.
> 
> This fixes nothing, but now we can change debugfs_remove("format")
> callers to nullify ->i_private and fix the the problem.
> 
> Note: the usage of event_mutex is sub-optimal but simple, we can
> change this later.
> 

Looks good for me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index b5144c4..3de2aca 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -839,7 +839,7 @@ enum {
>  
>  static void *f_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	struct ftrace_event_call *call = m->private;
> +	struct ftrace_event_call *call = event_file_data(m->private);
>  	struct list_head *common_head = &ftrace_common_fields;
>  	struct list_head *head = trace_get_fields(call);
>  	struct list_head *node = v;
> @@ -871,7 +871,7 @@ static void *f_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  static int f_show(struct seq_file *m, void *v)
>  {
> -	struct ftrace_event_call *call = m->private;
> +	struct ftrace_event_call *call = event_file_data(m->private);
>  	struct ftrace_event_field *field;
>  	const char *array_descriptor;
>  
> @@ -924,6 +924,11 @@ static void *f_start(struct seq_file *m, loff_t *pos)
>  	void *p = (void *)FORMAT_HEADER;
>  	loff_t l = 0;
>  
> +	/* ->stop() is called even if ->start() fails */
> +	mutex_lock(&event_mutex);
> +	if (!event_file_data(m->private))
> +		return ERR_PTR(-ENODEV);
> +
>  	while (l < *pos && p)
>  		p = f_next(m, p, &l);
>  
> @@ -932,6 +937,7 @@ static void *f_start(struct seq_file *m, loff_t *pos)
>  
>  static void f_stop(struct seq_file *m, void *p)
>  {
> +	mutex_unlock(&event_mutex);
>  }
>  
>  static const struct seq_operations trace_format_seq_ops = {
> @@ -943,7 +949,6 @@ static const struct seq_operations trace_format_seq_ops = {
>  
>  static int trace_format_open(struct inode *inode, struct file *file)
>  {
> -	struct ftrace_event_call *call = inode->i_private;
>  	struct seq_file *m;
>  	int ret;
>  
> @@ -952,7 +957,7 @@ static int trace_format_open(struct inode *inode, struct file *file)
>  		return ret;
>  
>  	m = file->private_data;
> -	m->private = call;
> +	m->private = file;
>  
>  	return 0;
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


