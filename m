Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaIJJUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:20:34 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:63430 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIJJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:20:32 -0400
From: Dmitry Voytik <voytikd@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] fs: seq_file: optimize seq_pad()
Date: Wed, 10 Sep 2014 13:20:19 +0400
Message-Id: <1410340819-18338-1-git-send-email-voytikd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use seq_putc() instead of seq_printf() in seq_pad() because the
former is faster.

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---
 fs/seq_file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3857b72..fef338e 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -787,8 +787,10 @@ EXPORT_SYMBOL(seq_write);
 void seq_pad(struct seq_file *m, char c)
 {
 	int size = m->pad_until - m->count;
-	if (size > 0)
-		seq_printf(m, "%*s", size, "");
+
+	while (size-- > 0)
+		if (unlikely(seq_putc(m, ' ')))
+			return;
 	if (c)
 		seq_putc(m, c);
 }
-- 
1.9.1

