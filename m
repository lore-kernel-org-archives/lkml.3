Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaEOLqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:46:24 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63370 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEOLqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:46:21 -0400
MIME-Version: 1.0
In-Reply-To: <53748819.8060705@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
	<1399383244-14556-4-git-send-email-kishon@ti.com>
	<53736CBC.2060702@ti.com>
	<5373897C.6080504@ti.com>
	<CAGo_u6qw1OomEw_ueb3x+xT+qZLAfGv7Se1K=o725aOoD3ankQ@mail.gmail.com>
	<5374859F.5080902@ti.com>
	<53748819.8060705@ti.com>
Date: Thu, 15 May 2014 06:46:19 -0500
X-Google-Sender-Auth: rfPIClwF1QmmWZRS5dJmpgKo3t4
Message-ID: <CAGo_u6qbbdAbdvrB3AFXSH1qD5MaBkJbi6oJJvvTWW4xfbmd_Q@mail.gmail.com>
Subject: Re: [PATCH 03/17] phy: ti-pipe3: add external clock support for PCIe PHY
From: Nishanth Menon <nm@ti.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        dt list <devicetree@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pci@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 4:25 AM, Roger Quadros <rogerq@ti.com> wrote:
> On 05/15/2014 12:15 PM, Kishon Vijay Abraham I wrote:
>> Hi Nishanth,
>>
>> On Wednesday 14 May 2014 09:04 PM, Nishanth Menon wrote:
>>> On Wed, May 14, 2014 at 10:19 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>> Hi Roger,
>>>>
>>>> On Wednesday 14 May 2014 06:46 PM, Roger Quadros wrote:
>>>>> Hi Kishon,
>>>>>
>>>>> On 05/06/2014 04:33 PM, Kishon Vijay Abraham I wrote:
>>>>>> APLL used by PCIE phy can either use external clock as input or the clock
>>>>>> from DPLL. Added support for the APLL to use external clock as input here.
>>>>>>
>>>>>> Cc: Rajendra Nayak <rnayak@ti.com>
>>>>>> Cc: Tero Kristo <t-kristo@ti.com>
>>>>>> Cc: Paul Walmsley <paul@pwsan.com>
>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>> ---
>>>>>>  Documentation/devicetree/bindings/phy/ti-phy.txt |    4 ++
>>>>>>  drivers/phy/phy-ti-pipe3.c                       |   75 ++++++++++++++--------
>>>>>>  2 files changed, 52 insertions(+), 27 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>>>> index bc9afb5..d50f8ee 100644
>>>>>> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>>>> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>>>> @@ -76,6 +76,10 @@ Required properties:
>>>>>>     * "dpll_ref_m2" - external dpll ref clk
>>>>>>     * "phy-div" - divider for apll
>>>>>>     * "div-clk" - apll clock
>>>>>> +   * "apll_mux" - mux for pcie apll
>>>>>> +   * "refclk_ext" - external reference clock for pcie apll
>>>>>> + - ti,ext-clk: To specifiy if PCIE apll should use external clock. Applicable
>>>>>> +   only to PCIE PHY.
>>>>>
>>>>> Instead of specifying both clock sources "dpll_ref_clock", "refclk_ext" and then specifying a 3rd control option "ti,ext-clk" to select one of the 2 sources, why can't the DT just supply one clock source, i.e. the one that is being used in the board instance? The driver should then just configure the clock rate that is needed at that node. Shouldn't the clock framework automatically take care of muxing and parent rates?
>>>>
>>>> Want the dt to have all the clocks used by the controller. "ti,ext-clk" should
>>>> go in the board dt file (suggested by Nishanth).
>>>> The point is at some point later if some one wants to change the clock source,
>>>> it should be a simple enabling "ti,ext-clk" flag instead of finding the clock
>>>> phandle etc..
>>>
>>> Wonder if that is implicit by the presence of  "refclk_ext" in the
>>> clocks provided?
>>
>> IMO the presence of "refclk_ext" is useless unless the board indicates it
>> provides the clock source.
>>
>> refclk_ext holds phandle for *fixed-clock*, so irrespective of whether the
>> board provides a clock or not, it can have that handle for configuring in PRCM.
>> However if the board does not provide the clock source, configuring refclk_ext
>> in PRCM is useless.
>
> I think what Nishant meant is that if "refclk_ext" is provided it means that the driver
> should use that over "dpll_ref_clock" so no need of a separate "ti,ext-clk" flag.

yes, thank you for clarifying - it does indeed redundant to have
"ti,ext-clk". and apologies on being a little obscure in the comment.

Regards,
Nishanth Menon
