Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3IIHzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 03:55:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52884 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab3IIHzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 03:55:32 -0400
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        DJ Johnston <dj.johnston@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v4 0/3] random: Account for entropy loss due to overwrites
Date: Mon,  9 Sep 2013 00:54:46 -0700
Message-Id: <1378713289-21617-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

[ Resending due to fumble-fingering vger.kernel.org. Sorry about that. ]

Version 4: my attempt at rebasing this patchset on top of 3.11, with
its changes to use cmpxchg.  I believe my adaptions are correct, but I
have not had the time to test them extensively.

When we write entropy into a non-empty pool, we currently don't
account at all for the fact that we will probabilistically overwrite
some of the entropy in that pool.  This means that unless the pool is
fully empty, we are currently *guaranteed* to overestimate the amount
of entropy in the pool!

This version of the patchset avoids manually duplicating information
by using a macro.  This removes *all* dynamic computation of derived
pool information and replaces them with static information: on just
about every architecture accessing pointer+offset is no more expensive
than just plain pointer, and this lets us get the information we
actually need from the start.

This version of the patchset adds handling of fractional bits, so that
we can continue to add a single bit of entropy without it being
rounded down to zero.  This version has 3 bits of fraction, which
means that with a 4096-bit input pool the multiply still cannot
overflow 32 bits; if we want to add the capability of crediting
fractional bits of entropy, which may be useful in itself, then we
probably need more bits of fraction and would have to use a 64-bit
multiply and shift.
