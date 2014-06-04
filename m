Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaFEAjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:39:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaFDXVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.14 054/228] dm cache: fix writethrough mode quiescing in cache_map
Date: Wed,  4 Jun 2014 16:21:23 -0700
Message-Id: <20140604232349.804157341@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@redhat.com>

commit 131cd131a9ff63d4b84f3fe15073a2984ac30066 upstream.

Commit 2ee57d58735 ("dm cache: add passthrough mode") inadvertently
removed the deferred set reference that was taken in cache_map()'s
writethrough mode support.  Restore taking this reference.

This issue was found with code inspection.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2506,6 +2506,7 @@ static int cache_map(struct dm_target *t
 
 		} else {
 			inc_hit_counter(cache, bio);
+			pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
 
 			if (bio_data_dir(bio) == WRITE && writethrough_mode(&cache->features) &&
 			    !is_dirty(cache, lookup_result.cblock))


