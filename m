Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3HPWsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:48:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:19162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab3HPWsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,897,1367996400"; 
   d="scan'208";a="282994844"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, peterz@infradead.org, akpm@linux-foundation.org
Subject: Improve preempt-scheduling and x86 user access v3
Date: Fri, 16 Aug 2013 14:17:18 -0700
Message-Id: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various optimizations related to CONFIG_PREEMPT_VOLUNTARY
and x86 uaccess

- Optimize copy_*_inatomic on x86-64 to handle 1-8 bytes 
without string instructions
- Inline might_sleep and other preempt code 
to optimize various preemption paths
This costs about 10k text size, but generates far better code
with less unnecessary function calls.

This patch kit is an attempt to get us back to sane code, 
mostly by doing proper inlining and doing sleep checks in the right
place. Unfortunately I had to add one tree sweep to avoid an nasty
include loop.

Unfortunately some of the inlining requires a tree sweep
for moving might_sleep and friends to sched.h

v2: Now completely remove reschedule checks for uaccess functions.
v3: Drop unnecessary changes (thanks Michael).
Now it only optimized copy_*_inatomic and inlines might_sleep()
