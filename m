Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3LRVY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:24:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3LRVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 091/118] dm thin: re-establish read-only state when switching to fail mode
Date: Wed, 18 Dec 2013 13:12:08 -0800
Message-Id: <20131218211222.031885653@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 5383ef3a929a1366e2ced45cd6d74be7aa2a2281 upstream.

If the thin-pool transitioned to fail mode and the thin-pool's table
were reloaded for some reason: the new table's default pool mode would
be read-write, though it will transition to fail mode during resume.

When the pool mode transitions directly from PM_WRITE to PM_FAIL we need
to re-establish the intermediate read-only state in both the metadata
and persistent-data block manager (as is usually done with the normal
pool mode transition sequence: PM_WRITE -> PM_READ_ONLY -> PM_FAIL).

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1400,6 +1400,7 @@ static void set_pool_mode(struct pool *p
 	case PM_FAIL:
 		DMERR("%s: switching pool to failure mode",
 		      dm_device_name(pool->pool_md));
+		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_fail;
 		pool->process_discard = process_bio_fail;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;


