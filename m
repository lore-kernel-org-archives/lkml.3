Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab3CTJXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:23:25 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:55126 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab3CTJXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:23:19 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 04/30] compat: embrace LINUX_BACKPORT() for v2.6.25
Date: Wed, 20 Mar 2013 02:22:29 -0700
Message-Id: <1363771375-31715-5-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

There is one change needed here to get compilation
working on v2.6.24, strict_strtoull is now being
redefined and because of a change that went into
v2.6.38.4 kstrtoul() was added there and the old
strict_strtoul was made a define from it. To help
aid the older kernels such as 2.6.24 that need
the old strict_strtoul we simply check if strict_strtoull
is defined, then we know you're on >= 2.6.38.4 and
don't need kstrtoul() and friends.

If strict_strtoull ever needs to be backported for
older kernels we'll have to revisit this check.

It is worth documenting here why this change went into
v2.6.38.4 and not the orignal v2.6.38 release, so
the commit is provided.

commit 280a1c38c907ab1e2617bdcef66de6bc70897253
Author: Alexey Dobriyan <adobriyan@gmail.com>

    kstrto*: converting strings to integers done (hopefully) right

    commit 33ee3b2e2eb9b4b6c64dcf9ed66e2ac3124e748c upstream.

    1. simple_strto*() do not contain overflow checks and crufty,
       libc way to indicate failure.
    2. strict_strto*() also do not have overflow checks but the name and
       comments pretend they do.
    3. Both families have only "long long" and "long" variants,
       but users want strtou8()
    4. Both "simple" and "strict" prefixes are wrong:
       Simple doesn't exactly say what's so simple, strict should not exist
       because conversion should be strict by default.

    The solution is to use "k" prefix and add convertors for more types.
    Enter
        kstrtoull()
        kstrtoll()
        kstrtoul()
        kstrtol()
        kstrtouint()
        kstrtoint()

        kstrtou64()
        kstrtos64()
        kstrtou32()
        kstrtos32()
        kstrtou16()
        kstrtos16()
        kstrtou8()
        kstrtos8()

    Include runtime testsuite (somewhat incomplete) as well.

    strict_strto*() become deprecated, stubbed to kstrto*() and
    eventually will be removed altogether.

    Use kstrto*() in code today!

    Note: on some archs _kstrtoul() and _kstrtol() are left in tree, even if
          they'll be unused at runtime. This is temporarily solution,
          because I don't want to hardcode list of archs where these
          functions aren't needed. Current solution with sizeof() and
          __alignof__ at least always works.

    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Tested with ckmake:

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/compat-2.6.25.h |    5 +++++
 include/linux/compat-2.6.39.h |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index 5ca6783..5d4fe38 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -68,6 +68,7 @@ hit:
 }
 
 /* Backports b718989da7 */
+#define pci_enable_device_mem LINUX_BACKPORT(pci_enable_device_mem)
 int __must_check pci_enable_device_mem(struct pci_dev *dev);
 
 /*
@@ -221,7 +222,9 @@ int compat_pm_qos_power_deinit(void);
 #define dev_crit(dev, format, arg...)           \
 	dev_printk(KERN_CRIT , dev , format , ## arg)
 
+#define __dev_addr_sync LINUX_BACKPORT(__dev_addr_sync)
 extern int		__dev_addr_sync(struct dev_addr_list **to, int *to_count, struct dev_addr_list **from, int *from_count);
+#define __dev_addr_unsync LINUX_BACKPORT(__dev_addr_unsync)
 extern void		__dev_addr_unsync(struct dev_addr_list **to, int *to_count, struct dev_addr_list **from, int *from_count);
 
 #define seq_file_net &init_net;
@@ -301,7 +304,9 @@ static inline void led_classdev_unregister_suspended(struct led_classdev *lcd)
  * The following things are out of ./include/linux/kernel.h
  * The new iwlwifi driver is using them.
  */
+#define strict_strtoul LINUX_BACKPORT(strict_strtoul)
 extern int strict_strtoul(const char *, unsigned int, unsigned long *);
+#define strict_strtol LINUX_BACKPORT(strict_strtol)
 extern int strict_strtol(const char *, unsigned int, long *);
 
 #else
diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index 8ff08ba..33db220 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -113,7 +113,7 @@ static inline struct msi_desc *irq_desc_get_msi_desc(struct irq_desc *desc)
  * version included in compat-drivers. We use strict_strtol to check if
  * kstrto* is already available.
  */
-#ifndef strict_strtol
+#ifndef strict_strtoull
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
-- 
1.7.10.4

