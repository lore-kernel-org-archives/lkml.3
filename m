Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbaGEUCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:02:07 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:42267 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751984AbaGEUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:02:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:2915:3138:3139:3140:3141:3142:3353:3865:3867:3868:4321:5007:7652:10004:10400:10848:11026:11658:11914:12114:12296:12517:12519:12555:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: power05_4c2a6361c6a4d
X-Filterd-Recvd-Size: 2346
Message-ID: <1404590522.6384.62.camel@joe-AO725>
Subject: [PATCH] ALSA: hda - Fix and neaten print_nid_path/debug_badness
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 05 Jul 2014 13:02:02 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_nid_path has a possible buffer overflow if
struct nid_path.path values are > 256.

Avoid this and neaten the output to remove the leading ':'

Neaten debug_badness to always verify arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/pci/hda/hda_generic.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 589e47c..b293583 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -350,16 +350,16 @@ static void print_nid_path(struct hda_codec *codec,
 			   const char *pfx, struct nid_path *path)
 {
 	char buf[40];
+	char *pos = buf;
 	int i;
 
+	*pos = 0;
+	for (i = 0; i < path->depth; i++)
+		pos += scnprintf(pos, sizeof(buf) - (pos - buf), "%s%02x",
+				 pos != buf ? ":" : "",
+				 path->path[i]);
 
-	buf[0] = 0;
-	for (i = 0; i < path->depth; i++) {
-		char tmp[4];
-		sprintf(tmp, ":%02x", path->path[i]);
-		strlcat(buf, tmp, sizeof(buf));
-	}
-	codec_dbg(codec, "%s path: depth=%d %s\n", pfx, path->depth, buf);
+	codec_dbg(codec, "%s path: depth=%d '%s'\n", pfx, path->depth, buf);
 }
 
 /* called recursively */
@@ -1700,9 +1700,11 @@ static int fill_and_eval_dacs(struct hda_codec *codec,
 #define DEBUG_BADNESS
 
 #ifdef DEBUG_BADNESS
-#define debug_badness(fmt, args...)	codec_dbg(codec, fmt, ##args)
+#define debug_badness(fmt, ...)						\
+	codec_dbg(codec, fmt, ##__VA_ARGS__)
 #else
-#define debug_badness(...)
+#define debug_badness(fmt, ...)						\
+	do { if (0) codec_dbg(codec, fmt, ##__VA_ARGS__); } while (0)
 #endif
 
 #ifdef DEBUG_BADNESS


