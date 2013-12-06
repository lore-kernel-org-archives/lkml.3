Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162767Ab3LFNtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:49:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab3LFNCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/272] qeth: avoid buffer overflow in snmp ioctl
Date: Fri,  6 Dec 2013 12:56:46 +0000
Message-Id: <1386334761-25517-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ursula Braun <ursula.braun@de.ibm.com>

commit 6fb392b1a63ae36c31f62bc3fc8630b49d602b62 upstream.

Check user-defined length in snmp ioctl request and allow request
only if it fits into a qeth command buffer.

Signed-off-by: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: Frank Blaschka <frank.blaschka@de.ibm.com>
Reviewed-by: Heiko Carstens <heicars2@linux.vnet.ibm.com>
Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/net/qeth_core_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0a328d0..bd8c09e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4451,7 +4451,7 @@ int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd *cmd;
 	struct qeth_snmp_ureq *ureq;
-	int req_len;
+	unsigned int req_len;
 	struct qeth_arp_query_info qinfo = {0, };
 	int rc = 0;
 
@@ -4467,6 +4467,10 @@ int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	/* skip 4 bytes (data_len struct member) to get req_len */
 	if (copy_from_user(&req_len, udata + sizeof(int), sizeof(int)))
 		return -EFAULT;
+	if (req_len > (QETH_BUFSIZE - IPA_PDU_HEADER_SIZE -
+		       sizeof(struct qeth_ipacmd_hdr) -
+		       sizeof(struct qeth_ipacmd_setadpparms_hdr)))
+		return -EINVAL;
 	ureq = memdup_user(udata, req_len + sizeof(struct qeth_snmp_ureq_hdr));
 	if (IS_ERR(ureq)) {
 		QETH_CARD_TEXT(card, 2, "snmpnome");
-- 
1.8.3.2

