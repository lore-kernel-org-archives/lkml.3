Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbaKSU4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:56:01 -0500
Received: from mout.web.de ([212.227.15.3]:65135 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbaKSUz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:55:59 -0500
Message-ID: <546D03BF.7040607@users.sourceforge.net>
Date: Wed, 19 Nov 2014 21:55:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Neil Brown <neilb@suse.de>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] dm: Deletion of unnecessary checks before two function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:N+iEKExMWa6biZhPeJGUaImGYXPN2v/UIb2OhHAwEws5ZJy6gcC
 2iw5CaBhtrlWeyZjpgd4fxbw7uWnekDOthymEdrwNqx3j5mof56C3JqXwnodNFzzzODrJhy
 f0cDX5xysamwvuwEPBYhh6yk8fKo70ZlJYiLV8ueOMEn3DAukhxKSyyBcGDZLVjtNOklKfX
 Gsa7ZSfretbeDYivkRKdw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 21:48:10 +0100

The functions dm_table_destroy() and vfree() perform also input
parameter validation. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-ioctl.c           |  3 +--
 drivers/md/dm-snap-persistent.c | 12 ++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5152142..0b925a4 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1050,8 +1050,7 @@ static int do_resume(struct dm_ioctl *param)
 	 * Since dm_swap_table synchronizes RCU, nobody should be in
 	 * read-side critical section already.
 	 */
-	if (old_map)
-		dm_table_destroy(old_map);
+	dm_table_destroy(old_map);
 
 	if (!r)
 		__dev_status(md, param);
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index d6e8817..4b29bac 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -200,16 +200,13 @@ err_area:
 
 static void free_area(struct pstore *ps)
 {
-	if (ps->area)
-		vfree(ps->area);
+	vfree(ps->area);
 	ps->area = NULL;
 
-	if (ps->zero_area)
-		vfree(ps->zero_area);
+	vfree(ps->zero_area);
 	ps->zero_area = NULL;
 
-	if (ps->header_area)
-		vfree(ps->header_area);
+	vfree(ps->header_area);
 	ps->header_area = NULL;
 }
 
@@ -605,8 +602,7 @@ static void persistent_dtr(struct dm_exception_store *store)
 	free_area(ps);
 
 	/* Allocated in persistent_read_metadata */
-	if (ps->callbacks)
-		vfree(ps->callbacks);
+	vfree(ps->callbacks);
 
 	kfree(ps);
 }
-- 
2.1.3

