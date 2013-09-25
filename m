Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3IYAUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab3IYAUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [ 034/117] regmap: debugfs: Fix continued read from registers file
Date: Tue, 24 Sep 2013 17:18:20 -0700
Message-Id: <20130925001744.576196356@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 26ee47411ae22caa07d3f3b63ca6d097cba6681b upstream.

The regmap_debugfs_get_dump_start() function maps from a file offset to the
register that can be found at that position in the file. This is done using a
look-up table. Commit d6814a7d ("regmap: debugfs: Suppress cache for partial
register files") added a check to bypass the look-up table for partial register
files, since the offsets in that table are only correct for the full register
file. The check incorrectly uses the file offset instead of the register base
address and returns it. This will cause the file offset to be interpreted as a
register address which will result in a incorrect output from the registers file
for all reads except at position 0.

The issue can easily be reproduced by doing small reads the registers file, e.g.
`dd if=registers bs=10 count=5`.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap-debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -85,8 +85,8 @@ static unsigned int regmap_debugfs_get_d
 	unsigned int reg_offset;
 
 	/* Suppress the cache if we're using a subrange */
-	if (from)
-		return from;
+	if (base)
+		return base;
 
 	/*
 	 * If we don't have a cache build one so we don't have to do a


