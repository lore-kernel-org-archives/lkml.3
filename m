Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3ANPxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:53:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3ANPxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:53:32 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4cOs46X_YuMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jtXemJRfm7kA:10 a=yPCof4ZbAAAA:8 a=ezgHxbjwsfrEoLTkGgkA:9 a=PUjeQqilurYA:10 a=7DSvI1NPTFQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358178810.5141.57.camel@gandalf.local.home>
Subject: Re: [PATCH] Tracing: fix regression of trace_pipe
From: Steven Rostedt <rostedt@goodmis.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 14 Jan 2013 10:53:30 -0500
In-Reply-To: <1358132051-5410-1-git-send-email-bo.li.liu@oracle.com>
References: <1358132051-5410-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 10:54 +0800, Liu Bo wrote:
> commit 0fb9656d changes the behaviour of trace_pipe, ie. it makes trace_pipe
> return if we've read something and tracing is enabled, and this means that
> we have to 'cat trace_pipe' again and again while running tests.

Bah, this is the second regression that this commit caused. I fixed the
first one and was about to send it to Linus. I'll add this one too and
rerun my tests again.

> 
> IMO the right way is if tracing is enabled, we always block and wait for
> ring buffer, or we may lose what we want since ring buffer's size is limited.

Hmm, I shouldn't have made this change with this commit. I may have
meant to do it as a separate commit, but committed both changes in this
one. It's actually unrelated to the change that was made in the change
log :-(

I'll see if I can add a test that checks for this regression, and add
that too to my test suite.

Thanks,

-- Steve

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  kernel/trace/trace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e512567..fc76beb 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3452,7 +3452,7 @@ static int tracing_wait_pipe(struct file *filp)
>  			return -EINTR;
>  
>  		/*
> -		 * We block until we read something and tracing is enabled.
> +		 * We block until we read something and tracing is disabled.
>  		 * We still block if tracing is disabled, but we have never
>  		 * read anything. This allows a user to cat this file, and
>  		 * then enable tracing. But after we have read something,
> @@ -3460,7 +3460,7 @@ static int tracing_wait_pipe(struct file *filp)
>  		 *
>  		 * iter->pos will be 0 if we haven't read anything.
>  		 */
> -		if (tracing_is_enabled() && iter->pos)
> +		if (!tracing_is_enabled() && iter->pos)
>  			break;
>  	}
>  


