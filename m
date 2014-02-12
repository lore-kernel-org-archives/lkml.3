Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaBLNLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:11:51 -0500
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:58315 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaBLNLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:11:50 -0500
MIME-Version: 1.0
In-Reply-To: <20140212134428.4a442f31@skate>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<52FB5795.9020708@free-electrons.com>
	<20140212133449.5c42216d@skate>
	<CACh+v5Nv7u4WSXttvsnMPxwNwN6R4ZDRABOXr9XXBjy6mSDi5w@mail.gmail.com>
	<20140212134428.4a442f31@skate>
Date: Wed, 12 Feb 2014 14:01:39 +0100
Message-ID: <CACh+v5MNSaW3nU_E2w+MV3JM_L5hmGdVSTTebLbMTV6W-fPr+A@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Device Tree support for the at91sam9261ek
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 8198521646676138008
X-Ovh-Remote: 209.85.192.174 (mail-pd0-f174.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I wasn't very informative indeed.

The dm9000 is instantiated from the DT, its irq is described as <&pioC
2 IRQ_TYPE_EDGE_BOTH>
The problem, as I see it, is that at the time the IRQ description is
translated the irq domain doesn't exist yet and the translation fails.
The result is that the ressource of the platform driver do not contain
any information about an IRQ.
The irq domain is added later when the gpio driver is probed
(pinctrl-at91.c:1684).
A bit later the dm9000 gets probed and fails lamely because it can't
find an IRQ ressource.

Jean-Jacques



2014-02-12 13:44 GMT+01:00 Thomas Petazzoni
<thomas.petazzoni@free-electrons.com>:
> Dear Jean-Jacques Hiblot,
>
> On Wed, 12 Feb 2014 13:36:08 +0100, Jean-Jacques Hiblot wrote:
>
>> >> For dm9000 the issue is (again) related to an ordering problem:
>> >> the Ethernet need an interrupt provided by the gpio driver. Unfortunately,
>> >> the gpio driver initialization is called after the dm900 driver
>> >> initialization.
>> >
>> > And -EPROBE_DEFER doesn't solve this problem?
>> not really the problem happens before the driver is actually probed
>> when the ressource for the platform driver are filled
>
> Sorry, I don't have all the context. If I understand correctly what you
> mean, the GPIO driver is probed through the DT, but the DM9000 driver
> is probed in a legacy way from the board file, and you have the case
> where the DM9000 platform_device gets registered before the GPIOs are
> actually available? In this case, what about having the
> of_platform_populate() call *before* the platform_device_register() for
> your DM9000 ? Again, I don't have all the context, so I might very well
> be getting the situation incorrectly.
>
> Of course, ideally, the DM9000 driver should be probed using the DT,
> but I guess this needs the SMC DT binding that is still being
> discussed, if I followed correctly.
>
> Thomas
> --
> Thomas Petazzoni, CTO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
