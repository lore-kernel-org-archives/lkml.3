Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3FKXWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 19:22:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:13532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab3FKXWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 19:22:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,848,1363158000"; 
   d="scan'208";a="351967431"
Message-ID: <51B7B128.60909@intel.com>
Date: Tue, 11 Jun 2013 16:22:16 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan kara <jack@suse.cz>
Subject: ext4 extent status tree LRU locking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a test case which I intended to use to stress the VM a bit.  It
fills memory up with page cache a couple of times.  It essentially runs
30 or so cp's in parallel.

98% of my CPU is system time, and 96% of _that_ is being spent on the
spinlock in ext4_es_lru_add().  I think the LRU list head and its lock
end up being *REALLY* hot cachelines and are *the* bottleneck on this
test.  Note that this is _before_ we go in to reclaim and actually start
calling in to the shrinker.  There is zero memory pressure in this test.

I'm not sure the benefits of having a proper in-order LRU during reclaim
outweigh such a drastic downside for the common case.

Any thoughts?
