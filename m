Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LKREr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:04:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:17786 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3LKREo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:04:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,872,1378882800"; 
   d="scan'208";a="448425447"
Message-ID: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
Subject: Potentially unbounded allocations in seq_read?
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Dec 2013 17:04:41 +0000
Organization: Intel Corporation UK Plc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

It seems that the buffer allocation in seq_read can double in size
indefinitely, at least I've seen that in practice with /proc/<pid>/smaps
(attempting to double m->size to 4M on a read of 1000 bytes). This
produces an ugly WARN_ON_ONCE, which should perhaps be avoided? (given
that it can be triggered by userspace at will)

>From the top comment in seq_file.c one would think that it is a
fundamental limitation of the current code that everything which will be
read (even if in chunks) needs to be in the kernel side buffer at the
same time?

If that is true then only way to fix it would be to completely re-design
the seq_file interface, just silencing the allocation failure with
__GFP_NOWARN perhaps as a temporary measure.

As an alternative, since it does sound a bit pathological, perhaps users
for seq_file who know can be printing out such huge amounts of text
should just use a different (new?) facility?

Thanks,

Tvrtko


