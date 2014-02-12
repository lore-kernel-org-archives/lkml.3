Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaBLWem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:34:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:39951 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaBLWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:34:41 -0500
Message-ID: <52FBF5DD.3030407@windriver.com>
Date: Wed, 12 Feb 2014 17:29:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        <x86@kernel.org>
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string handling
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com> <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com> <20140212020010.GB21033@windriver.com> <alpine.DEB.2.02.1402111821510.13509@chino.kir.corp.google.com> <52FB8BEB.5020506@windriver.com> <52FB9807.40706@windriver.com> <alpine.DEB.2.02.1402121357450.27082@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402121357450.27082@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-02-12 05:00 PM, David Rientjes wrote:
> On Wed, 12 Feb 2014, Paul Gortmaker wrote:
> 
>> Actually no v2 pending.  The original v1 patch was/is correct as-is.
>>
>> While x86-64 defconfig passed, it turns out that both strcmp and strstr
>> have to stay, else we will get this on i386 allyesconfig builds:
>>
>> arch/x86/boot/compressed/eboot.o: In function `handle_cmdline_files.isra.5.constprop.6':
>> eboot.c:(.text+0x4cf): undefined reference to `strstr'
>> eboot.c:(.text+0x601): undefined reference to `strstr'
>> make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
>>
> 
> This means there is a strstr() prototype that is visible to 
> drivers/firmware/efi/efi-stub-helper.c but fails at linkage because you've 
> removed the definition. 

Yes, because you suggested removal when you said, in what is
now deleted context text:

 "I don't see why you can't remove strstr() in 
 arch/x86/boot/string.c entirely.  What breaks?"

The above answers your question. The eboot.c breaks.  So
we can't remove strstr.

> So, again, why would you add a duplicate 
> prototype with your patch?

I'm sure there is an implicit path to <linux/string.h>
which allows eboot.c to see a prototype and hence compile.

But that prototype is not associated with the early boot
string.c support.  Those prototypes are in boot.h -- where
my 1st patch added the strstr one to be consistent with
all the other early boot string.c functions.  Is it clear now?

> 
>> arch/x86/boot/edd.o: In function `query_edd':
>> arch/x86/boot/edd.c:136: undefined reference to `strcmp'
>> arch/x86/boot/edd.c:136: undefined reference to `strcmp'
>> arch/x86/boot/edd.c:140: undefined reference to `strcmp'
>> arch/x86/boot/edd.c:142: undefined reference to `strcmp'
>> make[1]: *** [arch/x86/boot/setup.elf] Error 1
>>
>> So my gut feeling was right after all.  ;)
>>
> 
> I'm not sure what strcmp has to do with this.

Per the earlier mail, and you suggestion about removal of
anything unused, this demonstrated that strcmp was also being
used and hence could not be removed either.

Paul.
