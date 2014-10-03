Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbaJDAI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:08:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbaJCVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 3.16 237/357] NFC: microread: Potential overflows in microread_target_discovered()
Date: Fri,  3 Oct 2014 14:30:23 -0700
Message-Id: <20141003212940.630688745@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d07f1e8600ccb885c8f4143402b8912f7d827bcb upstream.

Smatch says that skb->data is untrusted so we need to check to make sure
that the memcpy() doesn't overflow.

Fixes: cfad1ba87150 ('NFC: Initial support for Inside Secure microread')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nfc/microread/microread.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -501,9 +501,13 @@ static void microread_target_discovered(
 		targets->sens_res =
 			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A_SAK];
-		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
-		       skb->data[MICROREAD_EMCF_A_LEN]);
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A_LEN];
+		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
+		       targets->nfcid1_len);
 		break;
 	case MICROREAD_GATE_ID_MREAD_ISO_A_3:
 		targets->supported_protocols =
@@ -511,9 +515,13 @@ static void microread_target_discovered(
 		targets->sens_res =
 			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A3_SAK];
-		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A3_UID],
-		       skb->data[MICROREAD_EMCF_A3_LEN]);
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A3_LEN];
+		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A3_UID],
+		       targets->nfcid1_len);
 		break;
 	case MICROREAD_GATE_ID_MREAD_ISO_B:
 		targets->supported_protocols = NFC_PROTO_ISO14443_B_MASK;


