Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3LTSFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:05:34 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:43431 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963Ab3LTSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:05:32 -0500
Date: Fri, 20 Dec 2013 12:05:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Chinner <david@fromorbit.com>
cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [fs] inode_lru_isolate(): Move counter increment into spinlock
 section
In-Reply-To: <20131220033502.GF31386@dastard>
Message-ID: <alpine.DEB.2.10.1312201202320.13927@nuc>
References: <00000143072add16-956bfa6c-d7d5-4df9-aabc-05a904a0edc4-000000@email.amazonses.com> <20131219042322.GX31386@dastard> <alpine.DEB.2.10.1312190921450.4238@nuc> <20131220033502.GF31386@dastard>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Dave Chinner wrote:

> If count_vm_events requires irqs to be disabled to behave correctly,
> then putting __count_vm_events under a spin lock is still not irq
> safe. Either way, this isn't in a performance critical path, so I'd
> much prefer the simpler, safer option be used rather than leave a
> landmine for other unsuspecting developers.


Subject: [fs] Use safe counter increment operations

The counter increment in inode_lru_isolate is happening with
preemption on using __count_vm_events making counter
increment races possible.

Use count_vm_events instead.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/fs/inode.c
===================================================================
--- linux.orig/fs/inode.c	2013-12-20 12:02:14.409583380 -0600
+++ linux/fs/inode.c	2013-12-20 12:02:14.409583380 -0600
@@ -722,9 +722,9 @@ inode_lru_isolate(struct list_head *item
 			unsigned long reap;
 			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
 			if (current_is_kswapd())
-				__count_vm_events(KSWAPD_INODESTEAL, reap);
+				count_vm_events(KSWAPD_INODESTEAL, reap);
 			else
-				__count_vm_events(PGINODESTEAL, reap);
+				count_vm_events(PGINODESTEAL, reap);
 			if (current->reclaim_state)
 				current->reclaim_state->reclaimed_slab += reap;
 		}
