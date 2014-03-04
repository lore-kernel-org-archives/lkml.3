Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaCDXp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:45:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:32189 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755418AbaCDXpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:45:25 -0500
Date: Tue, 4 Mar 2014 18:42:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
Message-ID: <20140304184210.11a0b157@gandalf.local.home>
In-Reply-To: <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
References: <20140214201841.826179349@linux.com>
	<20140214201907.228035121@linux.com>
	<20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014 15:02:17 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 14 Feb 2014 14:19:12 -0600 Christoph Lameter <cl@linux.com> wrote:
> 
> > Use __this_cpu_read instead.
> > 
> > ...
> >
> > --- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> > +++ linux/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> > @@ -618,7 +618,7 @@
> >  };
> >  
> >  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> > -#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
> > +#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> 
> arch/x86/platform/uv/uv_nmi.c: In function 'uv_check_nmi':
> arch/x86/platform/uv/uv_nmi.c:218: error: '_uv_cpu_nmi' undeclared (first use in this function)
> arch/x86/platform/uv/uv_nmi.c:218: error: (Each undeclared identifier is reported only once
> arch/x86/platform/uv/uv_nmi.c:218: error: for each function it appears in.)
> 
> 
> This?
> 
> --- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var-fix
> +++ a/arch/x86/include/asm/uv/uv_hub.h
> @@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
>  };
>  
>  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> -#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> +#define uv_cpu_nmi			(*this_cpu_ptr(&__uv_cpu_nmi))

Looks like an extra "_" was added.

-- Steve

>  #define uv_hub_nmi			(uv_cpu_nmi.hub)
>  #define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
>  #define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)
> _

