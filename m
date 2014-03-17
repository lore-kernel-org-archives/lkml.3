Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaCQXgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:36:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:48988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaCQXgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:36:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="500757060"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 0/4] RDSEED support for the Linux kernel
Date: Mon, 17 Mar 2014 16:36:26 -0700
Message-Id: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming Intel silicon adds a new RDSEED instruction.  Whereas RDRAND
returns output from a PRNG, the RDSEED instruction returns fully
conditioned entropy that is suitable for use as seeds to a PRNG.

This patchset adds support for RDSEED in the Linux kernel in three
places:

1. During bootup, use RDSEED to initialize the entropy pool if
   available (we already use RDRAND for this).  We don't add any
   credit at this point, but it will give much better starting point.

2. In the slow path to add_interrupt_randomness, executed once per
   second, we take a single RDSEED sample and mix it into the entropy
   pool, crediting it at 50% of its rated entropy.  This was suggested
   by Linus.

3. If we are about to block on /dev/random due to lack of entropy,
   attempt an "emergency pool refill" using RDSEED.

Changes since version 1:

a. Rebased on top of random.git:dev.
b. Unbreak the PowerPC build (I had managed to miss that PowerPC had
   grown archrandom.h support.)
c. Remove duplicate dummy function definitions in <linux/random.h>.
d. Add a fourth patch containing a microoptimization: avoid the loop
   in arch_random_refill() if arch_get_random_seed*() is unavailable.

Comments are, of course, appreciated.

Ted, if you are OK with this could you add this to random.git:dev so
linux-next can pick it up?

	-hpa
