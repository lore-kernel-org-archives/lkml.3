Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3EFUqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:46:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab3EFUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 071/115] swap: redirty page if page write fails on swap file
Date: Mon,  6 May 2013 13:45:07 -0700
Message-Id: <20130506203102.847560149@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Marchand <jmarchan@redhat.com>

commit 2d30d31ea3c5be426ce25607b9bd1835acb85e0a upstream.

Since commit 62c230bc1790 ("mm: add support for a filesystem to activate
swap files and use direct_IO for writing swap pages"), swap_writepage()
calls direct_IO on swap files.  However, in that case the page isn't
redirtied if I/O fails, and is therefore handled afterwards as if it has
been successfully written to the swap file, leading to memory corruption
when the page is eventually swapped back in.

This patch sets the page dirty when direct_IO() fails.  It fixes a
memory corruption that happened while using swap-over-NFS.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -222,6 +222,8 @@ int swap_writepage(struct page *page, st
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
+		} else {
+			set_page_dirty(page);
 		}
 		return ret;
 	}


