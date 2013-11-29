Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3K2PFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:05:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40376 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3K2PFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:05:40 -0500
Message-ID: <5298ABFA.8070804@ti.com>
Date: Fri, 29 Nov 2013 17:00:10 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>,
        "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] memory: ti-aemif: add bindings for AEMIF driver
References: <1384962416-14862-1-git-send-email-ivan.khoronzhuk@ti.com> <1384962416-14862-3-git-send-email-ivan.khoronzhuk@ti.com> <20131120182102.GK14627@ns203013.ovh.net> <528D076A.8070806@ti.com> <C0B815B0-E394-494C-88A2-78A0DBFA23DA@kernel.crashing.org>
In-Reply-To: <C0B815B0-E394-494C-88A2-78A0DBFA23DA@kernel.crashing.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar Gala,

On 11/22/2013 11:06 PM, Kumar Gala wrote:
> 
> On Nov 20, 2013, at 1:03 PM, ivan.khoronzhuk <ivan.khoronzhuk@ti.com> wrote:
> 
>> On 11/20/2013 08:21 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>> +				the chip select signal.
>>>> +				Minimum value is 1 (0 treated as 1).
>>>> +
>>>> +- ti,cs-wsetup:		write setup width, ns
>>>> +				Time between the beginning of a memory cycle
>>>> +				and the activation of write strobe.
>>>> +				Minimum value is 1 (0 treated as 1).
>>>> +
>>>> +- ti,cs-wstrobe:	write strobe width, ns
>>>> +				Time between the activation and deactivation of
>>>> +				the write strobe.
>>>> +				Minimum value is 1 (0 treated as 1).
>>>> +
>>>> +- ti,cs-whold:		write hold width, ns
>>>> +				Time between the deactivation of the write
>>>> +				strobe and the end of the cycle (which may be
>>>> +				either an address change or the deactivation of
>>>> +				the chip select signal.
>>>> +				Minimum value is 1 (0 treated as 1).
>>>> +
>>>> +If any of the above parameters are absent, current parameter value will be taken
>>>> +from the corresponding HW reg.
>>>> +
>>>> +The name for cs node must be in format csN, where N is the cs number.
>>>
>>> this is wired we should use reg instead to represent the cs as done for SPI
>>> or a an other property
>>>
>>> Best Regards,
>>> J.
>>>
>>
>> Ok, I will add new property cs-chipselect like following :
>>
>> ti,cs-chipselect:	number of chipselect. Indicates on the
>> 			aemif driver which chipselect is used
>> 			for accessing the memory.
>> 			For compatibles "ti,davinci-aemif" and
>> 			"ti,keystone-aemif" it can be in range [0-3].
>> 			For compatible "ti,omap-L138-aemif" range is [2-5].
>>
>> Is it OK?
> 
> Why do you need this? As it was mentioned just use reg:
> 
> So you’d have something like:
> 
> memory-controller@21000A00 {
> 	…
> 	nand:cs2@2 {
> 		reg = <2 0 0>;
> 		ranges;
> 		...
> 
> 	}:
> };

I'd prefer to continue with "ti,cs-chipselect" (this is more human friendly definition, as for me),
but if you insist - it can be changed as:
memory-controller@21000A00 {
	compatible = "ti,keystone-aemif";
...

	cs2 {
		compatible = "ti,aemif-cs";
		reg = <2>;
...
	}

	cs0 {
		compatible = "ti,aemif-cs";
		reg = <0>;
...
	}

> 
> However, I’m confused by the example in which you have:
> 
> +		nand@0,0x8000000 {
> +			compatible = "ti,davinci-nand";
> +			reg = <0 0x8000000 0x4000000
> +			       1 0x0000000 0x0000100>;
> +
> +			.. see davinci-nand.txt
> +		};
> 
> What chipselects is this on 0 & 1?

As I described in https://lkml.org/lkml/2013/11/26/282 we are not encoding CS number in reg
 - it's memory partition number.

Also, I'd like to note that we *DO NOT introduce* NAND device bindings here.
The Davinci NAND bindings was introduced and accepted more then one year ago, and
we've just updated its a bit (keeping full compatibility) and reused
(see https://lkml.org/lkml/2013/11/21/182). 
And the CS number is encoded for Davinci NAND node using standalone property
"ti,davinci-chipselect" and we need to provide (2) two memory ranges to it,
as result we can't encode CS number in "reg" for AEMIF child devices (NAND/NOR/etc),
as it will break bindings compatibility.

In this document, NAND node is used just as an example of child node.

Regards,
- grygorii

