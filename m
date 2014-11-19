Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713AbaKSVFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:05:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567AbaKSVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:05:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>
Subject: [PATCH 3.14 098/122] regmap: fix kernel hang on regmap_bulk_write with zero val_count.
Date: Wed, 19 Nov 2014 12:52:28 -0800
Message-Id: <20141119205212.075616805@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Casasnovas <quentin.casasnovas@oracle.com>

Fixes commit 2f06fa04cf35da5c24481da3ac84a2900d0b99c3 which was an
incorrect backported version of commit
d6b41cb06044a7d895db82bdd54f6e4219970510 upstream.

If val_count is zero we return -EINVAL with map->lock_arg locked, which
will deadlock the kernel next time we try to acquire this lock.

This was introduced by f5942dd ("regmap: fix possible ZERO_SIZE_PTR pointer
dereferencing error.") which improperly back-ported d6b41cb0.

This issue was found during review of Ubuntu Trusty 3.13.0-40.68 kernel to
prepare Ksplice rebootless updates.

Fixes: f5942dd ("regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.")
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1557,8 +1557,10 @@ int regmap_bulk_write(struct regmap *map
 	} else {
 		void *wval;
 
-		if (!val_count)
-			return -EINVAL;
+		if (!val_count) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {


