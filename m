Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbbAGCoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:44:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966AbbAGCHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 19/52] dm thin: fix inability to discard blocks when in out-of-data-space mode
Date: Tue,  6 Jan 2015 18:06:47 -0800
Message-Id: <20150107020558.262990365@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 45ec9bd0fd7abf8705e7cf12205ff69fe9d51181 upstream.

When the pool was in PM_OUT_OF_SPACE mode its process_prepared_discard
function pointer was incorrectly being set to
process_prepared_discard_passdown rather than process_prepared_discard.

This incorrect function pointer meant the discard was being passed down,
but not effecting the mapping.  As such any discard that was issued, in
an attempt to reclaim blocks, would not successfully free data space.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1592,7 +1592,7 @@ static void set_pool_mode(struct pool *p
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_discard;
 		pool->process_prepared_mapping = process_prepared_mapping;
-		pool->process_prepared_discard = process_prepared_discard_passdown;
+		pool->process_prepared_discard = process_prepared_discard;
 
 		if (!pool->pf.error_if_no_space && no_space_timeout)
 			queue_delayed_work(pool->wq, &pool->no_space_timeout, no_space_timeout);


