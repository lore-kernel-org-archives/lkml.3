Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaCDRco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:32:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaCDRcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:32:42 -0500
Date: Tue, 4 Mar 2014 18:31:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/14] uprobes: Add uprobes support for ARM
Message-ID: <20140304173134.GA18830@redhat.com>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org> <20140301123026.GD21483@n2100.arm.linux.org.uk> <53131DBE.7020500@linaro.org> <20140303205039.GA8949@redhat.com> <20140304005306.GO21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304005306.GO21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Russell King - ARM Linux wrote:
>
> On Mon, Mar 03, 2014 at 09:50:39PM +0100, Oleg Nesterov wrote:
> >
> > And why CONFIG_UPROBES should depend on PERF_EVENTS? uprobes can be
> > used by (say) systemtap without UPROBE_EVENT/PERF_EVENTS.
> >
> > But as Russell pointed out the events directory is only built if
> > CONFIG_PERF_EVENTS=y, so it should depend on it or select...
> >
> >
> > I dunno. Personally I vote for the patch from Srikar in
> >
> > 	http://article.gmane.org/gmane.linux.kernel/1017186
> >
> > This is what we currently have, currently CONFIG_UPROBES is not
> > user-selectable anyway.
>
> Yes, me too, but with the proviso that UPROBE_EVENT also sorts itself
> out with PERF_EVENTS in some way too (either by selecting it, which
> IMHO isn't nice, or by depending on it, or the build dependency itself
> gets sorted.)

OK... what do you think about the patch below for now?

> Maybe a simpler answer would be to change the build stuff (hand-crafted):
>
> kernel/Makefile
> -obj-$(CONFIG_PERF_EVENTS) += events/
> +obj-y += events/
>
> and kernel/events/Makefile:
>
> -obj-y := core.o ring_buffer.o callchain.o
> +perf-y := core.o ring_buffer.o callchain.o
>
> -obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
> +perf-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
> +
> +obj-${CONFIG_PERF_EVENTS) += $(perf-y)

I fully agree. Except I can't review this change ;) But hopefully I
can understand what it should do.

But personally I'd prefer to start with the simple/safe change which
allows us to merge this series. If nothing else, even if I think that
kernel/events/uprobes.c doesn't need CONFIG_PERF_EVENTS, this should
be verified and discussed with perf maintainers.

If you agree with the patch below, how should we route it? I won't
argue if you push it along with other patches from David.

BTW... why UPROBE_EVENT depends on MMU? I think that ARCH_SUPPORTS_UPROBES
should not be true if !CONFIG_MMU.

Oleg.
---

diff --git a/arch/Kconfig b/arch/Kconfig
index 80bbb8c..97ff872 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -86,9 +86,7 @@ config KPROBES_ON_FTRACE
 	 optimize on top of function tracing.
 
 config UPROBES
-	bool "Transparent user-space probes (EXPERIMENTAL)"
-	depends on UPROBE_EVENT && PERF_EVENTS
-	default n
+	def_bool n
 	select PERCPU_RWSEM
 	help
 	  Uprobes is the user-space counterpart to kprobes: they
@@ -101,8 +99,6 @@ config UPROBES
 	    managed by the kernel and kept transparent to the probed
 	    application. )
 
-	  If in doubt, say "N".
-
 config HAVE_64BIT_ALIGNED_ACCESS
 	def_bool 64BIT && !HAVE_EFFICIENT_UNALIGNED_ACCESS
 	help
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 015f85a..8639819 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -424,6 +424,7 @@ config UPROBE_EVENT
 	bool "Enable uprobes-based dynamic events"
 	depends on ARCH_SUPPORTS_UPROBES
 	depends on MMU
+	depends on PERF_EVENTS
 	select UPROBES
 	select PROBE_EVENTS
 	select TRACING

