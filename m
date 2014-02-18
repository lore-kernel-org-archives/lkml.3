Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaBRSCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:02:31 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:38953 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaBRSC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:02:27 -0500
MIME-Version: 1.0
In-Reply-To: <100D68C7BA14664A8938383216E40DE04062DEA1@FMSMSX114.amr.corp.intel.com>
References: <1392662333-25470-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CA+55aFwz+36NOk=uanDvii7zn46-s1kpMT1Lt=C0hhhn9v6w-Q@mail.gmail.com>
	<53035FE2.4080300@redhat.com>
	<100D68C7BA14664A8938383216E40DE04062DEA1@FMSMSX114.amr.corp.intel.com>
Date: Tue, 18 Feb 2014 10:02:26 -0800
X-Google-Sender-Auth: z_v864ZoM7GgVzBFl_eF_zb50j4
Message-ID: <CA+55aFzqZ2S==NyWG67hNV1YsY-oXLjLvCR0JeiHGJOfnoGJBg@mail.gmail.com>
Subject: Re: [RFC, PATCHv2 0/2] mm: map few pages around fault address if they
 are in page cache
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 6:15 AM, Wilcox, Matthew R
<matthew.r.wilcox@intel.com> wrote:
> We don't really need to lock all the pages being returned to protect against truncate.  We only need to lock the one at the highest index, and check i_size while that lock is held since truncate_inode_pages_range() will block on any page that is locked.
>
> We're still vulnerable to holepunches, but there's no locking currently between holepunches and truncate, so we're no worse off now.

It's not "holepunches and truncate", it's "holepunches and page
mapping", and I do think we currently serialize the two - the whole
"check page->mapping still being non-NULL" before mapping it while
having the page locked does that.

Besides, that per-page locking should serialize against truncate too.
No, there is no "global" serialization, but there *is* exactly that
page-level serialization where both truncation and hole punching end
up making sure that the page no longer exists in the page cache and
isn't mapped.

I'm just claiming that *because* of the way rmap works for file
mappings (walking the i_mapped list and page tables), we should
actually be ok.  The anonymous rmap list is protected by the page
lock, but the file-backed rmap is protected by the pte lock (well, and
the "i_mmap_mutex" that in turn protects the i_mmap list etc).

       Linus
