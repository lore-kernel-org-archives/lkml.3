Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaICWGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:06:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397AbaICWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kinglong Mee <kinglongmee@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.10 51/55] NFSD: Decrease nfsd_users in nfsd_startup_generic fail
Date: Wed,  3 Sep 2014 15:05:41 -0700
Message-Id: <20140903220502.099062426@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfssvc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -220,7 +220,8 @@ static int nfsd_startup_generic(int nrse
 	 */
 	ret = nfsd_racache_init(2*nrservs);
 	if (ret)
-		return ret;
+		goto dec_users;
+
 	ret = nfs4_state_start();
 	if (ret)
 		goto out_racache;
@@ -228,6 +229,8 @@ static int nfsd_startup_generic(int nrse
 
 out_racache:
 	nfsd_racache_shutdown();
+dec_users:
+	nfsd_users--;
 	return ret;
 }
 


