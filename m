Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaIANNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:13:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39297 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbaIANNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:13:40 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: ni_at_a2150: range check board index
Date: Mon,  1 Sep 2014 14:13:30 +0100
Message-Id: <1409577210-964-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ni_at_a2150" driver determines the board type by calling
`a2150_probe()`.  This reads a register and converts it to a board index
in the range 0 to 3.  However, the board table array it indexes into
(`a2150_boards[]`) only has 2 entries.  Return an error from the
Comedi driver "attach" handler `a2150_attach()` if the probed board
index is beyond the end of the array.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index de67161..32e7bf2 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -705,7 +705,11 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	dev->board_ptr = a2150_boards + a2150_probe(dev);
+	i = a2150_probe(dev);
+	if (i >= ARRAY_SIZE(a2150_boards))
+		return -ENODEV;
+
+	dev->board_ptr = a2150_boards + i;
 	thisboard = comedi_board(dev);
 	dev->board_name = thisboard->name;
 
-- 
2.0.4

