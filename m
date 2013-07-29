Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3G2JnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:43:14 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33508 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3G2JnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:43:12 -0400
Message-ID: <51F6392C.8000806@hitachi.com>
Date: Mon, 29 Jul 2013 18:43:08 +0900
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
Subject: Re: [PATCH v2 6/6] tracing: Change remove_event_file_dir() to clear
 "d_subdirs"->i_private
References: <20130726172551.GA3632@redhat.com>
In-Reply-To: <20130726172551.GA3632@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/27 2:25), Oleg Nesterov wrote:
> Change remove_event_file_dir() to clear ->i_private for every
> file we are going to remove.

Oleg, I think this should be done first.

AFAICS, your former patches depend strongly on this change.
Without this, they don't work as you expected, and it may
prevent git-bisect.

I see, including this patch also breaks current ftrace.
Thus, IMHO, it would better to make a separate patch which just
nullifies i_private with adding some NULL checks where accessing
i_private to avoid the breakages.

This looks a bit long way round, but it ensures bisecting.

Thank you,

> tracing_open_generic_file() and tracing_release_generic_file()
> can go away, ftrace_enable_fops and ftrace_event_filter_fops()
> use tracing_open_generic() but only to check tracing_disabled.
> 
> This fixes all races with event_remove() or instance_delete().
> f_op->read/write/whatever can never use the freed file/call,
> all event/* files were changed to check and use ->i_private
> under event_mutex.
> 
> Note: this doesn't not fix other problems, event_remove() can
> destroy the active ftrace_event_call, we need more changes but
> those changes are completely orthogonal.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events.c |   41 +++++++++--------------------------------
>  1 files changed, 9 insertions(+), 32 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 2a4f68a..1112fa0 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -428,42 +428,20 @@ static void *event_file_data(struct file *filp)
>  
>  static void remove_event_file_dir(struct ftrace_event_file *file)
>  {
> +	struct dentry *dir = file->dir;
> +	struct dentry *child;
> +
> +	/* ->i_mutex is not needed, nobody can create/remove a file */
> +	list_for_each_entry(child, &dir->d_subdirs, d_u.d_child)
> +		child->d_inode->i_private = NULL;
> +
>  	list_del(&file->list);
> -	debugfs_remove_recursive(file->dir);
> +	debugfs_remove_recursive(dir);
>  	remove_subsystem(file->system);
>  	kmem_cache_free(file_cachep, file);
>  }
>  
>  /*
> - * Open and update trace_array ref count.
> - * Must have the current trace_array passed to it.
> - */
> -static int tracing_open_generic_file(struct inode *inode, struct file *filp)
> -{
> -	struct ftrace_event_file *file = inode->i_private;
> -	struct trace_array *tr = file->tr;
> -	int ret;
> -
> -	if (trace_array_get(tr) < 0)
> -		return -ENODEV;
> -
> -	ret = tracing_open_generic(inode, filp);
> -	if (ret < 0)
> -		trace_array_put(tr);
> -	return ret;
> -}
> -
> -static int tracing_release_generic_file(struct inode *inode, struct file *filp)
> -{
> -	struct ftrace_event_file *file = inode->i_private;
> -	struct trace_array *tr = file->tr;
> -
> -	trace_array_put(tr);
> -
> -	return 0;
> -}
> -
> -/*
>   * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
>   */
>  static int
> @@ -1277,10 +1255,9 @@ static const struct file_operations ftrace_set_event_fops = {
>  };
>  
>  static const struct file_operations ftrace_enable_fops = {
> -	.open = tracing_open_generic_file,
> +	.open = tracing_open_generic,
>  	.read = event_enable_read,
>  	.write = event_enable_write,
> -	.release = tracing_release_generic_file,
>  	.llseek = default_llseek,
>  };
>  
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


