Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3LSP0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:26:16 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:49789 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab3LSP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:26:15 -0500
Date: Thu, 19 Dec 2013 09:26:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Chinner <david@fromorbit.com>
cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [fs] inode_lru_isolate(): Move counter increment into spinlock
 section
In-Reply-To: <20131219042322.GX31386@dastard>
Message-ID: <alpine.DEB.2.10.1312190921450.4238@nuc>
References: <00000143072add16-956bfa6c-d7d5-4df9-aabc-05a904a0edc4-000000@email.amazonses.com> <20131219042322.GX31386@dastard>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Dave Chinner wrote:

> On Wed, Dec 18, 2013 at 07:24:46PM +0000, Christoph Lameter wrote:
> > The counter increment in inode_lru_isolate is happening after
> > spinlocks have been dropped with preemption on using __count_vm_events
> > making counter increment races possible.
>
> That's a nasty, undocumented problem that __count_vm_events() has.

AFACIT that is a pretty well established and known issue. It only
affects cases where the fallback code for the counter increments is used.

> Nobody who is modifying the fs/inode.c code is likely to know about
> this, so just moving the code under an unrelated lock is not
> sufficient to prevent this from happening again. Hence I'd prefer
> that you just change it to use count_vm_events() rather than try to
> be tricksy by replacing the landmine in the code that we've already
> stepped on once.

I have a patchset here that is supposed to be merged soon that will detect
these cases.

Moving the code is IMHO the simplest solution. count_vm_events
will have to disable interrupts on platforms that do not support fast RMV
operations otherwise.

