Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaDCKPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 06:15:36 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52439 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDCKPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:15:32 -0400
Message-ID: <533D34BD.900@gmail.com>
Date: Thu, 03 Apr 2014 18:15:25 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: sandeep.kumar@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tao, Yue" <Yue.Tao@windriver.com>,
        "Yang, Zhangle (Eric)" <Zhangle.Yang@windriver.com>,
        guang.yang@windriver.com, joe@perches.com, festevam@gmail.com,
        linuxppc-dev@lists.ozlabs.org, richardcochran@gmail.com,
        clarocq@gmail.com, yongjun_wei@trendmicro.com.cn,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        zhuyj <zyjzyj2000@gmail.com>
Subject: Re: on kernel 2.6.34.15, vlan and raw packets can not be received
 with gfar-enet nic
References: <53310F4E.4080104@gmail.com> <533D25D4.4000607@gmail.com> <20140403092727.GD16158@1wt.eu>
In-Reply-To: <20140403092727.GD16158@1wt.eu>
Content-Type: multipart/mixed;
 boundary="------------010908060705050701050105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010908060705050701050105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/03/2014 05:27 PM, Willy Tarreau wrote:
> Hi Zhu,
>
> On Thu, Apr 03, 2014 at 05:11:48PM +0800, zhuyj wrote:
>> Hi, Claudiu
>>
>> Please help to review this patch. This patch is for kernel 2.6.x. Thanks
>> a lot.
>>
>> Hi, Willy
>>
>> Please help to merge this patch to longterm: 2.6.32.61 since this
>> problem also occurs on this kernel. Thanks a lot.
> Could you please send the reference to the equivalent mainline commit (the one
> which disables the tx vlan feature I'm assuming) ? I'll happily queue it for
> 2.6.32.62.
>
> Thanks,
> Willy
>
>
Hi, Willy

I made a new patch. In long commit message, I inserted the equivalent 
mainline commit
about this feature. Maybe it is better. Now this patch is in the 
attachment. Please check
and merge it into kernel 2.6.32.62.

Thanks a lot.
Zhu Yanjun


--------------010908060705050701050105
Content-Type: text/x-patch;
 name="0001-gianfar-disable-TX-vlan-based-on-kernel-2.6.x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-gianfar-disable-TX-vlan-based-on-kernel-2.6.x.patch"

>From 3b74ad6134f8eccce9ee391fb02ff15863630c1b Mon Sep 17 00:00:00 2001
From: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Date: Thu, 3 Apr 2014 16:41:13 +0800
Subject: [PATCH 1/1] gianfar: disable TX vlan based on kernel 2.6.x

2.6.x kernels require a similar logic change as commit e1653c3e
[gianfar: do vlan cleanup] and commit 51b8cbfc
[gianfar: fix bug caused by e1653c3e] introduces for newer kernels.

Since there is something wrong with tx vlan of gianfar nic driver,
in kernel(3.1+), tx vlan is disabled. But in kernel 2.6.x, tx vlan
is still enabled. Thus,gianfar nic driver can not support vlan
packets and non-vlan packets at the same time.

Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>
---
 drivers/net/gianfar.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 934a28f..8aa2cf6 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -365,7 +365,7 @@ static int gfar_probe(struct of_device *ofdev,
 	priv->vlgrp = NULL;
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN)
-		dev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
+		dev->features |= NETIF_F_HW_VLAN_RX;
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_EXTENDED_HASH) {
 		priv->extended_hash = 1;
@@ -1451,12 +1451,6 @@ static void gfar_vlan_rx_register(struct net_device *dev,
 	priv->vlgrp = grp;
 
 	if (grp) {
-		/* Enable VLAN tag insertion */
-		tempval = gfar_read(&priv->regs->tctrl);
-		tempval |= TCTRL_VLINS;
-
-		gfar_write(&priv->regs->tctrl, tempval);
-
 		/* Enable VLAN tag extraction */
 		tempval = gfar_read(&priv->regs->rctrl);
 		tempval |= (RCTRL_VLEX | RCTRL_PRSDEP_INIT);
-- 
1.7.9.5


--------------010908060705050701050105--
