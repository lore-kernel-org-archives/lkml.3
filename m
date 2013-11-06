Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3KFTUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:20:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30617 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755335Ab3KFTUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:20:32 -0500
Date: Wed, 6 Nov 2013 14:20:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: kernel-br@googlegroups.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v2] tracing: fix referencing after memory freeing and
 refactors code
Message-ID: <20131106142028.6ff5a4f9@gandalf.local.home>
In-Reply-To: <1383764571-7318-1-git-send-email-geyslan@gmail.com>
References: <1383764571-7318-1-git-send-email-geyslan@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Nov 2013 16:02:51 -0300
"Geyslan G. Bem" <geyslan@gmail.com> wrote:

> In 'system_tr_open()':
> Fix possible 'dir' assignment after freeing it.

I'll take this patch, but I'm going to reword the subject and the
change log. The assignment of dir to filp->private_data after dir is
freed is not as bad as it sounds. As we are returning an error,
filp->private_data is never used.

-- Steve


> 
> In both functions:
> Restructures logic conditions testing 'tracing_is_disabled()'
> return before the others tests.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  kernel/trace/trace_events.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 368a4d5..b44a7ea 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1062,6 +1062,9 @@ static int subsystem_open(struct inode *inode, struct file *filp)
>  	struct trace_array *tr;
>  	int ret;
>  
> +	if (tracing_is_disabled())
> +		return -ENODEV;
> +
>  	/* Make sure the system still exists */
>  	mutex_lock(&trace_types_lock);
>  	mutex_lock(&event_mutex);
> @@ -1108,6 +1111,9 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>  	struct trace_array *tr = inode->i_private;
>  	int ret;
>  
> +	if (tracing_is_disabled())
> +		return -ENODEV;
> +
>  	if (trace_array_get(tr) < 0)
>  		return -ENODEV;
>  
> @@ -1124,11 +1130,12 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>  	if (ret < 0) {
>  		trace_array_put(tr);
>  		kfree(dir);
> +		return ret;
>  	}
>  
>  	filp->private_data = dir;
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int subsystem_release(struct inode *inode, struct file *file)

