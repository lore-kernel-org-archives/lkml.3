Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbaDBQnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbaDBQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:43:40 -0400
Date: Wed, 2 Apr 2014 18:43:24 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Haggai Eran <haggaie@mellanox.com>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Shachar Raindel <raindel@mellanox.com>
Subject: Re: [PATCH] mm/mmu_notifier: restore set_pte_at_notify semantics
Message-ID: <20140402164324.GK1500@redhat.com>
References: <1389778834-21200-1-git-send-email-mike.rapoport@ravellosystems.com>
 <20140122131046.GF14193@redhat.com>
 <52DFCF2B.1010603@mellanox.com>
 <20140330203328.GA4859@gmail.com>
 <533C081D.9050202@mellanox.com>
 <20140402151825.GA3614@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402151825.GA3614@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 02, 2014 at 11:18:27AM -0400, Jerome Glisse wrote:
> This would imply either to scan all mmu_notifier currently register or to
> have a global flags for the mm to know if there is one mmu_notifier without
> change_pte. Moreover this would means that kvm would remain "broken" if one
> of the mmu notifier do not have the change_pte callback.
> 
> Solution i have in mind and is part of a patchset i am working on, just
> involve passing along an enum value to mmu notifier callback. The enum
> value would tell what are the exact event that actually triggered the
> mmu notifier call (vmscan, migrate, ksm, ...). Knowing this kvm could then
> simply ignore invalidate_range_start/end for event it knows it will get
> a change_pte callback.

That sounds similar to adding two new methods companion of change_pte
that if not implemented would fallback into
invalidate_range_start/end? And KVM would implement those as noops? It
would add bytes to the mmu notifer structure but it wouldn't add
branches.

It's not urgent but we clearly need to do something about this, or we
should drop change_pte entirely because currently it does nothing and
it only wastes some CPU cycle.

Removing change_pte these days isn't a showstopper because KVM page
fault become smarter lately. In the old days lack of change_pte would
mean that the guest would break KSM cow if it ever accessed the page
in readonly (sharable) mode. Back then change_pte was a fundamental
optimization to use KSM and to avoid all KSM pages to be cowed
immediately after being merged.

These days reading from guest memory backed by KSM won't break COW
even if the spte isn't already established before the KVM fault fires
on the KSM memory. change_pte these days has only the benefit of
avoiding a vmexit/vmenter cycle after a the KSM merge and one
vmexit/vmenter cyle after a KSM break COW (the event that triggers if
the guest eventually writes to the page).

KSM merge and KSM cows aren't too frequent operations (and they both
have significant cost associated with them) so it's uncertain if it's
worth keeping the change_pte optimization nowadays. Considering it's
already implemented I personally feel it's worth keeping as a
microoptimization because vmexit/vmenter are certainly more expensive
than calling change_pte.

Both what you suggested above (with enum or two new companion methods)
or the other way Haggai suggested (checking if change_pte is
implemented in all registered mmu notifiers) sounds good to me.

Thanks,
Andrea
