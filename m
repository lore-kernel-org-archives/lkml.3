Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaHRDnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 23:43:37 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:60574 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaHRDng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 23:43:36 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: dt2801: change function return type to void
Date: Sun, 17 Aug 2014 22:43:02 -0500
Message-Id: <1408333382-15086-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck was complaining that the variable 'stat' is being reassigned
before the old value is used.  Upon inspection, I found that
dt2801_writecmd() cannot fail, always returns 0, and most callers already
do not bother with assigning its return value anyway, so it makes sense to
just change the return type for this function from int to void, and remove
the two assignments to 'stat'.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/dt2801.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index ad8ba0b..c16d468 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -309,7 +309,7 @@ static int dt2801_wait_for_ready(struct comedi_device *dev)
 	return -ETIME;
 }
 
-static int dt2801_writecmd(struct comedi_device *dev, int command)
+static void dt2801_writecmd(struct comedi_device *dev, int command)
 {
 	int stat;
 
@@ -323,8 +323,6 @@ static int dt2801_writecmd(struct comedi_device *dev, int command)
 	if (!(stat & DT_S_READY))
 		dev_dbg(dev->class_dev, "!ready in %s, ignoring\n", __func__);
 	outb_p(command, dev->iobase + DT2801_CMD);
-
-	return 0;
 }
 
 static int dt2801_reset(struct comedi_device *dev)
@@ -380,7 +378,7 @@ static int probe_number_of_ai_chans(struct comedi_device *dev)
 	int data;
 
 	for (n_chans = 0; n_chans < 16; n_chans++) {
-		stat = dt2801_writecmd(dev, DT_C_READ_ADIM);
+		dt2801_writecmd(dev, DT_C_READ_ADIM);
 		dt2801_writedata(dev, 0);
 		dt2801_writedata(dev, n_chans);
 		stat = dt2801_readdata2(dev, &data);
@@ -451,7 +449,7 @@ static int dt2801_ai_insn_read(struct comedi_device *dev,
 	int i;
 
 	for (i = 0; i < insn->n; i++) {
-		stat = dt2801_writecmd(dev, DT_C_READ_ADIM);
+		dt2801_writecmd(dev, DT_C_READ_ADIM);
 		dt2801_writedata(dev, CR_RANGE(insn->chanspec));
 		dt2801_writedata(dev, CR_CHAN(insn->chanspec));
 		stat = dt2801_readdata2(dev, &d);
-- 
2.0.4

