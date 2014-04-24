Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaDXLYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:24:19 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52409 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaDXLYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:24:16 -0400
Message-ID: <5358F458.1030300@hitachi.com>
Date: Thu, 24 Apr 2014 20:24:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, Rob Landley <rob@landley.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>, systemtap@sourceware.org
Subject: Re: [PATCH -tip v9 20/26] kprobes: Support blacklist functions in
 module
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140417081856.26341.53535.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140424085601.GA7768@gmail.com>
In-Reply-To: <20140424085601.GA7768@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/24 17:56), Ingo Molnar wrote:
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index f520a76..2fdb673 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -16,6 +16,7 @@
>>  #include <linux/kobject.h>
>>  #include <linux/moduleparam.h>
>>  #include <linux/jump_label.h>
>> +#include <linux/kprobes.h>
> 
> This include breaks the x86 build:
> 
>   CC      arch/x86/kernel/jump_label.o
>   In file included from arch/x86/kernel/jump_label.c:14:0:
>   /fast/mingo/tip/arch/x86/include/asm/kprobes.h:35:12: error: conflicting types for ‘kprobe_opcode_t' typedef u8 kprobe_opcode_t;
>   [...]

Hmm, this error seems very odd... and I don't see

> 
> But the #include kprobes.h is unnecessary to begin with, as no kprobe 
> specific types are used.

OK, anyway I'll remove that.

> 
>>  #include <linux/export.h>
>>  
>>  #include <linux/percpu.h>
>> @@ -357,6 +358,10 @@ struct module {
>>  	unsigned int num_ftrace_callsites;
>>  	unsigned long *ftrace_callsites;
>>  #endif
>> +#ifdef CONFIG_KPROBES
>> +	unsigned int num_kprobe_blacklist;
>> +	unsigned long  *kprobe_blacklist;
>> +#endif
> 
> There's a small coding style problem here.
> 
> More importantly, I think more should be done to make sure that module 
> symbols are marked properly: since the module is going to register the 
> kprobes handler, that would be a perfect place to emit a warning, 
> right?
> 
> In fact, why don't kprobe handlers get added to the exclusion list 
> explicitly, when the handler gets registered? With such an approach 
> handlers are automatically nokprobe and don't need any annotation - 
> which is a far more robust usage model.

Ah, I see. That is because there are some local functions called only
from the kprobe handlers. It is easy to blacklist the kprobe handlers
itself, but not for the functions which are only called from them. :(

So, I can add a patch which automatically add handler functions to
blacklist. But that is another story. I think this patch is also
required.

Thank you,

> 
> So I'm skipping this patch and the next one that makes use of it.
> 
> Thanks,
> 
> 	Ingo
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


