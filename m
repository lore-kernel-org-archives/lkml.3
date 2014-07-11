Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaGKOcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:32:24 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59309 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaGKOcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:32:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
Cc: <gregkh@linuxfoundation.org>, <hsweeten@visionengravers.com>,
        <abbotti@mev.co.uk>, <dcb314@hotmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH v2] From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Date: Fri, 11 Jul 2014 15:32:07 +0100
Message-Id: <1405089127-21646-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405073603-21468-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405073603-21468-1-git-send-email-andrey.krieger.utkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

drivers/staging/comedi/drivers/ni_atmio16d.c: remove pointless condition

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

[ Actually, get rid of the final "else if" case and change the
next-to-last "else if" case to an "else" as the upper limit of "x" _is_
known to be 0xffffffff (UINT_MAX), which is less than 6553600000 -- Ian ]

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79871
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v2: Removed final "else if" block and changed preceding "else if" block
to "else" block as the condition is always true due to limited range of
"unsigned int". -- Ian
---
 drivers/staging/comedi/drivers/ni_atmio16d.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 6ad27f5..b1b4744 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -335,12 +335,9 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 	} else if (cmd->convert_arg < 655360000) {
 		base_clock = CLOCK_100_KHZ;
 		timer = cmd->convert_arg / 10000;
-	} else if (cmd->convert_arg <= 0xffffffff /* 6553600000 */) {
+	} else /* cmd->convert_arg < 6553600000 */ {
 		base_clock = CLOCK_10_KHZ;
 		timer = cmd->convert_arg / 100000;
-	} else if (cmd->convert_arg <= 0xffffffff /* 65536000000 */) {
-		base_clock = CLOCK_1_KHZ;
-		timer = cmd->convert_arg / 1000000;
 	}
 	outw(0xFF03, dev->iobase + AM9513A_COM_REG);
 	outw(base_clock, dev->iobase + AM9513A_DATA_REG);
@@ -403,12 +400,9 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 		} else if (cmd->scan_begin_arg < 655360000) {
 			base_clock = CLOCK_100_KHZ;
 			timer = cmd->scan_begin_arg / 10000;
-		} else if (cmd->scan_begin_arg < 0xffffffff /* 6553600000 */) {
+		} else /* cmd->scan_begin_arg < 6553600000 */ {
 			base_clock = CLOCK_10_KHZ;
 			timer = cmd->scan_begin_arg / 100000;
-		} else if (cmd->scan_begin_arg < 0xffffffff /* 65536000000 */) {
-			base_clock = CLOCK_1_KHZ;
-			timer = cmd->scan_begin_arg / 1000000;
 		}
 		outw(0xFF02, dev->iobase + AM9513A_COM_REG);
 		outw(base_clock, dev->iobase + AM9513A_DATA_REG);
-- 
2.0.0

