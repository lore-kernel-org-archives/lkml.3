Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaC1R4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:56:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaC1Raj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Josh Durgin <josh.durgin@inktank.com>
Subject: [PATCH 3.10 06/22] libceph: block I/O when PAUSE or FULL osd map flags are set
Date: Fri, 28 Mar 2014 10:31:58 -0700
Message-Id: <20140328173110.275180456@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit d29adb34a94715174c88ca93e8aba955850c9bde upstream.

The PAUSEWR and PAUSERD flags are meant to stop the cluster from
processing writes and reads, respectively. The FULL flag is set when
the cluster determines that it is out of space, and will no longer
process writes.  PAUSEWR and PAUSERD are purely client-side settings
already implemented in userspace clients. The osd does nothing special
with these flags.

When the FULL flag is set, however, the osd responds to all writes
with -ENOSPC. For cephfs, this makes sense, but for rbd the block
layer translates this into EIO.  If a cluster goes from full to
non-full quickly, a filesystem on top of rbd will not behave well,
since some writes succeed while others get EIO.

Fix this by blocking any writes when the FULL flag is set in the osd
client. This is the same strategy used by userspace, so apply it by
default.  A follow-on patch makes this configurable.

__map_request() is called to re-target osd requests in case the
available osds changed.  Add a paused field to a ceph_osd_request, and
set it whenever an appropriate osd map flag is set.  Avoid queueing
paused requests in __map_request(), but force them to be resent if
they become unpaused.

Also subscribe to the next osd map from the monitor if any of these
flags are set, so paused requests can be unblocked as soon as
possible.

Fixes: http://tracker.ceph.com/issues/6079

Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ceph/osd_client.h |    1 +
 net/ceph/osd_client.c           |   29 +++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -138,6 +138,7 @@ struct ceph_osd_request {
 	__le64           *r_request_pool;
 	void             *r_request_pgid;
 	__le32           *r_request_attempts;
+	bool              r_paused;
 	struct ceph_eversion *r_request_reassert_version;
 
 	int               r_result;
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1225,6 +1225,22 @@ void ceph_osdc_set_request_linger(struct
 EXPORT_SYMBOL(ceph_osdc_set_request_linger);
 
 /*
+ * Returns whether a request should be blocked from being sent
+ * based on the current osdmap and osd_client settings.
+ *
+ * Caller should hold map_sem for read.
+ */
+static bool __req_should_be_paused(struct ceph_osd_client *osdc,
+				   struct ceph_osd_request *req)
+{
+	bool pauserd = ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_PAUSERD);
+	bool pausewr = ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_PAUSEWR) ||
+		ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_FULL);
+	return (req->r_flags & CEPH_OSD_FLAG_READ && pauserd) ||
+		(req->r_flags & CEPH_OSD_FLAG_WRITE && pausewr);
+}
+
+/*
  * Pick an osd (the first 'up' osd in the pg), allocate the osd struct
  * (as needed), and set the request r_osd appropriately.  If there is
  * no up osd, set r_osd to NULL.  Move the request to the appropriate list
@@ -1241,6 +1257,7 @@ static int __map_request(struct ceph_osd
 	int acting[CEPH_PG_MAX_SIZE];
 	int o = -1, num = 0;
 	int err;
+	bool was_paused;
 
 	dout("map_request %p tid %lld\n", req, req->r_tid);
 	err = ceph_calc_ceph_pg(&pgid, req->r_oid, osdc->osdmap,
@@ -1257,12 +1274,18 @@ static int __map_request(struct ceph_osd
 		num = err;
 	}
 
+	was_paused = req->r_paused;
+	req->r_paused = __req_should_be_paused(osdc, req);
+	if (was_paused && !req->r_paused)
+		force_resend = 1;
+
 	if ((!force_resend &&
 	     req->r_osd && req->r_osd->o_osd == o &&
 	     req->r_sent >= req->r_osd->o_incarnation &&
 	     req->r_num_pg_osds == num &&
 	     memcmp(req->r_pg_osds, acting, sizeof(acting[0])*num) == 0) ||
-	    (req->r_osd == NULL && o == -1))
+	    (req->r_osd == NULL && o == -1) ||
+	    req->r_paused)
 		return 0;  /* no change */
 
 	dout("map_request tid %llu pgid %lld.%x osd%d (was osd%d)\n",
@@ -1797,7 +1820,9 @@ done:
 	 * we find out when we are no longer full and stop returning
 	 * ENOSPC.
 	 */
-	if (ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_FULL))
+	if (ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_FULL) ||
+		ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_PAUSERD) ||
+		ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_PAUSEWR))
 		ceph_monc_request_next_osdmap(&osdc->client->monc);
 
 	mutex_lock(&osdc->request_mutex);


