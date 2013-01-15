Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab3AOWgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:36:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:43929 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857Ab3AOWgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 202/221] libceph: avoid using freed osd in __kick_osd_requests()
Date: Tue, 15 Jan 2013 10:52:09 -0800
Message-Id: <20130115185012.619348963@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit 685a7555ca69030739ddb57a47f0ea8ea80196a4)

If an osd has no requests and no linger requests, __reset_osd()
will just remove it with a call to __remove_osd().  That drops
a reference to the osd, and therefore the osd may have been free
by the time __reset_osd() returns.  That function offers no
indication this may have occurred, and as a result the osd will
continue to be used even when it's no longer valid.

Change__reset_osd() so it returns an error (ENODEV) when it
deletes the osd being reset.  And change __kick_osd_requests() so it
returns immediately (before referencing osd again) if __reset_osd()
returns *any* error.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -581,7 +581,7 @@ static void __kick_osd_requests(struct c
 
 	dout("__kick_osd_requests osd%d\n", osd->o_osd);
 	err = __reset_osd(osdc, osd);
-	if (err == -EAGAIN)
+	if (err)
 		return;
 
 	list_for_each_entry(req, &osd->o_requests, r_osd_item) {
@@ -752,6 +752,7 @@ static int __reset_osd(struct ceph_osd_c
 	if (list_empty(&osd->o_requests) &&
 	    list_empty(&osd->o_linger_requests)) {
 		__remove_osd(osdc, osd);
+		ret = -ENODEV;
 	} else if (memcmp(&osdc->osdmap->osd_addr[osd->o_osd],
 			  &osd->o_con.peer_addr,
 			  sizeof(osd->o_con.peer_addr)) == 0 &&


