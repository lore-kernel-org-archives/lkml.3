Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaIBLBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:01:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43784 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbaIBLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:01:41 -0400
Date: Tue, 2 Sep 2014 12:01:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>, "kishon@ti.com" <kishon@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [PATCH 1/5] usb: dwc3: exynos: Add support for SCLK present on
 Exynos7
Message-ID: <20140902110102.GC6725@leverpostej>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
 <1409212920-28526-2-git-send-email-gautam.vivek@samsung.com>
 <20140828184847.GA18464@leverpostej>
 <CAFp+6iHLSaUjHqaKXXX0QLiRd3h+O67DRSQdExag-KUH0dnpag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFp+6iHLSaUjHqaKXXX0QLiRd3h+O67DRSQdExag-KUH0dnpag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:39:08AM +0100, Vivek Gautam wrote:
> Hi,
> 
> 
> On Fri, Aug 29, 2014 at 12:18 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Aug 28, 2014 at 09:01:56AM +0100, Vivek Gautam wrote:
> >> Exynos7 also has a separate special gate clock going to the IP
> >> apart from the usual AHB clock. So add support for the same.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> ---
> >>  drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >>
> >> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
> >> index f9fb8ad..bab6395 100644
> >> --- a/drivers/usb/dwc3/dwc3-exynos.c
> >> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> >> @@ -35,6 +35,7 @@ struct dwc3_exynos {
> >>       struct device           *dev;
> >>
> >>       struct clk              *clk;
> >> +     struct clk              *sclk;
> >>       struct regulator        *vdd33;
> >>       struct regulator        *vdd10;
> >>  };
> >> @@ -141,10 +142,17 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
> >>               return -EINVAL;
> >>       }
> >>
> >> +     /* Exynos7 has a special gate clock going to this IP */
> >> +     exynos->sclk = devm_clk_get(dev, "usbdrd30_sclk");
> >> +     if (IS_ERR(exynos->sclk))
> >> +             dev_warn(dev, "couldn't get sclk\n");
> >
> > Doesn't this introduce a pointless warning for Exynos SoCs other than
> > Exynos7?
> 
> True, it will introduce an unnecessary warning for non-Exynos7 systems.
> I initially thought of introducing a compatible check for Exynos7-dwc3, but that
> way we may end up adding such checks for future SoCs which have similar
> controller but have some clock difference or some other small change, no ?

Perhaps. I don't know what your future hardware will look like.

Is the usbdrd30_sclk input unique to Exynos7, or was it previously there
but just without an input?

If the latter you could just reduce this to:

dev_info(dev, "no sclk specified");

Mark.
