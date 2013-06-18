Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3FRLyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:54:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3FRLo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 62/93] libceph: must hold mutex for reset_changed_osds()
Date: Tue, 18 Jun 2013 12:43:10 +0100
Message-Id: <1371555821-12820-63-git-send-email-luis.henriques@canonical.com>
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

commit 14d2f38df67fadee34625fcbd282ee22514c4846 upstream.

An osd client has a red-black tree describing its osds, and
occasionally we would get crashes due to one of these trees tree
becoming corrupt somehow.

The problem turned out to be that reset_changed_osds() was being
called without protection of the osd client request mutex.  That
function would call __reset_osd() for any osd that had changed, and
__reset_osd() would call __remove_osd() for any osd with no
outstanding requests, and finally __remove_osd() would remove the
corresponding entry from the red-black tree.  Thus, the tree was
getting modified without having any lock protection, and was
vulnerable to problems due to concurrent updates.

This appears to be the only osd tree updating path that has this
problem.  It can be fairly easily fixed by moving the call up
a few lines, to just before the request mutex gets dropped
in kick_requests().

This resolves:
    http://tracker.ceph.com/issues/5043

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 8e43722..f181972 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1361,13 +1361,13 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 		__register_request(osdc, req);
 		__unregister_linger_request(osdc, req);
 	}
+	reset_changed_osds(osdc);
 	mutex_unlock(&osdc->request_mutex);
 
 	if (needmap) {
 		dout("%d requests for down osds, need new map\n", needmap);
 		ceph_monc_request_next_osdmap(&osdc->client->monc);
 	}
-	reset_changed_osds(osdc);
 }
 
 
-- 
1.8.1.2

