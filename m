Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3KRBPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:15:33 -0500
Received: from blu0-omc4-s13.blu0.hotmail.com ([65.55.111.152]:58125 "EHLO
	blu0-omc4-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004Ab3KRBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:15:25 -0500
X-TMN: [S28UfvRjtzQdX804Up8eZ70HWswlPzXv]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP3886F78E435CD570327E2797E40@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1384735922.2050.21.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
References: <20131115220529.GA3160@ls3530.box> <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com> <20131116200717.GA18939@schnuecks.de> <20131116200959.GA14098@kvack.org> <528933BC.50806@gmx.de> <1384724973.2050.14.camel@dabdike.int.hansenpartnership.com> <20131117234707.GA25545@p100.box> <1384735922.2050.21.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sun, 17 Nov 2013 20:15:14 -0500
CC: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>, Simon Baatz <gmbnomis@gmail.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 18 Nov 2013 01:15:24.0274 (UTC) FILETIME=[A8732D20:01CEE3FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17-Nov-13, at 7:52 PM, James Bottomley wrote:

>> +void flush_user_dcache_page(struct page *page);
>> +
>
> The split into flush_kernel.. and flush_user.. is pointless.  We  
> have no
> use for a flush_user_.. API because it's not part of the standard  
> linux
> one.  Plus it's going to confuse those who come after us no end  
> because
> now we're different from every other architecture.

I introduced it because it seemed to be what was needed on parisc when
we map a kernel page on PA8800/PA8900.  We need this to ensure what the
kernel sees is up to date and also to ensure that we don't create  
inequivalent
aliases between the user and kernel mappings.

>
>> #define flush_kernel_dcache_range(start,size) \
>> 	flush_kernel_dcache_range_asm((start), (start)+(size));
>> /* vmap range flushes and invalidates.  Architecturally, we don't  
>> need
>> @@ -125,18 +127,27 @@ flush_anon_page(struct vm_area_struct *vma,  
>> struct page *page, unsigned long vma
>> void mark_rodata_ro(void);
>> #endif
>>
>> -#ifdef CONFIG_PA8X00
>> -/* Only pa8800, pa8900 needs this */
>> -
>> #include <asm/kmap_types.h>
>>
>> #define ARCH_HAS_KMAP
>>
>> -void kunmap_parisc(void *addr);
>> +static inline void kmap_parisc(struct page *page)
>> +{
>> +	if (parisc_requires_coherency())
>> +		flush_user_dcache_page(page);
>> +}
>
> No ... if we're genuinely moving coherency into kmap/kunmap, this  
> has to
> become
>
> 	flush_dcache_page(page);
>
> unconditionally.

There are two things about flush_dcache_page(page):

1) The flush could be deferred.  I don't think we want that.
2) It seems to unnecessarily call flush_kernel_dcache_page().

Dave
--
John David Anglin	dave.anglin@bell.net



