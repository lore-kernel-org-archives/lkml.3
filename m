Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3ILPZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:25:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56589 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3ILPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:25:16 -0400
Message-ID: <5231DB88.90605@wwwdotorg.org>
Date: Thu, 12 Sep 2013 09:19:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com> <52308C91.2000105@ahsoftware.de> <523096FE.8080901@collabora.co.uk> <5230AB6E.1070807@ahsoftware.de> <5231817F.8000901@ahsoftware.de> <5231934D.4060706@collabora.co.uk> <52319741.5050407@ahsoftware.de> <5231A0F8.1070505@ahsoftware.de> <5231A4FE.1070704@ahsoftware.de> <5231A791.9080600@ahsoftware.de>
In-Reply-To: <5231A791.9080600@ahsoftware.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 05:37 AM, Alexander Holler wrote:
> Am 12.09.2013 13:26, schrieb Alexander Holler:
>> Am 12.09.2013 13:09, schrieb Alexander Holler:
>>> Am 12.09.2013 12:28, schrieb Alexander Holler:
>>>> Am 12.09.2013 12:11, schrieb Javier Martinez Canillas:
>>>>> On 09/12/2013 10:55 AM, Alexander Holler wrote:
...
>>>>> So, if I understood the code correctly the DT IRQ core doesn't expect
>>>>> a device node to have more than one "interrupt-parent" property.

The root-cause is the binding definition, not the code.

The interrupts property does not contain the phandle of the IRQ
controller, but rather the interrupt-parent property does. Thus, there
is a single interrupt parent for each node, unless you employ some
tricks (see below).

>>>>> It *should* work though if you have multiple "interrupts" properties
>>>>> defined and
>>>>> all of them have the same "interrupt-parent":
>>>>>
>>>>>         interrupt-parent = <&gpio6>;
>>>>>         interrupts = <1 IRQF_TRIGGER_HIGH>; /* GPIO6_1 */
>>>>>         interrupts = <2 IRQF_TRIGGER_LOW>; /* GPIO6_2 */

DT is a key/value data structure, not a list of property (name, value)
pairs. In other words, you can't have multiple properties of the same
name in a node. At least in the compiled DTB; you /might/ be able to
compile the DT above with dtc, but if so the second definition of the
property will just over-write the first.

...
>> I've just seen how they solved it for dma:
>>
>>              dmas = <&edma0 16
>>                  &edma0 17>;
>>              dma-names = "rx", "tx";
...
> And looking at how gpios are defined, I think it should be like that:
> 
>           interrupts = <&gpio6 1 IRQF_TRIGGER_HIGH
>                         &gpio7 2 IRQF_TRIGGER_LOW
>           >;
>           interrupt-names = "foo", "bar";
> 
> So without that interrupt-parent.

IRQs, DMA channels, and GPIOs are all different things. Their bindings
are defined independently. While it's good to define new types of
bindings consistently with other bindings, this hasn't always happened,
so you can make zero assumptions about the IRQ bindings by reading the
documentation for any other kind of binding.

Multiple interrupts are defined as follows:

	// Optional; otherwise inherited from parent/grand-parent/...
	interrupt-parent = <&gpio6>;
	// Must be in a fixed order, unless binding defines that the
	// optional interrupt-names property is to be used.
	interrupts = <1 IRQF_TRIGGER_HIGH> <2 IRQF_TRIGGER_LOW>;
	// Optional; binding for device defines whether it must
	// be present
	interrupt-names = "foo", "bar";

If you need multiple interrupts, each with a different parent, you need
to use an interrupt-map property (Google it for a more complete
explanation I guess). Unlike "interrupts", "interrupt-map" has a phandle
in each entry, and hence each entry can refer to a different IRQ
controller. You end up defining a dummy interrupt controller node (which
may be the leaf node with multiple IRQ outputs, which then points at
itself as the interrupt parent), pointing the leaf node's
interrupt-parent at that node, and then having interrupt-map "demux" the
N interrupt outputs to the various interrupt controllers.
