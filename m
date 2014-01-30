Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaA3Iqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 03:46:43 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57110 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaA3Iql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 03:46:41 -0500
Message-ID: <52EA116E.3030100@gmail.com>
Date: Thu, 30 Jan 2014 09:46:38 +0100
From: boris brezillon dev <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVucmlrIE5vcmRzdHLDtm0=?= <henrik@henriknordstrom.net>,
        linux-sunxi@googlegroups.com
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [linux-sunxi] Re: [RFC PATCH v2 09/14] mtd: nand: add sunxi NFC
 dt bindings doc
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>	 <1391006064-28890-10-git-send-email-b.brezillon.dev@gmail.com>	 <CAL_JsqLVr1gSLArqtfOiHce+u6ZK8FiKMX0o9bvMrMoGGhATvg@mail.gmail.com> <1391035079.14902.3.camel@localhost>
In-Reply-To: <1391035079.14902.3.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henrik,

Sorry for the noise, I sent the mail to Rob's old address.

On 29/01/2014 23:37, Henrik Nordström wrote:
> ons 2014-01-29 klockan 11:11 -0600 skrev Rob Herring:
>
>> Isn't allwinner,rb implied by a lack of rb-gpios property. Or no R/B
>> pin is an option? If so, don't you need some fixed time delay
>> properties like max erase time?
>>
>> rb-gpios could be added to the generic nand binding as well.
> The Allwinner NAND controller have dedicated RB pins when NAND is
> enabled, only MUXed with other functions when NAND is not enabled.
>
> Leaving RB unconnected is not a valid hardware configuration. The
> controller internal timing engine depends on being able to sense RB to
> sequence NAND commands properly.

This is not true (at least in this driver). It was in yuq's driver because
he was using the NFC_WAIT_FLAG ,and in this case the controller wait
for the native R/B pin to be high before considering the CMD is complete.

This driver choose the appropriate way to test the R/B state of the
NAND chip according to what was specified in the DT:
- allwinner,rb: native R/B id. These pins will be used by the NAND
   controller to test the R/B state. Only 0 and 1 are valid because the
   NAND controller only support 2 R/B pins.
- rb-gpios: gpio used for R/B tests. This is a simple GPIO and will
   use the GPIO subsystem to test the R/B pin state.
- none: the NAND base code will wait some time before and send
   STATUS cmd to the NAND to check its status.

BTW, the controller supports 8 CS (8 NAND chips), but only have 2 native
R/B pins, this means you'll have to use the GPIO or standard GET_STATUS
method if you connect 3 or more NAND chips.

And for the record, I still think the rb-gpios property (or whatever
common name you choose: nand-rb-gpios ?) should be part of
the generic NAND binding, because other controllers (at least the
atmel one :)) use GPIOs to test R/B state.

Best Regards,

Boris

>
> Regards
> Henrik
>

