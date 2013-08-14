Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab3HNAJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:09:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:1248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab3HNAHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,873,1367996400"; 
   d="scan'208";a="386655093"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, torvalds@linux-foundation.org
Subject: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY v2
Date: Tue, 13 Aug 2013 17:07:08 -0700
Message-Id: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
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

v2: Now completely remove reschedule checks for uaccess functions.
