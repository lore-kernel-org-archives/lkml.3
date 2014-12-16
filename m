Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaLPIUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:20:22 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47278 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaLPIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:20:20 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-59-548feb41e86c
Content-transfer-encoding: 8BIT
Message-id: <1418718015.28527.4.camel@AMDC1943>
Subject: Re: [PATCH] clk: samsung: Fix Exynos 5420 pinctrl setup and clock
 disable failure due to domain being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kevin Hilman <khilman@kernel.org>, Mike Turquette <mturquette@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 16 Dec 2014 09:20:15 +0100
In-reply-to: <7h8ui8h7n9.fsf@deeprootsystems.com>
References: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com>
 <1418129982.19339.6.camel@AMDC1943> <5486F69B.6020005@samsung.com>
 <7hlhmfo1b0.fsf@deeprootsystems.com> <7h8ui8h7n9.fsf@deeprootsystems.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xq7qOr/tDDJZvF7DYOGM9q8XR3wUW
	/Y9fM1s83fyYyeJs0xt2i02Pr7FaXN41h81ixvl9TBZrj9xlt3g64SKbxeE37awWP850s1is
	2vWH0YHX43JfL5PH3+fXWTx2zrrL7rFpVSebx51re9g8Ni+p9+jbsorR4/MmuQCOKC6blNSc
	zLLUIn27BK6Mtg+nWAumilbM2rmGuYHxvUAXIyeHhICJxMFTV9ggbDGJC/fWA9lcHEICSxkl
	Jv4/xAKS4BUQlPgx+R6QzcHBLCAvceRSNkiYWUBdYtK8RcwQ9Z8ZJdY/7GOGqNeX+Dz1NxtI
	vbBAmcTmP2D1bALGEpuXLwELiwj4Siz8rw/SyixwnVmif+cBsFYWAVWJg6vesoLYnAKGEndm
	nIe65wajxN+Lk5lAmiUElCUa+90mMArMQnLdLITrZiG5bgEj8ypG0dTS5ILipPRcQ73ixNzi
	0rx0veT83E2MkLj5soNx8TGrQ4wCHIxKPLwFvf0hQqyJZcWVuYcYJTiYlUR4t9wHCvGmJFZW
	pRblxxeV5qQWH2Jk4uCUamDkfzff6Ey6yaUe+/BD/+5GXbPz7XWcdr6YLVC/9w7XiYRzTq6a
	t9vfBZ3PXmXZ+KxsxifGy1VNc45Kzzn6knFZbPcHW5H4nmZNodl5u712RW77uU3bMOe628q1
	D1dNPXLiXXyXnCljQ9ycuPVrZ9/f4NKq4hPWofM36sniyZPcWxgW1kktENqlxFKckWioxVxU
	nAgAfL/t1XkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-12-15 at 14:26 -0800, Kevin Hilman wrote:
> Kevin Hilman <khilman@kernel.org> writes:
> 
> > Sylwester Nawrocki <s.nawrocki@samsung.com> writes:
> >
> >> On 09/12/14 13:59, Krzysztof Kozlowski wrote:
> >>> On pią, 2014-12-05 at 15:15 +0100, Krzysztof Kozlowski wrote:
> >>>> > Audio subsystem clocks are located in separate block. On Exynos 5420 if
> >>>> > clock for this block (from main clock domain) 'mau_epll' is gated then
> >>>> > any read or write to audss registers will block.
> >>>> > 
> >>>> > This kind of boot hang was observed on Arndale Octa and Peach Pi/Pit
> >>>> > after introducing runtime PM to pl330 DMA driver. After that commit the
> >>>> > 'mau_epll' was gated, because the "amba" clock was disabled and there
> >>>> > were no more users of mau_epll.
> >>>> > 
> >>>> > The system hang on one of steps:
> >>>> > 1. Disabling unused clocks from audss block.
> >>>> > 2. During audss GPIO setup (just before probing i2s0 because
> >>>> >    samsung_pinmux_setup() tried to access memory from audss block which was
> >>>> >    gated.
> >>>> > 
> >>>> > Add a workaround for this by enabling the 'mau_epll' clock in probe.
> >>>> > 
> >>>> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >>>> > ---
> >>>> >  drivers/clk/samsung/clk-exynos-audss.c | 29 ++++++++++++++++++++++++++++-
> >>>> >  1 file changed, 28 insertions(+), 1 deletion(-)
> >>>
> >>> Sorry for pinging so quick but merge window is open and it looks like
> >>> booting Exynos542x boards will be broken (because pl330 will no longer
> >>> hold adma clock enabled so whole audss domain will be gated).
> >>> 
> >>> This is a non-intrusive workaround for that issue, as wanted by
> >>> Sylwester:
> >>> https://lkml.org/lkml/2014/12/5/223
> >>> 
> >>> Any comments on this?
> >>
> >> The patch looks OK to me, it would be good though if someone else
> >> has confirmed it fixes the bug. I don't have any clock patches queued
> >> at the moment. Perhaps you could apply it directly, Mike ?
> >
> > I confirm it fixes the boot hang in linux-next (next-20141210) on my
> > exynos5800-peach-pi and exynos5420-arndale-octa.  Tested both
> > exynos_defconfig and multi_v7_defconfig.
> >
> > Tested-by: Kevin Hilman <khilman@linaro.org>
> 
> What's the status of this patch?  linux-next is still broken for several
> Exynos5 platforms without this fix.

I believe not only next is broken but also current mainline because
runtime PM for pl330 was merged yesterday...

The patch received two tested-bys (Kevin's and Javier's) and Sylwester's
ack.

Mike, could you pick the patch and send it to Linus after rc1?

Best regards,
Krzysztof

