Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3L2CRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:17:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55690 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858Ab3L2CLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:20 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Heiko Carstens" <heicars2@linux.vnet.ibm.com>,
        "Fabian Yamaguchi" <fabs@goesec.de>,
        "Frank Blaschka" <frank.blaschka@de.ibm.com>,
        "Nico Golde" <nico@ngolde.de>,
        "Ursula Braun" <ursula.braun@de.ibm.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.829171174@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 036/185] qeth: avoid buffer overflow in snmp ioctl
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/net/qeth_core_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4322,7 +4322,7 @@ int qeth_snmp_command(struct qeth_card *
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipa_cmd *cmd;
 	struct qeth_snmp_ureq *ureq;
-	int req_len;
+	unsigned int req_len;
 	struct qeth_arp_query_info qinfo = {0, };
 	int rc = 0;
 
@@ -4338,6 +4338,10 @@ int qeth_snmp_command(struct qeth_card *
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

