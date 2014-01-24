Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaAXFcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:32:12 -0500
Received: from linuxhacker.ru ([217.76.32.60]:44284 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaAXFbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:31:47 -0500
X-Greylist: delayed 2738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 00:31:40 EST
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH 1/5] staging/lustre: fix compile warning with is_vmalloc_addr
Date: Thu, 23 Jan 2014 23:45:04 -0500
Message-Id: <1390538708-4120-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent commit 175f5475fb9c5800319da4e3c4204413d7280f5c
introduced this compile warning (because vaddr is unsigned long),
so add a cast:
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function ‘kiblnd_kvaddr_to_page’:
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:532:2: warning: passing argument 1 of ‘is_vmalloc_addr’ makes pointer from integer without a cast [enabled by default]
  if (is_vmalloc_addr(vaddr)) {
  ^
In file included from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:43:0,
                 from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:41:
include/linux/mm.h:336:59: note: expected ‘const void *’ but argument is of type ‘long unsigned int’
 static inline int is_vmalloc_addr(const void *x)

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
CC: Laura Abbott <lauraa@codeaurora.org>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 9364863..6f58ead 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -529,7 +529,7 @@ kiblnd_kvaddr_to_page (unsigned long vaddr)
 {
 	struct page *page;
 
-	if (is_vmalloc_addr(vaddr)) {
+	if (is_vmalloc_addr((void *)vaddr)) {
 		page = vmalloc_to_page ((void *)vaddr);
 		LASSERT (page != NULL);
 		return page;
-- 
1.8.5.3

