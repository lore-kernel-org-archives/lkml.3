Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaJCVpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:45:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaJCVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3.16 204/357] regmap: Fix handling of volatile registers for format_write() chips
Date: Fri,  3 Oct 2014 14:29:50 -0700
Message-Id: <20141003212939.666907522@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 5844a8b9d98ec11ce1d77610daacf3f0a0e14715 upstream.

A previous over-zealous factorisation of code means that we only treat
registers as volatile if they are readable. For most devices this is fine
since normally most registers can be read and volatility implies
readability but for format_write() devices where there is no readback from
the hardware and we use volatility to mean simply uncacheability this means
that we end up treating all registers as cacheble.

A bigger refactoring of the code to clarify this is in order but as a fix
make a minimal change and only check readability when checking volatility
if there is no format_write() operation defined for the device.

Signed-off-by: Mark Brown <broonie@linaro.org>
Tested-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -109,7 +109,7 @@ bool regmap_readable(struct regmap *map,
 
 bool regmap_volatile(struct regmap *map, unsigned int reg)
 {
-	if (!regmap_readable(map, reg))
+	if (!map->format.format_write && !regmap_readable(map, reg))
 		return false;
 
 	if (map->volatile_reg)


