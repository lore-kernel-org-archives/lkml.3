Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaCED47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:56:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaCED46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:56:58 -0500
Date: Tue, 4 Mar 2014 20:00:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
Message-Id: <20140304200023.7b991909.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.10.1403042130250.3742@nuc>
References: <20140214201841.826179349@linux.com>
	<20140214201907.228035121@linux.com>
	<20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
	<alpine.DEB.2.10.1403042130250.3742@nuc>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014 21:31:12 -0600 (CST) Christoph Lameter <cl@linux.com> wrote:

> On Tue, 4 Mar 2014, Andrew Morton wrote:
> 
> > >
> > > ...
> > >
> > > --- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> > > +++ linux/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> > > @@ -618,7 +618,7 @@
> > >  };
> > >
> > >  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> > > -#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
> > > +#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> >
> > arch/x86/platform/uv/uv_nmi.c: In function 'uv_check_nmi':
> > arch/x86/platform/uv/uv_nmi.c:218: error: '_uv_cpu_nmi' undeclared (first use in this function)
> > arch/x86/platform/uv/uv_nmi.c:218: error: (Each undeclared identifier is reported only once
> > arch/x86/platform/uv/uv_nmi.c:218: error: for each function it appears in.)
> >
> >
> > This?
> 
> Nope. I missed an underscore.
> 
> 
> > --- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var-fix
> > +++ a/arch/x86/include/asm/uv/uv_hub.h
> > @@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
> >  };
> >
> >  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> > -#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> > +#define uv_cpu_nmi			(*this_cpu_ptr(&__uv_cpu_nmi))
> 
> __this_cpu_read(__uv_cpu_nmi)

--- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var-fix
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
 };
 
 DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
-#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
+#define uv_cpu_nmi			__this_cpu_read(__uv_cpu_nmi)
 #define uv_hub_nmi			(uv_cpu_nmi.hub)
 #define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
 #define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)

arch/x86/platform/uv/uv_nmi.c: In function 'uv_check_nmi':
arch/x86/platform/uv/uv_nmi.c:218: error: lvalue required as increment operand
arch/x86/platform/uv/uv_nmi.c: In function 'uv_nmi_wait':
arch/x86/platform/uv/uv_nmi.c:362: error: lvalue required as unary '&' operand
arch/x86/platform/uv/uv_nmi.c: In function 'uv_nmi_dump_state_cpu':
arch/x86/platform/uv/uv_nmi.c:422: error: lvalue required as unary '&' operand
arch/x86/platform/uv/uv_nmi.c: In function 'uv_nmi_dump_state':
arch/x86/platform/uv/uv_nmi.c:491: error: lvalue required as unary '&' operand
arch/x86/platform/uv/uv_nmi.c: In function 'uv_handle_nmi':
arch/x86/platform/uv/uv_nmi.c:618: error: lvalue required as unary '&' operand
arch/x86/platform/uv/uv_nmi.c:642: error: lvalue required as unary '&' operand
arch/x86/platform/uv/uv_nmi.c: In function 'uv_handle_nmi_ping':
arch/x86/platform/uv/uv_nmi.c:669: error: lvalue required as increment operand
arch/x86/platform/uv/uv_nmi.c:670: error: lvalue required as unary '&' operand
arch/x86/platform/uv/uv_nmi.c:675: error: lvalue required as increment operand
arch/x86/platform/uv/uv_nmi.c:678: error: lvalue required as unary '&' operand

