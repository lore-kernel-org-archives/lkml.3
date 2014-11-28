Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaK1JJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:09:55 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58273 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaK1JJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:09:48 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-4b-54783bda95cd
Message-id: <1417165784.18249.15.camel@AMDC1943>
Subject: Re: [PATCH v4 2/7] regulator: dt-bindings: Document the ena-gpios
 property
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 28 Nov 2014 10:09:44 +0100
In-reply-to: <20141127183058.GB7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-3-git-send-email-k.kozlowski@samsung.com>
 <20141127183058.GB7712@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xy7q3rCtCDGa+FLbYOGM9q8XUh0/Y
	LOYfOcdq0f/4NbPF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbOYcX4fk8XaI3fZHbg9ds66
	y+6xaVUnm8eda3vYPDYvqffo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujL6d21gL/gpUdC/4
	y9jAeJa3i5GTQ0LARGL34zZWCFtM4sK99WxdjFwcQgJLGSW6T85hhnA+M0qs6HrKCFLFK2Ag
	sf3obzBbWCBU4tTHn2DdbALGEpuXL2EDsUUElCWuft/LAtLMLNDMLPHvwT+wIhYBVYmm3ZPA
	ijgFjCR2Ld7JCLFhLaPEk3nHmEASzALqEpPmLQJazQF0k7JEY78bxGJBiR+T77FAlMhLbF7z
	lnkCo8AsJB2zkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIZHzdwbj0mNUh
	RgEORiUeXoZbZSFCrIllxZW5hxglOJiVRHhPfS0PEeJNSaysSi3Kjy8qzUktPsTIxMEp1cC4
	X9hLdI2bi4PCz7vLksz41+beW7lOzdDj0C5dK0tjkaAZ9tk/1k0XYJxu8lnGtHp24OLpnVes
	Jz29ezQscJ7809mdd81inA93cq9v943eFZ+5c+WkLY6yV3uXSMUfKnrhLiEYodesVbTLiZHH
	d+VxozfCz5ZdCYqqEukJDH6d0Mm7atKZ5nVKLMUZiYZazEXFiQDObIdnagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 18:30 +0000, Mark Brown wrote:
> On Thu, Nov 27, 2014 at 12:20:48PM +0100, Krzysztof Kozlowski wrote:
> 
> > +- ena-gpios: GPIO to use for enable control. Actual implementation depends
> > +  on regulator driver. The bindings documentation for given driver describes
> > +  which regulator actually supports it.
> > +- ena-gpio-open-drain: GPIO is open drain type.
> 
> I'm relly not a big fan of adding a fixed name property here with no
> override capability, it means that the naming won't reflect the specific
> regulator design so closely and in practice for many of the PMICs the
> GPIO control can do rather more than just control enables and supports
> reprogramming.  The latter case where we've got a signal which can
> sometimes be simply and enable but sometimes more makes it especially
> worrying to have the property always be there, it's something that might
> work in some configurations but could easily be broken if we try to
> exploit more advanced functionality (things also triggering other
> configuration changes at the same time).

I understand your concerns here however I didn't want to overengineer
this. Is the same GPIO (on more complex PMICs) used in different
contexts? Like enable control and something more in the same time?

For example the S5M8767 uses different GPIOs for:
1. enable control - one GPIO per regulator,
2. voltage selection (DVS) - 3 GPIOs total,
so there is no benefit in merging this into one common regulator code.

> Factoring out the code is good but it seems better to have it be
> something which drivers can control, for example by having them
> explicitly specify a property name to use or perhaps a flag to enable
> the default name.

Something like:
 struct regulator_desc desc {
 	.name		= "LDO1
 	.of_match	= of_match_ptr("LDO1"),
 	.regulators_node = of_match_ptr("voltage-regulators"),
 	.ops		= &max77686_ldo_ops,
+	.of_ena_gpio	= of_match_ptr("ena-gpios"),
 ...
 }
?


> We also need an invert option.

This is parsed from gpio specifier in DTS: the flags from
include/dt-bindings/gpio/gpio.h.

Thank you for feedback,
Krzysztof

