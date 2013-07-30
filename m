Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3G3Bbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:31:33 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54512 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3G3Bbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:31:32 -0400
Message-ID: <51F7176D.6000907@hitachi.com>
Date: Tue, 30 Jul 2013 10:31:25 +0900
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
Subject: Re: [PATCH v2 2/6] tracing: Change event_enable/disable_read() to
 verify i_private != NULL
References: <20130726172536.GA3612@redhat.com>
In-Reply-To: <20130726172536.GA3612@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/27 2:25), Oleg Nesterov wrote:
> tracing_open_generic_file() is racy, ftrace_event_file can be
> already freed by rmdir or trace_remove_event_call().
> 
> Change event_enable_read() and event_disable_read() to read and
> verify "file = i_private" under event_mutex.
> 
> This fixes nothing, but now we can change debugfs_remove("enable")
> callers to nullify ->i_private and fix the the problem.


Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

BTW, this still has a cosmetic change, is that OK for Steven?

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events.c |   31 ++++++++++++++++++++-----------
>  1 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 77990c4..39cb049 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -684,19 +684,28 @@ static ssize_t
>  event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		  loff_t *ppos)
>  {
> -	struct ftrace_event_file *file = filp->private_data;
> +	struct ftrace_event_file *file;
> +	unsigned long flags;
>  	char buf[4] = "0";
>  
> -	if (file->flags & FTRACE_EVENT_FL_ENABLED &&
> -	    !(file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
> +	mutex_lock(&event_mutex);
> +	file = event_file_data(filp);
> +	if (likely(file))
> +		flags = file->flags;
> +	mutex_unlock(&event_mutex);
> +
> +	if (!file)
> +		return -ENODEV;
> +
> +	if (flags & FTRACE_EVENT_FL_ENABLED &&
> +	    !(flags & FTRACE_EVENT_FL_SOFT_DISABLED))
>  		strcpy(buf, "1");
>  
> -	if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
> -	    file->flags & FTRACE_EVENT_FL_SOFT_MODE)
> +	if (flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
> +	    flags & FTRACE_EVENT_FL_SOFT_MODE)
>  		strcat(buf, "*");
>  
>  	strcat(buf, "\n");
> -
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
>  }
>  
> @@ -704,13 +713,10 @@ static ssize_t
>  event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		   loff_t *ppos)
>  {
> -	struct ftrace_event_file *file = filp->private_data;
> +	struct ftrace_event_file *file;
>  	unsigned long val;
>  	int ret;
>  
> -	if (!file)
> -		return -EINVAL;
> -
>  	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
>  	if (ret)
>  		return ret;
> @@ -722,8 +728,11 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	switch (val) {
>  	case 0:
>  	case 1:
> +		ret = -ENODEV;
>  		mutex_lock(&event_mutex);
> -		ret = ftrace_event_enable_disable(file, val);
> +		file = event_file_data(filp);
> +		if (likely(file))
> +			ret = ftrace_event_enable_disable(file, val);
>  		mutex_unlock(&event_mutex);
>  		break;
>  
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


