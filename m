Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab3FRQdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:33:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab3FRQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:39 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 04/48] libceph: must hold mutex for reset_changed_osds()
Date: Tue, 18 Jun 2013 09:17:30 -0700
Message-Id: <20130618161726.536925812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1399,13 +1399,13 @@ static void kick_requests(struct ceph_os
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
 
 


