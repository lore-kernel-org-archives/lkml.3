Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbbA2PMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:12:51 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19517 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbbA2PMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:49 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-18-54ca4d5daac0
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
Subject: [PATCH v10 16/17] module: fix types of device tables aliases
Date: Thu, 29 Jan 2015 18:12:00 +0300
Message-id: <1422544321-24232-17-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xy7qxvqdCDPZdNbfY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0eL5w4fsFhMetrFbrOxuZrPY/uwtk8XKzgesFpd3zWGz
	uLfmP6vFzWkXWCwWH7nNbPHu2WRmix8bHrM6CHrM3/mR0WPnrLvsHgs2lXos3vOSyWPTqk42
	j02fJrF7dL29wuRxYsZvFo8nV6YzeXx8eovFY8WGE8wefVtWMXp83iQXwBvFZZOSmpNZllqk
	b5fAldE54xtLwWPOipYFF9kaGOdxdDFyckgImEh8+PiSGcIWk7hwbz1bFyMXh5DAUkaJzz/2
	MEI4fUwSmxovs4JUsQnoSfybtZ0NxBYRUJDY3PuMFaSIWeA8i8TzQ8eBEhwcwgKuEn+XCILU
	sAioStx7e5UFxOYVcJfofjCTFaREQkBO4sLHeJAwJ1D4373HTBC7mhglNp6dxzaBkXcBI8Mq
	RtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJBI+LqDcekxq0OMAhyMSjy8MzadDBFiTSwrrsw9
	xCjBwawkwrvU8lSIEG9KYmVValF+fFFpTmrxIUYmDk6pBka+W05MXZX97BcU11/MiutYLr9/
	1fZz5bdYv71YED1/5t2NPwpcki7Pqn40R/ac24zvHKUbrh2fabM78u6/TrWXmcqTPoclaq2r
	279AM6L4U5hs2c7IWa9XHnPSY/S8Euv1V72+e279sposxu1nec5rSzd/P/B+B28gb7Agj/uN
	u5e4XzpxabkqsRRnJBpqMRcVJwIA7TTj/2ICAAA=
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
index b653d7c..7e3ccd0 100644
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
2.2.2

