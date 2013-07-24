Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3GXOZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:25:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45833 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab3GXOGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Jaganath Kanakkassery" <jaganath.k@samsung.com>,
        "Johan Hedberg" <johan.hedberg@intel.com>,
        "Chan-Yeol Park" <chanyeol.park@samsung.com>,
        "Gustavo Padovan" <gustavo.padovan@collabora.co.uk>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.189355690@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [32/85] Bluetooth: Fix invalid length check in l2cap_information_rsp()
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2868,7 +2868,7 @@ static inline int l2cap_information_rsp(
 	struct l2cap_info_rsp *rsp = (struct l2cap_info_rsp *) data;
 	u16 type, result;
 
-	if (cmd_len != sizeof(*rsp))
+	if (cmd_len < sizeof(*rsp))
 		return -EPROTO;
 
 	type   = __le16_to_cpu(rsp->type);

