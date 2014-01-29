Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaA2F7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 00:59:09 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36134 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaA2F7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 00:59:07 -0500
Message-ID: <52E898A3.2050401@linaro.org>
Date: Wed, 29 Jan 2014 14:58:59 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v3] audit: Add generic compat syscall support
References: <1384854235-6567-1-git-send-email-takahiro.akashi@linaro.org> <1389945795-4255-1-git-send-email-takahiro.akashi@linaro.org> <1389945795-4255-2-git-send-email-takahiro.akashi@linaro.org> <20140123145119.GE27520@arm.com> <52E5F56F.2030502@linaro.org> <20140127121505.GD32608@arm.com>
In-Reply-To: <20140127121505.GD32608@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin,

Let me correct myself,

On 01/27/2014 09:15 PM, Catalin Marinas wrote:
> On Mon, Jan 27, 2014 at 05:58:07AM +0000, AKASHI Takahiro wrote:
>> Catalin and audit maintainers,
>>
>> On 01/23/2014 11:51 PM, Catalin Marinas wrote:
>>> On Fri, Jan 17, 2014 at 08:03:15AM +0000, AKASHI Takahiro wrote:
>>>> diff --git a/lib/compat_audit.c b/lib/compat_audit.c
>>>> new file mode 100644
>>>> index 0000000..94f6480
>>>> --- /dev/null
>>>> +++ b/lib/compat_audit.c
>>>> @@ -0,0 +1,51 @@
>>>> +#include <linux/init.h>
>>>> +#include <linux/types.h>
>>>> +/* FIXME: this might be architecture dependent */
>>>> +#include <asm/unistd_32.h>
>>>
>>> It most likely is architecture dependent.
>>
>> I'm wondering what name is the most appropriate in this case.
>> Most archictures have __NR_xyz definitions in "unistd_32.h",
>> but arm64 doesn't have it, instead "unistd32." which contains
>> only __SYSCALL(xyz, NO). Confusing?
>
> I don't think we should introduce a new file (or at least it should be
> named something containing "audit" to make it clearer).
>
>>>> +int audit_classify_compat_syscall(int abi, unsigned syscall)
>>>> +{
>>>> +	switch (syscall) {
>>>> +#ifdef __NR_open
>>>> +	case __NR_open:
>>>> +		return 2;
>>>> +#endif
>>>> +#ifdef __NR_openat
>>>> +	case __NR_openat:
>>>> +		return 3;
>>>> +#endif
>>>> +#ifdef __NR_socketcall
>>>> +	case __NR_socketcall:
>>>> +		return 4;
>>>> +#endif
>>>> +	case __NR_execve:
>>>> +		return 5;
>>>> +	default:
>>>> +		return 1;
>>>> +	}
>>>> +}
>>>
>>> BTW, since they aren't many, you could get the arch code to define
>>> __NR_compat_open etc. explicitly and use these. On arm64 we have a few
>>> of these defined to avoid name collision in signal handling code.
>>
>> Again, most architecture have their own unistd32.h for compat system calls,
>> and use __NR_open-like naming.
>> It's unlikely for these archs to migrate to "generic compat" auditing,
>> but I believe that '__NR_open'-like naming is better because we may be able to avoid
>> arch-specific changes even for future(?) syscall-related enhancements in audit.

In my compat_audit.c, all the entries in audit classes are derived from asm-generic/audit_*.h,
where __NR_xyz are used to list the system calls. So it is not possible to use __NR_compat_xyz
as far as we re-use those generic files.
(Obviously we don't want to duplicate those header files, that is, audit_compat_*.h.)

I agree that we should not have similar but different files, like unist32.h and unistd_32.h,
but it seems to be inevitable for our case. (That is the reason why I dynamically generate unistd_32.h)

As for arch-specific header file name, "audit_unistd32.h" can be fine, but people on other architectures
might be unhappy with such a name since they can commonly use unistd32.h instead.


- Takahiro AKASHI

> My preference is as above, a few __NR_compat_* (just those required by
> audit) defined in unistd.h but I'm not an audit maintainer.
>
