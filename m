Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161243Ab3BOOse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:48:34 -0500
Received: from mail.abilis.ch ([195.70.19.74]:21600 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834Ab3BOOsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:48:32 -0500
Date: Fri, 15 Feb 2013 15:48:17 +0100
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] Prevent interrupt loop with DWMAC MMC RX IPC Counter
Message-ID: <20130215144815.GA31098@ab42.lan>
References: <1360934123-30476-1-git-send-email-christian.ruppert@abilis.com>
 <511E3C28.7090101@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <511E3C28.7090101@st.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guiseppe,

Thanks for the feedback. I'll send a new patch shortly which
unconditionally masks the interrupts as you suggest. The mask register
does not exist in DWMACs without RX IPC counters, however, and I have no
way of testing if accessing this register nevertheless generates a bus
error. Do you have hardware to verify if everything works fine even
without RX IPC counters before integrating the patch?

Greetings,
  Christian

On Fri, Feb 15, 2013 at 02:46:16PM +0100, Giuseppe CAVALLARO wrote:
> Hello Christian
> 
> On 2/15/2013 2:15 PM, Christian Ruppert wrote:
> >If the DesignWare MAC is synthesised with MMC RX IPC Counter, an unmanaged
> >and unacknowledged interrupt is generated after some time of operation. To
> >my knowledge there is no way to autodetect this configuration.
> >
> >This patch adds a Kconfig option to tell the driver about the counter which
> >in turn masks the undesired interrupts.
> >
> >Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> >---
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig    |    8 ++++++++
> >  drivers/net/ethernet/stmicro/stmmac/mmc_core.c |    3 +++
> >  2 files changed, 11 insertions(+), 0 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >index 1164930..60e5130 100644
> >--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >@@ -71,5 +71,13 @@ config STMMAC_CHAINED
> >
> >  endchoice
> >
> >+config STMMAC_RX_IPC_CTRS
> >+	bool "MMC Receive IPC Counters enabled"
> >+	depends on STMMAC_ETH
> >+	default n
> >+	---help---
> >+	  Select this option in case MMC Receive IPC counters were enabled at
> >+	  synthesis time of the block. If this option is not set correctly,
> >+	  system might hang after a certain amount of time.
> >
> >  endif
> >diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
> >index 0c74a70..ae877ee 100644
> >--- a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
> >+++ b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
> >@@ -149,6 +149,9 @@ void dwmac_mmc_intr_all_mask(void __iomem *ioaddr)
> >  {
> >  	writel(MMC_DEFAULT_MASK, ioaddr + MMC_RX_INTR_MASK);
> >  	writel(MMC_DEFAULT_MASK, ioaddr + MMC_TX_INTR_MASK);
> >+#ifdef CONFIG_STMMAC_RX_IPC_CTRS
> >+	writel(MMC_DEFAULT_MASK, ioaddr + MMC_RX_IPC_INTR_MASK);
> >+#endif
> 
> your fix makes sense to me; I have never faced this problem because the
> MMC RX IPC Counter is not synthesised  on the GMAC chip I used.
> 
> Anyway all mmc interrupts are not managed by defsign so I only ask
> you to remove the Kconfig option and add the writel in the
> dwmac_mmc_intr_all_mask.
> 
> peppe
> 
> >  }
> >
> >  /* This reads the MAC core counters (if actaully supported).
> >
> 

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
