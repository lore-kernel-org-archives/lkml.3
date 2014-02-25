Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaBYOgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:36:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaBYOf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:35:59 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu> <530B841F.5050803@zytor.com> <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu> <530B90A5.3090302@zytor.com> <20140224141329.1cd3bb52@gandalf.local.home> <20140224193043.GP6835@laptop.programming.kicks-ass.net> <530C12CA.6070308@zytor.com> <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: perf_fuzzer compiled for x32 causes reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 25 Feb 2014 06:34:55 -0800
To: Vince Weaver <vincent.weaver@maine.edu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Message-ID: <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#2 is what I really don't understand.

I worry something else is going on there

On February 25, 2014 6:07:51 AM PST, Vince Weaver <vincent.weaver@maine.edu> wrote:
>On Mon, 24 Feb 2014, H. Peter Anvin wrote:
>
>> On 02/24/2014 11:30 AM, Peter Zijlstra wrote:
>> > On Mon, Feb 24, 2014 at 02:13:29PM -0500, Steven Rostedt wrote:
>> >> Ah, and x86_64 saves off the cr2 register when entering NMI and
>restores
>> >> it before returning. But it seems to be missing from the i386
>code.
>> > 
>> > arch/x86/kernel/nmi.c:
>> > 
>> > #define nmi_nesting_preprocess(regs)					\
>> > 	do {								\
>> > 		if (this_cpu_read(nmi_state) != NMI_NOT_RUNNING) {	\
>> > 			this_cpu_write(nmi_state, NMI_LATCHED);		\
>> > 			return;						\
>> > 		}							\
>> > 		this_cpu_write(nmi_state, NMI_EXECUTING);		\
>> > 		this_cpu_write(nmi_cr2, read_cr2());			\
>> > 	} while (0);							\
>> > 	nmi_restart:
>> > 
>> > #define nmi_nesting_postprocess()					\
>> > 	do {								\
>> > 		if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))	\
>> > 			write_cr2(this_cpu_read(nmi_cr2));		\
>> > 		if (this_cpu_dec_return(nmi_state))			\
>> > 			goto nmi_restart;				\
>> > 	} while (0)
>> > 
>> > That very much looks like saving/restoring CR2 to me.
>> > 
>> > FWIW; I hate how the x86_64 and i386 versions of this NMI nesting
>magic
>> > are so completely different.
>> 
>> Is there any way that nmi_cr2 can end up getting overwritten by
>multiple
>> nestings of some kind?  I would have thought it would have made more
>> sense to spill cr2 onto the stack after the stack has been properly
>set up.
>
>So how can I help with debugging this?
>
>While the missing cr2 issue made debugging frustrating, I find the
>other 
>aspects of the bug more serious:
>
>  1.  Programs that are doing valid memory accesses can segfault
>and worse
>2.  This bug can cause an instant-reboot of the system (I assume
>somehow
>      with the right combination of memory accesses  it causes a 
>      triple-fault?)
>
>#2 is why I spent all of this time tracking this down, I couldn't leave
>a 
>machine fuzzing overnight without the machine rebooting.
>
>Vince

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
