Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbbAJKVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:21:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbAJKVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:21:08 -0500
Message-ID: <54B0FCDD.7000300@redhat.com>
Date: Sat, 10 Jan 2015 11:20:13 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Chen-Yu Tsai <wens@csie.org>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        devicetree <devicetree@vger.kernel.org>,
        =?windows-1252?Q?Antoine_T=E9?= =?windows-1252?Q?nart?= 
	<antoine.tenart@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-ide@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 2/4] Documentation: bindings: Add the regulator property
 to the sub-nodes AHCI bindings
References: <1420799989-10645-1-git-send-email-gregory.clement@free-electrons.com> <1420799989-10645-3-git-send-email-gregory.clement@free-electrons.com> <54AFF7E3.4070506@redhat.com> <54AFFFDC.7020307@free-electrons.com> <CAGb2v674q4Cjp9qy9CbUXe2j5pT_ez98CKxXHC8u4Diap2TT1A@mail.gmail.com> <20150109171131.GH2634@sirena.org.uk>
In-Reply-To: <20150109171131.GH2634@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09-01-15 18:11, Mark Brown wrote:
> On Sat, Jan 10, 2015 at 12:29:32AM +0800, Chen-Yu Tsai wrote:
>
>> Since the AHCI library code already supports the generic phy subsystem,
>> with one phy possible for each port node, you could possibly add a
>> generic phy that just takes a regulator, and hook it up that way.
>
>> I don't know if the extra layer of indirection is good or not.
>> Just offering an alternative.
>
> Or if the supply is for the device at the other end of the link (which
> is what it sounded like) then use that.  This just sounds like the same
> problem we have for all the enumerable buses in embedded systems where
> we need to be able to understand that the device exists prior to it
> being fully ready to appear in the system.  Having the link/slot be a
> device in Linux does indeed seem to be a common way people think about
> doing this, it sounds like for this one it might be the most direct.

I think we should be careful to not think too much from an implementation
pov here, the purpose of the devicetree description is to describe the hardware,
as is.

If I understand things correctly then the board Gregory is working on has
pairs of sata + satapower connectors on it, and what is on the other side
if anything is unknown, as such the proposed device tree description of
having a ahci controller node with port child nodes, with each port having
a regulator:

         sata@f7e90000 {
                 compatible = "marvell,berlin2q-achi", "generic-ahci";
                 reg = <0xe90000 0x1000>;
                 interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
                 clocks = <&chip CLKID_SATA>;
                 #address-cells = <1>;
                 #size-cells = <0>;

                 sata0: sata-port@0 {
                         reg = <0>;
                         phys = <&sata_phy 0>;
			target-supply = <&reg_sata0>;
                 };

                 sata1: sata-port@1 {
                         reg = <1>;
                         phys = <&sata_phy 1>;
			target-supply = <&reg_sata1>;
                 };
         };

Seems to match the hardware pretty exactly, and also matches how we've
been describing similar devices with only one sata port + power plug sofar,
so from a consistency pov it also is a good model.

So model wise I believe the above to be pretty good, and getting the modeling
right is the most important thing with devicetree, since it is an ABI which
once deployed is set in stone. Also is is os agnostic, and is also used by the
BSD-s etc, so implementation details should explicitly NOT be taken into
account when doing the modeling.

So once we come to the conclusion that the above model is the right model,
then the question becomes how to implement support for this, and this becomes
purely a Linux *internal* API discussion, *but* the model comes first!

So supporting this model requires having a regulator_get API which allows
specifying which of_node to get the regulator from, e.g. the proposed
of_regulator_get function. I know you (Mark) do not like this, but all
other subsystems have an of_foo_get function taking an of_node as argument,
I do not see how the regulator subsys is so special that it cannot have one,
and also notice that this is only a kernel internal API which we can always
change later.

Regards,

Hans
