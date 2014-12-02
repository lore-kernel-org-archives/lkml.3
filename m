Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaLBKvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:51:43 -0500
Received: from mout.web.de ([212.227.17.11]:60093 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaLBKvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:51:41 -0500
Message-ID: <547D99A3.7070506@users.sourceforge.net>
Date: Tue, 02 Dec 2014 11:51:15 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>, devel@driverdev.osuosl.org,
        HPDD-discuss@lists.01.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] lustre: Deletion of unnecessary checks before three function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:9G7lHeuw8N90G8EwKYNGC2KOGC39ifhpU66jaNzCpExVaTYbq0E
 uYTd3T1oLxAfIhXKfv0Wi2cBsMahe0IM+97d39YbkGlW46gmRWUXjc4a0gMpLzknN9/MrbW
 IC9eeTgNvTK+DW0v86Yw7Ii3W3sPH5zWYYh/81ou17lSmbfVBvE5drexfAT6A4mPrE2PJYi
 kZHIAlL2eoTCi8UZ26ebw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Dec 2014 11:40:33 +0100

The functions free_ll_remote_perm(), free_rmtperm_hash() and iput() test
whether their argument is NULL and then return immediately.
Thus the test around their calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/lustre/lustre/llite/remote_perm.c | 5 ++---
 drivers/staging/lustre/lustre/llite/statahead.c   | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/remote_perm.c b/drivers/staging/lustre/lustre/llite/remote_perm.c
index c05a912..a581826 100644
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c
+++ b/drivers/staging/lustre/lustre/llite/remote_perm.c
@@ -194,7 +194,7 @@ int ll_update_remote_perm(struct inode *inode, struct mdt_remote_perm *perm)
 
 	if (!lli->lli_remote_perms)
 		lli->lli_remote_perms = perm_hash;
-	else if (perm_hash)
+	else
 		free_rmtperm_hash(perm_hash);
 
 	head = lli->lli_remote_perms + remote_perm_hashfunc(perm->rp_uid);
@@ -209,8 +209,7 @@ again:
 			continue;
 		if (tmp->lrp_fsgid != perm->rp_fsgid)
 			continue;
-		if (lrp)
-			free_ll_remote_perm(lrp);
+		free_ll_remote_perm(lrp);
 		lrp = tmp;
 		break;
 	}
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index 227854b..6ad9dd0 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -334,8 +334,7 @@ static void ll_sa_entry_put(struct ll_statahead_info *sai,
 		LASSERT(ll_sa_entry_unhashed(entry));
 
 		ll_sa_entry_cleanup(sai, entry);
-		if (entry->se_inode)
-			iput(entry->se_inode);
+		iput(entry->se_inode);
 
 		OBD_FREE(entry, entry->se_size);
 		atomic_dec(&sai->sai_cache_count);
-- 
2.1.3

