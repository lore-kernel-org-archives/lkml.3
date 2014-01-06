Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaAFWiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbaAFWiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Greg Farnum <greg@inktank.com>,
        Sage Weil <sage@inktank.com>
Subject: [PATCH 3.12 003/144] ceph: cleanup aborted requests when re-sending requests.
Date: Mon,  6 Jan 2014 14:36:04 -0800
Message-Id: <20140106223745.427212546@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit eb1b8af33c2e42a9a57fc0a7588f4a7b255d2e79 upstream.

Aborted requests usually get cleared when the reply is received.
If MDS crashes, no reply will be received. So we need to cleanup
aborted requests when re-sending requests.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Greg Farnum <greg@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1875,8 +1875,11 @@ static int __do_request(struct ceph_mds_
 	int mds = -1;
 	int err = -EAGAIN;
 
-	if (req->r_err || req->r_got_result)
+	if (req->r_err || req->r_got_result) {
+		if (req->r_aborted)
+			__unregister_request(mdsc, req);
 		goto out;
+	}
 
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {


