Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaFEADz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:03:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaFDXW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        qindehua@163.com, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 188/228] dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode
Date: Wed,  4 Jun 2014 16:23:37 -0700
Message-Id: <20140604232354.063461779@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 8d07e8a5f5bc7b90f755d9b427ea930024f4c986 upstream.

Commit 3e1a0699 ("dm thin: fix out of data space handling") introduced
a regression in the metadata commit() method by returning an error if
the pool is in PM_OUT_OF_DATA_SPACE mode.  This oversight caused a thin
device to return errors even if the default queue_if_no_space ENOSPC
handling mode is used.

Fix commit() to only fail if pool is in PM_READ_ONLY or PM_FAIL mode.

Reported-by: qindehua@163.com
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -920,7 +920,7 @@ static int commit(struct pool *pool)
 {
 	int r;
 
-	if (get_pool_mode(pool) != PM_WRITE)
+	if (get_pool_mode(pool) >= PM_READ_ONLY)
 		return -EINVAL;
 
 	r = dm_pool_commit_metadata(pool->pmd);


