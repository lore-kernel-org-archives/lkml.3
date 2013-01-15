Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab3AOXWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:22:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:47247 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 149/171] libceph: always reset osds when kicking
Date: Tue, 15 Jan 2013 14:45:14 -0800
Message-Id: <20130115224324.096330138@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

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
(cherry picked from commit e6d50f67a6b1a6252a616e6e629473b5c4277218)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1306,7 +1306,7 @@ static void reset_changed_osds(struct ce
  * Requeue requests whose mapping to an OSD has changed.  If requests map to
  * no osd, request a new map.
  *
- * Caller should hold map_sem for read and request_mutex.
+ * Caller should hold map_sem for read.
  */
 static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 {
@@ -1381,6 +1381,7 @@ static void kick_requests(struct ceph_os
 		dout("%d requests for down osds, need new map\n", needmap);
 		ceph_monc_request_next_osdmap(&osdc->client->monc);
 	}
+	reset_changed_osds(osdc);
 }
 
 
@@ -1437,7 +1438,6 @@ void ceph_osdc_handle_map(struct ceph_os
 				osdc->osdmap = newmap;
 			}
 			kick_requests(osdc, 0);
-			reset_changed_osds(osdc);
 		} else {
 			dout("ignoring incremental map %u len %d\n",
 			     epoch, maplen);


