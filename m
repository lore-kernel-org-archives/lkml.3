Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaJIRnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:43:13 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22745 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJIRm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:42:58 -0400
Message-ID: <5436C912.5040705@c-s.fr>
Date: Thu, 09 Oct 2014 19:42:42 +0200
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, netdev@vger.kernel.org
Subject: Re: Upstream build failure due to commit d43a396af0 ('net: fs_enet:
 Add NAPI TX')
References: <20141009165122.GA1964@roeck-us.net>
In-Reply-To: <20141009165122.GA1964@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 141009-1, 09/10/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 09/10/2014 18:51, Guenter Roeck a écrit :
> Hi,
>
> I see the following build failure in upstream Linux.
>
> drivers/net/ethernet/freescale/fs_enet/mac-scc.c:119:32: error: 'SCCE_ENET_TXF' undeclared
>
> This is not surprising as SCCE_ENET_TXF is not defined anywhere in the kernel.
> linux-next fails to build with the same error.
>
> Affected builds are
> 	powerpc:mpc85xx_defconfig
> 	powerpc:mpc85xx_smp_defconfig
> 	powerpc:tqm8xx_defconfig
>
> Can you please have a look ?
>
>
Yes, fixed by the patch below submitted this afternoon.

Christophe

Subject: [PATCH] net: fs_enet: error: 'SCCE_ENET_TXF' undeclared

[linux-devel:devel-hourly-2014100909 3763/3915] drivers/net/ethernet/freescale/fs_enet/mac-scc.c:119:32: error: 'SCCE_ENET_TXF' undeclared

Due to patch d43a396 net: fs_enet: Add NAPI TX, it appears that some target
compilations are broken.
This is due to the fact that unlike the FEC, the SCC and FCC don't have a TXF
event (complete Frame transmitted) but only TXB (buffer transmitted).

Signed-off-by: Christophe Leroy<christophe.leroy@c-s.fr>

---
  drivers/net/ethernet/freescale/fs_enet/mac-fcc.c | 2 +-
  drivers/net/ethernet/freescale/fs_enet/mac-scc.c | 2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
index 2c578db..08f5b91 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
@@ -125,7 +125,7 @@ out:
  }
  
  #define FCC_NAPI_RX_EVENT_MSK	(FCC_ENET_RXF | FCC_ENET_RXB)
-#define FCC_NAPI_TX_EVENT_MSK	(FCC_ENET_TXF | FCC_ENET_TXB)
+#define FCC_NAPI_TX_EVENT_MSK	(FCC_ENET_TXB)
  #define FCC_RX_EVENT		(FCC_ENET_RXF)
  #define FCC_TX_EVENT		(FCC_ENET_TXB)
  #define FCC_ERR_EVENT_MSK	(FCC_ENET_TXE)
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
index 5b592a6..90c9652 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
@@ -117,7 +117,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
  }
  
  #define SCC_NAPI_RX_EVENT_MSK	(SCCE_ENET_RXF | SCCE_ENET_RXB)
-#define SCC_NAPI_TX_EVENT_MSK	(SCCE_ENET_TXF | SCCE_ENET_TXB)
+#define SCC_NAPI_TX_EVENT_MSK	(SCCE_ENET_TXB)
  #define SCC_RX_EVENT		(SCCE_ENET_RXF)
  #define SCC_TX_EVENT		(SCCE_ENET_TXB)
  #define SCC_ERR_EVENT_MSK	(SCCE_ENET_TXE | SCCE_ENET_BSY)
-- 2.1.0



---
Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
http://www.avast.com

