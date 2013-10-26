Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3JZCnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 22:43:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:64595 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3JZCnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 22:43:09 -0400
X-Spam-Score: -100.9
Message-ID: <526B2BFE.4090107@asianux.com>
Date: Sat, 26 Oct 2013 10:42:06 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
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
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com> <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com> <CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com> <52673E41.6040606@asianux.com> <5267AF98.1010800@asianux.com> <5268B0B1.9050009@asianux.com> <CA+5PVA6N0c_ych96bC0nPw=hSqFtO-zhFFHzPW96yK8k=Z3fPg@mail.gmail.com>
In-Reply-To: <CA+5PVA6N0c_ych96bC0nPw=hSqFtO-zhFFHzPW96yK8k=Z3fPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 11:29 PM, Josh Boyer wrote:
> On Wed, Oct 23, 2013 at 10:31 PM, Chen Gang <gang.chen@asianux.com> wrote:
>> For some architectures, tool chain is not smart enough to recognize the
>> macro with multiple lines (e.g. arc tool chain), and for common ".S"
>> file, this kind of macro is also rarely used.
>>
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
> 
> Is this only an issue with using multi-line macro definitions in .S
> files?  The practice of using multi-line macro definitions isn't rare.
>  Look at e.g. include/linux/module.h, and a number of other header
> files.
> 

Yes, excluding "arch/*", for all ".S" files, except x86 driver and this
file, no others use multi-line macro definition, and "arch/arc" don't
use mulit-line macro definitions, either.

The related search command is:

  "find | grep -i "\.S$" | grep -v "/arch/"  | grep -v "Documentation" | xargs grep define".

Hmm... at least, in our case, we need not use the multi-line macro
definition, if expand it, the total lines will be shrunk, that will
be more clearer and simpler to source code readers and writers.


> This seems like a toolchain bug that should be fixable if it works for
> other architectures.
> 

Hmm... at least, we are sure the toolchain is not quite smart enough
(but we can not say it must be a bug).


So for me, I recommend to apply this patch (maybe the patch comment
need improvement). It is quite valuable to continue discussing about
it, but it is not related with whether applying this patch or not.

> josh
> 
> 

Thanks.
-- 
Chen Gang
