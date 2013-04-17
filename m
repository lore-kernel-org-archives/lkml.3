Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966295Ab3DQMMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966134Ab3DQMMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:12:41 -0400
Message-ID: <516E918B.3050309@redhat.com>
Date: Wed, 17 Apr 2013 14:11:55 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH] swap: redirty page if page write fails on swap file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since commit 62c230b, swap_writepage() calls direct_IO on swap files.
However, in that case page isn't redirtied if I/O fails, and is therefore
handled afterwards as if it has been successfully written to the swap
file, leading to memory corruption when the page is eventually swapped
back in.
This patch sets the page dirty when direct_IO() fails. It fixes a memory
corruption that happened while using swap-over-NFS.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 mm/page_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..04ca00d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -222,6 +222,8 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
+		} else {
+			set_page_dirty(page);
 		}
 		return ret;
 	}
