Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaBYBMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:12:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55856 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaBYBMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:12:36 -0500
Date: Mon, 24 Feb 2014 20:12:28 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] r8169: initialize rtl8169_stats seqlock
Message-ID: <20140225011228.GC14970@merlin.infradead.org>
References: <20140224231748.GA18598@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224231748.GA18598@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Boris reports he's seeing:
> [    9.195943] INFO: trying to register non-static key.
> [    9.196031] the code is fine but needs lockdep annotation.
> [    9.196031] turning off the locking correctness validator.
> [    9.196031] CPU: 1 PID: 933 Comm: modprobe Not tainted 3.14.0-rc4+ #1
with the r8169 driver.

These are occuring because the seqcount embedded in u64_stats_sync on
32-bit SMP is uninitialized which is making lockdep unhappy.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---

Patch is only compile tested by me, as these initializers will disappear
on 64-bit.

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -7118,6 +7118,8 @@ rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	mutex_init(&tp->wk.mutex);
+	u64_stats_init(&tp->rx_stats.syncp);
+	u64_stats_init(&tp->tx_stats.syncp);
 
 	/* Get MAC address */
 	for (i = 0; i < ETH_ALEN; i++)
