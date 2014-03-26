Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaCZHEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:04:11 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47209 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCZHEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:04:09 -0400
Message-ID: <53327BE1.906@hitachi.com>
Date: Wed, 26 Mar 2014 16:04:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Wright <chrisw@sous-sol.org>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, fche@redhat.com,
        mingo@redhat.com, Rob Landley <rob@landley.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alok Kataria <akataria@vmware.com>, systemtap@sourceware.org
Subject: Re: [PATCH -tip v8 04/26] kprobes: Introduce NOKPROBE_SYMBOL() macro
 for blacklist
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115911.22766.61140.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140321204917.636820fa@gandalf.local.home>
In-Reply-To: <20140321204917.636820fa@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/22 9:49), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 20:59:11 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>>
>> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
>> index 0cfb00f..7062631 100644
>> --- a/Documentation/kprobes.txt
>> +++ b/Documentation/kprobes.txt
>> @@ -22,8 +22,9 @@ Appendix B: The kprobes sysctl interface
>>  
>>  Kprobes enables you to dynamically break into any kernel routine and
>>  collect debugging and performance information non-disruptively. You
>> -can trap at almost any kernel code address, specifying a handler
>> +can trap at almost any kernel code address(*), specifying a handler
>>  routine to be invoked when the breakpoint is hit.
>> +(*: at some part of kernel code can not be trapped, see 1.5 Blacklist)
> 
> "*: some parts of the kernel code can not be trapped,"
> 
>>  
>>  There are currently three types of probes: kprobes, jprobes, and
>>  kretprobes (also called return probes).  A kprobe can be inserted
>> @@ -273,6 +274,19 @@ using one of the following techniques:
>>   or
>>  - Execute 'sysctl -w debug.kprobes_optimization=n'
>>  
>> +1.5 Blacklist
>> +
>> +Kprobes can probe almost of the kernel except itself. This means
> 
> s/almost/most/
> 
>> +that there are some functions where kprobes cannot probe. Probing
>> +(trapping) such functions can cause recursive trap (e.g. double
> 
>    cause a recursive trap
> 
>> +fault) or at least the nested probe handler never be called.
> 
>   "or the nested probe handler may never be called."
> 
>> +Kprobes manages such functions as a blacklist.
>> +If you want to add a function into the blacklist, you just need
>> +to (1) include linux/kprobes.h and (2) use NOKPROBE_SYMBOL() macro
>> +to specify a blacklisted function.
>> +Kprobes checks given probe address with the blacklist and reject
> 
>   "checks the given probe address against the black list and rejects"
> 
>> +registering if the given address is in the blacklist.
> 
>    registering it, if

Thank you for helping ! :)

>> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
>> index 4582e8e..7730c1c 100644
>> --- a/arch/x86/include/asm/asm.h
>> +++ b/arch/x86/include/asm/asm.h
>> @@ -57,6 +57,12 @@
>>  	.long (from) - . ;					\
>>  	.long (to) - . + 0x7ffffff0 ;				\
>>  	.popsection
>> +
>> +# define _ASM_NOKPROBE(entry)					\
>> +	.pushsection "_kprobe_blacklist","aw" ;			\
>> +	_ASM_ALIGN ;						\
>> +	_ASM_PTR (entry);					\
>> +	.popsection
>>  #else
>>  # define _ASM_EXTABLE(from,to)					\
>>  	" .pushsection \"__ex_table\",\"a\"\n"			\
>> @@ -71,6 +77,7 @@
>>  	" .long (" #from ") - .\n"				\
>>  	" .long (" #to ") - . + 0x7ffffff0\n"			\
>>  	" .popsection\n"
>> +/* For C file, we already have NOKPROBE_SYMBOL macro */
>>  #endif
>>  
>>  #endif /* _ASM_X86_ASM_H */
>> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
>> index 1b10af8..4c785fd 100644
>> --- a/arch/x86/kernel/paravirt.c
>> +++ b/arch/x86/kernel/paravirt.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/efi.h>
>>  #include <linux/bcd.h>
>>  #include <linux/highmem.h>
>> +#include <linux/kprobes.h>
>>  
>>  #include <asm/bug.h>
>>  #include <asm/paravirt.h>
>> @@ -389,6 +390,9 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
>>  	.end_context_switch = paravirt_nop,
>>  };
>>  
>> +/* At this point, native_get_debugreg has real function entry */
> 
>   "has a real"

OK, I'll fix them all ;)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


