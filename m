Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaENR5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:57:55 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58859 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaENR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:57:53 -0400
Message-ID: <5373AE9A.3050008@gmail.com>
Date: Wed, 14 May 2014 19:57:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <31922167.uMVzxsQNIT@wuerfel> <20140514154929.GA8016@kwain> <4414637.rKolGB14Rm@wuerfel> <20140514165722.GA18495@kwain>
In-Reply-To: <20140514165722.GA18495@kwain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:57 PM, Antoine Ténart wrote:
> On Wed, May 14, 2014 at 06:11:24PM +0200, Arnd Bergmann wrote:
>> On Wednesday 14 May 2014 17:49:29 Antoine Ténart wrote:
>>> On Wed, May 14, 2014 at 05:31:24PM +0200, Arnd Bergmann wrote:
>>>> Why do you need a custom mask? Is that something you could pass
>>>> as the argument in the phy descriptor using #phy-cells=<1>?
>>>
>>> I meant a custom mask in the AHCI driver, when calling the
>>> ahci_platform_init_host() function. Otherwise we'll have problems on the
>>> BG2Q DMP (it only has one PHY available, and not initializing it is not
>>> enough).
>>
>> Ah, I see what you mean now. Of course, this could also be an optional
>> property in the generic AHCI binding, which would require that you
>> specify the available ports in DT for nonstandard masks.
>>
>> Just to confirm: The HOST_PORTS_IMPL register on BG2Q DMP has an
>> value that we can't use here to determine the available ports, right?
> 
> Right. The register is here but saying there are 2 available ports,
> which is true for the BG2Q SoC but not true for the BG2Q DMP board. So
> the AHCI framework reads the register and performs a misconfiguration of
> the SATA.

*Disclaimer:* All PHY IP related comments below are *pure* guessing. I
have no clue how that PHY really looks like or how it is wired up.

I think it is time to sum this up a little bit and help Antoine carry
on this patches.

>From what I understand from the conversation, we have a single PHY
register set dealing with both SATA ports available on the SoC.
Also, from the name of the PHY bits we assume the PHY may be able
to work in different modes than just SATA. And we currently have
an AHCI-compatible SATA IP that supports up to two ports, with one
actually connected to a SATA plug on the DMP board.

Now, thinking about the PHY binding and the (possible) multi-protocol
support, it can be possible that on BG2Q there is a generic 2-lane
LVDS PHY that can be configured to support SATA or PCIe. Both are
electrically and bit-level compatible, so they could be internally
wired-up with AHCI and PCIe controller.

>From a DT point-of-view, we need a way to (a) link each SATA or PCIe
port to the PHY, (b) specify the PHY lane to be used, and (c) specify
the protocol to be used on that lane. If I got it right, Arnd already
mentioned to use the phy-specifier to deal with it:

e.g. phy = <&genphy 0 MODE_SATA> or phy = <&genphy 1 MODE_PCIE>

Let's assume we have one dual-port SATA controller and one PCIe
controller with either x1 or x2 support. The only sane DT binding,
I can think of then would be:

berlin2q.dtsi:

genphy: lvds@ea00ff {
	compatible = "marvell,berlin-lvds-phy";
	reg = <0xea00ff 0x100>;
	#phy-cells = <2>;
};

sata: sata@ab00ff {
	compatible = "ahci-platform";
	reg = <0xab00ff 0x100>;
	
	sata0: sata-port@0 {
		reg = <0>;
		phy = <&genphy 0 MODE_SATA>;
		status = "disabled";
	};

	sata1: sata-port@1 {
		reg = <1>;
		phy = <&genphy 1 MODE_SATA>;
		status = "disabled";
	};
};

pcie: pcie@ab01ff {
	compatible = "marvell,berlin-pcie";
	reg = <0xab01ff 0x100>;

	pcie0: pcie-port@0 {
		reg = <0>;
		/* set phy on a per-board basis */
		/* PCIe x1 on Lane 0 : phy = <&genphy 0 MODE_PCIE>; */
		/* PCIe x2 on Lane 0 and 1 : phy = <&genphy 0 MODE_PCIE>, <&genphy 1
MODE_PCIE>; */
		status = "disabled";
	};
};

berlin2q-dmp.dts:

&sata1 {
	status = "okay";
};

&pcie0 {
	phy = <&genphy 1 MODE_PCIE>;
};

berlin2q-foo.dts:

&pcie0 {
	phy = <&genphy 0 MODE_PCIE>, <&genphy 1 MODE_PCIE>;
};

For the driver, Antoine then would have to squeeze all PHY register
mangling in phy-berlin2.c and see how to make ahci-platform aware of
individual port nodes (I haven't looked up if it already exists, sorry)
and announce only enabled port child nodes, right?

Sebastian

