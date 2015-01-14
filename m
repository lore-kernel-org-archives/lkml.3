Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbbANJu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:50:27 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:36425 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbbANJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:50:22 -0500
Date: Wed, 14 Jan 2015 10:50:19 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Cyril Hrubis <chrubis@suse.cz>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
Subject: Should mmap MAP_LOCKED fail if mm_poppulate fails?
Message-ID: <20150114095019.GC4706@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Cyril has encountered one of the LTP tests failing after 3.12 kernel.
To quote him:
"
What the test does is to set memory limit inside of memcg to PAGESIZE by
writing to memory.limit_in_bytes, then runs a subprocess that uses
mmap() with MAP_LOCKED which allocates 2 * PAGESIZE and expects that
it's killed by OOM. This does not happen and the call to mmap() returns
a correct pointer to a memory region, that when accessed finally causes
the OOM.
"

The difference came from the memcg OOM killer rework because OOM killer
is triggered only from the page fault path since 519e52473ebe (mm:
memcg: enable memcg OOM killer only for user faults). The rationale is
described in 3812c8c8f395 (mm: memcg: do not trap chargers with full
callstack on OOM).

This is _not_ the primary _issue_, though. It has just made a long
standing issue more visible, the same is possible even without memcg but
it is much less likely (it might get more visible once we start failing
GFP_KERNEL allocations more often). The primary issue is that mmap
doesn't report a failure if MAP_LOCKED fails to populate the area. Is
this the correct/expected behavior?

The man page says
"
MAP_LOCKED (since Linux 2.5.37)
      Lock the pages of the mapped region into memory in the manner of
      mlock(2).  This flag is ignored in older kernels.
"

and mlock is required to fail if the population fails.
"
       mlock() locks pages in the address range starting at addr and
       continuing for len bytes.  All pages that contain a part of the
       specified address range are guaranteed to be resident in RAM when
       the call returns successfully; the pages are guaranteed to stay
       in RAM until later unlocked.
"

I have checked the history and it seems we never reported an error, at
least not during git era.

FWIW mlock behaves correctly and reports the error to the userspace.

I am not sure this is something to be fixed or rather documented in the
man page. I can imagine users who would prefer ENOMEM rather than seeing
a page fault later on - I would expect RT - but do those run inside memcg
controller or on heavily overcommited systems?

On the other hand the fix sound quite easy, we just have to use
__mm_populate and unmap the area on failure for VM_LOCKED vmas. Maybe
there are some historical reason for not doing that though.

Thanks!
-- 
Michal Hocko
SUSE Labs
