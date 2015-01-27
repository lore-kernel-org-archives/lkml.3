Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbbA0OHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:07:30 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51614 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbbA0OH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:07:27 -0500
MIME-Version: 1.0
In-Reply-To: <20150126155733.GQ12209@pengutronix.de>
References: <20141127101830.GP30369@pengutronix.de>
	<CACRpkdbMdJT6y-NL36RgQe0-CAFAVGqKiwY9+yFcwA7JDLmA+Q@mail.gmail.com>
	<20141202135527.GM30369@pengutronix.de>
	<CACRpkdZeRd+j7d_iRphruHRg8p3XjqWK8_HQzLH2PTZ_pqOrYA@mail.gmail.com>
	<20150112122200.GC18908@pengutronix.de>
	<CACRpkdYXrdiRWMV8YpxrSLe2rLEV-ZnX7=36w21zGquh==6WgA@mail.gmail.com>
	<20150113161614.GF23940@pengutronix.de>
	<CACRpkdYRrs2=gNM1XGSh1cSo5Pvx6iNLt4HjL6gdTqGPWYSRDw@mail.gmail.com>
	<1421403805.11671.58.camel@mtksdaap41>
	<CACRpkdYmjrEtds4wLr0cOmCPOLhS9xisfrY-cNZ3r0oh8n489Q@mail.gmail.com>
	<20150126155733.GQ12209@pengutronix.de>
Date: Tue, 27 Jan 2015 15:07:26 +0100
Message-ID: <CACRpkdazPhi6ebrMs4uN9wC_fxyDzFUUTuy=4qObEsdtU_VBrw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] dt-bindings: Add pinctrl bindings for mt65xx/mt81xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        huang eddie <eddie.huang@mediatek.com>, dandan.he@mediatek.com,
        alan.cheng@mediatek.com, toby.liu@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 4:57 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Jan 20, 2015 at 10:45:09AM +0100, Linus Walleij wrote:

>> As discussed with Sascha Hauer it is ambigous to use "pins" for
>> a numerical value indicating both a mux setting and a pin. Sascha
>> suggests using "pinmux" and adding this as a secondary generic
>> binding for this type of pin controllers that use numbers and #defines
>> to set up bindings.
>>
>> We should still move these parsing functions to the core.
>
> I tried that for the last few days and failed.
>
> Part of the problem is that the core lacks the data structures to put
> the information in. There is
>
> struct pinctrl_map_mux {
>         const char *group;
>         const char *function;
> };
>
> but its meaning is SoC specific. Some SoCs combine the pins found in a
> dt subnode to one group (i.MX, rockchip, at91) while others make an
> individual group from each single pin (Tegra, others?). Also the
> function string is SoC specific. Some SoCs just define functions like
> "alt1".."altn" which are valid for all groups, others define different
> function names for each group.
>
> Another thing is that the binding gives us numbers, but struct
> pinctrl_map_mux expects strings, so the numbers would have to be
> converted to strings. This is crude since the contents of struct
> pinctrl_map_mux are converted from strings back to numbers later from
> the pinctrl core with the help of the driver. So we would have to
> translate the numbers from the bindings to strings just to convert them
> back to numbers before passing them to the driver later.

So can we use a union?

struct pinctrl_map_mux {
        union group {
              const char *groupstr;
              u16 groupno;
        };
        union function {
              const char *functionstr;
              u16 funcno;
        };
};

The augment the code to reference foo->group.groupstr or
foo->group.groupno etc depending on runpath.

Yours,
Linus Walleij
