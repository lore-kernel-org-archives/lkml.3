Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBLPtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:49:16 -0500
Received: from mail1.windriver.com ([147.11.146.13]:38313 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaBLPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:49:15 -0500
Message-ID: <52FB9807.40706@windriver.com>
Date: Wed, 12 Feb 2014 10:49:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        <x86@kernel.org>
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string handling
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com> <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com> <20140212020010.GB21033@windriver.com> <alpine.DEB.2.02.1402111821510.13509@chino.kir.corp.google.com> <52FB8BEB.5020506@windriver.com>
In-Reply-To: <52FB8BEB.5020506@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-02-12 09:57 AM, Paul Gortmaker wrote:
> On 14-02-11 09:23 PM, David Rientjes wrote:
>> On Tue, 11 Feb 2014, Paul Gortmaker wrote:
>>
>>>>> Fixes:
>>>>>
>>>>> arch/x86/boot/compressed/../string.c:60:14: warning: symbol 'atou' was not declared. Should it be static?
>>>>> arch/x86/boot/string.c:133:6: warning: symbol 'strstr' was not declared. Should it be static?
>>>>>
>>>>> The atou one could be considered a false positive; it seems somehow
>>>>> caused by including ./string.c from within /compressed/string.c file.
>>>>> However git grep shows only the atou prototype and declaration, so
>>>>> it is completely unused and we can hence delete it.
>>>>>
>>>>
>>>> Declaring a prototype in a header file would be pointless if there is no 
>>>> current breakage; I don't see why you can't remove strstr() in 
>>>> arch/x86/boot/string.c entirely.  What breaks?
>>>
>>> Explicit breakage vs. sparse warnings are two different things.  It may
>>> be that we can delete strstr() just like I did for atou() -- but in the
>>> interest of doing the minimal change, I did just what was needed for
>>> fixing the sparse warnings for strstr.  I can test if it can be removed,
>>> but it has the smell of generic-libc usage all over it...
>>>
>>
>> When the minimal change is to add an unnecessary prototype for a function 
>> that is not referenced, it doesn't seem acceptable.
> 
> OK, fair enough -- it seems surprisingly unused, as well as strcmp, despite
> my gut feeling that they'd be used in multiple places.  I'll send a v2
> that deletes all three once it passes allyesconfig on linux-next for x86
> 32/64/uml.

Actually no v2 pending.  The original v1 patch was/is correct as-is.

While x86-64 defconfig passed, it turns out that both strcmp and strstr
have to stay, else we will get this on i386 allyesconfig builds:

arch/x86/boot/compressed/eboot.o: In function `handle_cmdline_files.isra.5.constprop.6':
eboot.c:(.text+0x4cf): undefined reference to `strstr'
eboot.c:(.text+0x601): undefined reference to `strstr'
make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1

arch/x86/boot/edd.o: In function `query_edd':
arch/x86/boot/edd.c:136: undefined reference to `strcmp'
arch/x86/boot/edd.c:136: undefined reference to `strcmp'
arch/x86/boot/edd.c:140: undefined reference to `strcmp'
arch/x86/boot/edd.c:142: undefined reference to `strcmp'
make[1]: *** [arch/x86/boot/setup.elf] Error 1

So my gut feeling was right after all.  ;)

Thanks,
Paul.
--
