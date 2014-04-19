Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaDSVZC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 17:25:02 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62368 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaDSVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 17:24:50 -0400
Date: Sat, 19 Apr 2014 14:23:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Kelley Nielsen <kelleynnn@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] memcg: mm_update_next_owner() should skip kthreads
In-Reply-To: <20140419181407.GB982@redhat.com>
Message-ID: <alpine.LSU.2.11.1404191404510.15123@eggly.anvils>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com>
 <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com> <20140418162359.GA4398@redhat.com> <20140418172631.GA13323@redhat.com> <20140419083455.GA17601@amd.pavel.ucw.cz> <20140419181407.GB982@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2014, Oleg Nesterov wrote:
> On 04/19, Pavel Machek wrote:
> >
> > > > Hmm. I seem to see a bug in this function, it can be fulled by use_mm,
> > > > but I am not sure this can explain the problem. I'll send a patch.
> > >
> > > Untested, please review. But it really looks "obviously wrong", and note
> > > that unuse_mm() doesn't do mm_update_next_owner(). (just in case, do not
> > > confuse it with unuse_mm() in mm/swapfile.c).
> >
> > Having two functions, one exported, one static with same name -- that
> > sounds quite evil, right?
> 
> Yes, agreed.

Doubly agreed; though it seems to have escaped causing confusion
for several years, so no great hurry to resolve it.

> 
> > mmu_context.c: * unuse_mm
> > mmu_context.c:void unuse_mm(struct mm_struct *mm)
> > mmu_context.c:EXPORT_SYMBOL_GPL(unuse_mm);
> > swapfile.c:static int unuse_mm(struct mm_struct *mm,
> 
> Yes, I was thinking about s/unuse_mm/unswap_mm/ change in swapfile.c,
> but then we should probaly rename other "unuse" functions there, and
> shmem_unuse/try_to_unuse are not static.

My preference is "swapoff" instead of "unuse" throughout there:
it saves having to explain that "unuse" implies "swapoff" each
time we send in a patch making a change to that code.

But I'd prefer you hold off for the moment: Kelley Nielsen is currently
preparing a patchset reworking try_to_unuse, and I suggested a few days
ago to include such renaming in that patchset.

Partly driven by s390's recent 45961722f8e3 "mm: add support for
discard of unused ptes" which adds further confusion with pte_unused().

Hugh
