Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaFDJNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:13:00 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:54265
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbaFDJKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:10:00 -0400
X-IronPort-AV: E=Sophos;i="4.98,972,1392159600"; 
   d="scan'208";a="65385492"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/10] staging: tidspbridge: use safer test on the result of find_first_zero_bit
Date: Wed,  4 Jun 2014 11:07:54 +0200
Message-Id: <1401872880-23685-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
return a larger number than the maximum position argument if that position
is not a multiple of BITS_PER_LONG.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3;
statement S1,S2;
@@

e1 = find_first_zero_bit(e2,e3)
...
if (e1 
- ==
+ >=
  e3)
S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/tidspbridge/rmgr/node.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -935,7 +935,7 @@ int node_connect(struct node_object *nod
 				 node2_type == NODE_DAISSOCKET)) {
 		/* Find available pipe */
 		pipe_id = find_first_zero_bit(hnode_mgr->pipe_map, MAXPIPES);
-		if (pipe_id == MAXPIPES) {
+		if (pipe_id >= MAXPIPES) {
 			status = -ECONNREFUSED;
 			goto out_unlock;
 		}
@@ -1008,7 +1008,7 @@ int node_connect(struct node_object *nod
 			status = -EINVAL;
 			goto out_unlock;
 		}
-		if (chnl_id == CHNL_MAXCHANNELS) {
+		if (chnl_id >= CHNL_MAXCHANNELS) {
 			status = -ECONNREFUSED;
 			goto out_unlock;
 		}

