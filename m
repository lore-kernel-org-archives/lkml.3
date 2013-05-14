Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab3ENUfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:35:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60305 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758419Ab3ENUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:35:46 -0400
Date: Tue, 14 May 2013 21:30:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: V3.10-rc1 memory leak
Message-ID: <20130514203028.GA2997@MacBook-Pro.local>
References: <51912567.6090507@lwfinger.net>
 <1368558586.6828.53.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368558586.6828.53.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Tue, May 14, 2013 at 08:09:46PM +0100, Steven Rostedt wrote:
> # find /debug/tracing/events/ -name format |xargs grep ffff8800769f7438
> /debug/tracing/events/drm/drm_vblank_event_delivered/format:	field:pid_t pid;	offset:8;	size:4;	signed:1;ffff8800769f7438
> 
> Thus, what it is complaining about being leaked, is currently being
> used.
> 
> I guess it's because the fields are stored on the "event class"
> structure of the module. That is, the struct ftrace_event_class, which
> is part of the module data section:
> 
> struct ftrace_event_class {
>         char                    *system;
>         void                    *probe;
> #ifdef CONFIG_PERF_EVENTS
>         void                    *perf_probe;
> #endif
>         int                     (*reg)(struct ftrace_event_call *event,
>                                        enum trace_reg type, void *data);
>         int                     (*define_fields)(struct ftrace_event_call *);
>         struct list_head        *(*get_fields)(struct ftrace_event_call *);
>         struct list_head        fields;
>         int                     (*raw_init)(struct ftrace_event_call *);
> };
> 
> 
> The list_head fields holds the fields and these are used to print out
> the formats. For some reason, kmemleak is missing that the fields are
> being assigned to this list on module load.
> 
> Catalin, have any idea why kmemleak is not detecting that the field is
> being referenced?

I just got a patch today:

https://lkml.org/lkml/2013/5/10/607

which could be related. If Rusty doesn't push it I'll do. But please let
me know if it does not solve the problem.

Thanks.

-- 
Catalin
