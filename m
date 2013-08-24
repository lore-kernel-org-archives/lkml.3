Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3HXSxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:53:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50713 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755353Ab3HXSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:53:13 -0400
Date: Sat, 24 Aug 2013 14:53:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Paul Bolle <pebolle@tiscali.nl>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/trace: Correcting and extending
	tracepoint documentation
Message-ID: <20130824185309.GA13216@Krystal>
References: <1377208171-9004-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377208171-9004-1-git-send-email-zoltan.kiss@citrix.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zoltan Kiss (zoltan.kiss@citrix.com) wrote:
> The sample missed the moving of the header files into the events subdirectory.
> I've also extended it based on the existing headers, and mentioned the tiny
> but important role of CREATE_TRACE_POINTS.

Given that we expect tracepoints to be used though the TRACE_EVENT
wrapper, it makes sense indeed. A small nit below:

> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> ---
>  Documentation/trace/tracepoints.txt |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
> index da49437..e8e3c4b 100644
> --- a/Documentation/trace/tracepoints.txt
> +++ b/Documentation/trace/tracepoints.txt
> @@ -40,7 +40,13 @@ Two elements are required for tracepoints :
>  
>  In order to use tracepoints, you should include linux/tracepoint.h.
>  
> -In include/trace/subsys.h :
> +In include/trace/events/subsys.h :
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM subsys
> +
> +#if !defined(_TRACE_SUBSYS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_SUBSYS_H
>  
>  #include <linux/tracepoint.h>
>  
> @@ -48,10 +54,16 @@ DECLARE_TRACE(subsys_eventname,
>  	TP_PROTO(int firstarg, struct task_struct *p),
>  	TP_ARGS(firstarg, p));
>  
> +#endif /* _TRACE_SUBSYS_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> +
>  In subsys/file.c (where the tracing statement must be added) :
>  
> -#include <trace/subsys.h>
> +#include <trace/events/subsys.h>
>  
> +#define CREATE_TRACE_POINTS
>  DEFINE_TRACE(subsys_eventname);
>  
>  void somefct(void)
> @@ -72,6 +84,9 @@ Where :
>  - TP_ARGS(firstarg, p) are the parameters names, same as found in the
>    prototype.
>  
> +- if you use the header in multiple source files, #define CREATE_TRACE_POINTS
> +  should appear only in one source file

Missing dot at the end of the sentence above.

Other than that,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

Mathieu

> +
>  Connecting a function (probe) to a tracepoint is done by providing a
>  probe (function to call) for the specific tracepoint through
>  register_trace_subsys_eventname().  Removing a probe is done through
> -- 
> 1.7.9.5
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
