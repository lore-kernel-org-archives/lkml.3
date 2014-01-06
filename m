Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbaAFWtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:49:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbaAFWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.4 03/43] ceph: wake up safe waiters when unregistering request
Date: Mon,  6 Jan 2014 14:39:20 -0800
Message-Id: <20140106223942.357298019@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit fc55d2c9448b34218ca58733a6f51fbede09575b upstream.

We also need to wake up 'safe' waiters if error occurs or request
aborted. Otherwise sync(2)/fsync(2) may hang forever.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -609,6 +609,8 @@ static void __unregister_request(struct
 		req->r_unsafe_dir = NULL;
 	}
 
+	complete_all(&req->r_safe_completion);
+
 	ceph_mdsc_put_request(req);
 }
 
@@ -2132,7 +2134,6 @@ static void handle_reply(struct ceph_mds
 	if (head->safe) {
 		req->r_got_safe = true;
 		__unregister_request(mdsc, req);
-		complete_all(&req->r_safe_completion);
 
 		if (req->r_got_unsafe) {
 			/*


