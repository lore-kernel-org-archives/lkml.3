Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaBLITT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:19:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50305 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbaBLIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:10 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yan, Zheng" <zheng.z.yan@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sage Weil" <sage@inktank.com>, "Greg Farnum" <greg@inktank.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.290810454@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 28/79] ceph: cleanup aborted requests when re-sending
 requests.
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ceph/mds_client.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index cf1b9e0..cd682f2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1815,8 +1815,11 @@ static int __do_request(struct ceph_mds_client *mdsc,
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

