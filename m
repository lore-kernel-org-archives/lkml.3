Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031591Ab3HIXEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:04:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:10655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031452Ab3HIXE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="384045634"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
Date: Fri,  9 Aug 2013 16:04:07 -0700
Message-Id: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 user access functions (*_user) were originally very well tuned,
with partial inline code and other optimizations.

Then over time various new checks -- particularly the sleep checks for
a voluntary preempt kernel -- destroyed a lot of the tunings

A typical user access operation is now doing multiple useless
function calls. Also the without force inline gcc's inlining
policy makes it even worse, with adding more unnecessary calls.

Here's a typical example from ftrace:

     10)               |    might_fault() {
     10)               |      _cond_resched() {
     10)               |        should_resched() {
     10)               |          need_resched() {
     10)   0.063 us    |            test_ti_thread_flag();
     10)   0.643 us    |          }
     10)   1.238 us    |        }
     10)   1.845 us    |      }
     10)   2.438 us    |    }

So we spent 2.5us doing nothing (ok it's a bit less without
ftrace, but still pretty bad)

Then in other cases we would have an out of line function,
but would actually do the might_sleep() checks in the inlined
caller. This doesn't make any sense at all.

There were also a few other problems, for example the x86-64 uaccess
code regularly falls back to string functions, even though a simple
mov would be enough. For example every futex access to the lock
variable would actually use string instructions, even though 
it's just 4 bytes.

This patch kit is an attempt to get us back to sane code, 
mostly by doing proper inlining and doing sleep checks in the right
place. Unfortunately I had to add one tree sweep to avoid an nasty
include loop.

It costs a bit of text space, but I think it's worth it
(if only to keep my blood pressure down while reading ftrace logs...)

I haven't done any particular benchmarks, but important low level
functions just ought to be fast.

64bit:
13249492        1881328 1159168 16289988         f890c4 vmlinux-before-uaccess
13260877        1877232 1159168 16297277         f8ad3d vmlinux-uaccess
+ 11k, +0.08%

32bit:
11223248         899512 1916928 14039688         d63a88 vmlinux-before-uaccess
11230358         895416 1916928 14042702         d6464e vmlinux-uaccess
+ 7k, +0.06%

