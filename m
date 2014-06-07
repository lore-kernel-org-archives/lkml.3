Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaFGCui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 22:50:38 -0400
Received: from ns.horizon.com ([71.41.210.147]:18027 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752526AbaFGCug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 22:50:36 -0400
Date: 6 Jun 2014 22:50:36 -0400
Message-ID: <20140607025036.14266.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, rdunlap@infradead.org, tj@kernel.org
Subject: [PATCH v2 3/3] libata: Use glob_match from lib/glob.c
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20140607024404.13786.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function may be useful for other drivers, so export it.
(Suggested by Tejun Heo.)

Note that I inverted the return value of glob_match; returning
true on match seemed to make more sense.

Signed-off-by: George Spelvin <linux@horizon.com>
---
This is unchanged vrom v1.

 drivers/ata/Kconfig       |  1 +
 drivers/ata/libata-core.c | 72 ++---------------------------------------------
 2 files changed, 4 insertions(+), 69 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 0033fafc..0a5e4556 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -16,6 +16,7 @@ menuconfig ATA
 	depends on BLOCK
 	depends on !(M32R || M68K || S390) || BROKEN
 	select SCSI
+	select GLOB
 	---help---
 	  If you want to use an ATA hard disk, ATA tape drive, ATA CD-ROM or
 	  any other ATA device under Linux, say Y and make sure that you know
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ea83828b..b75695ff 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -59,6 +59,7 @@
 #include <linux/async.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
+#include <linux/glob.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -4250,73 +4251,6 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ }
 };
 
-/**
- *	glob_match - match a text string against a glob-style pattern
- *	@text: the string to be examined
- *	@pattern: the glob-style pattern to be matched against
- *
- *	Either/both of text and pattern can be empty strings.
- *
- *	Match text against a glob-style pattern, with wildcards and simple sets:
- *
- *		?	matches any single character.
- *		*	matches any run of characters.
- *		[xyz]	matches a single character from the set: x, y, or z.
- *		[a-d]	matches a single character from the range: a, b, c, or d.
- *		[a-d0-9] matches a single character from either range.
- *
- *	The special characters ?, [, -, or *, can be matched using a set, eg. [*]
- *	Behaviour with malformed patterns is undefined, though generally reasonable.
- *
- *	Sample patterns:  "SD1?",  "SD1[0-5]",  "*R0",  "SD*1?[012]*xx"
- *
- *	This function uses one level of recursion per '*' in pattern.
- *	Since it calls _nothing_ else, and has _no_ explicit local variables,
- *	this will not cause stack problems for any reasonable use here.
- *
- *	RETURNS:
- *	0 on match, 1 otherwise.
- */
-static int glob_match (const char *text, const char *pattern)
-{
-	do {
-		/* Match single character or a '?' wildcard */
-		if (*text == *pattern || *pattern == '?') {
-			if (!*pattern++)
-				return 0;  /* End of both strings: match */
-		} else {
-			/* Match single char against a '[' bracketed ']' pattern set */
-			if (!*text || *pattern != '[')
-				break;  /* Not a pattern set */
-			while (*++pattern && *pattern != ']' && *text != *pattern) {
-				if (*pattern == '-' && *(pattern - 1) != '[')
-					if (*text > *(pattern - 1) && *text < *(pattern + 1)) {
-						++pattern;
-						break;
-					}
-			}
-			if (!*pattern || *pattern == ']')
-				return 1;  /* No match */
-			while (*pattern && *pattern++ != ']');
-		}
-	} while (*++text && *pattern);
-
-	/* Match any run of chars against a '*' wildcard */
-	if (*pattern == '*') {
-		if (!*++pattern)
-			return 0;  /* Match: avoid recursion at end of pattern */
-		/* Loop to handle additional pattern chars after the wildcard */
-		while (*text) {
-			if (glob_match(text, pattern) == 0)
-				return 0;  /* Remainder matched */
-			++text;  /* Absorb (match) this char and try again */
-		}
-	}
-	if (!*text && !*pattern)
-		return 0;  /* End of both strings: match */
-	return 1;  /* No match */
-}
-
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev)
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
@@ -4327,10 +4261,10 @@ static unsigned long ata_dev_blacklisted(const struct ata_device *dev)
 	ata_id_c_string(dev->id, model_rev, ATA_ID_FW_REV, sizeof(model_rev));
 
 	while (ad->model_num) {
-		if (!glob_match(model_num, ad->model_num)) {
+		if (glob_match(model_num, ad->model_num)) {
 			if (ad->model_rev == NULL)
 				return ad->horkage;
-			if (!glob_match(model_rev, ad->model_rev))
+			if (glob_match(model_rev, ad->model_rev))
 				return ad->horkage;
 		}
 		ad++;
-- 
2.0.0

