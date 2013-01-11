Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3AKCa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:30:28 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45898 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3AKCaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:30:06 -0500
X-AuditID: 9c930179-b7c7fae00000255c-0e-50ef792a0d6f
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH v2 2/2] Enhance read_block of page_owner.c
Date: Fri, 11 Jan 2013 11:30:01 +0900
Message-Id: <1357871401-7075-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357871401-7075-1-git-send-email-minchan@kernel.org>
References: <1357871401-7075-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read_block reads char one by one until meeting two newline.
It's not good for the performance and current code isn't good shape
for readability.

This patch enhances speed and clean up.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Alexander Nyberg <alexn@dsv.su.se>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/page_owner.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/Documentation/page_owner.c b/Documentation/page_owner.c
index 43dde96..96bf481 100644
--- a/Documentation/page_owner.c
+++ b/Documentation/page_owner.c
@@ -28,26 +28,17 @@ static int max_size;
 
 struct block_list *block_head;
 
-int read_block(char *buf, FILE *fin)
+int read_block(char *buf, int buf_size, FILE *fin)
 {
-	int ret = 0;
-	int hit = 0;
-	int val;
-	char *curr = buf;
-
-	for (;;) {
-		val = getc(fin);
-		if (val == EOF) return -1;
-		*curr = val;
-		ret++;
-		if (*curr == '\n' && hit == 1)
-			return ret - 1;
-		else if (*curr == '\n')
-			hit = 1;
-		else
-			hit = 0;
-		curr++;
+	char *curr = buf, *const buf_end = buf + buf_size;
+
+	while (buf_end - curr > 1 && fgets(curr, buf_end - curr, fin)) {
+		if (*curr == '\n') /* empty line */
+			return curr - buf;
+		curr += strlen(curr);
 	}
+
+	return -1; /* EOF or no space left in buf. */
 }
 
 static int compare_txt(struct block_list *l1, struct block_list *l2)
@@ -84,10 +75,12 @@ static void add_list(char *buf, int len)
 	}
 }
 
+#define BUF_SIZE	1024
+
 int main(int argc, char **argv)
 {
 	FILE *fin, *fout;
-	char buf[1024];
+	char buf[BUF_SIZE];
 	int ret, i, count;
 	struct block_list *list2;
 	struct stat st;
@@ -106,11 +99,10 @@ int main(int argc, char **argv)
 	list = malloc(max_size * sizeof(*list));
 
 	for(;;) {
-		ret = read_block(buf, fin);
+		ret = read_block(buf, BUF_SIZE, fin);
 		if (ret < 0)
 			break;
 
-		buf[ret] = '\0';
 		add_list(buf, ret);
 	}
 
-- 
1.7.9.5

