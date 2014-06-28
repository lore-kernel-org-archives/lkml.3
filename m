Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776AbaF1SDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:03:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbaF1RxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Christophe Vu-Brugier <cvubrugier@yahoo.fr>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 097/139] target: Report correct response length for some commands
Date: Sat, 28 Jun 2014 10:47:38 -0700
Message-Id: <20140628174609.835033480@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_sbc.c       |    4 ++--
 drivers/target/target_core_spc.c       |    9 ++++++---
 drivers/target/target_core_transport.c |   17 +++++++++++++++++
 include/target/target_core_backend.h   |    1 +
 4 files changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -81,7 +81,7 @@ sbc_emulate_readcapacity(struct se_cmd *
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 8);
 	return 0;
 }
 
@@ -137,7 +137,7 @@ sbc_emulate_readcapacity_16(struct se_cm
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 32);
 	return 0;
 }
 
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -721,6 +721,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 	unsigned char *buf;
 	sense_reason_t ret;
 	int p;
+	int len = 0;
 
 	buf = kzalloc(SE_INQUIRY_BUF, GFP_KERNEL);
 	if (!buf) {
@@ -742,6 +743,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 
 		ret = spc_emulate_inquiry_std(cmd, buf);
+		len = buf[4] + 5;
 		goto out;
 	}
 
@@ -749,6 +751,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		if (cdb[2] == evpd_handlers[p].page) {
 			buf[1] = cdb[2];
 			ret = evpd_handlers[p].emulate(cmd, buf);
+			len = get_unaligned_be16(&buf[2]) + 4;
 			goto out;
 		}
 	}
@@ -765,7 +768,7 @@ out:
 	kfree(buf);
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd_with_length(cmd, GOOD, len);
 	return ret;
 }
 
@@ -1103,7 +1106,7 @@ set_length:
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, length);
 	return 0;
 }
 
@@ -1279,7 +1282,7 @@ done:
 	buf[3] = (lun_count & 0xff);
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, 8 + lun_count * 8);
 	return 0;
 }
 EXPORT_SYMBOL(spc_emulate_report_luns);
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -703,6 +703,23 @@ void target_complete_cmd(struct se_cmd *
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
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -59,6 +59,7 @@ int	transport_subsystem_register(struct
 void	transport_subsystem_release(struct se_subsystem_api *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
+void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 sense_reason_t	spc_parse_cdb(struct se_cmd *cmd, unsigned int *size);
 sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);


