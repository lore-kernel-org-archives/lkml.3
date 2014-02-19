Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaBSJwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:52:31 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:63618 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbaBSJw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:52:29 -0500
Message-ID: <1392803546.27558.16.camel@x220>
Subject: [PATCH] target_core_alua: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Feb 2014 10:52:26 +0100
In-Reply-To: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Feb 2014 09:52:26.0528 (UTC) FILETIME=[4B923A00:01CF2D58]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 10:02 +0100, Geert Uytterhoeven wrote:
> *** WARNINGS ***
> 
> 188 regressions:
>   [...]
>   + /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 773:18

This one popped up on my (Fedora 20 based) builds on 32 and 64 bits x86.
Geert seems to have seen this on v3.12 already. I first saw it in
v3.14-rc1. Not clear why that is. Anyhow, this is what I came up with to
make this warning go away. (Compile tested only. I don't use this driver
myself.)
-------->8--------
From: Paul Bolle <pebolle@tiscali.nl>

Building target_core_alua.o triggers a GCC warning:
    drivers/target/target_core_alua.c: In function ‘target_alua_state_check’:
    drivers/target/target_core_alua.c:773:18: warning: ‘alua_ascq’ may be used uninitialized in this function [-Wmaybe-uninitialized]
       cmd->scsi_ascq = alua_ascq;
                      ^

This is a false positive. A little trial and error shows it is
apparently caused by core_alua_state_lba_dependent(). It must be hard
for GCC to track the branches of switch statement, inside a
list_for_each_entry loop, inside a while loop.

But if we add a small (inline) helper function we can reorganize the
code a bit. That also allows to drop alua_ascq which, obviously, gets
rid of this warning.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/target/target_core_alua.c | 94 ++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 50 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index c3d9df6..4111f43 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -455,11 +455,26 @@ out:
 	return rc;
 }
 
+static inline void set_ascq(struct se_cmd *cmd, u8 alua_ascq)
+{
+	/*
+	 * Set SCSI additional sense code (ASC) to 'LUN Not Accessible';
+	 * The ALUA additional sense code qualifier (ASCQ) is determined
+	 * by the ALUA primary or secondary access state..
+	 */
+	pr_debug("[%s]: ALUA TG Port not available, "
+		"SenseKey: NOT_READY, ASC/ASCQ: "
+		"0x04/0x%02x\n",
+		cmd->se_tfo->get_fabric_name(), alua_ascq);
+
+	cmd->scsi_asc = 0x04;
+	cmd->scsi_ascq = alua_ascq;
+}
+
 static inline int core_alua_state_nonoptimized(
 	struct se_cmd *cmd,
 	unsigned char *cdb,
-	int nonop_delay_msecs,
-	u8 *alua_ascq)
+	int nonop_delay_msecs)
 {
 	/*
 	 * Set SCF_ALUA_NON_OPTIMIZED here, this value will be checked
@@ -471,10 +486,9 @@ static inline int core_alua_state_nonoptimized(
 	return 0;
 }
 
-static inline int core_alua_state_lba_dependent(
+static noinline int core_alua_state_lba_dependent(
 	struct se_cmd *cmd,
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	u8 *alua_ascq)
+	struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
 	struct se_device *dev = cmd->se_dev;
 	u64 segment_size, segment_mult, sectors, lba;
@@ -520,7 +534,7 @@ static inline int core_alua_state_lba_dependent(
 		}
 		if (!cur_map) {
 			spin_unlock(&dev->t10_alua.lba_map_lock);
-			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 			return 1;
 		}
 		list_for_each_entry(map_mem, &cur_map->lba_map_mem_list,
@@ -531,11 +545,11 @@ static inline int core_alua_state_lba_dependent(
 			switch(map_mem->lba_map_mem_alua_state) {
 			case ALUA_ACCESS_STATE_STANDBY:
 				spin_unlock(&dev->t10_alua.lba_map_lock);
-				*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+				set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 				return 1;
 			case ALUA_ACCESS_STATE_UNAVAILABLE:
 				spin_unlock(&dev->t10_alua.lba_map_lock);
-				*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+				set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 				return 1;
 			default:
 				break;
@@ -548,8 +562,7 @@ static inline int core_alua_state_lba_dependent(
 
 static inline int core_alua_state_standby(
 	struct se_cmd *cmd,
-	unsigned char *cdb,
-	u8 *alua_ascq)
+	unsigned char *cdb)
 {
 	/*
 	 * Allowed CDBs for ALUA_ACCESS_STATE_STANDBY as defined by
@@ -570,7 +583,7 @@ static inline int core_alua_state_standby(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 			return 1;
 		}
 	case MAINTENANCE_OUT:
@@ -578,7 +591,7 @@ static inline int core_alua_state_standby(
 		case MO_SET_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 			return 1;
 		}
 	case REQUEST_SENSE:
@@ -588,7 +601,7 @@ static inline int core_alua_state_standby(
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+		set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 		return 1;
 	}
 
@@ -597,8 +610,7 @@ static inline int core_alua_state_standby(
 
 static inline int core_alua_state_unavailable(
 	struct se_cmd *cmd,
-	unsigned char *cdb,
-	u8 *alua_ascq)
+	unsigned char *cdb)
 {
 	/*
 	 * Allowed CDBs for ALUA_ACCESS_STATE_UNAVAILABLE as defined by
@@ -613,7 +625,7 @@ static inline int core_alua_state_unavailable(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 			return 1;
 		}
 	case MAINTENANCE_OUT:
@@ -621,7 +633,7 @@ static inline int core_alua_state_unavailable(
 		case MO_SET_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 			return 1;
 		}
 	case REQUEST_SENSE:
@@ -629,7 +641,7 @@ static inline int core_alua_state_unavailable(
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+		set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 		return 1;
 	}
 
@@ -638,8 +650,7 @@ static inline int core_alua_state_unavailable(
 
 static inline int core_alua_state_transition(
 	struct se_cmd *cmd,
-	unsigned char *cdb,
-	u8 *alua_ascq)
+	unsigned char *cdb)
 {
 	/*
 	 * Allowed CDBs for ALUA_ACCESS_STATE_TRANSITION as defined by
@@ -654,7 +665,7 @@ static inline int core_alua_state_transition(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq = ASCQ_04H_ALUA_STATE_TRANSITION;
+			set_ascq(cmd, ASCQ_04H_ALUA_STATE_TRANSITION);
 			return 1;
 		}
 	case REQUEST_SENSE:
@@ -662,7 +673,7 @@ static inline int core_alua_state_transition(
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		*alua_ascq = ASCQ_04H_ALUA_STATE_TRANSITION;
+		set_ascq(cmd, ASCQ_04H_ALUA_STATE_TRANSITION);
 		return 1;
 	}
 
@@ -684,8 +695,6 @@ target_alua_state_check(struct se_cmd *cmd)
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	int out_alua_state, nonop_delay_msecs;
-	u8 alua_ascq;
-	int ret;
 
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
@@ -701,9 +710,8 @@ target_alua_state_check(struct se_cmd *cmd)
 	if (atomic_read(&port->sep_tg_pt_secondary_offline)) {
 		pr_debug("ALUA: Got secondary offline status for local"
 				" target port\n");
-		alua_ascq = ASCQ_04H_ALUA_OFFLINE;
-		ret = 1;
-		goto out;
+		set_ascq(cmd, ASCQ_04H_ALUA_OFFLINE);
+		return TCM_CHECK_CONDITION_NOT_READY;
 	}
 	 /*
 	 * Second, obtain the struct t10_alua_tg_pt_gp_member pointer to the
@@ -731,20 +739,23 @@ target_alua_state_check(struct se_cmd *cmd)
 
 	switch (out_alua_state) {
 	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
-		ret = core_alua_state_nonoptimized(cmd, cdb,
-					nonop_delay_msecs, &alua_ascq);
+		core_alua_state_nonoptimized(cmd, cdb, nonop_delay_msecs);
 		break;
 	case ALUA_ACCESS_STATE_STANDBY:
-		ret = core_alua_state_standby(cmd, cdb, &alua_ascq);
+		if (core_alua_state_standby(cmd, cdb))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	case ALUA_ACCESS_STATE_UNAVAILABLE:
-		ret = core_alua_state_unavailable(cmd, cdb, &alua_ascq);
+		if (core_alua_state_unavailable(cmd, cdb))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	case ALUA_ACCESS_STATE_TRANSITION:
-		ret = core_alua_state_transition(cmd, cdb, &alua_ascq);
+		if (core_alua_state_transition(cmd, cdb))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
-		ret = core_alua_state_lba_dependent(cmd, tg_pt_gp, &alua_ascq);
+		if (core_alua_state_lba_dependent(cmd, tg_pt_gp))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	/*
 	 * OFFLINE is a secondary ALUA target port group access state, that is
@@ -757,23 +768,6 @@ target_alua_state_check(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-out:
-	if (ret > 0) {
-		/*
-		 * Set SCSI additional sense code (ASC) to 'LUN Not Accessible';
-		 * The ALUA additional sense code qualifier (ASCQ) is determined
-		 * by the ALUA primary or secondary access state..
-		 */
-		pr_debug("[%s]: ALUA TG Port not available, "
-			"SenseKey: NOT_READY, ASC/ASCQ: "
-			"0x04/0x%02x\n",
-			cmd->se_tfo->get_fabric_name(), alua_ascq);
-
-		cmd->scsi_asc = 0x04;
-		cmd->scsi_ascq = alua_ascq;
-		return TCM_CHECK_CONDITION_NOT_READY;
-	}
-
 	return 0;
 }
 
-- 
1.8.5.3


