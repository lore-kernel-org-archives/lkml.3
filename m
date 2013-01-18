Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3ARC3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 21:29:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57710 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3ARC3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 21:29:17 -0500
Date: Fri, 18 Jan 2013 13:29:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20130118132904.ec0677175f1191290f060776@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Jan_2013_13_29_04_+1100_PTU7PN/uyATHqqCK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jan_2013_13_29_04_+1100_PTU7PN/uyATHqqCK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/net/wireless/ath/wil6210/wil6210.h:24:0,
                 from drivers/net/wireless/ath/wil6210/main.c:26:
drivers/net/wireless/ath/wil6210/dbg_hexdump.h:21:0: error: "print_hex_dump=
_bytes" redefined [-Werror]
include/linux/printk.h:322:0: note: this is the location of the previous de=
finition

Caused by commit 7a555613eb77 ("dynamic_debug: dynamic hex dump")
interacting with commit 2be7d22f0625 ("wireless: add new wil6210 802.11ad
60GHz driver") that was added to Linus' tree in the last few days.

I have applied the following merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 18 Jan 2013 13:24:32 +1100
Subject: [PATCH] wireless: remove conflicting version of print_hex_dump_byt=
es

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/dbg_hexdump.h b/drivers/net/w=
ireless/ath/wil6210/dbg_hexdump.h
index 6a315ba..e5712f0 100644
--- a/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
+++ b/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
@@ -1,25 +1,15 @@
 #ifndef WIL_DBG_HEXDUMP_H_
 #define WIL_DBG_HEXDUMP_H_
=20
-#if defined(CONFIG_DYNAMIC_DEBUG)
-#define wil_dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
-			     groupsize, buf, len, ascii)	\
-do {								\
-	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,		\
-		__builtin_constant_p(prefix_str) ? prefix_str : "hexdump");\
-	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
-		print_hex_dump(KERN_DEBUG, prefix_str,		\
-			       prefix_type, rowsize, groupsize,	\
-			       buf, len, ascii);		\
-} while (0)
+#include <linux/printk.h>
+#include <linux/dynamic_debug.h>
=20
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define wil_print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
 				 groupsize, buf, len, ascii)		\
-	wil_dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
+	dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
 			     groupsize, buf, len, ascii)
=20
-#define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
-	wil_dynamic_hex_dump(prefix_str, prefix_type, 16, 1, buf, len, true)
 #else /* defined(CONFIG_DYNAMIC_DEBUG) */
 #define wil_print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
 				 groupsize, buf, len, ascii)		\
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__18_Jan_2013_13_29_04_+1100_PTU7PN/uyATHqqCK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ+LNwAAoJEECxmPOUX5FEZAkP/j+9YSfFdwTCD5SZJFhgnPbt
89RvqjZSxCEt0Q49eSI3IxjYlWxNLNI+hb0CBI3jf9JAeV2j0fWfg83HLnbQnR+E
bEHYcPxFq+jR6hbOnVE4+N/ep1Xhztns0vRUwedS/taOsevNvs0YlBQY/Tf7LguZ
BqFT+L3pZBYV2qatSK3xMhcvi8wqrEUW/VQh5yTNlEZEAZoKm1T0wqW9ArfOB9BO
PXmXbGm8jtbr1eXVkf9jpDZR55KDseol209ga72KFfslUZagHcaE/E3pO97TMBri
V0WKcNsfAnNvhcoZGCh9lRL3+SwQcZYfFEJmFeyvjzLfAArVCvDp92cdbCQXrsQj
Ot3SqE6kn2iuM8OCWFfOf3kW+TqQH5FLs9bBgGrWKPq9EwQlWL954qE6Kyxn/UbV
m+kro2A1hybiKGqhZsJxN1daGFoxyR87DZcl94ppzZEPGI9+kSc+8h0T76ltWb3m
V2BuLhzVov42Z9VH48sQFfzJso6+COaswE6wxc21NgQAPI08bgKF42aG2KG4ZnNR
WJR6TtWH7kB2SdOwz5+JP2EwuR/fJPhfXC2rP/rdP/7Crkt+DYXYkSfBx39iJH5h
VkP/SsmuqagfB76pdCwcHaIH7IOOYGRwWiqadwCWE39c0mT4zbBFKO15lbTUjDaw
eHeEtkUUNUbxdUnro2dB
=VaAA
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jan_2013_13_29_04_+1100_PTU7PN/uyATHqqCK--
