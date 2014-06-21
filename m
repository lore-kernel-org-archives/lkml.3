Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbaFUD7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 23:59:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56413 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbaFUD7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 23:59:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ip9qhZOdbBVTEXrLV+vNYErII3DYSr20=
X-DKIM: OpenDKIM Filter v2.0.1 titan BEBAB5951B1
From: Jason Cooper <jason@lakedaemon.net>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] direct-io: squelch maybe-uninitialized warning in do_direct_IO()
Date: Sat, 21 Jun 2014 03:58:59 +0000
Message-Id: <1403323139-12858-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings:

  fs/direct-io.c: In function ‘__blockdev_direct_IO’:
  fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  fs/direct-io.c:913:16: note: ‘to’ was declared here
  fs/direct-io.c:1011:12: warning: ‘from’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  fs/direct-io.c:913:10: note: ‘from’ was declared here

are not necessary because dio_get_page() either fails, or sets both
'from' and 'to'.

Make the compiler happy so we can more easily detect legitimate
warnings.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 fs/direct-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 98040ba388ac..c0a9854d2bc7 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -910,7 +910,8 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
 
 	while (sdio->block_in_file < sdio->final_block_in_request) {
 		struct page *page;
-		size_t from, to;
+		size_t from = 0;
+		size_t to = 0;
 		page = dio_get_page(dio, sdio, &from, &to);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
-- 
2.0.0

