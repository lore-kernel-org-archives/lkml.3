Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaDYPCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:02:24 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53642 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaDYPCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:02:22 -0400
MIME-Version: 1.0
In-Reply-To: <3334700.hi79274ifW@vostro.rjw.lan>
References: <1397750006-17463-1-git-send-email-semen.protsenko@linaro.org>
	<3334700.hi79274ifW@vostro.rjw.lan>
Date: Fri, 25 Apr 2014 18:02:22 +0300
Message-ID: <CAGBcZGc0vQG2W3-q2uLGLHSCm2jNXuW0EB293GZCkU7LJq8xqg@mail.gmail.com>
Subject: Re: [PATCH] acpi: respect const qualifier
From: Sam Protsenko <semen.protsenko@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is not a mainline kernel problem, surely?

Correct, this warning is just example of possible issue that can be
occurred because of missing "const" qualifier. Actually I saw this
warning in Linaro ACPI kernel (intended for ARMv8 AArch64
architecture).

But I believe that this issue should be fixed in mainline kernel,
because it can cause the same warning in the future.

On 21 April 2014 23:44, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, April 17, 2014 06:53:26 PM Semen Protsenko wrote:
>> This patch fixes next warning:
>>
>> <------------------------------- cut here --------------------------------->
>> drivers/acpi/property.c: In function ‘acpi_free_properties’:
>> drivers/acpi/property.c:35:2: warning: passing argument 1 of ‘acpi_os_free’
>>                               discards ‘const’ qualifier from pointer
>>                               target type [enabled by default]
>>
>>   ACPI_FREE(adev->properties);
>> <------------------------------- cut here --------------------------------->
>
> This is not a mainline kernel problem, surely?
>
>>
>> The problem is next:
>>
>>  - acpi_free_properties() calls ACPI_FREE(), passing "const *"
>>    parameter to it
>>  - ACPI_FREE() is macro for acpi_os_free()
>>  - acpi_os_free() takes "void *" parameter
>>  - acpi_os_free() calls kfree()
>>  - but kfree() requires "const void *" parameter
>>
>> So acpi_os_free() should require "const void *" parameter as well.
>>
>> Signed-off-by: Semen Protsenko <semen.protsenko@linaro.org>
>> ---
>>  include/acpi/platform/aclinux.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
>> index 93c55ed..c6fa763 100644
>> --- a/include/acpi/platform/aclinux.h
>> +++ b/include/acpi/platform/aclinux.h
>> @@ -174,7 +174,7 @@ static inline void *acpi_os_allocate_zeroed(acpi_size size)
>>  #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate_zeroed
>>  #define USE_NATIVE_ALLOCATE_ZEROED
>>
>> -static inline void acpi_os_free(void *memory)
>> +static inline void acpi_os_free(const void *memory)
>>  {
>>       kfree(memory);
>>  }
>>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
