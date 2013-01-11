Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3AKCaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:30:07 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45898 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3AKCaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:30:06 -0500
X-AuditID: 9c930179-b7c7fae00000255c-08-50ef792a7831
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>,
        Michal Nazarewicz <mina86@mina86.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2 1/2] Fix wrong EOF compare
Date: Fri, 11 Jan 2013 11:30:00 +0900
Message-Id: <1357871401-7075-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C standards allows the character type char to be singed or unsinged,
depending on the platform and compiler. Most of systems uses signed char,
but those based on PowerPC and ARM processors typically use unsigned char.
This can lead to unexpected results when the variable is used to compare
with EOF(-1). It happens my ARM system and this patch fixes it.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Alexander Nyberg <alexn@dsv.su.se>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/page_owner.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/page_owner.c b/Documentation/page_owner.c
index f0156e1..43dde96 100644
--- a/Documentation/page_owner.c
+++ b/Documentation/page_owner.c
@@ -32,12 +32,13 @@ int read_block(char *buf, FILE *fin)
 {
 	int ret = 0;
 	int hit = 0;
+	int val;
 	char *curr = buf;
 
 	for (;;) {
-		*curr = getc(fin);
-		if (*curr == EOF) return -1;
-
+		val = getc(fin);
+		if (val == EOF) return -1;
+		*curr = val;
 		ret++;
 		if (*curr == '\n' && hit == 1)
 			return ret - 1;
-- 
1.7.9.5

