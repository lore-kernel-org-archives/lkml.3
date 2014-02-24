Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaBXTay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:30:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48496 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaBXTax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:30:53 -0500
Date: Mon, 24 Feb 2014 20:30:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140224193043.GP6835@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
 <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com>
 <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu>
 <20140224172536.GD9987@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
 <530B841F.5050803@zytor.com>
 <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
 <530B90A5.3090302@zytor.com>
 <20140224141329.1cd3bb52@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224141329.1cd3bb52@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 02:13:29PM -0500, Steven Rostedt wrote:
> Ah, and x86_64 saves off the cr2 register when entering NMI and restores
> it before returning. But it seems to be missing from the i386 code.

arch/x86/kernel/nmi.c:

#define nmi_nesting_preprocess(regs)					\
	do {								\
		if (this_cpu_read(nmi_state) != NMI_NOT_RUNNING) {	\
			this_cpu_write(nmi_state, NMI_LATCHED);		\
			return;						\
		}							\
		this_cpu_write(nmi_state, NMI_EXECUTING);		\
		this_cpu_write(nmi_cr2, read_cr2());			\
	} while (0);							\
	nmi_restart:

#define nmi_nesting_postprocess()					\
	do {								\
		if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))	\
			write_cr2(this_cpu_read(nmi_cr2));		\
		if (this_cpu_dec_return(nmi_state))			\
			goto nmi_restart;				\
	} while (0)

That very much looks like saving/restoring CR2 to me.

FWIW; I hate how the x86_64 and i386 versions of this NMI nesting magic
are so completely different.
