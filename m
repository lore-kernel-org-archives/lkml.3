Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3AVX5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:57:16 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54269 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3AVX5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
	<CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
Date: Tue, 22 Jan 2013 16:57:06 -0700
Message-ID: <CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:55 AM, Shuah Khan <shuahkhan@gmail.com> wrote:

>>> init:
>>
>> Does the attached patch stop them?  It basically skips all initialization of the DMA ring on your system.  What I don't understand is why you still get them with the previous patch, but not with 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb reverted.  909d9eb67f1e4e39f2ea88e96bde03d560cde3eb only affects the use of the DMA ring for buffer migration and the patch I previously attached disables the use of the DMA ring for buffer migration.  Does the latest batch of drm-fixes from Dave that Linus just merged help?
>>
>> Alex
>
> Will try your latest patch. Will also try the latest git - I am
> currently on Jan 17th. However, in the meantime, I found that these
> messages might not be new and getting printed now with the
> eaaa6983ab2ccdf826c90838eb584211e0cadb76 [PATCH] drm/radeon: print dma
> status reg on lockup (v2) commit that introduced debug messages in
> r600_gpu_soft_reset(). I couldn't revert this commit, but doing a
> compile with these messages commented out. Will update you on the
> results and then test the new git
>
> -- Shuah

Here is what I tried:

1. Applied your latest disable_dma_ring_on_6xx-2.diff and still see messages.
2. Tried intel_iommu=igfx_off to see if that changes anything. The
reason for trying this option is, I noticed this message: (this is not
a new message, I see this all the time)

[    1.337112] DMAR: Disabling IOMMU for graphics on this chipset

No change with or without option - still see the same messages.

Next steps:

1. One big difference between 3.7 and 3.8 is in the
r600_gpu_soft_reset() - I started with 3.7 to see the differences if
any of these differences is causing this to be logged. In 3.7
r600_gpu_soft_reset() is called with no reset_mask. I am going to
first verify if softreset happens on 3.7. Does this give you any ideas
of whether this could cause a problem?

2. Another angle I am looking at is the newly added

dev_info(rdev->dev, "  R_00D034_DMA_STATUS_REG   = 0x%08X\n",
                RREG32(DMA_STATUS_REG));

messages in r600_gpu_soft_reset_dma().

Could it be that these newly added debug messages are now showing this
old condition that always existed on my test system. From what I have
observed so far, this is very likely.

Please let me know if you want to me try anything else or if you don't
think these steps won't help.

-- Shuah
