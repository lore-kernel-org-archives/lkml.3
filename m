Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaBLXbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:31:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55224 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaBLXbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:31:36 -0500
Message-ID: <52FC0439.7020508@zytor.com>
Date: Wed, 12 Feb 2014 15:31:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string handling
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com> <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com> <20140212020010.GB21033@windriver.com> <alpine.DEB.2.02.1402111821510.13509@chino.kir.corp.google.com> <52FB8BEB.5020506@windriver.com> <52FB9807.40706@windriver.com> <alpine.DEB.2.02.1402121357450.27082@chino.kir.corp.google.com> <52FBF5DD.3030407@windriver.com> <alpine.DEB.2.02.1402121508430.20539@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402121508430.20539@chino.kir.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 03:14 PM, David Rientjes wrote:
> On Wed, 12 Feb 2014, Paul Gortmaker wrote:
> 
>>> This means there is a strstr() prototype that is visible to 
>>> drivers/firmware/efi/efi-stub-helper.c but fails at linkage because you've 
>>> removed the definition. 
>>
>> Yes, because you suggested removal when you said, in what is
>> now deleted context text:
>>
>>  "I don't see why you can't remove strstr() in 
>>  arch/x86/boot/string.c entirely.  What breaks?"
>>
>> The above answers your question. The eboot.c breaks.  So
>> we can't remove strstr.
>>
> 
> Thanks.
> 
>>> So, again, why would you add a duplicate 
>>> prototype with your patch?
>>
>> I'm sure there is an implicit path to <linux/string.h>
>> which allows eboot.c to see a prototype and hence compile.
>>
> 
> Nope, linux/string.h only declares the prototype when 
> #ifndef __HAVE_ARCH_STRSTR and the 32-bit x86 declaration in 
> include/asm/string_32.h properly does #define __HAVE_ARCH_STRSTR.
> 
> There's also no #include ordering issue here since linux/string.h does 
> #include <asm/string.h> first.
> 
> If you had a real problem here, the build would break.  So I'll renew my 
> original objection: I don't think it's acceptable to add unneeded 
> prototypes because sparse doesn't understand this.
> 

The real answer IMO ought to be that since arch/x86/boot/string.c is now
used separately from boot.h (eboot.c which includes efi-stub-helper.c
does *not* include boot.h) we may have to move those string functions
into a separate header file.

Matt, do you have any opinions here?

I don't think it is appropriate to leave these warnings in the code
"just because".  We have too many live warnings, some of which are real
bugs, and we need to encourage people to address them instead of leaving
them lost in the noise.

	-hpa

