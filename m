Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbaJUWDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:03:55 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60567 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933598AbaJUWDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:03:52 -0400
Message-ID: <5446D833.1030702@gmail.com>
Date: Tue, 21 Oct 2014 15:03:31 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QW50b2luZSBUw6luYXI=?= =?UTF-8?B?dA==?= 
	<antoine.tenart@free-electrons.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Marvell PXA168 libphy handling and Berlin Ethernet
References: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 10/21/2014 01:53 AM, Sebastian Hesselbarth wrote:
> This patch series deals with a removing a IP feature that can be found
> on all currently supported Marvell Ethernet IP (pxa168_eth, mv643xx_eth,
> mvneta). The MAC IP allows to automatically perform PHY auto-negotiation
> without software interaction.
> 
> However, this feature (a) fundamentally clashes with the way libphy works
> and (b) is unable to deal with quirky PHYs that require special treatment.
> In this series, pxa168_eth driver is rewritten to completely disable that
> feature and properly deal with libphy provided PHYs.
> 
> This is the real patch set after an RFT sent earlier. Unfortunately, there
> was no testing from MMP/gplug but there was for BG2Q. However, it still
> would be great to get a Tested-by on gplug. Also, this patch set is now
> rebased on v3.18-rc1. As usual, a branch on top of v3.18-rc1 can be found at
> 
> git://git.infradead.org/users/hesselba/linux-berlin.git devel/bg2-bg2cd-eth-v1
> 
> Patches 1-5 should go through David's net tree, I'll pick up the DT patches
> 6-9.
> 
> Compared to the RFT, there have been some changes:
> - added phy-connection-type property to BG2Q PHY DT node
> - bail out from pxa168_eth_adjust_link when there is no change in
>   PHY parameters. Also, add a call to phy_print_status.
> 
> Patch 1 adds support for Marvell 88E3016 FastEthernet PHY that is also
> integrated in Marvell Berlin BG2/BG2CD SoCs.
> 
> Patch 2 allows to pass phy_interface_t on pxa168_eth platform_data that
> is only used by mach-mmp/gplug. From the board setup, I guessed gplug's
> PHY is connected via RMII. The patch still isn't even compile tested.
> 
> Patches 3-5 prepare proper libphy handling and finally remove all in-driver
> PHY mangling related to the feature explained above.
> 
> Patches 6-9 add corresponding ethernet DT nodes to BG2, BG2CD, add a
> phy-connection-type property to BG2Q and enable ethernet on BG2-based Sony
> NSZ-GS7. I have tested all this on GS7 successfully with ip=dhcp on 100M FD.

Besides the misplacement of the 'phy-connection-type' as reported by
Sergei, this looks good to me:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!

> 
> Antoine Ténart (1):
>   ARM: berlin: Add phy-connection-type to BG2Q PHY
> 
> Sebastian Hesselbarth (8):
>   phy: marvell: Add support for 88E3016 FastEthernet PHY
>   net: pxa168_eth: Provide phy_interface mode on platform_data
>   net: pxa168_eth: Prepare proper libphy handling
>   net: pxa168_eth: Remove HW auto-negotiaion
>   net: pxa168_eth: Remove in-driver PHY mangling
>   ARM: berlin: Add BG2 ethernet DT nodes
>   ARM: berlin: Add BG2CD ethernet DT nodes
>   ARM: berlin: Enable ethernet on Sony NSZ-GS7
> 
>  arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts |   2 +
>  arch/arm/boot/dts/berlin2.dtsi             |  36 +++++
>  arch/arm/boot/dts/berlin2cd.dtsi           |  36 +++++
>  arch/arm/boot/dts/berlin2q.dtsi            |   1 +
>  arch/arm/mach-mmp/gplugd.c                 |   2 +
>  drivers/net/ethernet/marvell/pxa168_eth.c  | 248 ++++++++++++-----------------
>  drivers/net/phy/marvell.c                  |  46 ++++++
>  include/linux/marvell_phy.h                |   1 +
>  include/linux/pxa168_eth.h                 |   1 +
>  9 files changed, 225 insertions(+), 148 deletions(-)
> 
> ---
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 

