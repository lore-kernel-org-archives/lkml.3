Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3FRLyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:54:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab3FRLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 61/93] libceph: always reset osds when kicking
Date: Tue, 18 Jun 2013 12:43:09 +0100
Message-Id: <1371555821-12820-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit e6d50f67a6b1a6252a616e6e629473b5c4277218 upstream.

When ceph_osdc_handle_map() is called to process a new osd map,
kick_requests() is called to ensure all affected requests are
updated if necessary to reflect changes in the osd map.  This
happens in two cases:  whenever an incremental map update is
processed; and when a full map update (or the last one if there is
more than one) gets processed.

In the former case, the kick_requests() call is followed immediately
by a call to reset_changed_osds() to ensure any connections to osds
affected by the map change are reset.  But for full map updates
this isn't done.

Both cases should be doing this osd reset.

Rather than duplicating the reset_changed_osds() call, move it into
the end of kick_requests().

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 60ae916..8e43722 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1300,7 +1300,7 @@ static void reset_changed_osds(struct ceph_osd_client *osdc)
  * Requeue requests whose mapping to an OSD has changed.  If requests map to
  * no osd, request a new map.
  *
- * Caller should hold map_sem for read and request_mutex.
+ * Caller should hold map_sem for read.
  */
 static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 {
@@ -1367,6 +1367,7 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 		dout("%d requests for down osds, need new map\n", needmap);
 		ceph_monc_request_next_osdmap(&osdc->client->monc);
 	}
+	reset_changed_osds(osdc);
 }
 
 
@@ -1423,7 +1424,6 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 				osdc->osdmap = newmap;
 			}
 			kick_requests(osdc, 0);
-			reset_changed_osds(osdc);
 		} else {
 			dout("ignoring incremental map %u len %d\n",
 			     epoch, maplen);
-- 
1.8.1.2

