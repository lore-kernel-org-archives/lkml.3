Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaJMC07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:26:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaJMC0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neerav Parikh <neerav.parikh@intel.com>,
        Catherine Sullivan <catherine.sullivan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 3.14 05/37] i40e: Dont stop driver probe when querying DCB config fails
Date: Mon, 13 Oct 2014 04:24:02 +0200
Message-Id: <20141013022400.517640856@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neerav Parikh <neerav.parikh@intel.com>

Commit id: 014269ff376f552363ecdab78d3d947fbe2237d9 in Linus's tree
should be queued up for stable 3.14 & 3.15 since the i40e driver will
not load when DCB is enabled, unless this patch is applied.

In case of any AQ command to query port's DCB configuration fails
during driver's probe time; the probe fails and returns an error.

This patch prevents this issue by continuing the driver probe even
when an error is returned.

Also, added an error message to dump the AQ error status to show what
error caused the failure to get the DCB configuration from firmware.

Change-ID: Ifd5663512588bca684069bb7d4fb586dd72221af
Signed-off-by: Neerav Parikh <neerav.parikh@intel.com>
Signed-off-by: Catherine Sullivan <catherine.sullivan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4024,6 +4024,9 @@ static int i40e_init_pf_dcb(struct i40e_
 				       DCB_CAP_DCBX_VER_IEEE;
 			pf->flags |= I40E_FLAG_DCB_ENABLED;
 		}
+	} else {
+		dev_info(&pf->pdev->dev, "AQ Querying DCB configuration failed: %d\n",
+			 pf->hw.aq.asq_last_status);
 	}
 
 out:
@@ -8003,7 +8006,7 @@ static int i40e_probe(struct pci_dev *pd
 	if (err) {
 		dev_info(&pdev->dev, "init_pf_dcb failed: %d\n", err);
 		pf->flags &= ~I40E_FLAG_DCB_ENABLED;
-		goto err_init_dcb;
+		/* Continue without DCB enabled */
 	}
 #endif /* CONFIG_I40E_DCB */
 
@@ -8119,9 +8122,6 @@ err_vsis:
 err_switch_setup:
 	i40e_reset_interrupt_capability(pf);
 	del_timer_sync(&pf->service_timer);
-#ifdef CONFIG_I40E_DCB
-err_init_dcb:
-#endif /* CONFIG_I40E_DCB */
 err_mac_addr:
 err_configure_lan_hmc:
 	(void)i40e_shutdown_lan_hmc(hw);


