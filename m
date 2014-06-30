Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaF3MaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbaF3MaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 156/181] target: Report correct response length for some commands
Date: Mon, 30 Jun 2014 13:52:57 +0200
Message-Id: <f2ca08d64d1a83e706bebbfd70c8cc51a04362af.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_sbc.c       |  4 ++--
 drivers/target/target_core_spc.c       |  9 ++++++---
 drivers/target/target_core_transport.c | 17 +++++++++++++++++
 include/target/target_core_backend.h   |  1 +
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e84149895af2..214522282c19 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -80,7 +80,7 @@ sbc_emulate_readcapacity(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 8);
 	return 0;
 }
 
@@ -118,7 +118,7 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 32);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 074539558a54..ee400df1fea2 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -639,6 +639,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 	unsigned char buf[SE_INQUIRY_BUF];
 	sense_reason_t ret;
 	int p;
+	int len = 0;
 
 	memset(buf, 0, SE_INQUIRY_BUF);
 
@@ -656,6 +657,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 
 		ret = spc_emulate_inquiry_std(cmd, buf);
+		len = buf[4] + 5;
 		goto out;
 	}
 
@@ -663,6 +665,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		if (cdb[2] == evpd_handlers[p].page) {
 			buf[1] = cdb[2];
 			ret = evpd_handlers[p].emulate(cmd, buf);
+			len = get_unaligned_be16(&buf[2]) + 4;
 			goto out;
 		}
 	}
@@ -678,7 +681,7 @@ out:
 	}
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd_with_length(cmd, GOOD, len);
 	return ret;
 }
 
@@ -996,7 +999,7 @@ set_length:
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, length);
 	return 0;
 }
 
@@ -1173,7 +1176,7 @@ done:
 	buf[3] = (lun_count & 0xff);
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 8 + lun_count * 8);
 	return 0;
 }
 EXPORT_SYMBOL(spc_emulate_report_luns);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 66c0541ee910..334c3364837d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -690,6 +690,23 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
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
index 5ebe21cd5d1c..7eb689ad52a2 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -51,6 +51,7 @@ int	transport_subsystem_register(struct se_subsystem_api *);
 void	transport_subsystem_release(struct se_subsystem_api *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
+void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 sense_reason_t	spc_parse_cdb(struct se_cmd *cmd, unsigned int *size);
 sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
-- 
2.0.0

