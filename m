Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935140Ab3IDPGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:06:53 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:58063 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3IDPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:06:51 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r7Rwb0vUtI=
X-RZG-CLASS-ID: mo00
Date: Wed, 4 Sep 2013 17:06:48 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation
 code for util services
Message-ID: <20130904150648.GA9162@aepfle.de>
References: <1372786290-12641-1-git-send-email-kys@microsoft.com>
 <20130904135754.GA2010@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130904135754.GA2010@aepfle.de>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, Olaf Hering wrote:

> I suggest to let callers deal with error handling. Also as a cleanup,
> vmbus_prep_negotiate_resp does not make use of the negop passed to it.
> So that arg can be removed.

Simplify vmbus_prep_negotiate_resp. If we take the optimistic approach
that negotiation will not fail for any of the callers of
vmbus_prep_negotiate_resp this patch on top of yours should fix 2008 and
2012r2.

Olaf

---
 drivers/hv/channel_mgmt.c | 22 +++++++++-------------
 drivers/hv/hv_kvp.c       |  8 ++++----
 drivers/hv/hv_snapshot.c  |  3 +--
 drivers/hv/hv_util.c      |  7 +++----
 include/linux/hyperv.h    |  4 +---
 5 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 12ec8c8..dcaad3e 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -41,7 +41,6 @@ struct vmbus_channel_message_table_entry {
 /**
  * vmbus_prep_negotiate_resp() - Create default response for Hyper-V Negotiate message
  * @icmsghdrp: Pointer to msg header structure
- * @icmsg_negotiate: Pointer to negotiate message structure
  * @buf: Raw buffer channel data
  *
  * @icmsghdrp is of type &struct icmsg_hdr.
@@ -54,10 +53,10 @@ struct vmbus_channel_message_table_entry {
  *
  * Mainly used by Hyper-V drivers.
  */
-bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
-				struct icmsg_negotiate *negop, u8 *buf,
+bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp, u8 *buf,
 				int fw_version, int srv_version)
 {
+	struct icmsg_negotiate *negop;
 	int icframe_major, icframe_minor;
 	int icmsg_major, icmsg_minor;
 	int fw_major, fw_minor;
@@ -65,7 +64,6 @@ bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
 	int i;
 	bool found_match = false;
 
-	icmsghdrp->icmsgsize = 0x10;
 	fw_major = (fw_version >> 16);
 	fw_minor = (fw_version & 0xFFFF);
 
@@ -116,19 +114,17 @@ bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
 	 * version numbers we can support.
 	 */
 
-fw_error:
-	if (!found_match) {
-		negop->icframe_vercnt = 0;
-		negop->icmsg_vercnt = 0;
-	} else {
+	if (found_match) {
+		icmsghdrp->icmsgsize = 0x10;
 		negop->icframe_vercnt = 1;
 		negop->icmsg_vercnt = 1;
+		negop->icversion_data[0].major = icframe_major;
+		negop->icversion_data[0].minor = icframe_minor;
+		negop->icversion_data[1].major = icmsg_major;
+		negop->icversion_data[1].minor = icmsg_minor;
 	}
 
-	negop->icversion_data[0].major = icframe_major;
-	negop->icversion_data[0].minor = icframe_minor;
-	negop->icversion_data[1].major = icmsg_major;
-	negop->icversion_data[1].minor = icmsg_minor;
+fw_error:
 	return found_match;
 }
 
diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 5312720..31e338a 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -584,7 +584,6 @@ void hv_kvp_onchannelcallback(void *context)
 	struct hv_kvp_msg *kvp_msg;
 
 	struct icmsg_hdr *icmsghdrp;
-	struct icmsg_negotiate *negop = NULL;
 
 	if (kvp_transaction.active) {
 		/*
@@ -607,14 +606,15 @@ void hv_kvp_onchannelcallback(void *context)
 			 * We start with win8 version and if the host cannot
 			 * support that we use the previous version.
 			 */
-			if (vmbus_prep_negotiate_resp(icmsghdrp, negop,
+			if (vmbus_prep_negotiate_resp(icmsghdrp,
 				 recv_buffer, UTIL_FW_MAJOR_MINOR,
 				 WIN8_SRV_MAJOR_MINOR))
 				goto done;
 
-			vmbus_prep_negotiate_resp(icmsghdrp, negop,
+			if (vmbus_prep_negotiate_resp(icmsghdrp,
 				 recv_buffer, UTIL_FW_MAJOR_MINOR,
-				 WIN7_SRV_MAJOR_MINOR);
+				 WIN7_SRV_MAJOR_MINOR))
+				goto done;
 
 		} else {
 			kvp_msg = (struct hv_kvp_msg *)&recv_buffer[
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index e4572f3..51e8203 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -170,7 +170,6 @@ void hv_vss_onchannelcallback(void *context)
 
 
 	struct icmsg_hdr *icmsghdrp;
-	struct icmsg_negotiate *negop = NULL;
 
 	if (vss_transaction.active) {
 		/*
@@ -189,7 +188,7 @@ void hv_vss_onchannelcallback(void *context)
 			sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			vmbus_prep_negotiate_resp(icmsghdrp, negop,
+			vmbus_prep_negotiate_resp(icmsghdrp,
 				 recv_buffer, UTIL_FW_MAJOR_MINOR,
 				 VSS_MAJOR_MINOR);
 		} else {
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index c16164d..01d7b17 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -88,7 +88,6 @@ static void shutdown_onchannelcallback(void *context)
 	struct shutdown_msg_data *shutdown_msg;
 
 	struct icmsg_hdr *icmsghdrp;
-	struct icmsg_negotiate *negop = NULL;
 
 	vmbus_recvpacket(channel, shut_txf_buf,
 			 PAGE_SIZE, &recvlen, &requestid);
@@ -98,7 +97,7 @@ static void shutdown_onchannelcallback(void *context)
 			sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			vmbus_prep_negotiate_resp(icmsghdrp, negop,
+			vmbus_prep_negotiate_resp(icmsghdrp,
 					shut_txf_buf, UTIL_FW_MAJOR_MINOR,
 					SHUTDOWN_MAJOR_MINOR);
 		} else {
@@ -225,7 +224,7 @@ static void timesync_onchannelcallback(void *context)
 				sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			vmbus_prep_negotiate_resp(icmsghdrp, NULL, time_txf_buf,
+			vmbus_prep_negotiate_resp(icmsghdrp, time_txf_buf,
 						UTIL_FW_MAJOR_MINOR,
 						TIMESYNCH_MAJOR_MINOR);
 		} else {
@@ -266,7 +265,7 @@ static void heartbeat_onchannelcallback(void *context)
 				sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			vmbus_prep_negotiate_resp(icmsghdrp, NULL,
+			vmbus_prep_negotiate_resp(icmsghdrp,
 				hbeat_txf_buf, UTIL_FW_MAJOR_MINOR,
 				HEARTBEAT_MAJOR_MINOR);
 		} else {
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 4994907..084a858 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1502,9 +1502,7 @@ struct hyperv_service_callback {
 };
 
 #define MAX_SRV_VER	0x7ffffff
-extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *,
-					struct icmsg_negotiate *, u8 *, int,
-					int);
+extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *, u8 *, int, int);
 
 int hv_kvp_init(struct hv_util_service *);
 void hv_kvp_deinit(void);
