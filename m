Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaKRNw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:52:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:36602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbaKRNwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:52:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="609776257"
From: lukasz.anaczkowski@intel.com
To: m.chehab@samsung.com, dougthompson@xmission.com
Cc: bp@alien8.de, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Snow <jim.m.snow@intel.com>, Jim Snow <jim.snow@intel.com>,
        Lukasz Anaczkowski <lukasz.anaczkowski@intel.com>
Subject: [PATCH 2/2] sb_edac: Fix erroneous bytes->gigabytes conversion
Date: Tue, 18 Nov 2014 14:51:09 +0100
Message-Id: <1416318669-96322-3-git-send-email-lukasz.anaczkowski@intel.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416318669-96322-1-git-send-email-lukasz.anaczkowski@intel.com>
References: <1416318669-96322-1-git-send-email-lukasz.anaczkowski@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Snow <jim.m.snow@intel.com>

Signed-off-by: Jim Snow <jim.snow@intel.com>
Signed-off-by: Lukasz Anaczkowski <lukasz.anaczkowski@intel.com>
---
 drivers/edac/sb_edac.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index e9bb1af..f37d01f 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -909,7 +909,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	u32 reg;
 	u64 limit, prv = 0;
 	u64 tmp_mb;
-	u32 mb, kb;
+	u32 gb, mb;
 	u32 rir_way;
 
 	/*
@@ -919,15 +919,17 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	pvt->tolm = pvt->info.get_tolm(pvt);
 	tmp_mb = (1 + pvt->tolm) >> 20;
 
-	mb = div_u64_rem(tmp_mb, 1000, &kb);
-	edac_dbg(0, "TOLM: %u.%03u GB (0x%016Lx)\n", mb, kb, (u64)pvt->tolm);
+	gb = div_u64_rem(tmp_mb, 1024, &mb);
+	edac_dbg(0, "TOLM: %u.%03u GB (0x%016Lx)\n",
+		gb, (mb*1000)/1024, (u64)pvt->tolm);
 
 	/* Address range is already 45:25 */
 	pvt->tohm = pvt->info.get_tohm(pvt);
 	tmp_mb = (1 + pvt->tohm) >> 20;
 
-	mb = div_u64_rem(tmp_mb, 1000, &kb);
-	edac_dbg(0, "TOHM: %u.%03u GB (0x%016Lx)\n", mb, kb, (u64)pvt->tohm);
+	gb = div_u64_rem(tmp_mb, 1024, &mb);
+	edac_dbg(0, "TOHM: %u.%03u GB (0x%016Lx)\n",
+		gb, (mb*1000)/1024, (u64)pvt->tohm);
 
 	/*
 	 * Step 2) Get SAD range and SAD Interleave list
@@ -949,11 +951,11 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			break;
 
 		tmp_mb = (limit + 1) >> 20;
-		mb = div_u64_rem(tmp_mb, 1000, &kb);
+		gb = div_u64_rem(tmp_mb, 1024, &mb);
 		edac_dbg(0, "SAD#%d %s up to %u.%03u GB (0x%016Lx) Interleave: %s reg=0x%08x\n",
 			 n_sads,
 			 get_dram_attr(reg),
-			 mb, kb,
+			 gb, (mb*1000)/1024,
 			 ((u64)tmp_mb) << 20L,
 			 INTERLEAVE_MODE(reg) ? "8:6" : "[8:6]XOR[18:16]",
 			 reg);
@@ -984,9 +986,9 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			break;
 		tmp_mb = (limit + 1) >> 20;
 
-		mb = div_u64_rem(tmp_mb, 1000, &kb);
+		gb = div_u64_rem(tmp_mb, 1024, &mb);
 		edac_dbg(0, "TAD#%d: up to %u.%03u GB (0x%016Lx), socket interleave %d, memory interleave %d, TGT: %d, %d, %d, %d, reg=0x%08x\n",
-			 n_tads, mb, kb,
+			 n_tads, gb, (mb*1000)/1024,
 			 ((u64)tmp_mb) << 20L,
 			 (u32)TAD_SOCK(reg),
 			 (u32)TAD_CH(reg),
@@ -1009,10 +1011,10 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 					      tad_ch_nilv_offset[j],
 					      &reg);
 			tmp_mb = TAD_OFFSET(reg) >> 20;
-			mb = div_u64_rem(tmp_mb, 1000, &kb);
+			gb = div_u64_rem(tmp_mb, 1024, &mb);
 			edac_dbg(0, "TAD CH#%d, offset #%d: %u.%03u GB (0x%016Lx), reg=0x%08x\n",
 				 i, j,
-				 mb, kb,
+				 gb, (mb*1000)/1024,
 				 ((u64)tmp_mb) << 20L,
 				 reg);
 		}
@@ -1034,10 +1036,10 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 
 			tmp_mb = pvt->info.rir_limit(reg) >> 20;
 			rir_way = 1 << RIR_WAY(reg);
-			mb = div_u64_rem(tmp_mb, 1000, &kb);
+			gb = div_u64_rem(tmp_mb, 1024, &mb);
 			edac_dbg(0, "CH#%d RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d, reg=0x%08x\n",
 				 i, j,
-				 mb, kb,
+				 gb, (mb*1000)/1024,
 				 ((u64)tmp_mb) << 20L,
 				 rir_way,
 				 reg);
@@ -1048,10 +1050,10 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 						      &reg);
 				tmp_mb = RIR_OFFSET(reg) << 6;
 
-				mb = div_u64_rem(tmp_mb, 1000, &kb);
+				gb = div_u64_rem(tmp_mb, 1024, &mb);
 				edac_dbg(0, "CH#%d RIR#%d INTL#%d, offset %u.%03u GB (0x%016Lx), tgt: %d, reg=0x%08x\n",
 					 i, j, k,
-					 mb, kb,
+					 gb, (mb*1000)/1024,
 					 ((u64)tmp_mb) << 20L,
 					 (u32)RIR_RNK_TGT(reg),
 					 reg);
@@ -1089,7 +1091,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	u8			ch_way, sck_way, pkg, sad_ha = 0;
 	u32			tad_offset;
 	u32			rir_way;
-	u32			mb, kb;
+	u32			mb, gb;
 	u64			ch_addr, offset, limit = 0, prv = 0;
 
 
@@ -1358,10 +1360,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			continue;
 
 		limit = pvt->info.rir_limit(reg);
-		mb = div_u64_rem(limit >> 20, 1000, &kb);
+		gb = div_u64_rem(limit >> 20, 1024, &mb);
 		edac_dbg(0, "RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d\n",
 			 n_rir,
-			 mb, kb,
+			 gb, (mb*1000)/1024,
 			 limit,
 			 1 << RIR_WAY(reg));
 		if  (ch_addr <= limit)
-- 
2.0.4

--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek
przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by
others is strictly prohibited.

