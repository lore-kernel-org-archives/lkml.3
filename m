Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbbAUQxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:53:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43526 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbbAUQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:32 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-9e-54bfd8b2f5a0
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
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v9 09/17] kmemleak: disable kasan instrumentation for kmemleak
Date: Wed, 21 Jan 2015 19:51:37 +0300
Message-id: <1421859105-25253-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7qbbuwPMVj0Vsxi269HbBa/985k
	tZizfg2bxZFr39kt3i/rYbS4/u0No8Wnlw8YLZ4/fMhuMeFhG7vFyu5mNovtz94yWazsfMBq
	cXnXHDaLe2v+s1osPnKb2eLds8nMFj82PGZ1EPRYM28No8f8nR8ZPXbOusvusWBTqcfiPS+Z
	PDat6mTz2PRpErtH19srTB4nZvxm8XhyZTqTx8ent1g8+rasYvT4vEkugDeKyyYlNSezLLVI
	3y6BK2Pr3x6WgotcFd/PLGVvYHzA0cXIySEhYCLx4NxBdghbTOLCvfVsXYxcHEICSxklHnSv
	Y4Fw+pgk1p9eD1bFJqAn8W/WdjYQW0RAQWJz7zNWkCJmgcssEmu+fAMrEhbwk1jZ94wRxGYR
	UJXYMvUOmM0r4C7x9M8mRoh1chIb76xgBbE5geIzz09kgtjWxCjx+ch2tgmMvAsYGVYxiqaW
	JhcUJ6XnGuoVJ+YWl+al6yXn525ihETDlx2Mi49ZHWIU4GBU4uGtCN0fIsSaWFZcmXuIUYKD
	WUmEd/51oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG8BlrPnL52zi3Xn6W/zqvzfj8x2rJ516x
	cevOSB4/l/Hi8/lNS/J3NOe9tlDbdU29obeCddvVWB0//6r3qRUVDNMNbYu38h8uzP19cvOe
	eV3LjB9+i5PuaLPcd1l/r9CZhs52kbBbDBfrnp+qmenvxMcfY/fwbm+GGvdE38/3DX2j7No2
	3SlUYinOSDTUYi4qTgQAfWHnc2QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc internally round up allocation size, and kmemleak
uses rounded up size as object's size. This makes kasan
to complain while kmemleak scans memory or calculates of object's
checksum. The simplest solution here is to disable kasan.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 3cda50c..9bda1b3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -98,6 +98,7 @@
 #include <asm/processor.h>
 #include <linux/atomic.h>
 
+#include <linux/kasan.h>
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
@@ -1113,7 +1114,10 @@ static bool update_checksum(struct kmemleak_object *object)
 	if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
 		return false;
 
+	kasan_disable_local();
 	object->checksum = crc32(0, (void *)object->pointer, object->size);
+	kasan_enable_local();
+
 	return object->checksum != old_csum;
 }
 
@@ -1164,7 +1168,9 @@ static void scan_block(void *_start, void *_end,
 						  BYTES_PER_POINTER))
 			continue;
 
+		kasan_disable_local();
 		pointer = *ptr;
+		kasan_enable_local();
 
 		object = find_and_get_object(pointer, 1);
 		if (!object)
-- 
2.2.1

