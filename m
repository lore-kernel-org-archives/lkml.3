Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbaGOWHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:07:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbaGOVgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:36:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 129/198] target: Report correct response length for some commands
Date: Tue, 15 Jul 2014 14:29:59 -0700
Message-Id: <1405459868-15089-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 2426bd456a61407388b6e61fc5f98dbcbebc50e2 upstream.

When an initiator sends an allocation length bigger than what its
command consumes, the target should only return the actual response data
and set the residual length to the unused part of the allocation length.

Add a helper function that command handlers (INQUIRY, READ CAPACITY,
etc) can use to do this correctly, and use this code to get the correct
residual for commands that don't use the full initiator allocation in the
handlers for READ CAPACITY, READ CAPACITY(16), INQUIRY, MODE SENSE and
REPORT LUNS.

This addresses a handful of failures as reported by Christophe with
the Windows Certification Kit:

  http://permalink.gmane.org/gmane.linux.scsi.target.devel/6515

Signed-off-by: Roland Dreier <roland@purestorage.com>
Tested-by: Christophe Vu-Brugier <cvubrugier@yahoo.fr>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_sbc.c       |  4 ++--
 drivers/target/target_core_spc.c       |  9 ++++++---
 drivers/target/target_core_transport.c | 17 +++++++++++++++++
 include/target/target_core_backend.h   |  1 +
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index baa8bf4..45d0bc6 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -80,7 +80,7 @@ sbc_emulate_readcapacity(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 8);
 	return 0;
 }
 
@@ -128,7 +128,7 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 32);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 021c3f4..143e75b 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -646,6 +646,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 	unsigned char buf[SE_INQUIRY_BUF];
 	sense_reason_t ret;
 	int p;
+	int len = 0;
 
 	memset(buf, 0, SE_INQUIRY_BUF);
 
@@ -663,6 +664,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 
 		ret = spc_emulate_inquiry_std(cmd, buf);
+		len = buf[4] + 5;
 		goto out;
 	}
 
@@ -670,6 +672,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		if (cdb[2] == evpd_handlers[p].page) {
 			buf[1] = cdb[2];
 			ret = evpd_handlers[p].emulate(cmd, buf);
+			len = get_unaligned_be16(&buf[2]) + 4;
 			goto out;
 		}
 	}
@@ -685,7 +688,7 @@ out:
 	}
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd_with_length(cmd, GOOD, len);
 	return ret;
 }
 
@@ -1003,7 +1006,7 @@ set_length:
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, length);
 	return 0;
 }
 
@@ -1180,7 +1183,7 @@ done:
 	buf[3] = (lun_count & 0xff);
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 8 + lun_count * 8);
 	return 0;
 }
 EXPORT_SYMBOL(spc_emulate_report_luns);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 31adaac..ea545f4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -669,6 +669,23 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
+void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
+{
+	if (scsi_status == SAM_STAT_GOOD && length < cmd->data_length) {
+		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+			cmd->residual_count += cmd->data_length - length;
+		} else {
+			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
+			cmd->residual_count = cmd->data_length - length;
+		}
+
+		cmd->data_length = length;
+	}
+
+	target_complete_cmd(cmd, scsi_status);
+}
+EXPORT_SYMBOL(target_complete_cmd_with_length);
+
 static void target_add_to_state_list(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 39e0114..feacd9b 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -56,6 +56,7 @@ int	transport_subsystem_register(struct se_subsystem_api *);
 void	transport_subsystem_release(struct se_subsystem_api *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
+void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 sense_reason_t	spc_parse_cdb(struct se_cmd *cmd, unsigned int *size);
 sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
-- 
1.9.1

