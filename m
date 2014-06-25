Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaFYKLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:11:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17769 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaFYKLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:11:16 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4d-53aaa042220e
Message-id: <53AAA02A.1090601@samsung.com>
Date: Wed, 25 Jun 2014 12:10:50 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Daniel Drake <drake@endlessm.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 3/6] clk: samsung: exynos4: Remove SRC_MASK_ISP gates
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-4-git-send-email-t.figa@samsung.com>
 <CAD8Lp45a0kQocSFVeXGY99jE+Rx7PVwv6ZZKbE8iFp7G4=X12A@mail.gmail.com>
In-reply-to: <CAD8Lp45a0kQocSFVeXGY99jE+Rx7PVwv6ZZKbE8iFp7G4=X12A@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xy7pOC1YFGxxdLGHxaP5jZoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVmsPXKX3eLphItsFqt2/WF04PBY9D3LY+esu+wed67tYfPYvKTe
	o2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDKOdeUUfOSrOH9hEWMD4zPuLkZODgkBE4n2zzvY
	IWwxiQv31rN1MXJxCAksZZRYuf03lPOZUeLL/jdsIFW8AloSn65vYQSxWQRUJfr2LGUFsdkE
	1CQ+NzwCq+EHqlnTdJ2li5GDQ1QgQuLxBSGIVkGJH5PvsYDYIkCtv5Y3s4LMZxZYzCRx8c1L
	sJnCAp4SH+fPhlp8iFFi+8GdYAs4BYIlOvvbwU5lFlCXmDRvETOELS+xec1b5gmMgrOQLJmF
	pGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MULi4csOxsXHrA4xCnAwKvHwBvCs
	ChZiTSwrrswFuoaDWUmE13EOUIg3JbGyKrUoP76oNCe1+BAjEwenVAOjP5OgzJVFRYuSj0Qp
	px1kOl71o6lHriznlyrjh4kp+TEpaUfdY/MuyR28UXOfR51t549VCh8FF2kaecTUp/Z3bPa/
	XL110RHFGGfVTzXiHwMUphSs2vdvrujZB/seKVT8LGqQnPDi+L4qXo/pq5cI/Pow0+r44Ve6
	DBdXn3fYGNu3v/2ez5YuJZbijERDLeai4kQA6aEZOmUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 25.06.2014 11:58, Daniel Drake wrote:
> Hi Tomasz,
> 
> On Tue, Jun 24, 2014 at 2:57 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> ISP special clocks have dedicated gating registers and so MUX SRC_MASK
>> register should not be used. This patch fixes the problem of
>> Exynos4x12-based boards freezing on system suspend, because those
>> mux outputs need not to be masked while suspending.
> 
> Not sure if you will be interested in this, as your plate must be
> pretty full already, and I am probably the first person to try
> suspend/resume on ODROID, but:
> 
> ODROID-U2 fails to suspend/resume. I am testing with rtcwake, trying
> to raise a wakeup alarm on the internal Exynos4412 RTC. For this,
> CONFIG_COMMON_CLK_MAX77686 must be disabled (otherwise it disables the
> upstream 32KHz clock source for the RTC), I also have
> CONFIG_RTC_DRV_MAX77686 disabled so that there is only one RTC to
> worry about.
> 
> Then:
>  rtcwake --utc -m mem -s 10 -v
> 
> Before this patch, it would totally hang after calling cpu_suspend()
> (checked with S3C_PMDBG) - not sure if it hangs before sleeping, or if
> it sleeps but simply fails to wake up.
> 
> With this patch, now it seems like the RTC alarm does wake up the
> system after the desired time, however it immediately goes back into
> uboot rather than resuming into Linux. So this patch does make some
> progress at least.
> 
> The power light is on at all times during these tests (not sure if
> that means anything, but I was wondering if it should go out when the
> system suspends).

As far as I'm aware of, all Exynos4412-based ODROIDs run secure
firmware, which needs special handling of suspend/resume. I already have
a series to address this, but there is one more issue that I'd like to
fix, until I send it. The patches should hit the ML this week, though.

Best regards,
Tomasz
