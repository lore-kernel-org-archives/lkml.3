Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab3KIDS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 22:18:56 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33199 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3KIDSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 22:18:54 -0500
Message-ID: <527DA997.4080306@hitachi.com>
Date: Sat, 09 Nov 2013 12:18:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
 methods (v6)
References: <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com> <20131106173754.GA11299@redhat.com> <87a9hgwqal.fsf@sejong.aot.lge.com>
In-Reply-To: <87a9hgwqal.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/07 17:48), Namhyung Kim wrote:
> On Wed, 6 Nov 2013 18:37:54 +0100, Oleg Nesterov wrote:
>> On 11/06, Namhyung Kim wrote:
>>>
>>> On Tue, 5 Nov 2013 20:24:01 +0100, Oleg Nesterov wrote:
>>>> On 11/05, Oleg Nesterov wrote:
>>>>>
>>>>> As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
>>>>> the "@" argument anyway, why it can't also substruct this offset?
>>>>>
>>>>> Or perhaps we can change parse_probe_arg("@") to update "param" ? Yes,
>>>>> in this case it needs another argument, not sure...
>>>>
>>>> Or,
>>>>
>>>>> 	+	if (is_ret_probe(tu)) {
>>>>> 	+		saved_ip = instruction_pointer(regs);
>>>>> 	+		instruction_pointer_set(func);
>>>>> 	+	}
>>>>> 		store_trace_args(...);
>>>>> 	+	if (is_ret_probe(tu))
>>>>> 	+		instruction_pointer_set(saved_ip);
>>>>
>>>> we can put "-= tu->offset" here.
>>>
>>> I don't think I get the point.
>>
>> I meant,
>>
>> 		saved_ip = instruction_pointer(regs);
>>
>> 		// pass the "ip" which was used to calculate
>> 		// the @addr argument to fetch_*() methods
>>
>> 		temp_ip = is_ret_probe(tu) ? func : saved_ip;
>> 		temp_ip -= tu->offset;
>> 		instruction_pointer_set(temp_ip);
>>
>> 		store_trace_args(...);
>>
>> 		instruction_pointer_set(saved_ip);
>>
>> This way we can avoid the new "void *" argument for fetch_func_t,
>> we do not need it to calculate the address.
> 
> Okay, but as I said before, subtracting tu->offset part can be removed.

Ah, that's good to me too :)


>>
>> However, now I think it would be more clean to leave FETCH_MTD_memory
>> alone and add FETCH_MTD_memory_dotranslate instead.
>>
>> So trace_uprobes.c should define
>>
>> 	void FETCH_FUNC_NAME(memory, type)(addr, ...)
>> 	{
>> 		copy_from_user((void __user *)addr);
>> 	}
>>
>> 	void FETCH_FUNC_NAME(memory_dotranslate, type)(addr, ...)
>> 	{
>> 		void __user *uaddr = get_user_vaddr(regs, addr);
>> 		copy_from_user(uaddr);
>> 	}
> 
> Looks good.
> 
>>
>> Then,
>>
>>>> Or. Perhaps we can leave "case '@'" in parse_probe_arg() and
>>>> FETCH_MTD_memory alone. You seem to agree that "absolute address"
>>>> can be useful anyway.
>>>
>>> Yes, but it's only meaningful to process-wide tracing sessions IMHO.
>>
>> Yes, yes, sure.
>>
>> I meant, we need both. Say, "perf probe "func global=@addr" means
>> FETCH_MTD_memory, and "perf probe "func global=*addr" means
>> FETCH_MTD_memory_dotranslate.
>>
>> Just in case, of course I do not care about the syntax, for example we
>> can use "@~addr" for translate (or not translate) or whatever.
> 
> Yeah, and I want to hear from Masami.

Hm, this part I need to clarify. So you mean the @addr is for referring
the absolute address in a user process, but @~addr is for referring
the relative address of a executable or library, correct?
In that case, I suggest you to use "@+addr" for the relative address,
since that is an offset, isn't that? :)

BTW, it seems that @addr syntax is hard to use for uprobes, because
current uprobes is based on a binary, not a process, we cannot specify
which process is probed when we define it.


>> My only point: I think we need both to
>>
>> 	1. avoid the new argument in fetch_func_t
>>
>> 	2. allow the dump the data from the absolute address

Looks good to me :)

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


