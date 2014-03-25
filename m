Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaCYNZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:25:50 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:58840 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaCYNZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:25:48 -0400
Message-ID: <533183D5.8020704@tilera.com>
Date: Tue, 25 Mar 2014 09:25:41 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Eric Paris <eparis@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compat_audit: allow it to work without asm/unistd32.h
References: <201403201730.s2KHUVpf005157@farm-0039.internal.tilera.com> <1395678071.24733.3.camel@flatline.rdu.redhat.com> <53305FC4.3040002@tilera.com> <5330E6E0.4020503@linaro.org>
In-Reply-To: <5330E6E0.4020503@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/24/2014 10:16 PM, AKASHI Takahiro wrote:
> On 03/25/2014 01:39 AM, Chris Metcalf wrote:
>> The problem is that audit_is_compat() is a dynamic test that the compiler
>> can't optimize away, so you end with an undefined reference to
>> audit_classify_compat_syscall().
>>
>>
>
> [...]
> I prefer
> #ifdef CONFIG_AUDIT_COMPAT_GENERIC
> #define audit_is_compat(arch) (...)
> #else
> #define audit_is_compat(arch) false
> #endif

This works fine for tilegx:

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 9af01d77dc44..3273d01ba417 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -362,7 +362,7 @@ enum {
 #define AUDIT_ARCH_SPARC64     (EM_SPARCV9|__AUDIT_ARCH_64BIT)
 #define AUDIT_ARCH_X86_64      (EM_X86_64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)

-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AUDIT_COMPAT_GENERIC
 #define audit_is_compat(arch)  (!((arch) & __AUDIT_ARCH_64BIT))
 #else
 #define audit_is_compat(arch)  false

Thanks!

>> On 3/24/2014 12:21 PM, Eric Paris wrote:
>>> I don't know tilegx, but I have replaced 223b24d807610 with
>>> 4b58841149dcaa5.  I believe adding AUDIT_ARCH_COMPAT_GENERIC was
>>> akashi-san's  fix for this problem on mips.  Is this a better fix?
>>>
>>> Thanks
>>> -Eric
>>>
>>> On Thu, 2014-03-20 at 11:31 -0400, Chris Metcalf wrote:
>>>> For architectures that use the asm-generic syscall table for both
>>>> 32- and 64-bit, there should be no need to provide a separate
>>>> <asm/unistd32.h>; just using <linux/unistd.h> is sufficient.
>>>> Conditionalize use of <asm/unistd32.h> on the one platform that
>>>> currently requires it (arm64).  If another platform ends up needing
>>>> it we can create a suitable config flag at that point.
>>>>
>>>> This change fixes the tilegx build failure seen in linux-next.
>>>>
>>>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>>>> ---
>>>> By the way - I also note that commit 223b24d807610 that introduced
>>>> this also put an "#ifdef COMPAT_xxx" in a UAPI header.  This seems
>>>> like a pretty clear signal that the added code should be in
>>>> linux/include/audit.h, not linux/uapi/include/audit.h.  But here
>>>> I'm just focussing on getting tilegx to continue to build...
>>>>
>>>>   lib/compat_audit.c | 7 ++++++-
>>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/lib/compat_audit.c b/lib/compat_audit.c
>>>> index 873f75b640ab..e89a84b3fbe8 100644
>>>> --- a/lib/compat_audit.c
>>>> +++ b/lib/compat_audit.c
>>>> @@ -1,6 +1,11 @@
>>>>   #include <linux/init.h>
>>>>   #include <linux/types.h>
>>>> -#include <asm/unistd32.h>
>>>> +#ifdef COMPAT_ARM64
>>>> +/* 64-bit syscalls are generic, but 32-bit are not. */
>>>> +# include <asm/unistd32.h>
>>>> +#else
>>>> +# include <linux/unistd.h>
>>>> +#endif
>>>>
>>>>   unsigned compat_dir_class[] = {
>>>>   #include <asm-generic/audit_dir_write.h>
>>>
>>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

