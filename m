Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaCYCQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 22:16:11 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:33838 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaCYCQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 22:16:09 -0400
Message-ID: <5330E6E0.4020503@linaro.org>
Date: Tue, 25 Mar 2014 11:16:00 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>, Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat_audit: allow it to work without asm/unistd32.h
References: <201403201730.s2KHUVpf005157@farm-0039.internal.tilera.com> <1395678071.24733.3.camel@flatline.rdu.redhat.com> <53305FC4.3040002@tilera.com>
In-Reply-To: <53305FC4.3040002@tilera.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 01:39 AM, Chris Metcalf wrote:
> The problem is that audit_is_compat() is a dynamic test that the compiler
> can't optimize away, so you end with an undefined reference to
> audit_classify_compat_syscall().
>
> For some reason audit_classify_compat_syscall() is declared as __weak
> in <linux/audit.h>; usually the __weak tag is only provided on the definition.
> But I suppose you could imagine providing a weak definition in lib/audit.c
> itself.

I still believe that a function can be declared with __weak and replaced
by a strong definition later on (at link time).
But this is not the case anyway.

> Or there could be a CONFIG_AUDIT_COMPAT symbol that architectures need to
> set if they want to have audit_is_compat() return anything other than "false",
> and then just use that symbol in the #ifdef in <uapi/linux/audit.h>.  In that
> case the compiler would optimize away the call to audit_classify_compat_syscall().
>
> My guess is that the second option is probably cleanest.

Yep, but I don't want to add new CONFIG_AUDIT_COMPAT symbol just for
audit_is_compat() because it is only used in lib/audit.c(AUDIT_GENERIC).
Instead, I prefer
#ifdef CONFIG_AUDIT_COMPAT_GENERIC
#define audit_is_compat(arch) (...)
#else
#define audit_is_compat(arch) false
#endif

Thanks,
-Takahiro AKASHI

> On 3/24/2014 12:21 PM, Eric Paris wrote:
>> I don't know tilegx, but I have replaced 223b24d807610 with
>> 4b58841149dcaa5.  I believe adding AUDIT_ARCH_COMPAT_GENERIC was
>> akashi-san's  fix for this problem on mips.  Is this a better fix?
>>
>> Thanks
>> -Eric
>>
>> On Thu, 2014-03-20 at 11:31 -0400, Chris Metcalf wrote:
>>> For architectures that use the asm-generic syscall table for both
>>> 32- and 64-bit, there should be no need to provide a separate
>>> <asm/unistd32.h>; just using <linux/unistd.h> is sufficient.
>>> Conditionalize use of <asm/unistd32.h> on the one platform that
>>> currently requires it (arm64).  If another platform ends up needing
>>> it we can create a suitable config flag at that point.
>>>
>>> This change fixes the tilegx build failure seen in linux-next.
>>>
>>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>>> ---
>>> By the way - I also note that commit 223b24d807610 that introduced
>>> this also put an "#ifdef COMPAT_xxx" in a UAPI header.  This seems
>>> like a pretty clear signal that the added code should be in
>>> linux/include/audit.h, not linux/uapi/include/audit.h.  But here
>>> I'm just focussing on getting tilegx to continue to build...
>>>
>>>   lib/compat_audit.c | 7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/lib/compat_audit.c b/lib/compat_audit.c
>>> index 873f75b640ab..e89a84b3fbe8 100644
>>> --- a/lib/compat_audit.c
>>> +++ b/lib/compat_audit.c
>>> @@ -1,6 +1,11 @@
>>>   #include <linux/init.h>
>>>   #include <linux/types.h>
>>> -#include <asm/unistd32.h>
>>> +#ifdef COMPAT_ARM64
>>> +/* 64-bit syscalls are generic, but 32-bit are not. */
>>> +# include <asm/unistd32.h>
>>> +#else
>>> +# include <linux/unistd.h>
>>> +#endif
>>>
>>>   unsigned compat_dir_class[] = {
>>>   #include <asm-generic/audit_dir_write.h>
>>
>
