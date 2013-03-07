Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3CGKfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:35:54 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53698 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3CGKfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:35:53 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1303071721540.28820@syhkavp.arg>
References: <1362372667-953-1-git-send-email-iamjoonsoo.kim@lge.com>
	<alpine.LFD.2.03.1303051642110.28820@syhkavp.arg>
	<20130307081258.GA14839@lge.com>
	<alpine.LFD.2.03.1303071721540.28820@syhkavp.arg>
Date: Thu, 7 Mar 2013 19:35:51 +0900
Message-ID: <CAAmzW4NjefPV7tryvySfLXPy6Zcz3BLTvfxD=UnTKCqrRB3voQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ARM: mm: disable kmap_high_get() for SMP
From: JoonSoo Kim <js1304@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/7 Nicolas Pitre <nicolas.pitre@linaro.org>:
> On Thu, 7 Mar 2013, Joonsoo Kim wrote:
>
>> Hello, Nicolas.
>>
>> On Tue, Mar 05, 2013 at 05:36:12PM +0800, Nicolas Pitre wrote:
>> > On Mon, 4 Mar 2013, Joonsoo Kim wrote:
>> >
>> > > With SMP and enabling kmap_high_get(), it makes users of kmap_atomic()
>> > > sequential ordered, because kmap_high_get() use global kmap_lock().
>> > > It is not welcome situation, so turn off this optimization for SMP.
>> >
>> > I'm not sure I understand the problem.
>> >
>> > The lock taken by kmap_high_get() is released right away before that
>> > function returns and therefore this is not actually serializing
>> > anything.
>>
>> Yes, you understand what I want to say correctly.
>> Sorry for bad explanation.
>>
>> Following is reasons why I send this patch with RFC tag.
>>
>> If we have more cpus, performance degration is possible although
>> it is very short time to holding the lock in kmap_high_get().
>>
>> And kmap has maximum 512 entries(512 * 4K = 2M) and some mobile devices
>> has 2G memory(highmem 1G>), so probability for finding matched entry
>> is approximately < 1/512. This probability can be more decreasing
>> for device which have more memory. So I think that waste time to find
>> matched entry is more than saved time.
>>
>> Above is my humble opinion, so please let me know what I am missing.
>
> Please look at the kmap_high_get() code again.  It performs no
> searching at all.  What it does is:

If page is not highmem, it may be already filtered in kmap_atomic().
So we only consider highmem page.

For highmem page, it perform searching.
In kmap_high_get(), page_address() is called.
In page_address(), it hash PA and iterate a list for this hashed value.

And another advantage of disabling ARCH_NEEDS_KMAP_HIGH_GET is
that kmap(), kunmap() works without irq disabled.

Thanks.

> - lock the kmap array against concurrent changes
>
> - if the given page is not highmem, unlock and return NULL
>
> - otherwise increment that page reference count, unlock, and return the
>   mapped address for that page.
>
> There is almost zero cost to this function, independently of the number
> of kmap entries, whereas it does save much bigger costs elsewhere when
> it is successful.
>
>
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
