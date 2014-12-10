Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbaLJRfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:35:37 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52699 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620AbaLJRff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:35:35 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable failure due to domain being gated
References: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com>
	<1418129982.19339.6.camel@AMDC1943> <5486F69B.6020005@samsung.com>
Date: Wed, 10 Dec 2014 09:35:31 -0800
In-Reply-To: <5486F69B.6020005@samsung.com> (Sylwester Nawrocki's message of
	"Tue, 09 Dec 2014 14:18:19 +0100")
Message-ID: <7hlhmfo1b0.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sylwester Nawrocki <s.nawrocki@samsung.com> writes:

> On 09/12/14 13:59, Krzysztof Kozlowski wrote:
>> On pią, 2014-12-05 at 15:15 +0100, Krzysztof Kozlowski wrote:
>>> > Audio subsystem clocks are located in separate block. On Exynos 5420 if
>>> > clock for this block (from main clock domain) 'mau_epll' is gated then
>>> > any read or write to audss registers will block.
>>> > 
>>> > This kind of boot hang was observed on Arndale Octa and Peach Pi/Pit
>>> > after introducing runtime PM to pl330 DMA driver. After that commit the
>>> > 'mau_epll' was gated, because the "amba" clock was disabled and there
>>> > were no more users of mau_epll.
>>> > 
>>> > The system hang on one of steps:
>>> > 1. Disabling unused clocks from audss block.
>>> > 2. During audss GPIO setup (just before probing i2s0 because
>>> >    samsung_pinmux_setup() tried to access memory from audss block which was
>>> >    gated.
>>> > 
>>> > Add a workaround for this by enabling the 'mau_epll' clock in probe.
>>> > 
>>> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>> > ---
>>> >  drivers/clk/samsung/clk-exynos-audss.c | 29 ++++++++++++++++++++++++++++-
>>> >  1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> Sorry for pinging so quick but merge window is open and it looks like
>> booting Exynos542x boards will be broken (because pl330 will no longer
>> hold adma clock enabled so whole audss domain will be gated).
>> 
>> This is a non-intrusive workaround for that issue, as wanted by
>> Sylwester:
>> https://lkml.org/lkml/2014/12/5/223
>> 
>> Any comments on this?
>
> The patch looks OK to me, it would be good though if someone else
> has confirmed it fixes the bug. I don't have any clock patches queued
> at the moment. Perhaps you could apply it directly, Mike ?

I confirm it fixes the boot hang in linux-next (next-20141210) on my
exynos5800-peach-pi and exynos5420-arndale-octa.  Tested both
exynos_defconfig and multi_v7_defconfig.

Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin
