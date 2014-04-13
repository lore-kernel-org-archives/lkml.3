Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaDMSqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 14:46:33 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:50755 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaDMSqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:46:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] cifs: Use min_t() when comparing "size_t" and "unsigned long"
Date: Sun, 13 Apr 2014 20:46:21 +0200
Message-Id: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32 bit, size_t is "unsigned int", not "unsigned long", causing the
following warning when comparing with PAGE_SIZE, which is always "unsigned
long":

fs/cifs/file.c: In function ‘cifs_readdata_to_iov’:
fs/cifs/file.c:2757: warning: comparison of distinct pointer types lacks a cast

Introduced by commit 7f25bba819a38ab7310024a9350655f374707e20
("cifs_iovec_read: keep iov_iter between the calls of
cifs_readdata_to_iov()"), which changed the signedness of "remaining"
and the code from min_t() to min().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
PAGE_SIZE should really be size_t, but that would require lots of changes
all over the place.

 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8807442c94dd..8add25538a3b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2754,7 +2754,7 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, struct iov_iter *iter)
 
 	for (i = 0; i < rdata->nr_pages; i++) {
 		struct page *page = rdata->pages[i];
-		size_t copy = min(remaining, PAGE_SIZE);
+		size_t copy = min_t(size_t, remaining, PAGE_SIZE);
 		size_t written = copy_page_to_iter(page, 0, copy, iter);
 		remaining -= written;
 		if (written < copy && iov_iter_count(iter) > 0)
-- 
1.7.9.5

