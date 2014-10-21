Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaJUJhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:37:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40656 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaJUJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:37:45 -0400
Message-ID: <54462960.3080006@hitachi.com>
Date: Tue, 21 Oct 2014 18:37:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com> <543F5C84.7090005@hitachi.com> <20141016105709.GA11072@osiris>
In-Reply-To: <20141016105709.GA11072@osiris>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/16 19:57), Heiko Carstens wrote:
> Hi Masami,
> 
> thank you for your comments!
> 
> On Thu, Oct 16, 2014 at 02:49:56PM +0900, Masami Hiramatsu wrote:
>> (2014/10/16 0:46), Heiko Carstens wrote:
>>> we would like to implement an architecture specific variant of "kprobes
>>> on ftrace" without using the current HAVE_KPROBES_ON_FTRACE infrastructure
>>> which is currently only used by x86.
>>>
>>> The rationale for these two patches is:
>>> - we want to patch the first instruction of the mcount code block to
>>>   reduce the overhead of the function tracer
>>> - we'd like to keep the ftrace_caller function as simple as possible and
>>>   not require it to generate a 100% valid pt_regs structure as required
>>>   by the combination of DYNAMIC_FTRACE_WITH_REGS and HAVE_KPROBES_ON_FTRACE.
>>>   This allows us to not generate the psw mask field in the pt_regs
>>>   structure on each function tracer enabled function, which otherwise would
>>>   be very expensive. Besides that program check generated pt_regs contents
>>>   are "more" accurate than program generated ones and don't require any
>>>   maintenance.
>>>   And also we can keep the ftrace and kprobes backends quite separated.
>>
>> I'm not sure about s390 nor have the machine, so it is very helpful if you
>> give us a command line level test and show us the result with this patch :)
>> Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
>> You can add the testcase for checking co-existence of kprobes and ftrace on
>> an entry of a function.
> 
> Ok, my personal test case was just a kernel module, that added/removed a kprobe
> while also enabling/disabling function tracing and verifying that both the
> kprobes handler got called correctly and correct entries were added to the
> function trace buffer.
> Everything worked as expected, however I think I can come up with a test case
> that will fit into the ftrace selftests.
> I just need to get familiar with the kprobe dynamic event interface (again) ;)
> 
>> And also, since ftrace is now supporting assembly trampoline code for each
>> handler, performance overhead can be reduced if we save registers only when
>> the kprobes enabled on the function. I'm not sure it can implement on s390,
>> but your requirement looks similar. What would you think about that?
> 
> Yes, Vojtech Pavlik did send patches which implemented that. But that resulted
> in a lot of asm code duplication which I didn't feel comfortable with.
> Right now the s390 variant of ftrace_regs_caller() is an alias to
> ftrace_caller() which means we only have one piece of code which handles both
> variants.
> I'm still thinking of a different solution which handles the creation of the
> pt_regs contents 100% correct with an own trampoline for ftrace_regs_caller(),
> but that's a different story.
> 
> However, this is more or less independently to the question of what you think
> about allowing an architecture to handle kprobes on ftrace completely in the
> architecture backend.
> 
>>From a pure technical point of view both versions can be implemented and would
> also work on s390:
> - either handling kprobes on ftrace completely by the architecture
> - or implement a "full" version of DYNAMIC_FTRACE_WITH_REGS and then also
>   implement a similar HAVE_KPROBES_ON_FTRACE backend like x86 already has
> 
> Personally I'd prefer handling kprobes on ftrace completely by the
> architecture backend, because both Martin and I think this simply looks
> better, and keeps things more separated.
> Given that this preference only requires removal of a sanity check in
> kprobes.c ("don't put a kprobe on an ftrace location") I'd say this shouldn't
> be a problem, no?

>From the functional point of view, if we can set the kprobes on
ftrace site, that is OK for me. And I'm sure your series doesn't
make change according to your test case. So I think it's OK :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


