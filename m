Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaFKUqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:46:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:34852 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaFKUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:45:42 -0400
Message-Id: <20140611202744.676528190@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 20:45:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Subject: [patch 0/5] futex: More robustness tweaks
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking for the minimal functional fix for the futex CVE, I
found a few things which can be done simpler and therefor make the
code more robust.

1) UNLOCK_PI

   Change the ordering:
   
   - Lookup waiters first. If waiters exist wake up the top priority
     waiter with all sanity checks applied. That allows us to catch
     manipulation of the user space value.

   - Only if there are no waiters, do the atomic release

2) futex_lock_pi_atomic()

   Its a maze of retry hoops and loops. Reduce it to simple and
   userstandable states.

   That requires to split out the lookup and validation functions from
   lookup_pi_state(), but that turns out to be an overall win on
   readabilty.

The overall cleanup results in less code and 488 bytes text size
reduction on x8664.

Thanks,

	tglx
---
 futex.c |  385 ++++++++++++++++++++++++++++------------------------------------
 1 file changed, 171 insertions(+), 214 deletions(-)

