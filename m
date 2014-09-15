Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaIOWMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:12:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaIOWMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kinglong Mee <kinglongmee@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 131/187] NFSD: Decrease nfsd_users in nfsd_startup_generic fail
Date: Mon, 15 Sep 2014 15:09:01 -0700
Message-Id: <1410818997-9432-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kinglong Mee <kinglongmee@gmail.com>

commit d9499a95716db0d4bc9b67e88fd162133e7d6b08 upstream.

A memory allocation failure could cause nfsd_startup_generic to fail, in
which case nfsd_users wouldn't be incorrectly left elevated.

After nfsd restarts nfsd_startup_generic will then succeed without doing
anything--the first consequence is likely nfs4_start_net finding a bad
laundry_wq and crashing.

Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
Fixes: 4539f14981ce "nfsd: replace boolean nfsd_up flag by users counter"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfssvc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 760c85a..4942f43 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -221,7 +221,8 @@ static int nfsd_startup_generic(int nrservs)
 	 */
 	ret = nfsd_racache_init(2*nrservs);
 	if (ret)
-		return ret;
+		goto dec_users;
+
 	ret = nfs4_state_start();
 	if (ret)
 		goto out_racache;
@@ -229,6 +230,8 @@ static int nfsd_startup_generic(int nrservs)
 
 out_racache:
 	nfsd_racache_shutdown();
+dec_users:
+	nfsd_users--;
 	return ret;
 }
 
-- 
1.9.1

