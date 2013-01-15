Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab3AOXW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:22:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:47237 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800Ab3AOWxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 148/171] libceph: move linger requests sooner in kick_requests()
Date: Tue, 15 Jan 2013 14:45:13 -0800
Message-Id: <20130115224324.027075440@linuxfoundation.org>
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

The kick_requests() function is called by ceph_osdc_handle_map()
when an osd map change has been indicated.  Its purpose is to
re-queue any request whose target osd is different from what it
was when it was originally sent.

It is structured as two loops, one for incomplete but registered
requests, and a second for handling completed linger requests.
As a special case, in the first loop if a request marked to linger
has not yet completed, it is moved from the request list to the
linger list.  This is as a quick and dirty way to have the second
loop handle sending the request along with all the other linger
requests.

Because of the way it's done now, however, this quick and dirty
solution can result in these incomplete linger requests never
getting re-sent as desired.  The problem lies in the fact that
the second loop only arranges for a linger request to be sent
if it appears its target osd has changed.  This is the proper
handling for *completed* linger requests (it avoids issuing
the same linger request twice to the same osd).

But although the linger requests added to the list in the first loop
may have been sent, they have not yet completed, so they need to be
re-sent regardless of whether their target osd has changed.

The first required fix is we need to avoid calling __map_request()
on any incomplete linger request.  Otherwise the subsequent
__map_request() call in the second loop will find the target osd
has not changed and will therefore not re-send the request.

Second, we need to be sure that a sent but incomplete linger request
gets re-sent.  If the target osd is the same with the new osd map as
it was when the request was originally sent, this won't happen.
This can be fixed through careful handling when we move these
requests from the request list to the linger list, by unregistering
the request *before* it is registered as a linger request.  This
works because a side-effect of unregistering the request is to make
the request's r_osd pointer be NULL, and *that* will ensure the
second loop actually re-sends the linger request.

Processing of such a request is done at that point, so continue with
the next one once it's been moved.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
(cherry picked from commit ab60b16d3c31b9bd9fd5b39f97dc42c52a50b67d)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1320,6 +1320,24 @@ static void kick_requests(struct ceph_os
 	for (p = rb_first(&osdc->requests); p; ) {
 		req = rb_entry(p, struct ceph_osd_request, r_node);
 		p = rb_next(p);
+
+		/*
+		 * For linger requests that have not yet been
+		 * registered, move them to the linger list; they'll
+		 * be sent to the osd in the loop below.  Unregister
+		 * the request before re-registering it as a linger
+		 * request to ensure the __map_request() below
+		 * will decide it needs to be sent.
+		 */
+		if (req->r_linger && list_empty(&req->r_linger_item)) {
+			dout("%p tid %llu restart on osd%d\n",
+			     req, req->r_tid,
+			     req->r_osd ? req->r_osd->o_osd : -1);
+			__unregister_request(osdc, req);
+			__register_linger_request(osdc, req);
+			continue;
+		}
+
 		err = __map_request(osdc, req, force_resend);
 		if (err < 0)
 			continue;  /* error */
@@ -1334,17 +1352,6 @@ static void kick_requests(struct ceph_os
 				req->r_flags |= CEPH_OSD_FLAG_RETRY;
 			}
 		}
-		if (req->r_linger && list_empty(&req->r_linger_item)) {
-			/*
-			 * register as a linger so that we will
-			 * re-submit below and get a new tid
-			 */
-			dout("%p tid %llu restart on osd%d\n",
-			     req, req->r_tid,
-			     req->r_osd ? req->r_osd->o_osd : -1);
-			__register_linger_request(osdc, req);
-			__unregister_request(osdc, req);
-		}
 	}
 
 	list_for_each_entry_safe(req, nreq, &osdc->req_linger,
@@ -1352,6 +1359,7 @@ static void kick_requests(struct ceph_os
 		dout("linger req=%p req->r_osd=%p\n", req, req->r_osd);
 
 		err = __map_request(osdc, req, force_resend);
+		dout("__map_request returned %d\n", err);
 		if (err == 0)
 			continue;  /* no change and no osd was specified */
 		if (err < 0)


