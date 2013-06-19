Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915Ab3FSQ5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:57:35 -0400
Received: from [207.46.163.151] ([207.46.163.151]:14690 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934462Ab3FSQ5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:57:33 -0400
Message-ID: <51C1E2EF.7020106@caviumnetworks.com>
Date: Wed, 19 Jun 2013 09:57:19 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: Linux 3.10-rc6
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com> <CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com> <CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com> <20130617133055.20463ce157e104af15ef60a1@linux-foundation.org> <51BF7610.10803@caviumnetworks.com> <20130617135920.587959a34da85d7940a6936f@linux-foundation.org> <51BF7ABD.3080508@caviumnetworks.com> <20130617141310.3d62ea2b05041ec5974f9525@linux-foundation.org> <51BF7EE9.8060308@caviumnetworks.com> <20130617143851.480d327256b7cb54f292e147@linux-foundation.org>
In-Reply-To: <20130617143851.480d327256b7cb54f292e147@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-Antispam-Report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:0;SRVR:SN2PR07MB064;H:BL2PRD0712HT004.namprd07.prod.outlook.com;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 02:38 PM, Andrew Morton wrote:
> On Mon, 17 Jun 2013 14:26:01 -0700 David Daney <ddaney@caviumnetworks.com> wrote:
>
>> On 06/17/2013 02:13 PM, Andrew Morton wrote:
>>> On Mon, 17 Jun 2013 14:08:13 -0700 David Daney <ddaney@caviumnetworks.com> wrote:
>>>
>>>>>
>>>>> I think switch-back-to-a-macro is simplest and safest for now.  Perhaps
>>>>> you can queue a 3.11 patch which restores the C function and fixes up
>>>>> mn10300 and ia64?
>>>>>
>>>>
>>>> If the patch is reverted, I will do that.
>>>
>>> I'm not proposing that we revert f21afc25f9ed4.  Retain its
>>> functionality, but do it via a macro for 3.10.

FYI, these two commits:

c0691143dfe (mn10300: Fix include dependency in irqflags.h et al.)
f75773103d2 ([IA64] Fix include dependency in asm/irqflags.h)

... seem to fix all known breakage related to this issue.  So, the patch 
(to convert back to a macro) may not be necessary.

Sorry to create all this late -rc churn,
David Daney

>>>
>>
>> I misread your patch.  Your patch may be incorrect in that the flags
>> variable you introduce has name space collisions with code using the
>> macro.  Linus found this exact problem with the first version of my
>> patch (which was identical to your patch).
>
> Sigh.  Macros do so suck.
>
> --- a/include/linux/smp.h~include-linux-smph-on_each_cpu-switch-back-to-a-macro
> +++ a/include/linux/smp.h
> @@ -11,7 +11,6 @@
>   #include <linux/list.h>
>   #include <linux/cpumask.h>
>   #include <linux/init.h>
> -#include <linux/irqflags.h>
>
>   extern void cpu_idle(void);
>
> @@ -140,17 +139,14 @@ static inline int up_smp_call_function(s
>   }
>   #define smp_call_function(func, info, wait) \
>   			(up_smp_call_function(func, info))
> -
> -static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	func(info);
> -	local_irq_restore(flags);
> -	return 0;
> -}
> -
> +#define on_each_cpu(func, info, wait)		\
> +	({					\
> +		unsigned long __flags;		\
> +		local_irq_save(__flags);	\
> +		func(info);			\
> +		local_irq_restore(__flags);	\
> +		0;				\
> +	})
>   /*
>    * Note we still need to test the mask even for UP
>    * because we actually can get an empty mask from
> _
>
>> Once you fix the name of 'flags', I hope you don't run into the same
>> Include Hell on ia64 and mn10300 that I did.
>
> I build-tested ia64.  I don't have an mn10300 cross-compiler set up.
>
>

