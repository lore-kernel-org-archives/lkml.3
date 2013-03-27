Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3C0A0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:26:33 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64720 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3C0A0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:26:32 -0400
Date: Tue, 26 Mar 2013 17:26:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michel Lespinasse <walken@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Revert VM_POPULATE?
Message-ID: <alpine.LNX.2.00.1303261646070.23041@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel, I propose that we revert 3.9-rc1's VM_POPULATE flag - 186930500985
"mm: introduce VM_POPULATE flag to better deal with racy userspace programs".

Konstantin's 3.7 cleanup of VM_flags has left several bits below 32
free, but sooner or later someone will want to come through again and
free some more, and I think VM_POPULATE will be among the first to go.

It just doesn't add much value, and flags a transient condition which
then sticks around indefinitely.  Better we remove it now than later.

You said yourself in the 0/8 or 1/8:
    - Patch 8 is optional to this entire series. It only helps to deal more
      nicely with racy userspace programs that might modify their mappings
      while we're trying to populate them. It adds a new VM_POPULATE flag
      on the mappings we do want to populate, so that if userspace replaces
      them with mappings it doesn't want populated, mm_populate() won't
      populate those replacement mappings.
when you were just testing the waters with 8/8 to see if it was wanted.

I don't see any serious problem with it.  We can probably contrive
a case in which someone mlocks-then-munlocks scattered segments of a
large vma, and the VM_POPULATE flag left behind prevents the segments
from being merged back into a single vma; but that can happen in other
ways, so it doesn't count for much.

(I presume VM_POPULATE is left uncleared, because there could always be
races when it's cleared too soon - if userspace is racing with itself.)

I just don't see VM_POPLULATE solving any real problem: the kernel code
appears to be safe enough without it, and if userspace wishes to play
racing mmap games, oh, just let it.

The original patch appears to revert cleanly, except in mm/mmap.c
where "*populate = true;" has since become "*populate = len;".

Hugh
