Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3I3K1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:27:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab3I3KMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 056/104] libceph: unregister request in __map_request failed and nofail == false
Date: Mon, 30 Sep 2013 11:10:33 +0100
Message-Id: <1380535881-9239-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 73d9f7eef3d98c3920e144797cc1894c6b005a1e upstream.

For nofail == false request, if __map_request failed, the caller does
cleanup work, like releasing the relative pages.  It doesn't make any sense
to retry this request.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index f181972..a90c575 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1745,6 +1745,8 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 				dout("osdc_start_request failed map, "
 				     " will retry %lld\n", req->r_tid);
 				rc = 0;
+			} else {
+				__unregister_request(osdc, req);
 			}
 			goto out_unlock;
 		}
-- 
1.8.3.2

