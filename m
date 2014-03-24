Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaCXQjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 12:39:35 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52149 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaCXQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 12:39:34 -0400
Message-ID: <53305FC4.3040002@tilera.com>
Date: Mon, 24 Mar 2014 12:39:32 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH] compat_audit: allow it to work without asm/unistd32.h
References: <201403201730.s2KHUVpf005157@farm-0039.internal.tilera.com> <1395678071.24733.3.camel@flatline.rdu.redhat.com>
In-Reply-To: <1395678071.24733.3.camel@flatline.rdu.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that audit_is_compat() is a dynamic test that the compiler
can't optimize away, so you end with an undefined reference to
audit_classify_compat_syscall(). 

For some reason audit_classify_compat_syscall() is declared as __weak
in <linux/audit.h>; usually the __weak tag is only provided on the definition.
But I suppose you could imagine providing a weak definition in lib/audit.c
itself.

Or there could be a CONFIG_AUDIT_COMPAT symbol that architectures need to
set if they want to have audit_is_compat() return anything other than "false",
and then just use that symbol in the #ifdef in <uapi/linux/audit.h>.  In that
case the compiler would optimize away the call to audit_classify_compat_syscall().

My guess is that the second option is probably cleanest.

On 3/24/2014 12:21 PM, Eric Paris wrote:
> I don't know tilegx, but I have replaced 223b24d807610 with
> 4b58841149dcaa5.  I believe adding AUDIT_ARCH_COMPAT_GENERIC was
> akashi-san's  fix for this problem on mips.  Is this a better fix?
>
> Thanks
> -Eric
>
> On Thu, 2014-03-20 at 11:31 -0400, Chris Metcalf wrote:
>> For architectures that use the asm-generic syscall table for both
>> 32- and 64-bit, there should be no need to provide a separate
>> <asm/unistd32.h>; just using <linux/unistd.h> is sufficient.
>> Conditionalize use of <asm/unistd32.h> on the one platform that
>> currently requires it (arm64).  If another platform ends up needing
>> it we can create a suitable config flag at that point.
>>
>> This change fixes the tilegx build failure seen in linux-next.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>> By the way - I also note that commit 223b24d807610 that introduced
>> this also put an "#ifdef COMPAT_xxx" in a UAPI header.  This seems
>> like a pretty clear signal that the added code should be in
>> linux/include/audit.h, not linux/uapi/include/audit.h.  But here
>> I'm just focussing on getting tilegx to continue to build...
>>
>>  lib/compat_audit.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/compat_audit.c b/lib/compat_audit.c
>> index 873f75b640ab..e89a84b3fbe8 100644
>> --- a/lib/compat_audit.c
>> +++ b/lib/compat_audit.c
>> @@ -1,6 +1,11 @@
>>  #include <linux/init.h>
>>  #include <linux/types.h>
>> -#include <asm/unistd32.h>
>> +#ifdef COMPAT_ARM64
>> +/* 64-bit syscalls are generic, but 32-bit are not. */
>> +# include <asm/unistd32.h>
>> +#else
>> +# include <linux/unistd.h>
>> +#endif
>>  
>>  unsigned compat_dir_class[] = {
>>  #include <asm-generic/audit_dir_write.h>
>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

