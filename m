Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbaDIQM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:12:28 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60841 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933811AbaDIQML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:12:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140409090204.GA6583@linaro.org>
References: <1396926910-11227-1-git-send-email-keescook@chromium.org>
	<1396926910-11227-3-git-send-email-keescook@chromium.org>
	<20140409090204.GA6583@linaro.org>
Date: Wed, 9 Apr 2014 09:12:10 -0700
X-Google-Sender-Auth: K1uDEaoPoPJRlOqGGQ_GK-VdhSU
Message-ID: <CAGXu5jL0Exz0TSYE1EaPVwxik5+0y3QXTWLkU6Ti+9+ahHM=ow@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: mm: allow text and rodata sections to be read-only
From: Kees Cook <keescook@chromium.org>
To: Steve Capper <steve.capper@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 2:02 AM, Steve Capper <steve.capper@linaro.org> wrote:
> Hi Kees,
>
> On Mon, Apr 07, 2014 at 08:15:10PM -0700, Kees Cook wrote:
>> This introduces CONFIG_DEBUG_RODATA, making kernel text and rodata
>> read-only. Additionally, this splits rodata from text so that rodata can
>> also be NX, which may lead to wasted memory when aligning to SECTION_SIZE.
>>
>> The read-only areas are made writable during ftrace updates. Additional
>> work is needed for kprobes and kexec, so the feature is temporarily
>> marked as unavailable in Kconfig when those options are selected.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/arm/include/asm/cacheflush.h |    9 ++++++++
>>  arch/arm/kernel/ftrace.c          |   17 ++++++++++++++
>>  arch/arm/kernel/vmlinux.lds.S     |    3 +++
>>  arch/arm/mm/Kconfig               |   12 ++++++++++
>>  arch/arm/mm/init.c                |   46 +++++++++++++++++++++++++++++++++++++
>>  5 files changed, 87 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
>> index 8b8b61685a34..b6fea0a1a88b 100644
>> --- a/arch/arm/include/asm/cacheflush.h
>> +++ b/arch/arm/include/asm/cacheflush.h
>> @@ -487,4 +487,13 @@ int set_memory_rw(unsigned long addr, int numpages);
>>  int set_memory_x(unsigned long addr, int numpages);
>>  int set_memory_nx(unsigned long addr, int numpages);
>>
>> +#ifdef CONFIG_DEBUG_RODATA
>> +void mark_rodata_ro(void);
>> +void set_kernel_text_rw(void);
>> +void set_kernel_text_ro(void);
>> +#else
>> +static inline void set_kernel_text_rw(void) { }
>> +static inline void set_kernel_text_ro(void) { }
>> +#endif
>> +
>>  #endif
>> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
>> index af9a8a927a4e..ea446ae09c89 100644
>> --- a/arch/arm/kernel/ftrace.c
>> +++ b/arch/arm/kernel/ftrace.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/ftrace.h>
>>  #include <linux/uaccess.h>
>>  #include <linux/module.h>
>> +#include <linux/stop_machine.h>
>>
>>  #include <asm/cacheflush.h>
>>  #include <asm/opcodes.h>
>> @@ -35,6 +36,22 @@
>>
>>  #define      OLD_NOP         0xe1a00000      /* mov r0, r0 */
>>
>> +static int __ftrace_modify_code(void *data)
>> +{
>> +     int *command = data;
>> +
>> +     set_kernel_text_rw();
>> +     ftrace_modify_all_code(*command);
>> +     set_kernel_text_ro();
>> +
>> +     return 0;
>> +}
>
> Would another approach be to keep all the kernel .text ro then override
> probe_kernel_write (which has a weak reference), to create a separate
> temporary rw mapping to the specific page that needs to be modified?
>
> That way you only worry about TLB and cache maintenance for a smaller
> area. Also, your kernel .text VAs never actually become writable, so
> you don't need to worry as much about unauthorised changes whilst your
> guard is temporarily down.
>
> (Though lots of small changes could probably make this more
> expensive, and you will need to double check aliasing in pre-ARMv7).

As I understand it, early boot needs some of these areas RWX. Doing
the protection during init-free means we can avoid all that and still
allow the memory to get reclaimed. As to not doing section
re-mappings, I share the same concern about it being very expensive to
do lots of small changes. As such, I think this is the cleanest
approach that is still portable.

-Kees

-- 
Kees Cook
Chrome OS Security
