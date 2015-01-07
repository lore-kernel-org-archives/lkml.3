Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbbAGCzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:55:00 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:25353 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328AbbAGCyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:54:43 -0500
Message-ID: <54AC9FC0.7050902@huawei.com>
Date: Wed, 7 Jan 2015 10:53:52 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <acme@kernel.org>, <jolsa@kernel.org>
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind
 is on
References: <1419643571-62764-1-git-send-email-wangnan0@huawei.com> <20141229075607.GC6081@sejong> <54A10D53.2010800@huawei.com>
In-Reply-To: <54A10D53.2010800@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54AC9FE1.00AB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8cbf9f3b983a38873662d12c99e987b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping...

On 2014/12/29 16:14, Wang Nan wrote:
> On 2014/12/29 15:56, Namhyung Kim wrote:
>> Hi Wang,
>>
>> (Adding Arnaldo and Jiri to CC)
>>
>> On Sat, Dec 27, 2014 at 09:26:11AM +0800, Wang Nan wrote:
>>> When build with 'make ARCH=x86' and dwarf unwind is on, there is a
>>> compiling error:
>>>
>>>    CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
>>>    CC       /home/wn/perf/arch/x86/tests/regs_load.o
>>>  arch/x86/tests/regs_load.S: Assembler messages:
>>>  arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
>>>  arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
>>>  make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
>>>  make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
>>>  make: *** [all] Error 2
>>>  ...
>>>
>>> Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
>>> 'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'. However,
>>> with 'ARCH=x86', the underlying compile may also be x86_64, which causes
>>> mismatching.
>>
>> Hmm.. how did you compile this?  I guess ARCH=x86 requires -m32 flag
>> to the gcc, did you pass it (like via EXTRA_CFLAGS=-m32)?
>>
>> I'm confused by 'underlying compile may also be x86_64' part..
>>
> 
> I hit this problem when building perf with Yocto (https://www.yoctoproject.org/), which
> is a famous building system for embeded system.
> 
> When building kernel, we can simply use 'make ARCH=x86' and select 'CONFIG_64BIT'
> in menuconfig to get a x86_64 kernel. As a result, there building framework
> like Yocto doesn't ever consider 'x86_64' as a valid ARCH option. See:
> https://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/classes/kernel-arch.bbclass
> Therefore, when building with such framework, it uses a x86_64 compiler and ARCH=x86.
> 
>> Thanks,
>> Namhyung
>>
>>
>>>
>>> This patch fixes it by checking __x86_64__ in both case of
>>> 'ARCH=x86_64' and 'ARCH=x86'.
>>>
>>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>>> ---
>>>  tools/perf/config/Makefile.arch | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
>>> index 851cd01..303a096 100644
>>> --- a/tools/perf/config/Makefile.arch
>>> +++ b/tools/perf/config/Makefile.arch
>>> @@ -15,6 +15,8 @@ endif
>>>  
>>>  ifeq ($(ARCH),x86_64)
>>>    override ARCH := x86
>>> +endif
>>> +ifeq ($(ARCH),x86)
>>>    IS_X86_64 := 0
>>>    ifeq (, $(findstring m32,$(CFLAGS)))
>>>      IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
>>> -- 
>>> 1.8.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


