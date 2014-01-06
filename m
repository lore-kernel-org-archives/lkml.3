Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710AbaAFXU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:20:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbaAFWlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 071/129] mm: numa: avoid unnecessary work on the failure path
Date: Mon,  6 Jan 2014 14:38:20 -0800
Message-Id: <20140106223901.644775194@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit eb4489f69f224356193364dc2762aa009738ca7f upstream.

If a PMD changes during a THP migration then migration aborts but the
failure path is doing more work than is necessary.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1715,7 +1715,8 @@ int migrate_misplaced_transhuge_page(str
 		putback_lru_page(page);
 		mod_zone_page_state(page_zone(page),
 			 NR_ISOLATED_ANON + page_lru, -HPAGE_PMD_NR);
-		goto out_fail;
+
+		goto out_unlock;
 	}
 
 	/*
@@ -1765,6 +1766,7 @@ out_dropref:
 	set_pmd_at(mm, haddr, pmd, entry);
 	update_mmu_cache_pmd(vma, address, &entry);
 
+out_unlock:
 	unlock_page(page);
 	put_page(page);
 	return 0;


