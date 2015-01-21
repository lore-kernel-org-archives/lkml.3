Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbbAUQyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:54:53 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37326 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbbAUQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:41 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-bc-54bfd8be9100
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v9 16/17] module: fix types of device tables aliases
Date: Wed, 21 Jan 2015 19:51:44 +0300
Message-id: <1421859105-25253-17-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7r7buwPMXi8l8Vi269HbBa/985k
	tZizfg2bxZFr39ktrn97w2jx6eUDRovnDx+yW0x42MZusbK7mc1i+7O3TBYrOx+wWlzeNYfN
	4t6a/6wWN6ddYLFYfOQ2s8W7Z5OZLX5seMzqIOgxf+dHRo+ds+6yeyzYVOqxeM9LJo9NqzrZ
	PDZ9msTu0fX2CpPHiRm/WTyeXJnO5PHx6S0WjxUbTjB79G1ZxejxeZNcAG8Ul01Kak5mWWqR
	vl0CV8apJbeZCh5zVuy4doK1gXEeRxcjJ4eEgIlE96QD7BC2mMSFe+vZuhi5OIQEljJKXN7x
	nhnC6WOSeNn2ihmkik1AT+LfrO1sILaIgILE5t5nrCBFzALnWSSeHzoOlhAWcJFYu2UzC4jN
	IqAqcebCN1YQm1fAXWLtuaNQ6+QkNt5ZARbnBIrPPD+RCWJbE6PE5yPb2SYw8i5gZFjFKJpa
	mlxQnJSea6RXnJhbXJqXrpecn7uJERINX3cwLj1mdYhRgINRiYdXwmd/iBBrYllxZe4hRgkO
	ZiUR3vnXgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYD904/ay3pkOXe/kWic3+cSqO5XH+S+49
	uj7Bac6qvn/nD6pt2jux/UtA2Ov67g0bzA4UeuuxstZwmSl6hFveffiBdbqXuTsz21eTd2L/
	GuS23FE94RG4Mt5Jp2hzgvttQ3kWqcJlgj172xkUT1/i/nyOc4ud/E75BKvMurdq7efaxRpF
	FxspsRRnJBpqMRcVJwIAFYPCWmQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MODULE_DEVICE_TABLE() macro used to create aliases to device tables.
Normally alias should have the same type as aliased symbol.

Device tables are arrays, so they have 'struct type##_device_id[x]'
types. Alias created by MODULE_DEVICE_TABLE() will have non-array type -
	'struct type##_device_id'.

This inconsistency confuses compiler, it could make a wrong
assumption about variable's size which leads KASan to
produce a false positive report about out of bounds access.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index ebfb0e1..54e75a7 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -135,7 +135,7 @@ void trim_init_extable(struct module *m);
 #ifdef MODULE
 /* Creates an alias so file2alias.c can find device table. */
 #define MODULE_DEVICE_TABLE(type, name)					\
-  extern const struct type##_device_id __mod_##type##__##name##_device_table \
+extern typeof(name) __mod_##type##__##name##_device_table \
   __attribute__ ((unused, alias(__stringify(name))))
 #else  /* !MODULE */
 #define MODULE_DEVICE_TABLE(type, name)
-- 
2.2.1

