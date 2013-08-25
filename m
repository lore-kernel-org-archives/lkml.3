Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3HYNIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 09:08:39 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:50228 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab3HYNIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 09:08:38 -0400
Date: Sun, 25 Aug 2013 03:59:54 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation/trace: Correcting and extending
 tracepoint documentation
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, Paul Bolle <pebolle@tiscali.nl>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zoltan Kiss <zoltan.kiss@citrix.com>
In-Reply-To: <1377208171-9004-1-git-send-email-zoltan.kiss@citrix.com> (from
	zoltan.kiss@citrix.com on Thu Aug 22 16:49:31 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377421194.2737.118@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 04:49:31 PM, Zoltan Kiss wrote:
> The sample missed the moving of the header files into the events  
> subdirectory.
> I've also extended it based on the existing headers, and mentioned  
> the tiny
> but important role of CREATE_TRACE_POINTS.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> ---
>  Documentation/trace/tracepoints.txt |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/trace/tracepoints.txt  
> b/Documentation/trace/tracepoints.txt
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

That addition I can sort of see, I guess?

> +#if !defined(_TRACE_SUBSYS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_SUBSYS_H

But this makes no sense to me: why is it needed? (I.E. why must it be  
block copied into each _user_ of tracepoints?)

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

Why? (Both why do you need to #include a header outside a multiple  
inclusion guard, and why is the additional header needed at all in  
_every_ subsystem trace header?)

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
> +- if you use the header in multiple source files, #define  
> CREATE_TRACE_POINTS
> +  should appear only in one source file
> +
>  Connecting a function (probe) to a tracepoint is done by providing a
>  probe (function to call) for the specific tracepoint through
>  register_trace_subsys_eventname().  Removing a probe is done through

I guess the documentation isn't at fault if the tracepoint subsystem is  
suddenly becoming a lot more repetitive and complicated for no readily  
apparent reason, but did anybody ask _why_ this thing changed? Can we  
document why the extra redundancy is needed?

Rob