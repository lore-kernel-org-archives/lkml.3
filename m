Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3HaBrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 21:47:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48750 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752638Ab3HaBrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 21:47:37 -0400
Message-ID: <1377913655.2070.45.camel@joe-AO722>
Subject: [PATCH] i40e: Fix 32 bit shift compilation warnings
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 18:47:35 -0700
In-Reply-To: <daa992875a6f542adc41069daeb81246e46b7f80.1377903831.git.joe@perches.com>
References: <cover.1377903831.git.joe@perches.com>
	 <daa992875a6f542adc41069daeb81246e46b7f80.1377903831.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dma_addr_t is a 32 bit value, >> 32 emits compiler warnings
Use ((addr>>16) >>16) to avoid this.

I presume the macro should actually use the kernel.h
macro upper_32_bits() eventually.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/i40e/i40e_hmc.h  | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.h b/drivers/net/ethernet/intel/i40e/i40e_hmc.h
index 745fb355..2f1b72f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.h
@@ -123,7 +123,7 @@ struct i40e_hmc_info {
 #define I40E_SET_PF_SD_ENTRY(hw, pa, sd_index, type)			\
 {									\
 	u32 val1, val2, val3;						\
-	val1 = (u32)((pa) >> sizeof(u32) * 8);				\
+	val1 = (u32)(I40E_HI_DWORD(pa));				\
 	val2 = (u32)(pa) | (I40E_HMC_MAX_BP_COUNT <<			\
 		 I40E_PFHMC_SDDATALOW_PMSDBPCOUNT_SHIFT) |		\
 		((((type) == I40E_SD_TYPE_PAGED) ? 0 : 1) <<		\
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 36e35cc..4263cf7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -78,8 +78,8 @@ typedef void (*I40E_ADMINQ_CALLBACK)(struct i40e_hw *, struct i40e_aq_desc *);
 #define I40E_ETH_LENGTH_OF_ADDRESS	6
 
 /* Data type manipulation macros. */
-#define I40E_HI_DWORD(x)	((u32)(((x)>>32)&0xFFFFFFFF))
-#define I40E_LO_DWORD(x)	((u32)((x)&0xFFFFFFFF))
+#define I40E_HI_DWORD(x)	((u32)((((x) >> 16) >> 16) & 0xFFFFFFFF))
+#define I40E_LO_DWORD(x)	((u32)((x) & 0xFFFFFFFF))
 
 #define I40E_HI_WORD(x)		((u16)(((x)>>16)&0xFFFF))
 #define I40E_DESC_UNUSED(R)	\


