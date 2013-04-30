Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628Ab3D3NEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:04:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3D3NEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:04:43 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wqGFXKhCnOcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=FdXLZsnBMF8A:10 a=oGMlB6cnAAAA:8 a=hGzw-44bAAAA:8 a=20KFwNOVAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=K_kkNN7lvub2rmn5U7kA:9 a=QEXdDO2ut3YA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=dowx1zmaLagA:10 a=jEp0ucaQiEUA:10 a=fNChW5oJl9MA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367327079.30667.59.camel@gandalf.local.home>
Subject: Re: [PATCH] [TRIVIAL] FIX: unintended variable name reuse
From: Steven Rostedt <rostedt@goodmis.org>
To: dl9pf@gmx.de
Cc: tglx@linutronix.de, hpa@zytor.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Apr 2013 09:04:39 -0400
In-Reply-To: <1367316153-14808-1-git-send-email-dl9pf@gmx.de>
References: <1367316153-14808-1-git-send-email-dl9pf@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 12:02 +0200, dl9pf@gmx.de wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> The variable name events_group is already in used and led to a compilation error
> when using clang to build the Linux Kernel . The fix is just to rename the var.
> No functional change. Please apply.

Need to be a little more specific on the problem in the change log. I'm
guessing that the issue is with the events_group define in
perf_event_intel_uncore.h:

#define events_group attr_groups[2]

I can see that causing issues with something like:

	struct attribute_group *events_group;

I don't think we really want that to end up being:

	struct attribute_group *attr_groups[2];

I'm surprised gcc allowed that :-/

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Fix suggested in discussion by PaX Team <pageexec@freemail.hu>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> 
> CC: tglx@linutronix.de
> CC: hpa@zytor.com
> CC: rostedt@goodmis.org
> CC: a.p.zijlstra@chello.nl
> CC: paulus@samba.org
> CC: mingo@redhat.com
> CC: acme@ghostprotocols.net
> CC: x86@kernel.org
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index d0f9e5a..c01d159 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -3093,7 +3093,7 @@ static void __init uncore_types_exit(struct intel_uncore_type **types)
>  static int __init uncore_type_init(struct intel_uncore_type *type)
>  {
>  	struct intel_uncore_pmu *pmus;
> -	struct attribute_group *events_group;
> +	struct attribute_group *attr_group;
>  	struct attribute **attrs;
>  	int i, j;
>  
> @@ -3120,19 +3120,19 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
>  		while (type->event_descs[i].attr.attr.name)
>  			i++;
>  
> -		events_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
> -					sizeof(*events_group), GFP_KERNEL);
> -		if (!events_group)
> +		attr_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
> +					sizeof(*attr_group), GFP_KERNEL);
> +		if (!attr_group)
>  			goto fail;
>  
> -		attrs = (struct attribute **)(events_group + 1);
> -		events_group->name = "events";
> -		events_group->attrs = attrs;
> +		attrs = (struct attribute **)(attr_group + 1);
> +		attr_group->name = "events";
> +		attr_group->attrs = attrs;
>  
>  		for (j = 0; j < i; j++)
>  			attrs[j] = &type->event_descs[j].attr.attr;
>  
> -		type->events_group = events_group;
> +		type->events_group = attr_group;
>  	}
>  
>  	type->pmu_group = &uncore_pmu_attr_group;


