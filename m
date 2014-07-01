Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaGAB51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:57:27 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:55876 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaGAB50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <1403920822-14488-4-git-send-email-j.glisse@gmail.com>
References: <1403920822-14488-1-git-send-email-j.glisse@gmail.com>
	<1403920822-14488-4-git-send-email-j.glisse@gmail.com>
Date: Mon, 30 Jun 2014 18:57:25 -0700
X-Google-Sender-Auth: ZzjYK2PIluRSuA8nqTuz_Ye4vG8
Message-ID: <CA+55aFxKs=LXNw+eg8JuGSBXpBUcjEu5iLm1gfZ3NSDF=PcmPw@mail.gmail.com>
Subject: Re: [PATCH 3/6] mmu_notifier: add event information to address
 invalidation v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <j.glisse@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Peter Anvin <hpa@zytor.com>,
        peterz@infraread.org, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Jatin Kumar <jakumar@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Duncan Poole <dpoole@nvidia.com>, Oded Gabbay <Oded.Gabbay@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 7:00 PM, Jérôme Glisse <j.glisse@gmail.com> wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
>
> The event information will be useful [...]

That needs to be cleaned up, though.

Why the heck are you making up ew and stupid event types? Now you make
the generic VM code do stupid things like this:

+       if ((vma->vm_flags & VM_READ) && (vma->vm_flags & VM_WRITE))
+               event = MMU_MPROT_RANDW;
+       else if (vma->vm_flags & VM_WRITE)
+               event = MMU_MPROT_WONLY;
+       else if (vma->vm_flags & VM_READ)
+               event = MMU_MPROT_RONLY;

which makes no sense at all. The names are some horrible abortion too
("RANDW"? That sounds like "random write" to me, not "read-and-write",
which is commonly shortened RW or perhaps RDWR. Same foes for
RONLY/WONLY - what kind of crazy names are those?

But more importantly, afaik none of that is needed. Instead, tell us
why you need particular flags, and don't make up crazy names like
this. As far as I can tell, you're already passing in the new
protection information (thanks to passing in the vma), so all those
badly named states you've made up seem to be totally pointless. They
add no actual information, but they *do* add crazy code like the above
to generic code that doesn't even WANT any of this crap. The only
thing this should need is a MMU_MPROT event, and just use that. Then
anybody who wants to look at whether the protections are being changed
to read-only, they can just look at the vma->vm_flags themselves.

So things like this need to be tightened up and made sane before any
chance of merging it.

So NAK NAK NAK in the meantime.

            Linus
