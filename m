Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaBYDuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:50:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaBYDuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:50:23 -0500
Message-ID: <530C12CA.6070308@zytor.com>
Date: Mon, 24 Feb 2014 19:49:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu> <530B841F.5050803@zytor.com> <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu> <530B90A5.3090302@zytor.com> <20140224141329.1cd3bb52@gandalf.local.home> <20140224193043.GP6835@laptop.programming.kicks-ass.net>
In-Reply-To: <20140224193043.GP6835@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 11:30 AM, Peter Zijlstra wrote:
> On Mon, Feb 24, 2014 at 02:13:29PM -0500, Steven Rostedt wrote:
>> Ah, and x86_64 saves off the cr2 register when entering NMI and restores
>> it before returning. But it seems to be missing from the i386 code.
> 
> arch/x86/kernel/nmi.c:
> 
> #define nmi_nesting_preprocess(regs)					\
> 	do {								\
> 		if (this_cpu_read(nmi_state) != NMI_NOT_RUNNING) {	\
> 			this_cpu_write(nmi_state, NMI_LATCHED);		\
> 			return;						\
> 		}							\
> 		this_cpu_write(nmi_state, NMI_EXECUTING);		\
> 		this_cpu_write(nmi_cr2, read_cr2());			\
> 	} while (0);							\
> 	nmi_restart:
> 
> #define nmi_nesting_postprocess()					\
> 	do {								\
> 		if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))	\
> 			write_cr2(this_cpu_read(nmi_cr2));		\
> 		if (this_cpu_dec_return(nmi_state))			\
> 			goto nmi_restart;				\
> 	} while (0)
> 
> That very much looks like saving/restoring CR2 to me.
> 
> FWIW; I hate how the x86_64 and i386 versions of this NMI nesting magic
> are so completely different.

Is there any way that nmi_cr2 can end up getting overwritten by multiple
nestings of some kind?  I would have thought it would have made more
sense to spill cr2 onto the stack after the stack has been properly set up.

	-hpa


