Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbaIZKeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:34:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbaIZJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kinglong Mee <kinglongmee@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/142] NFSD: Decrease nfsd_users in nfsd_startup_generic fail
Date: Fri, 26 Sep 2014 11:43:58 +0200
Message-Id: <a6efb1347048618cf3ef8c3959b732a4b0989749.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kinglong Mee <kinglongmee@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d9499a95716db0d4bc9b67e88fd162133e7d6b08 upstream.

A memory allocation failure could cause nfsd_startup_generic to fail, in
which case nfsd_users wouldn't be incorrectly left elevated.

After nfsd restarts nfsd_startup_generic will then succeed without doing
anything--the first consequence is likely nfs4_start_net finding a bad
laundry_wq and crashing.

Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
Fixes: 4539f14981ce "nfsd: replace boolean nfsd_up flag by users counter"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfssvc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 760c85a6f534..4942f4370f60 100644
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
2.1.0

