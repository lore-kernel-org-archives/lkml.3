Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3AZLpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 06:45:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3AZLps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 06:45:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 11/19] regmap: regmap: avoid spurious warning in regmap_read_debugfs
Date: Sat, 26 Jan 2013 11:45:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <20130126100326.GK30594@opensource.wolfsonmicro.com> <20130126100744.GD23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130126100744.GD23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301261145.36158.arnd@arndb.de>
X-Provags-ID: V02:K0:tXrObEMoDh79Ncb0dyf2QXdAfnd4ts5sBpYacj2FKAW
 cAprf4IqneYuWWrUamU2cB2IDDgmvCqTN5vC24/41DbNBRUpGz
 IxtIZh2CrTWxJ6fgVWQKXJpU9DTruNUqGhC4cNyH/kQV+2mXcf
 SyhiFrGxIjlk96Lk8CDAO3qQc5XipV2CwLBZoSF7wWBcNXnCiW
 T6z2KVUtCWCYvGUpsyDoSasss9CsEJK730U02OJCQkTmqhcwNR
 aDun3BDsJUfGPD0cwHPxWA6Sy+j3Wthvurddzdop14f+19ETDF
 LjuIv6KqenBB7lO/eotWYSER3tT5vBu6L2mVWQPg0JzCQE54+V
 IzfmgaKr7HQXElvd/GMI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

Gcc warns about the case where regmap_read_debugfs tries to walk an
empty map->debugfs_off_cache list, which would results in uninitialized
variable getting returned, if we hadn't checked the same condition
just before that.

After an originally suggested inferior patch from Arnd Bergmann,
this is the solution that Russell King came up with, sidestepping
the problem by merging the error case for an empty list with the
normal path.

Without this patch, building mxs_defconfig results in:

drivers/base/regmap/regmap-debugfs.c: In function 'regmap_read_debugfs':
drivers/base/regmap/regmap-debugfs.c:147:9: : warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Reported-by: Vincent Stehle <v-stehle@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 41b65f6..ef35c25 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -128,10 +128,8 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	 * allocate and we should never be in this code if there are
 	 * no registers at all.
 	 */
-	if (list_empty(&map->debugfs_off_cache)) {
-		WARN_ON(list_empty(&map->debugfs_off_cache));
-		return base;
-	}
+	WARN_ON(list_empty(&map->debugfs_off_cache));
+	ret = base;
 
 	/* Find the relevant block */
 	list_for_each_entry(c, &map->debugfs_off_cache, list) {
