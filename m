Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaEOGqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:46:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37223 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaEOGqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:46:38 -0400
Message-ID: <537462A2.5020607@ti.com>
Date: Thu, 15 May 2014 12:15:54 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <jszhang@marvell.com>, <tj@kernel.org>
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <20140514165722.GA18495@kwain> <5373AE9A.3050008@gmail.com> <5764751.ffUj9rhnMd@wuerfel> <5373B908.5090904@gmail.com>
In-Reply-To: <5373B908.5090904@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 15 May 2014 12:12 AM, Sebastian Hesselbarth wrote:
> On 05/14/2014 08:12 PM, Arnd Bergmann wrote:
>> On Wednesday 14 May 2014 19:57:46 Sebastian Hesselbarth wrote:
>>> On 05/14/2014 06:57 PM, Antoine Ténart wrote:
>>>> On Wed, May 14, 2014 at 06:11:24PM +0200, Arnd Bergmann wrote:
>>>>> On Wednesday 14 May 2014 17:49:29 Antoine Ténart wrote:
>>>>>> On Wed, May 14, 2014 at 05:31:24PM +0200, Arnd Bergmann wrote:
>>>
>>> From what I understand from the conversation, we have a single PHY
>>> register set dealing with both SATA ports available on the SoC.
>>> Also, from the name of the PHY bits we assume the PHY may be able
>>> to work in different modes than just SATA. And we currently have
>>> an AHCI-compatible SATA IP that supports up to two ports, with one
>>> actually connected to a SATA plug on the DMP board.
>>>
>>> Now, thinking about the PHY binding and the (possible) multi-protocol
>>> support, it can be possible that on BG2Q there is a generic 2-lane
>>> LVDS PHY that can be configured to support SATA or PCIe. Both are
>>> electrically and bit-level compatible, so they could be internally
>>> wired-up with AHCI and PCIe controller.
>>
>> Sounds like a reasonable guess. We have other PHY drivers doing the
>> same thing already.
> 
> Well, I based that on what I know about FPGA LVDS transceivers, so
> I wasn't guessing out of the blue ;)
> 
>>> From a DT point-of-view, we need a way to (a) link each SATA or PCIe
>>> port to the PHY, (b) specify the PHY lane to be used, and (c) specify
>>> the protocol to be used on that lane. If I got it right, Arnd already
>>> mentioned to use the phy-specifier to deal with it:
>>>
>>> e.g. phy = <&genphy 0 MODE_SATA> or phy = <&genphy 1 MODE_PCIE>
>>
>> Right.
>>
>>> Let's assume we have one dual-port SATA controller and one PCIe
>>> controller with either x1 or x2 support. The only sane DT binding,
>>> I can think of then would be:
>>>
>>> berlin2q.dtsi:
>>>
>>> genphy: lvds@ea00ff {
>>> 	compatible = "marvell,berlin-lvds-phy";
>>> 	reg = <0xea00ff 0x100>;
>>> 	#phy-cells = <2>;
>>> };
>>>
>>> sata: sata@ab00ff {
>>> 	compatible = "ahci-platform";
>>> 	reg = <0xab00ff 0x100>;
>>> 	
>>> 	sata0: sata-port@0 {
>>> 		reg = <0>;
>>> 		phy = <&genphy 0 MODE_SATA>;
>>> 		status = "disabled";
>>> 	};
>>>
>>> 	sata1: sata-port@1 {
>>> 		reg = <1>;
>>> 		phy = <&genphy 1 MODE_SATA>;
>>> 		status = "disabled";
>>> 	};
>>> };
>>>
>>> pcie: pcie@ab01ff {
>>> 	compatible = "marvell,berlin-pcie";
>>> 	reg = <0xab01ff 0x100>;
>>>
>>> 	pcie0: pcie-port@0 {
>>> 		reg = <0>;
>>> 		/* set phy on a per-board basis */
>>> 		/* PCIe x1 on Lane 0 : phy = <&genphy 0 MODE_PCIE>; */
>>> 		/* PCIe x2 on Lane 0 and 1 : phy = <&genphy 0 MODE_PCIE>, <&genphy 1
>>> MODE_PCIE>; */
>>> 		status = "disabled";
>>> 	};
>>> };
>>>
>>> berlin2q-dmp.dts:
>>>
>>> &sata1 {
>>> 	status = "okay";
>>> };
>>>
>>> &pcie0 {
>>> 	phy = <&genphy 1 MODE_PCIE>;
>>> };
>>>
>>> berlin2q-foo.dts:
>>>
>>> &pcie0 {
>>> 	phy = <&genphy 0 MODE_PCIE>, <&genphy 1 MODE_PCIE>;
>>> };
>>
>> Exactly. I would also be fine with keeping the sub-nodes of the
>> phy device as in v3 and using #phy-cells=<1> instead of #phy-cells.
>> The result would be pretty much the same, it just depends on how
>> closely connected the two logical phys are.

huh.. even with sub-nodes you'll need #phy-cells=<2> if we use a single *PHY
PROVIDER*. Because with just PHYs node pointer we won't be able to get the PHY.
We'll need PHY providers node pointer.

However I'd prefer to have sub-nodes for each individual PHYs and register a
single PHY PROVIDER.

Thanks
Kishon
