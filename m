Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbbA2PPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:15:48 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19019 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbbA2PMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:35 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-08-54ca4d50c536
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
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...))
Subject: [PATCH v10 08/17] fs: dcache: manually unpoison dname after allocation
 to shut up kasan's reports
Date: Thu, 29 Jan 2015 18:11:52 +0300
Message-id: <1422544321-24232-9-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xy7oBvqdCDJbMUrbY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0eL5w4fsFhMetrFbrOxuZrPY/uwtk8XKzgesFnv2nmSx
	uLxrDpvFvTX/WS0WH7nNbPHu2WRmi/N/j7Na/NjwmNVByGP+zo+MHjtn3WX3WLCp1GPxnpdM
	HptWdbJ5bPo0id2j6+0VJo8TM36zeDy5Mp3J4+PTWywefVtWMXp83iTnsenJW6YA3igum5TU
	nMyy1CJ9uwSujJebrrAWHOCquHt2D1MD4zmOLkZODgkBE4nbG3cyQthiEhfurWfrYuTiEBJY
	yijRMPckI4TTxySxrPc3G0gVm4CexL9Z28FsEQEFic29z1hBipgFprBKnF7ayQySEBbIkVh1
	9zA7iM0ioCrxq/0AmM0r4CZx+/tGpi5GDqB1chIXPsaDhDkF3CX+3XvMBLGsiVFi49l5bBMY
	eRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImKLzsYFx+zOsQowMGoxMM7c9PJECHW
	xLLiytxDjBIczEoivEstT4UI8aYkVlalFuXHF5XmpBYfYmTi4JRqYFy+zujYq4gpue/Wnv7z
	UUsvIfeX8l2eOfMPN7csfb50/sYjx92lYiLqmlco3v49c6bIheaFLbxqr2bXf55yes30/K8x
	d765zVe0Feg2vXT6mhfXyinZHgKKwa67u29GqHKeLzCT/6R+bFmK1flV92x/nzyrJfxd9AX7
	aa7rdtF6dw/uOpLnXNqrxFKckWioxVxUnAgAwcZEUWgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to manually unpoison rounded up allocation size for dname
to avoid kasan's reports in dentry_string_cmp().
When CONFIG_DCACHE_WORD_ACCESS=y dentry_string_cmp may access
few bytes beyound requested in kmalloc() size.

dentry_string_cmp() relates on that fact that dentry allocated
using kmalloc and kmalloc internally round up allocation size.
So this is not a bug, but this makes kasan to complain about
such accesses.
To avoid such reports we mark rounded up allocation size in
shadow as accessible.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 fs/dcache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 1467ab9..dc400fd 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,6 +38,8 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/kasan.h>
+
 #include "internal.h"
 #include "mount.h"
 
@@ -1539,6 +1541,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 		}
 		atomic_set(&p->u.count, 1);
 		dname = p->name;
+		if (IS_ENABLED(CONFIG_DCACHE_WORD_ACCESS))
+			kasan_unpoison_shadow(dname,
+				round_up(name->len + 1,	sizeof(unsigned long)));
 	} else  {
 		dname = dentry->d_iname;
 	}	
-- 
2.2.2

