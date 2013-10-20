Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3JTMOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 08:14:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34493 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3JTMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 08:14:29 -0400
From: Hong Zhiguo <honkiko@gmail.com>
To: tj@kernel.org, vgoyal@redhat.com
Cc: cgroups@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Hong Zhiguo <zhiguohong@tencent.com>
Subject: [PATCH v4 0/2] blk-throttle: simplify logic by token bucket algorithm
Date: Sun, 20 Oct 2013 20:11:10 +0800
Message-Id: <1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20131018155532.GD2277@redhat.com>
References: <20131018155532.GD2277@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Zhiguo <zhiguohong@tencent.com>

Based on the discussion with Vivek, Tejun and Jens.

Patch 1/2 implements basic token bucket rate limiting for blk-throttle.
Patch 2/2 adjusts some behavior for the cases pointed out by Vivek:
	- A huge bio may be allowed immediately after a long time of idle
	- When token is trimmed for above case, should not trim ancestors
	  when bio climbs up, instead, trim ancestors when bio is queued
	  on lowest child group.

Trimming of iops token is not necessary. Since a bio always costs _one_ 
iops token. Trimming it won't change the fact that current iops token is
zero or not.

I renamed "last_dispatch" back to "t_c"(Time Checkpoint, naming from network
code) because now it's not only updated when a bio is dispatched. See patch
2/2.

Thanks Vivek for the ancestor over-trim issue and the proposed solution.
I took another method inspired by Vivek's comments but different. Please
help to review it.

Hong Zhiguo (2):
  blk-throttle: simplify logic by token bucket algorithm
  blk-throttle: trim tokens generated for an idle tree

 block/blk-throttle.c | 321 ++++++++++++++-------------------------------------
 1 file changed, 87 insertions(+), 234 deletions(-)

-- 
1.8.1.2

