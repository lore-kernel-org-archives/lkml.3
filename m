Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaGKKNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:13:39 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:42209 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaGKKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:13:37 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        abbotti@mev.co.uk, dcb314@hotmail.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] drivers/staging/comedi/drivers/ni_atmio16d.c: remove pointless condition
Date: Fri, 11 Jul 2014 13:13:23 +0300
Message-Id: <1405073603-21468-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue was discovered with static analysis and has two instances in
this file. The code looks like this
if (x < 65536000) {
	...
} else if (x < 655360000) {
	...
} else if (x <= 0xffffffff /* 6553600000 */) {
	...
} else if (x <= 0xffffffff /* 65536000000 */) {
	...
}

The meaning of this block is to select appropriate clock frequency for
interval timer basing on "x", which is amount of time.

Notes:
1. That last condition matches previous one - that's the issue.
2. Decimal numbers in comments don't match hex numbers in expressions.
But in first case the numbers have same order, while in the second case
the hex number is the same, and the decimal one is 10 times bigger.
3. Actually type of "x" is "unsigned int", so its exact upper limit is
not obviously known.
4. There's no "else" block.

So it makes sense to make an "else" block from last "else if" case. The
code inside the block seems correct for such usage.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79871
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/staging/comedi/drivers/ni_atmio16d.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 6ad27f5..895b56d 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -338,7 +338,7 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 	} else if (cmd->convert_arg <= 0xffffffff /* 6553600000 */) {
 		base_clock = CLOCK_10_KHZ;
 		timer = cmd->convert_arg / 100000;
-	} else if (cmd->convert_arg <= 0xffffffff /* 65536000000 */) {
+	} else {
 		base_clock = CLOCK_1_KHZ;
 		timer = cmd->convert_arg / 1000000;
 	}
@@ -406,7 +406,7 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 		} else if (cmd->scan_begin_arg < 0xffffffff /* 6553600000 */) {
 			base_clock = CLOCK_10_KHZ;
 			timer = cmd->scan_begin_arg / 100000;
-		} else if (cmd->scan_begin_arg < 0xffffffff /* 65536000000 */) {
+		} else {
 			base_clock = CLOCK_1_KHZ;
 			timer = cmd->scan_begin_arg / 1000000;
 		}
-- 
1.8.3.2

