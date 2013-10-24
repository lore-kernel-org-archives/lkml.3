Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3JXG1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 02:27:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:57538 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab3JXG1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 02:27:34 -0400
X-Spam-Score: -100.8
Message-ID: <5268BD96.2060806@asianux.com>
Date: Thu, 24 Oct 2013 14:26:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: Joern Rennecke <joern.rennecke@embecosm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH] kernel/modsign_certificate.S: use real contents instead
 of macro GLOBAL()
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com> <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com> <CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com> <52673E41.6040606@asianux.com> <5267AF98.1010800@asianux.com> <5268B0B1.9050009@asianux.com> <CAFLxGvzERDqwZhb_5d=bXKmqz6-Yrema_TLMTM7rjyeFeDJG_w@mail.gmail.com>
In-Reply-To: <CAFLxGvzERDqwZhb_5d=bXKmqz6-Yrema_TLMTM7rjyeFeDJG_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 02:03 PM, Richard Weinberger wrote:
> On Thu, Oct 24, 2013 at 7:31 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> For some architectures, tool chain is not smart enough to recognize the
>> macro with multiple lines (e.g. arc tool chain), and for common ".S"
>> file, this kind of macro is also rarely used.
> 
> Does not "not smart enough" mean than the said toolchain is broken/buggy
> or is the kernel using an unsupported notation?
> 

Hmm... maybe my comments is not quite precise, what I want to say is:

 - another architectures tool chain (e.g. arm-linux-gnueabi-) support it.
   but our tool chain (arc-elf32-) will cause issue.

 - in kernel source, excluding "arch/" sub directory, excep this file and one x86 drivers, no one use macro in this way, now.
   and in "arch/arc/" sub-directory, no one use macro in this way, too.
   the related find command: "find | grep "\.S$" | grep -v "/arch/"  | grep -v "Documentation" | xargs grep define"

So at least, for kernel itself, better change the using way (only 2
areas use the macro, and the macro only contents 2 lines, so it is
acceptable enough to expand it).


Anyway, maybe it is also the tool chain's bug (so I include related arc
tool chain guys in this mail).


Thanks.

>> So expand the related contents of macro to let it pass compiling (can
>> use "arc-elf32-objdump -x" to know about it).
>>
>> The related error (allmodconfig for arc):
>>
>>     LD      init/built-in.o
>>   kernel/built-in.o: In function `load_module_signing_keys':
>>   kernel/modsign_pubkey.c:66: undefined reference to `modsign_certificate_list'
>>   kernel/modsign_pubkey.c:71: undefined reference to `modsign_certificate_list_end'
>>   kernel/modsign_pubkey.c:67: undefined reference to `modsign_certificate_list_end'
>>
>> The related tool chain information:
>>
>>   [root@gchenlinux linux-next]# arc-elf32-as -v
>>   GNU assembler version 2.23.2 (arc-elf32) using BFD version (GNU Binutils) 2.23.2
>>   [root@gchenlinux linux-next]# arc-elf32-ld -v
>>   GNU ld (GNU Binutils) 2.23.2
>>   [root@gchenlinux linux-next]# arc-elf32-gcc -v
>>   Using built-in specs.
>>   COLLECT_GCC=arc-elf32-gcc
>>   COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/arc-elf32/4.8.0/lto-wrapper
>>   Target: arc-elf32
>>   Configured with: ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 : (reconfigured) ../gcc/configure --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 : (reconfigured) ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 --disable-multilib --with-headers=../newlib/newlib/libc/include
>>   Thread model: single
>>   gcc version 4.8.0 (GCC)
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/modsign_certificate.S |   10 ++++------
>>  1 files changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
>> index 4a9a86d..1967dcd 100644
>> --- a/kernel/modsign_certificate.S
>> +++ b/kernel/modsign_certificate.S
>> @@ -1,12 +1,10 @@
>>  #include <linux/export.h>
>>
>> -#define GLOBAL(name)   \
>> -       .globl VMLINUX_SYMBOL(name);    \
>> -       VMLINUX_SYMBOL(name):
>> -
>>         .section ".init.data","aw"
>>
>> -GLOBAL(modsign_certificate_list)
>> +       .globl VMLINUX_SYMBOL(modsign_certificate_list)
>> +VMLINUX_SYMBOL(modsign_certificate_list):
>>         .incbin "signing_key.x509"
>>         .incbin "extra_certificates"
>> -GLOBAL(modsign_certificate_list_end)
>> +       .globl VMLINUX_SYMBOL(modsign_certificate_list_end)
>> +VMLINUX_SYMBOL(modsign_certificate_list_end):
>> --
>> 1.7.7.6
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


-- 
Chen Gang
