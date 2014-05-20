Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaETDyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:54:02 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42509 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaETDyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:54:00 -0400
From: naota@elisp.net
To: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dm: check era->md is non-NULL before closing it
Date: Tue, 20 May 2014 12:53:56 +0900
Message-ID: <87d2f9ds17.fsf@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In era_ctr(), era->md remain NULL until it's set after metadata_open().
On the other hand, era_destroy() assume era->md is non-NULL and it is
called by era_ctr() before initializing the value.

This patch just checks if era->md is non-NULL.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 drivers/md/dm-era-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 414dad4..ad913cd 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1391,7 +1391,8 @@ static int era_is_congested(struct dm_target_callbacks *cb, int bdi_bits)
 
 static void era_destroy(struct era *era)
 {
-	metadata_close(era->md);
+	if (era->md)
+		metadata_close(era->md);
 
 	if (era->wq)
 		destroy_workqueue(era->wq);
-- 
1.9.2


