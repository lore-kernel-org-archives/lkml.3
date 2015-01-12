Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbbALJT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:19:58 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31738 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbALJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:19:54 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-73-54b391b92d91
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5] kstrdup optimization
Date: Mon, 12 Jan 2015 10:18:38 +0100
Message-id: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t/xK7o7J24OMdjdpmZxa905Vos569ew
	WRy59p3d4vK/NywWZ5veAFm75rBZ3Fvzn9Vi7ZG77BZPJ1xkszj/9zirA5fH/J0fGT02fZrE
	7nHn2h42jxMzfrN4LLmp5tG3ZRWjx+dNch6bnrxlCuCI4rJJSc3JLEst0rdL4MronH2VpWC1
	QMX7zcvYGhg7eLsYOTgkBEwkZsy36WLkBDLFJC7cW8/WxcjFISSwlFHid8ctNpCEkEAfk8Sp
	z+YgNpuApsTfzTfB4iJADR/PXGYGaWAWOMEksf5XIxNIQhio6FrfbzaQBSwCqhJPz+SBhHkF
	nCX2/zjJBLFMTuLkscmsExi5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICa6vOxiX
	HrM6xCjAwajEw2sptTlEiDWxrLgy9xCjBAezkgivaxlQiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A6PZ1/OOBza+NzfdK3ts5YrbXkHybyeXJF3wut9dLfX6gm2u83VjhXu7UlY4hBzmededLrj/
	98abdZNsz07cfLKAOdzlTPOsmJmLXptOXXb/5rqHnW5zliWeT7Xk3H70ucgb7zshR5Kv/Di8
	6t6ij0km7NdfJPo9PXvtzvUzR8QOm+XPZuUQZFnppsRSnJFoqMVcVJwIAAL1yXwMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kstrdup if often used to duplicate strings where neither source neither
destination will be ever modified. In such case we can just reuse the source
instead of duplicating it. The problem is that we must be sure that
the source is non-modifiable and its life-time is long enough.

I suspect the good candidates for such strings are strings located in kernel
.rodata section, they cannot be modifed because the section is read-only and
their life-time is equal to kernel life-time.

This small patchset proposes alternative version of kstrdup - kstrdup_const,
which returns source string if it is located in .rodata otherwise it fallbacks
to kstrdup.
To verify if the source is in .rodata function checks if the address is between
sentinels __start_rodata, __end_rodata. I guess it should work with all
architectures.

The main patch is accompanied by four patches constifying kstrdup for cases
where situtation described above happens frequently.

As I have tested the patchset on mobile platform (exynos4210-trats) it saves
3272 string allocations. Since minimal allocation is 32 or 64 bytes depending
on Kconfig options the patchset saves respectively about 100KB or 200KB of memory.

The patchset is based on 3.19-rc4.

This patchset have been already sent to the list as RFC.
Current version have following changes:
- added missing export,
- added kerneldocs,
- constified kstrdup in VFS devname allocation.

Regards
Andrzej


Andrzej Hajda (5):
  mm/util: add kstrdup_const
  kernfs: convert node name allocation to kstrdup_const
  clk: convert clock name allocations to kstrdup_const
  mm/slab: convert cache name allocations to kstrdup_const
  fs/namespace: convert devname allocation to kstrdup_const

 drivers/clk/clk.c      | 12 ++++++------
 fs/kernfs/dir.c        | 12 ++++++------
 fs/namespace.c         |  6 +++---
 include/linux/string.h |  3 +++
 mm/slab_common.c       |  6 +++---
 mm/util.c              | 38 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 59 insertions(+), 18 deletions(-)

-- 
1.9.1

