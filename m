Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbbAEOPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:15:44 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51551 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbbAEOPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:15:35 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b0-54aa9c853fda
Message-id: <1420467330.16219.4.camel@AMDC1943>
Subject: Re: [PATCH v4 2/3] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 05 Jan 2015 15:15:30 +0100
In-reply-to: <CACRpkdaVJKmMzc0uNL1XK8w93Cf_yWcdW9w4E2NFxroWEkkzZg@mail.gmail.com>
References: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
 <1417777254-26579-3-git-send-email-k.kozlowski@samsung.com>
 <CACRpkdaVJKmMzc0uNL1XK8w93Cf_yWcdW9w4E2NFxroWEkkzZg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xy7qtc1aFGPz7KmKxccZ6Vov5R86x
	WrRdOchucfR3gUX/49fMFk83P2ayONv0ht1iyp/lTBabHl9jtdg8/w+jxeVdc9gsZpzfx2Sx
	9shddounEy6yWRx+085qsWrXH0YHAY+/z6+zeOycdZfdY9OqTjaPO9f2sHlsXlLv0bdlFaPH
	501yAexRXDYpqTmZZalF+nYJXBn3Xt5jKpjJV9E/awNTA+Nh7i5GTg4JAROJjuVPWSBsMYkL
	99azdTFycQgJLGWUmPNtDyOE85lR4t67j+wgVbwC+hJPT3aCdQgLpEl87nnHBmKzCRhLbF6+
	BMwWEdCR6N72kxWkmVmghU3iSMM5sASLgKrEkQmrGEFsToFgiem9k5ghNpxhlGi/dwJsKrOA
	usSkeYuAEhxANylLNPa7QSwWlPgx+R5UibzE5jVvmScwCsxC0jELSdksJGULGJlXMYqmliYX
	FCel5xrpFSfmFpfmpesl5+duYoTE1NcdjEuPWR1iFOBgVOLh9TixMkSINbGsuDL3EKMEB7OS
	CO+r9FUhQrwpiZVVqUX58UWlOanFhxiZODilGhjrGuLCb1RVpF6Yn7Jo0cHQhxEaS/XW9fxz
	XLzuqlb+0ymiFitNl+fvjpK5JvQkI1tj/Y+bwluvvr7js47H6z+75J5rpc9WrMrZxBnNbHHI
	0L27aJHcyp6Iq5eDpP99mJu/89DnsOzOrqaPnHbCK0XuVxyfe3r6Wsty+xPNhcdMj5oraR5l
	2y6jxFKckWioxVxUnAgAzlerEIcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2015-01-05 at 15:05 +0100, Linus Walleij wrote:
> On Fri, Dec 5, 2014 at 12:00 PM, Krzysztof Kozlowski
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
> > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> Tomasz, is this OK and should I apply it for fixes or next?

Ha! That is a good question. The issue is fixed for now by the
workaround (merged) [1].

The workaround just enables the clock for entire runtime of Exynos
5420-like device. This has some energy impact - around 1.5% in idle [2].

So actually this is question which way we want to solve it:
1. Stick with the workaround (small piece of code, energy impact when
not used).
2. Full clock enable on use (big chunk of code, no energy impact when
not used).

[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f1e9203e2366164b832d8a6ce10134de8c575178
[2] http://www.spinics.net/lists/linux-samsung-soc/msg39827.html

Best regards,
Krzysztof


