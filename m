Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaK1OIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:08:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18313 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1OIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:08:49 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-96-547881ee4226
Content-transfer-encoding: 8BIT
Message-id: <1417183724.18249.36.camel@AMDC1943>
Subject: Re: [PATCH v2 3/5] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 28 Nov 2014 15:08:44 +0100
In-reply-to: <CACRpkdb8F8YcvFeHPvOKHjx_p4HEpimck3XRabB3oHpZTdmRQQ@mail.gmail.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
 <1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
 <CACRpkdb8F8YcvFeHPvOKHjx_p4HEpimck3XRabB3oHpZTdmRQQ@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xK7rvGitCDBbMl7DYOGM9q8X8I+dY
	LdquHGS3OPq7wKL/8Wtmi6ebHzNZnG16w24x5c9yJotNj6+xWmye/4fR4vKuOWwWM87vY7K4
	fZnXYu2Ru+wWTydcZLM4/Kad1eLYjCWMFqt2/WF0EPJoae5h8/j7/DqLx85Zd9k9Nq3qZPO4
	c20Pm8fmJfUefVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlXH+/SbWguPcFYtXn2FqYJzN2cXI
	ySEhYCJx4OELJghbTOLCvfVsXYxcHEICSxkltq/7zgyS4BUQlPgx+R5LFyMHB7OAvMSRS9kg
	YWYBdYlJ8xaBlQgJfGaU2Hu2DqLcQGLvu/9sILawQJrEtumzGEFsNgFjic3Ll4DFRQR0JLq3
	/WQF2cUscJtNYkLHerAiFgFViZXzb7KC2JwCwRIfmiGKhATOMEpsfdLBCHKEhICyRGO/2wRG
	gVlIzpuFcN4sJOctYGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESaV92MC4+ZnWIUYCD
	UYmH90ByRYgQa2JZcWXuIUYJDmYlEd70EqAQb0piZVVqUX58UWlOavEhRiYOTqkGxpXzIirN
	5VLZjloJM0rfXHf+GctV2a+aSYf/OnZOXX3WzONurvRh9suCsx7+n8FWttn2+7S3pbc2fmaY
	uur8zCPm/4sub3P1frU2fP4qri8L1of+c5ws5symXJIkGBU0z+HCi1cHTqzSVflyQ2n5QUfG
	2ArVHQzrj3zpOO4hfV6B04r7wNuQ6u9KLMUZiYZazEXFiQCKAMDhkgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-28 at 15:04 +0100, Linus Walleij wrote:
> On Wed, Nov 26, 2014 at 3:24 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> 
> > The audio subsystem on Exynos 5420 has separate clocks and GPIO. To
> > operate properly on GPIOs the main block clock 'mau_epll' must be
> > enabled.
> >
> > This was observed on Peach Pi/Pit and Arndale Octa (after enabling i2s0)
> > after introducing runtime PM to pl330 DMA driver. After that commit the
> > 'mau_epll' was gated, because the "amba" clock was disabled and there
> > were no more users of mau_epll.
> >
> > The system hang just before probing i2s0 because
> > samsung_pinmux_setup() tried to access memory from audss block which was
> > gated.
> >
> > Add a clock property to the pinctrl driver and enable the clock during
> > GPIO setup. During normal GPIO operations (set, get, set_direction) the
> > clock is not enabled.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Waiting for Tomasz to review this.
> 
> Can this patch be applied in separation from the others?

Yes, it can be picked independently.

The commit message is somehow misleading because issue is actually fixed
by enabling this in DTS. So the next patch (4/5: ARM: dts: exynos5420:
Add clock for audss pinctrl) actually fixes the issue on Arndale Octa
board from pinctrl perspective. Unfortunately I spot that mistake (in
commit msg) later...

Best regards,
Krzysztof


