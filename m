Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaLEMoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:44:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17573 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaLEMoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:44:16 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-1e-5481a89d5a09
Message-id: <5481A88F.9090308@samsung.com>
Date: Fri, 05 Dec 2014 13:43:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 1/3] clk: samsung: Fix clock disable failure because
 domain being gated
References: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
 <1417777254-26579-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1417777254-26579-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7pzVzSGGCw8aGixccZ6Vou2KwfZ
	LY7+LrB4/cLQov/xa2aLp5sfM1mcbXrDbrHp8TVWi8u75rBZzDi/j8li7ZG77BZPJ1xks1i1
	6w+jA6/H3+fXWTx2zrrL7rFpVSebx51re9g8Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27
	BK6M07M2shfM4a2Yd2sDawPjW64uRk4OCQETibZlU9khbDGJC/fWs4HYQgJLGSUu3VTsYuQC
	sj8xSjw8uoQVJMEroCVx+dphJhCbRUBVoufUJ7AGNgFDid6jfYwgtqhAhMTJu3vYIeoFJX5M
	vscCYosIhEns+r2UBWQos8ANZol31yaBNQsLJEhcP/iQBWJbK6PEyodtYBs4BTwktvbcBdrM
	AdShJ3H/ohZImFlAXmLzmrfMExgFZiHZMQuhahaSqgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS
	9ZLzczcxQuLl6w7GpcesDjEKcDAq8fD+iGsMEWJNLCuuzD3EKMHBrCTCmzwbKMSbklhZlVqU
	H19UmpNafIiRiYNTqoEx9n6ttWX7JQPLSgXbk9O+rZ15y+uMQYXsI6OU5wmsNWWhrE7RC3+9
	+Jdj9VMocG7MkdJEXRUth6fdbf1N2vNTbrqfW+8573WMzYMek426R9d5RtUV1T0/5F5400yx
	6dYSns2NN8NumZ9kO23w1uzVdK9ME+993W9zK3RfXdL4pFh9L+Mk0wMlluKMREMt5qLiRAD0
	KZqhdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 05/12/14 12:00, Krzysztof Kozlowski wrote:
> Audio subsystem clocks are located in separate block. If clock for this
> block (from main clock domain) 'mau_epll' is gated then any read or
> write to audss registers will block.
> 
> This was observed on Exynos 5420 platforms (Arndale Octa and Peach
> Pi/Pit) after introducing runtime PM to pl330 DMA driver. After that
> commit the 'mau_epll' was gated, because the "amba" clock was disabled
> and there were no more users of mau_epll. The system hang on disabling
> unused clocks from audss block.
> 
> Unfortunately the 'mau_epll' clock is not parent of some of audss clocks.
> 
> Whenever system wants to operate on audss clocks it has to enable epll
> clock. The solution reuses common clk-gate/divider/mux code and duplicates
> clk_register_*() functions.
> 
> Additionally this patch fixes memory leak of clock gate/divider/mux
> structures. The leak exists in generic clk_register_*() functions. Patch
> replaces them with custom code with managed allocation.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reported-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Instead of this big patch perhaps for v3.19 we could just add
a clk_enable() call in exynos5420 clock controller driver, to make
sure the required clock is always enabled, as it was before you have
added runtime PM support to the PL330 DMA controller driver ?

It sounds like a workaround but wouldn't be as intrusive as this
patch.

--
Regards,
Sylwester
