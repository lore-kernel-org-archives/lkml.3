Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3GRR75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:59:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072Ab3GRR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:59:56 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Yl0AzRYO7AIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=d6u8WKc2XIIA:10 a=ayC55rCoAAAA:8 a=kNqCl963W6Y3sKetRbMA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374170394.6458.252.camel@gandalf.local.home>
Subject: Re: [PATCH v2] tracing: Miscellaneous fixes for trace_array ref
 counting
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Z Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Date: Thu, 18 Jul 2013 13:59:54 -0400
In-Reply-To: <1374169621-31314-1-git-send-email-azl@google.com>
References: <1374169621-31314-1-git-send-email-azl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 10:47 -0700, Alexander Z Lam wrote:
>  
>  static const struct file_operations tracing_iter_fops = {
> @@ -3958,7 +3965,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
>  	if (!iter) {
>  		ret = -ENOMEM;
> -		goto out;
> +		goto fail_iter;
>  	}
>  
>  	/*
> @@ -3968,13 +3975,13 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  	iter->trace = kmalloc(sizeof(*iter->trace), GFP_KERNEL);
>  	if (!iter->trace) {
>  		ret = -ENOMEM;
> -		goto fail;
> +		goto fail_trace;
>  	}
>  	*iter->trace = *tr->current_trace;
>  
>  	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
>  		ret = -ENOMEM;
> -		goto fail;
> +		goto fail_trace;
>  	}
>  
>  	/* trace pipe does not show start of buffer */
> @@ -4001,9 +4008,10 @@ out:
>  	mutex_unlock(&trace_types_lock);
>  	return ret;
>  
> -fail:
> +fail_trace:
>  	kfree(iter->trace);
>  	kfree(iter);
> +fail_iter:
>  	__trace_array_put(tr);
>  	mutex_unlock(&trace_types_lock);
>  	return ret;


You missed my comment about not adding the extra label. The only change
to the code above should have been:

	if (!iter) {
		ret = -ENOMEM;
+		__trace_array_put(tr);
		goto out;
	}

A one liner.

-- Steve

