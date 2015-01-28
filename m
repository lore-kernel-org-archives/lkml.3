Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbbA2BMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:12:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59068 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbbA2BKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:10:55 -0500
Message-ID: <54C9654C.8030407@ti.com>
Date: Wed, 28 Jan 2015 17:40:12 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, "Balbi, Felipe" <balbi@ti.com>,
        <mugunthanvnm@ti.com>
CC: David Miller <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v8 0/4] net: Add Keystone NetCP ethernet driver
 support
References: <1421367007-19744-1-git-send-email-m-karicheri2@ti.com> <54C92878.3030207@ti.com> <54C94A0D.9050505@ti.com> <20343006.1NmdQEM9nn@wuerfel>
In-Reply-To: <20343006.1NmdQEM9nn@wuerfel>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Felipe, Mugunthan for commenting on TI_CPSW, ALE.

On 01/28/2015 04:03 PM, Arnd Bergmann wrote:
> On Wednesday 28 January 2015 15:43:57 Murali Karicheri wrote:
>>> this. Hope I am on the right track.
>>
>> Reproduced this. Following errors seen when building the modules.
>>
>>     LD [M]  drivers/net/ethernet/ti/keystone_netcp.o
>> drivers/net/ethernet/ti/netcp_ethss.o: In function `init_module':
>> netcp_ethss.c:(.init.text+0x0): multiple definition of `init_module'
>> drivers/net/ethernet/ti/netcp_core.o:netcp_core.c:(.init.text+0x0):
>> first defined here
>> drivers/net/ethernet/ti/netcp_ethss.o: In function `cleanup_module':
>> netcp_ethss.c:(.exit.text+0x0): multiple definition of `cleanup_module'
>> drivers/net/ethernet/ti/netcp_core.o:netcp_core.c:(.exit.text+0x0):
>> first defined here
>> make[4]: *** [drivers/net/ethernet/ti/keystone_netcp.o] Error 1
>>
>> BTW, I had to disable cpsw_ale.c to get to build keystone NetCP. I am
>> assuming someone from TI is addressing this.
>>
>> drivers/net/ethernet/ti/cpsw_ale.c: In function ‘cpsw_ale_start’:
>> drivers/net/ethernet/ti/cpsw_ale.c:759:2: error: ‘KBUILD_MODNAME’
>> undeclared (first use in this function)
>> drivers/net/ethernet/ti/cpsw_ale.c:759:2: note: each undeclared
>> identifier is reported only once for each function it appears in
>
> I think both problems are nontrivial to fix. The first one is obviously
> that there are multiple init_module functions in one module. You have
> to either split the driver into multiple loadable modules with at most
> one init_module/cleanup_module pair each, or call one of the functions
> from the other one in the right order.
I have a version that is building now with out issues. I had to make 
several modifications.

1. export functions from drivers/soc/ti/knav* that are used by the netcp 
driver. I will be sending a patch for this soon.

2. Convert netcp_ethss.o to a module and add Kconfig for the same

  config TI_KEYSTONE_NETCP
-       tristate "TI Keystone NETCP Ethernet subsystem Support"
+       tristate "TI Keystone NETCP Core Support"
+       select TI_CPSW_ALE
         depends on OF
         depends on KEYSTONE_NAVIGATOR_DMA && KEYSTONE_NAVIGATOR_QMSS
         ---help---
-         This driver supports TI's Keystone NETCP Ethernet subsystem.
+         This driver supports TI's Keystone NETCP Core.
+
+         To compile this driver as a module, choose M here: the module
+         will be called keystone_netcp.
+
+config TI_KEYSTONE_NETCP_ETHSS
+       depends on TI_KEYSTONE_NETCP
+       tristate "TI Keystone NETCP Ethernet subsystem Support"
+       ---help---


And Makefile to change as

diff --git a/drivers/net/ethernet/ti/Makefile 
b/drivers/net/ethernet/ti/Makefile
index 0a9813b..1dbb8b5 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -8,9 +8,13 @@ obj-$(CONFIG_TI_DAVINCI_EMAC) += davinci_emac.o
  obj-$(CONFIG_TI_DAVINCI_MDIO) += davinci_mdio.o
  obj-$(CONFIG_TI_DAVINCI_CPDMA) += davinci_cpdma.o
  obj-$(CONFIG_TI_CPSW_PHY_SEL) += cpsw-phy-sel.o
  obj-$(CONFIG_TI_CPSW) += ti_cpsw.o
  ti_cpsw-y := cpsw_ale.o cpsw.o cpts.o

  obj-$(CONFIG_TI_KEYSTONE_NETCP) += keystone_netcp.o
-keystone_netcp-y := netcp_core.o netcp_ethss.o netcp_sgmii.o \
-                       netcp_xgbepcsr.o cpsw_ale.o
+keystone_netcp-y := netcp_core.o
+
+obj-$(CONFIG_TI_KEYSTONE_NETCP_ETHSS) += keystone_netcp_ethss.o
+keystone_netcp_ethss-y := netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o \
+               cpsw_ale.o

3. export some of the functions in netcp_core.c to support building 
keystone_netcp_ethss as module.

>
> The second problem is where I got stuck myself: cpsw_ale.c (also cpts.c)
> is getting linked into both modules, which is not allowed: It is
> impossible for the kernel to compile these if one driver is a module
> and the other one is not, and any use of KBUILD_MODNAME fails because
> it is unclear what the modname is if the file is compiled once to
> be linked into two drivers.

I am still looking into this. Both Keystone and TI CPSW driver would 
need to use cpsw_ale.o and cpts.o (currently not used, but will need 
this later). Not found a solution yet.

Murali
>
> 	Arnd


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
