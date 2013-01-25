Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3AYEKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:10:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31241 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AYEKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:10:37 -0500
Message-ID: <51020566.6040408@oracle.com>
Date: Thu, 24 Jan 2013 23:09:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, jbaron@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 3/5] kprobes: constify check_kprobe_address_safe and friends
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com> <1357772960-4436-3-git-send-email-sasha.levin@oracle.com> <50FD2B30.20100@hitachi.com>
In-Reply-To: <50FD2B30.20100@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Masami,

Thank you for your review!

My comments are below.

On 01/21/2013 06:49 AM, Masami Hiramatsu wrote:
> (2013/01/10 8:09), Sasha Levin wrote:
>> @@ -278,7 +278,7 @@ static int __kprobes can_optimize(unsigned long paddr)
>>  }
>>  
>>  /* Check optimized_kprobe can actually be optimized. */
>> -int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
>> +int __kprobes arch_check_optimized_kprobe(const struct optimized_kprobe *op)
>>  {
>>  	int i;
>>  	struct kprobe *p;
> 
> This can be change optimized_kprobe inside, e.g. change flags.
> IMHO, I don't like to change this interface.

[snip]

>> -static __kprobes int check_kprobe_address_safe(struct kprobe *p,
>> +static __kprobes int check_kprobe_address_safe(const struct kprobe *p,
>>  					       struct module **probed_mod)
>>  {
>>  	int ret = 0;
>>
> 
> No, p is NOT constant in this function. This changes p->flags.
> 
> ---
> #ifdef KPROBES_CAN_USE_FTRACE
>                 /* Given address is not on the instruction boundary */
>                 if ((unsigned long)p->addr != ftrace_addr)
>                         return -EILSEQ;
>                 p->flags |= KPROBE_FLAG_FTRACE;
> #else   /* !KPROBES_CAN_USE_FTRACE */

As to arch_check_optimized_kprobe() and check_kprobe_address_safe(), this
is simply way too confusing. It doesn't make sense that a function named
check_[...]() would modify any of it's parameters.

For example, that entire block within KPROBES_CAN_USE_FTRACE should be split
out and go into update_kprobe_for_ftrace() or something similar.

If that makes sense, I can send a patch to split out all the parts that
modify anything in those two functions out of them.


Thanks,
Sasha
