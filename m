Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3LKHLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:11:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:43724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3LKHLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352405"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 00/15] perf, x86: Haswell LBR call stack support
Date: Wed, 11 Dec 2013 15:10:45 +0800
Message-Id: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are executed
the last captured branch record is popped from the on-chip LBR registers.
The LBR call stack facility can help perf to get call chains of progam
without frame pointer. This feature can be disabled/enabled through an
attribute file in the cpu pmu sysfs directory.

The LBR call stack has following known limitations
 - Zero length calls are not filtered out by hardware
 - Exception handing such as setjmp/longjmp will have calls/returns not
   match
 - Pushing different return address onto the stack will have calls/returns
   not match
 - If callstack is deeper than the LBR, only the last entries are captured

Change since previous version
 - split change into more patches
 - introduce context switch callback and use it to flush LBR
 - use the context switch callback to save/restore LBR
 - dynamic allocate memory area for storing LBR stack, always switch the
   memory area during context switch
 - disable this feature by default
