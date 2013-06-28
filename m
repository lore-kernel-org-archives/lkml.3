Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3F1Szy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:55:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41761 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3F1Szw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jaganath Kanakkassery <jaganath.k@samsung.com>,
        Chan-Yeol Park <chanyeol.park@samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 101/105] Bluetooth: Fix invalid length check in l2cap_information_rsp()
Date: Fri, 28 Jun 2013 11:52:03 -0700
Message-Id: <1372445527-24414-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaganath Kanakkassery <jaganath.k@samsung.com>

commit 3f6fa3d489e127ca5a5b298eabac3ff5dbe0e112 upstream.

The length check is invalid since the length varies with type of
info response.

This was introduced by the commit cb3b3152b2f5939d67005cff841a1ca748b19888

Because of this, l2cap info rsp is not handled and command reject is sent.

> ACL data: handle 11 flags 0x02 dlen 16
        L2CAP(s): Info rsp: type 2 result 0
          Extended feature mask 0x00b8
            Enhanced Retransmission mode
            Streaming mode
            FCS Option
            Fixed Channels
< ACL data: handle 11 flags 0x00 dlen 10
        L2CAP(s): Command rej: reason 0
          Command not understood

Signed-off-by: Jaganath Kanakkassery <jaganath.k@samsung.com>
Signed-off-by: Chan-Yeol Park <chanyeol.park@samsung.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9f03abb..e133d58 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4229,7 +4229,7 @@ static inline int l2cap_information_rsp(struct l2cap_conn *conn,
 	struct l2cap_info_rsp *rsp = (struct l2cap_info_rsp *) data;
 	u16 type, result;
 
-	if (cmd_len != sizeof(*rsp))
+	if (cmd_len < sizeof(*rsp))
 		return -EPROTO;
 
 	type   = __le16_to_cpu(rsp->type);
-- 
1.8.1.2

