Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaLIVxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:53:52 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46766 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaLIVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:53:49 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: soc-dapm: Fix comparison of pointers
Date: Tue,  9 Dec 2014 22:53:41 +0100
Message-Id: <1418162021-32229-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idiom 'return a - b;' often used in comparison functions is wrong
unless one is certain the values being compared lie in a sufficiently
small range. In this case dapm_seq_compare would also return 0 if the
->dapm pointers happened to differ by a multiple of 2^32.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

Notes:
    I don't know if the other occurences of the idiom in this function are
    ok; that depends on whether the values always lie in [0, 2^31-1].

 sound/soc/soc-dapm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index c61cb9cedbcd..a894a7c71557 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1255,8 +1255,10 @@ static int dapm_seq_compare(struct snd_soc_dapm_widget *a,
 	}
 	if (a->reg != b->reg)
 		return a->reg - b->reg;
-	if (a->dapm != b->dapm)
-		return (unsigned long)a->dapm - (unsigned long)b->dapm;
+	if (a->dapm < b->dapm)
+		return -1;
+	if (a->dapm > b->dapm)
+		return 1;
 
 	return 0;
 }
-- 
2.1.3

