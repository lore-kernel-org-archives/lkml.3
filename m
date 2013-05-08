Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3EHCzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:55:18 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47455 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3EHCzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:55:15 -0400
Subject: [PATCH] powerpc/rtas_flash: Fix validate_flash buffer overflow issue
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org
Date: Wed, 08 May 2013 08:24:47 +0530
Message-ID: <20130508025435.28788.40499.stgit@hegdevasant>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050802-9574-0000-0000-000007C18E59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ibm,validate-flash-image RTAS call output buffer contains 150 - 200
bytes of data on latest system. Presently we have output
buffer size as 64 bytes and we use sprintf to copy data from
RTAS buffer to local buffer. This causes kernel oops (see below
call trace).

This patch increases local buffer size to 256 and also uses
snprintf instead of sprintf to copy data from RTAS buffer.

Kernel call trace :
-------------------
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in: nfs fscache lockd auth_rpcgss nfs_acl sunrpc fuse loop dm_mod ipv6 ipv6_lib usb_storage ehea(X) sr_mod qlge ses cdrom enclosure st be2net sg ext3 jbd mbcache usbhid hid ohci_hcd ehci_hcd usbcore qla2xxx usb_common sd_mod crc_t10dif scsi_dh_hp_sw scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh lpfc scsi_transport_fc scsi_tgt ipr(X) libata scsi_mod
Supported: Yes
NIP: 4520323031333130 LR: 4520323031333130 CTR: 0000000000000000
REGS: c0000001b91779b0 TRAP: 0400   Tainted: G            X  (3.0.13-0.27-ppc64)
MSR: 8000000040009032 <EE,ME,IR,DR>  CR: 44022488  XER: 20000018
TASK = c0000001bca1aba0[4736] 'cat' THREAD: c0000001b9174000 CPU: 36
GPR00: 4520323031333130 c0000001b9177c30 c000000000f87c98 000000000000009b
GPR04: c0000001b9177c4a 000000000000000b 3520323031333130 2032303133313031
GPR08: 3133313031350a4d 000000000000009b 0000000000000000 c0000000003664a4
GPR12: 0000000022022448 c000000003ee6c00 0000000000000002 00000000100e8a90
GPR16: 00000000100cb9d8 0000000010093370 000000001001d310 0000000000000000
GPR20: 0000000000008000 00000000100fae60 000000000000005e 0000000000000000
GPR24: 0000000010129350 46573738302e3030 2046573738302e30 300a4d4720323031
GPR28: 333130313520554e 4b4e4f574e0a4d47 2032303133313031 3520323031333130
NIP [4520323031333130] 0x4520323031333130
LR [4520323031333130] 0x4520323031333130
Call Trace:
[c0000001b9177c30] [4520323031333130] 0x4520323031333130 (unreliable)
Instruction dump:
XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX


Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/rtas_flash.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 5b30224..2f3cdb0 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -89,6 +89,7 @@
 
 /* Array sizes */
 #define VALIDATE_BUF_SIZE 4096    
+#define VALIDATE_MSG_LEN  256
 #define RTAS_MSG_MAXLEN   64
 
 /* Quirk - RTAS requires 4k list length and block size */
@@ -466,7 +467,7 @@ static void validate_flash(struct rtas_validate_flash_t *args_buf)
 }
 
 static int get_validate_flash_msg(struct rtas_validate_flash_t *args_buf, 
-		                   char *msg)
+		                   char *msg, int msglen)
 {
 	int n;
 
@@ -474,7 +475,8 @@ static int get_validate_flash_msg(struct rtas_validate_flash_t *args_buf,
 		n = sprintf(msg, "%d\n", args_buf->update_results);
 		if ((args_buf->update_results >= VALIDATE_CUR_UNKNOWN) ||
 		    (args_buf->update_results == VALIDATE_TMP_UPDATE))
-			n += sprintf(msg + n, "%s\n", args_buf->buf);
+			n += snprintf(msg + n, msglen - n, "%s\n",
+					args_buf->buf);
 	} else {
 		n = sprintf(msg, "%d\n", args_buf->status);
 	}
@@ -486,11 +488,11 @@ static ssize_t validate_flash_read(struct file *file, char __user *buf,
 {
 	struct rtas_validate_flash_t *const args_buf =
 		&rtas_validate_flash_data;
-	char msg[RTAS_MSG_MAXLEN];
+	char msg[VALIDATE_MSG_LEN];
 	int msglen;
 
 	mutex_lock(&rtas_validate_flash_mutex);
-	msglen = get_validate_flash_msg(args_buf, msg);
+	msglen = get_validate_flash_msg(args_buf, msg, VALIDATE_MSG_LEN);
 	mutex_unlock(&rtas_validate_flash_mutex);
 
 	return simple_read_from_buffer(buf, count, ppos, msg, msglen);

