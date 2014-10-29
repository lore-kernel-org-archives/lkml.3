Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaJ2FfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:35:08 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55024 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaJ2FfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:35:06 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com, minchan@kernel.org,
        iamjoonsoo.kim@lge.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, Gioh Kim <gioh.kim@lge.com>
Subject: [PATCHv2 0/3] staging: ion: enable pool shrinking in page unit
Date: Wed, 29 Oct 2014 14:35:57 +0900
Message-Id: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Current pool shrinking is not page unit, block unit.
But shrinker returns the pool size in page unit,
so it is confused.

And there is no way to control pool size and shrink pool directly.

I have 3 patches like followings.

1. Patch 1/3: make pool be shrinked by page unit
This patch shrinks pool in page unit.

2. Patch 2/3: limit pool size
This patch specifies pool size limit via debugfs.
The default value of limit is 0.
cat /sys/kernel/debug/ion/heaps/system_limit returns 0.
If you want to create 4 pools and limit each pool by 10MB,
you can write 40MB(=41943040) at system_limit debugfs file
like following:
echo 41943040 > /sys/kernel/debug/ion/heaps/system_limit

2. Patch 3/3: enable debugfs to shrink page directly
This patch enables debugfs to specify shrink amount.
For instance, this shrinks all pages in every pool.
echo 0 > /sys/kernel/debug/ion/heaps/system_shrink
And this shrinks 300-pages from entire pool.
echo 30 > /sys/kernel/debug/ion/heaps/system_shrink
It try to shrink high-order pool first because high-order pages is necessary
more than low-order when the system has low memory.

This patchset is based on linux-next-20141023.


Gioh Kim (3):
  staging: ion: shrink page-pool by page unit
  staging: ion: limit pool size
  staging: ion: debugfs to shrink pool

 drivers/staging/android/ion/ion.c             |   62 ++++++++++++++++---------
 drivers/staging/android/ion/ion_page_pool.c   |   32 ++++++++-----
 drivers/staging/android/ion/ion_system_heap.c |   20 ++++++--
 3 files changed, 75 insertions(+), 39 deletions(-)

-- 
1.7.9.5

