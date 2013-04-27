Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3D0Wo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 18:44:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52226 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab3D0Woy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 18:44:54 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        DJ Johnston <dj.johnston@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v3 0/3] random: Account for entropy loss due to overwrites
Date: Sat, 27 Apr 2013 15:44:36 -0700
Message-Id: <1367102679-5178-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

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
