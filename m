Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab3EJSBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:01:19 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:41459 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3EJSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130510091923.GH12292@phenom.ffwll.local>
References: <cover.1368128020.git.luto@amacapital.net> <97346b603822ffd8ab446316fc08fbf7686c9d50.1368128020.git.luto@amacapital.net>
 <20130510091923.GH12292@phenom.ffwll.local>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 10 May 2013 11:00:56 -0700
Message-ID: <CALCETrVQzMjxZ87zY=+-TUKAMARnR9m3CzYdWZgEopJxF0TkDw@mail.gmail.com>
Subject: Re: [RFC/PATCH v2 1/8] Add arch_phys_wc_{add,del} to manipulate WC
 MTRRs if needed
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 2:19 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Thu, May 09, 2013 at 12:46:20PM -0700, Andy Lutomirski wrote:
>> Several drivers currently use mtrr_add through various #ifdef guards
>> and/or drm wrappers.  The vast majority of them want to add WC MTRRs
>> on x86 systems and don't actually need the MTRR if PAT (i.e.
>> ioremap_wc, etc) are working.
>>
>> arch_phys_wc_add and arch_phys_wc_del are new functions, available
>> on all architectures and configurations, that add WC MTRRs on x86 if
>> needed (and handle errors) and do nothing at all otherwise.  They're
>> also easier to use than mtrr_add and mtrr_del, so the call sites can
>> be simplified.
>>
>> As an added benefit, this will avoid wasting MTRRs and possibly
>> warning pointlessly on PAT-supporting systems.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/include/asm/io.h       |  7 ++++++
>>  arch/x86/include/asm/mtrr.h     |  5 ++++-
>>  arch/x86/kernel/cpu/mtrr/main.c | 48 +++++++++++++++++++++++++++++++++++++++++
>>  include/linux/io.h              | 25 +++++++++++++++++++++
>>  4 files changed, 84 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>> index d8e8eef..34f69cb 100644
>> --- a/arch/x86/include/asm/io.h
>> +++ b/arch/x86/include/asm/io.h
>> @@ -345,4 +345,11 @@ extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
>>
>>  #define IO_SPACE_LIMIT 0xffff
>>
>> +#ifdef CONFIG_MTRR
>> +extern int __must_check arch_phys_wc_add(unsigned long base,
>> +                                      unsigned long size);
>> +extern void arch_phys_wc_del(int handle);
>> +#define arch_phys_wc_add arch_phys_wc_add
>> +#endif
>> +
>>  #endif /* _ASM_X86_IO_H */
>> diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
>> index e235582..10d0fba 100644
>> --- a/arch/x86/include/asm/mtrr.h
>> +++ b/arch/x86/include/asm/mtrr.h
>> @@ -26,7 +26,10 @@
>>  #include <uapi/asm/mtrr.h>
>>
>>
>> -/*  The following functions are for use by other drivers  */
>> +/*
>> + * The following functions are for use by other drivers that cannot use
>> + * arch_phys_wc_add and arch_phys_wc_del.
>> + */
>>  # ifdef CONFIG_MTRR
>>  extern u8 mtrr_type_lookup(u64 addr, u64 end);
>>  extern void mtrr_save_fixed_ranges(void *);
>> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
>> index 726bf96..23bd49a 100644
>> --- a/arch/x86/kernel/cpu/mtrr/main.c
>> +++ b/arch/x86/kernel/cpu/mtrr/main.c
>> @@ -51,6 +51,7 @@
>>  #include <asm/e820.h>
>>  #include <asm/mtrr.h>
>>  #include <asm/msr.h>
>> +#include <asm/pat.h>
>>
>>  #include "mtrr.h"
>>
>> @@ -524,6 +525,53 @@ int mtrr_del(int reg, unsigned long base, unsigned long size)
>>  }
>>  EXPORT_SYMBOL(mtrr_del);
>>
>> +/**
>> + * arch_phys_wc_add - add a WC MTRR and handle errors if PAT is unavailable
>> + * @base: Physical base address
>> + * @size: Size of region
>> + *
>> + * If PAT is available, this does nothing.  If PAT is unavailable, it
>> + * attempts to add a WC MTRR covering size bytes starting at base and
>> + * logs an error if this fails.
>> + *
>> + * Drivers must store the return value to pass to mtrr_del_wc_if_needed,
>> + * but drivers should not try to interpret that return value.
>> + */
>> +int arch_phys_wc_add(unsigned long base, unsigned long size)
>> +{
>> +     int ret;
>> +
>> +     if (pat_enabled)
>> +             return 0;  /* Success!  (We don't need to do anything.) */
>
> Shouldn't we #define a big number for this case since mtrr_add returns
> 0-based mtrr indices? Rather unlikely that the very first mtrr is unused I
> know, but still feels like a cleaner interface. And we don't need to leak
> that #define out at all to users of this interface.

I did something more like that in v1, but I like having the property
that arch_phys_wc_del(0) does nothing as opposed to possibly breaking
the system.  Given that almost all of these things are stored in
kzalloced space, this seems safer to me.  The return value here could
just as easily be -ENOSYS, but nothing should care.

There is an issue, though: the drm maps interface is leaking the
return values to userspace via a couple of ioctls, so I should fix it
to at least return the correct value.  (Why that interface includes an
mtrr number is a mystery to me.)

Have I convinced you that my bike shed color is okay?  I'll send out a
v3 later today with a fix for the leaking-to-userspace issue and I'll
fix the i915 thing.

--Andy
