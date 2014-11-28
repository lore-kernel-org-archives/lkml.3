Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaK1I4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:56:00 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22594 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaK1Iz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:55:58 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-de-5478389a1961
Message-id: <54783899.2060604@samsung.com>
Date: Fri, 28 Nov 2014 09:55:53 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v9 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
References: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
 <20141127225100.GA3840@n2100.arm.linux.org.uk>
In-reply-to: <20141127225100.GA3840@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4Nd1ZFhUhBrd3aVr8nXSM3eLR/MfM
	Fr0LrrJZnG16w26xvXMGu8WUP8uZLDY9vsZqcXnXHDaL2Uv6WSxmnN/HZHH7Mq/Fue1bWCyW
	Xr/IZHHq+mc2i1W7/jBa7L/i5SDgsWbeGkaPluYeNo/fvyYxenz7OonF43JfL5PHou9ZHjtn
	3WX3uHNtD5vH5iX1HldONLF69G1ZxejxeZNcAE8Ul01Kak5mWWqRvl0CV8bGCZuYCj6IV6x7
	8pStgXGCcBcjJ4eEgInEplsTWSBsMYkL99azdTFycQgJLGWU6DkxnQnC+cQo0da6jLmLkYOD
	V0BL4uIsd5AGFgFViRkbLrKD2GwChhJdb7vYQGxRgRiJ+ztXg9m8AoISPybfA1sgImAqce3R
	M2YQm1ngKrPEjqvyILawgLfEiZ9trCC2kECFRMOsDiYQm1PAWmLe7odQ9WYSX14eZoWw5SU2
	r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkj0fdnBuPiY
	1SFGAQ5GJR7ehMdlIUKsiWXFlbmHGCU4mJVEeE99LQ8R4k1JrKxKLcqPLyrNSS0+xMjEwSnV
	wBgTm/5IW/7b/PY4UwbJqojf5+paoiSWlJ8xu5rysGOPr82BvCvrle5llNYvOd+067LNiQ/S
	ZcmHWEV27Sz/n7FSf8eBxP/fH8bISWiIaKzad2RmijmDyqWrbPNfHt966PJmu3tm5y+8XCi0
	33lpzP5mRh6RJ2pd6uX33l2sDBVLjxcPaeCNUFFiKc5INNRiLipOBACe8nMtnAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-11-27 23:51, Russell King - ARM Linux wrote:
> On Mon, Nov 17, 2014 at 12:48:22PM +0100, Marek Szyprowski wrote:
>> This is an updated patchset, which intends to add support for L2 cache
>> on Exynos4 SoCs on boards running under secure firmware, which requires
>> certain initialization steps to be done with help of firmware, as
>> selected registers are writable only from secure mode.
>>
>> First four patches extend existing support for secure write in L2C driver
>> to account for design of secure firmware running on Exynos. Namely:
>>   1) direct read access to certain registers is needed on Exynos, because
>>      secure firmware calls set several registers at once,
>>   2) not all boards are running secure firmware, so .write_sec callback
>>      needs to be installed in Exynos firmware ops initialization code,
>>   3) write access to {DATA,TAG}_LATENCY_CTRL registers fron non-secure world
>>      is not allowed and so must use l2c_write_sec as well,
>>   4) on certain boards, default value of prefetch register is incorrect
>>      and must be overridden at L2C initialization.
>> For boards running with firmware that provides access to individual
>> L2C registers this series should introduce no functional changes. However
>> since the driver is widely used on other platforms I'd like to kindly ask
>> any interested people for testing.
>>
>> Further three patches add implementation of .write_sec and .configure
>> callbacks for Exynos secure firmware and necessary DT nodes to enable
>> L2 cache.
>>
>> Changes in this version tested on Exynos4412-based TRATS2 and OdroidU3+
>> boards (both with secure firmware). There should be no functional change
>> for Exynos boards running without secure firmware. I do not have access
>> to affected non-Exynos boards, so I could not test on them.
> So, I applied this series, and now I get a conflicts between my tree and
> arm-soc for:
>
> arch/arm/mach-exynos/firmware.c
> arch/arm/mach-exynos/sleep.S
>
> So, I'm going to un-stage the exynos bits, and we'll have to work out
> some way to handle those.

I've already pointed that those patches depend on other previously merged to
exynos and arm-soc trees, but both Arnd and Kukjin said that those patch 
series
should go via your kernel tree:

https://lkml.org/lkml/2014/11/15/158

That's why in v9 I rebased patches once again onto vanilla v3.18-rc4 and 
uploaded
to your patch tracker. I see the following two possibilities to get them 
merged:

1. Merge patches to rmk tree and resolve the merge conflict. The 
conflict IS quite
easy to resolve - both trees, arm-soc and rmk only adds some code and 
the goal is
simply to have both chunks added.

2. Merge the previous version (v8 from the above link) to arm-soc tree, 
where it
applies cleanly on for-next, preferably with Russell's Acked-by.

Arnd, Russell: which approach do you prefer? How can I help to get it 
merged?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

