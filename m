Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaDAL0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:26:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaDALTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 133/144] libceph: resend all writes after the osdmap loses the full flag
Date: Tue,  1 Apr 2014 12:15:37 +0100
Message-Id: <1396350948-29910-134-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit 9a1ea2dbff11547a8e664f143c1ffefc586a577a upstream.

With the current full handling, there is a race between osds and
clients getting the first map marked full. If the osd wins, it will
return -ENOSPC to any writes, but the client may already have writes
in flight. This results in the client getting the error and
propagating it up the stack. For rbd, the block layer turns this into
EIO, which can cause corruption in filesystems above it.

To avoid this race, osds are being changed to drop writes that came
from clients with an osdmap older than the last osdmap marked full.
In order for this to work, clients must resend all writes after they
encounter a full -> not full transition in the osdmap. osds will wait
for an updated map instead of processing a request from a client with
a newer map, so resent writes will not be dropped by the osd unless
there is another not full -> full transition.

This approach requires both osds and clients to be fixed to avoid the
race. Old clients talking to osds with this fix may hang instead of
returning EIO and potentially corrupting an fs. New clients talking to
old osds have the same behavior as before if they encounter this race.

Fixes: http://tracker.ceph.com/issues/6938

Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index bd87c39..448e9d9 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1629,14 +1629,17 @@ static void reset_changed_osds(struct ceph_osd_client *osdc)
  *
  * Caller should hold map_sem for read.
  */
-static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
+static void kick_requests(struct ceph_osd_client *osdc, bool force_resend,
+			  bool force_resend_writes)
 {
 	struct ceph_osd_request *req, *nreq;
 	struct rb_node *p;
 	int needmap = 0;
 	int err;
+	bool force_resend_req;
 
-	dout("kick_requests %s\n", force_resend ? " (force resend)" : "");
+	dout("kick_requests %s %s\n", force_resend ? " (force resend)" : "",
+		force_resend_writes ? " (force resend writes)" : "");
 	mutex_lock(&osdc->request_mutex);
 	for (p = rb_first(&osdc->requests); p; ) {
 		req = rb_entry(p, struct ceph_osd_request, r_node);
@@ -1661,7 +1664,10 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 			continue;
 		}
 
-		err = __map_request(osdc, req, force_resend);
+		force_resend_req = force_resend ||
+			(force_resend_writes &&
+				req->r_flags & CEPH_OSD_FLAG_WRITE);
+		err = __map_request(osdc, req, force_resend_req);
 		if (err < 0)
 			continue;  /* error */
 		if (req->r_osd == NULL) {
@@ -1681,7 +1687,8 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 				 r_linger_item) {
 		dout("linger req=%p req->r_osd=%p\n", req, req->r_osd);
 
-		err = __map_request(osdc, req, force_resend);
+		err = __map_request(osdc, req,
+				    force_resend || force_resend_writes);
 		dout("__map_request returned %d\n", err);
 		if (err == 0)
 			continue;  /* no change and no osd was specified */
@@ -1723,6 +1730,7 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 	struct ceph_osdmap *newmap = NULL, *oldmap;
 	int err;
 	struct ceph_fsid fsid;
+	bool was_full;
 
 	dout("handle_map have %u\n", osdc->osdmap ? osdc->osdmap->epoch : 0);
 	p = msg->front.iov_base;
@@ -1736,6 +1744,8 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 
 	down_write(&osdc->map_sem);
 
+	was_full = ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_FULL);
+
 	/* incremental maps */
 	ceph_decode_32_safe(&p, end, nr_maps, bad);
 	dout(" %d inc maps\n", nr_maps);
@@ -1760,7 +1770,10 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 				ceph_osdmap_destroy(osdc->osdmap);
 				osdc->osdmap = newmap;
 			}
-			kick_requests(osdc, 0);
+			was_full = was_full ||
+				ceph_osdmap_flag(osdc->osdmap,
+						 CEPH_OSDMAP_FULL);
+			kick_requests(osdc, 0, was_full);
 		} else {
 			dout("ignoring incremental map %u len %d\n",
 			     epoch, maplen);
@@ -1803,7 +1816,10 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 					skipped_map = 1;
 				ceph_osdmap_destroy(oldmap);
 			}
-			kick_requests(osdc, skipped_map);
+			was_full = was_full ||
+				ceph_osdmap_flag(osdc->osdmap,
+						 CEPH_OSDMAP_FULL);
+			kick_requests(osdc, skipped_map, was_full);
 		}
 		p += maplen;
 		nr_maps--;
-- 
1.9.1

