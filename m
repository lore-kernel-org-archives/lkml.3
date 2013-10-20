Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3JTVfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:35:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43070 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3JTVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:35:16 -0400
Message-ID: <52644C88.5060608@wwwdotorg.org>
Date: Sun, 20 Oct 2013 22:35:04 +0100
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Alexander Holler <holler@ahsoftware.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
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
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <5231E44C.9070800@ahsoftware.de> <20130918003632.CBF48C42BC5@trevor.secretlab.ca> <1805938.y3dym69kEh@avalon>
In-Reply-To: <1805938.y3dym69kEh@avalon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2013 01:41 PM, Laurent Pinchart wrote:
> Hi Grant,
> 
> On Tuesday 17 September 2013 17:36:32 Grant Likely wrote:
>> On Thu, 12 Sep 2013 17:57:00 +0200, Alexander Holler wrote:
>>> Am 12.09.2013 17:19, schrieb Stephen Warren:
>>>> IRQs, DMA channels, and GPIOs are all different things. Their bindings
>>>> are defined independently. While it's good to define new types of
>>>> bindings consistently with other bindings, this hasn't always happened,
>>>> so you can make zero assumptions about the IRQ bindings by reading the
>>>> documentation for any other kind of binding.
>>>>
>>>> Multiple interrupts are defined as follows:
>>>> 	// Optional; otherwise inherited from parent/grand-parent/...
>>>> 	interrupt-parent = <&gpio6>;
>>>> 	// Must be in a fixed order, unless binding defines that the
>>>> 	// optional interrupt-names property is to be used.
>>>> 	interrupts = <1 IRQF_TRIGGER_HIGH> <2 IRQF_TRIGGER_LOW>;
>>>> 	// Optional; binding for device defines whether it must
>>>> 	// be present
>>>> 	interrupt-names = "foo", "bar";
>>>>
>>>> If you need multiple interrupts, each with a different parent, you need
>>>> to use an interrupt-map property...
...
>> Actually, I think it is solveable but doing so requires a new binding
>> for interrupts. I took a shot at implementing it earlier this week and
>> I've got working patches that I'll be posting soon. I created a new
>> "interrupts-extended" property that uses a phandle+args type of
>> binding like this:
...
>> device@3000 {
>> 	interrupts-extended = <&intc1 5> <&intc2 3 4> <&intc1 6>;
>> };
...
> Any progress on this ? I'll need to use multiple interrupts with different 
> parents in the near future, I can take this over if needed.
> 
> I've also been thinking that we could possibly reuse the "interrupts" property 
> without defining a new "interrupts-extended". When parsing the property the 
> code would use the current DT bindings if an interrupt-parent is present, and 
> the new DT bindings if it isn't.

interrupt-parents doesn't have to be present in individual nodes; it can
be inherited from the parent. That means you'd have to convert whole
sub-trees at once. It seems much more flexible to use a new property and
hence make it explicit what format the data is in.
