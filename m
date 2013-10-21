Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3JUIvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39426 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab3JUIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "majianpeng" <majianpeng@gmail.com>,
        "Sage Weil" <sage@inktank.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.138222653@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 021/149] libceph: unregister request in __map_request
 failed and nofail == false
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 73d9f7eef3d98c3920e144797cc1894c6b005a1e upstream.

For nofail == false request, if __map_request failed, the caller does
cleanup work, like releasing the relative pages.  It doesn't make any sense
to retry this request.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
[bwh: Backported to 3.2: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ceph/osd_client.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1719,6 +1719,8 @@ int ceph_osdc_start_request(struct ceph_
 				dout("osdc_start_request failed map, "
 				     " will retry %lld\n", req->r_tid);
 				rc = 0;
+			} else {
+				__unregister_request(osdc, req);
 			}
 			goto out_unlock;
 		}

