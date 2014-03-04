Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbaCDVE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:04:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbaCDUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.13 103/172] powerpc/powernv: Fix indirect XSCOM unmangling
Date: Tue,  4 Mar 2014 12:03:07 -0800
Message-Id: <20140304200303.010624424@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit e0cf957614976896111e676e5134ac98ee227d3d upstream.

We need to unmangle the full address, not just the register
number, and we also need to support the real indirect bit
being set for in-kernel uses.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-xscom.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/arch/powerpc/platforms/powernv/opal-xscom.c
+++ b/arch/powerpc/platforms/powernv/opal-xscom.c
@@ -71,11 +71,11 @@ static int opal_xscom_err_xlate(int64_t
 	}
 }
 
-static u64 opal_scom_unmangle(u64 reg)
+static u64 opal_scom_unmangle(u64 addr)
 {
 	/*
 	 * XSCOM indirect addresses have the top bit set. Additionally
-	 * the reset of the top 3 nibbles is always 0.
+	 * the rest of the top 3 nibbles is always 0.
 	 *
 	 * Because the debugfs interface uses signed offsets and shifts
 	 * the address left by 3, we basically cannot use the top 4 bits
@@ -86,10 +86,13 @@ static u64 opal_scom_unmangle(u64 reg)
 	 * conversion here. To leave room for further xscom address
 	 * expansion, we only clear out the top byte
 	 *
+	 * For in-kernel use, we also support the real indirect bit, so
+	 * we test for any of the top 5 bits
+	 *
 	 */
-	if (reg & (1ull << 59))
-		reg = (reg & ~(0xffull << 56)) | (1ull << 63);
-	return reg;
+	if (addr & (0x1full << 59))
+		addr = (addr & ~(0xffull << 56)) | (1ull << 63);
+	return addr;
 }
 
 static int opal_scom_read(scom_map_t map, u64 reg, u64 *value)
@@ -98,8 +101,8 @@ static int opal_scom_read(scom_map_t map
 	int64_t rc;
 	__be64 v;
 
-	reg = opal_scom_unmangle(reg);
-	rc = opal_xscom_read(m->chip, m->addr + reg, (__be64 *)__pa(&v));
+	reg = opal_scom_unmangle(m->addr + reg);
+	rc = opal_xscom_read(m->chip, reg, (__be64 *)__pa(&v));
 	*value = be64_to_cpu(v);
 	return opal_xscom_err_xlate(rc);
 }
@@ -109,8 +112,8 @@ static int opal_scom_write(scom_map_t ma
 	struct opal_scom_map *m = map;
 	int64_t rc;
 
-	reg = opal_scom_unmangle(reg);
-	rc = opal_xscom_write(m->chip, m->addr + reg, value);
+	reg = opal_scom_unmangle(m->addr + reg);
+	rc = opal_xscom_write(m->chip, reg, value);
 	return opal_xscom_err_xlate(rc);
 }
 


