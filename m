Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3ITUdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:33:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3ITUKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 09/93] libceph: unregister request in __map_request failed and nofail == false
Date: Fri, 20 Sep 2013 13:08:04 -0700
Message-Id: <1379707768-1804-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 73d9f7eef3d98c3920e144797cc1894c6b005a1e upstream.

For nofail == false request, if __map_request failed, the caller does
cleanup work, like releasing the relative pages.  It doesn't make any sense
to retry this request.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/osd_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index a5dfcb8..d62120b 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1723,6 +1723,8 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 				dout("osdc_start_request failed map, "
 				     " will retry %lld\n", req->r_tid);
 				rc = 0;
+			} else {
+				__unregister_request(osdc, req);
 			}
 			goto out_unlock;
 		}
-- 
1.8.1.2

