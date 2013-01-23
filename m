Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3AWEsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:48:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3AWEsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:48:33 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1lp5RE5RrrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CpGQe48J6BUA:10 a=5EU8-YO1TYepbVPt_BgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358916512.21576.108.camel@gandalf.local.home>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 22 Jan 2013 23:48:32 -0500
In-Reply-To: <1358916249.21576.105.camel@gandalf.local.home>
References: <1358910114.21576.86.camel@gandalf.local.home>
	 <20130123040846.GA2638@kroah.com>
	 <1358915495.21576.102.camel@gandalf.local.home>
	 <1358916249.21576.105.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 23:44 -0500, Steven Rostedt wrote:

> +	ret = event_trace_add_tracer(tr->dir, tr);
> +	if (ret)
> +		goto out_free_tr;
> +
> +	init_tracer_debugfs(tr, tr->dir);
> +
> +	mutex_unlock(&trace_types_lock);
> +
> +	list_add(&tr->list, &ftrace_trace_arrays);

I just noticed this bug :-)

The list_add() needs to be inside the mutex protection. This code use to
be within the trace_new_instance_write(), and I just moved it into its
own function. Must have been where I screwed up.

-- Steve

> +
> +	return 0;
> +
> + out_free_tr:
> +	if (tr->buffer)
> +		ring_buffer_free(tr->buffer);
> +	kfree(tr->name);
> +	kfree(tr);
> +
> + out_unlock:
> +	mutex_unlock(&trace_types_lock);
> +
> +	return ret;
> +
> +}
> +

