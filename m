Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3HUXGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:06:03 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:65075 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3HUXGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:06:00 -0400
Date: Thu, 22 Aug 2013 03:05:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130821230557.GD18673@moon>
References: <5214C524.1050900@citrix.com>
 <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
 <20130821141926.GT18673@moon>
 <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:30:03AM -0700, Linus Torvalds wrote:
> Quite frankly, unless I see a patch later today that is
> 
>  (a) obvious
>  (b) explains what is going on
>  (c) tested
> 
> I will be reverting the whole soft-dirty mess. I thought the
> bit-mapping games it played were already too complicated (the patch to
> pgtable-2level.h in commit 41bb3476b361 just makes me want to barf and
> came in very late, so I'm not positive about the whole soft-dirty mess
> in the first place). I really am not at all inclined to want to play
> games in this area any more. It's too damn late in the release window.

Hi all, I worked on patch which would not touch PSE bit for dirty page
tracking and the result is not that good:

 - 2level pages now always page dirty if page is swapped in and out, because
   there is no space left in PTE (other than PSE bit)

 - only 3level pages scheme uses high 32bits to keep offset of swap entry,
   x86-64 shifts offset up to _PAGE_BIT_GLOBAL + 1 bit, thus I need some
   different bit nonunified with anything else for no reason :(

Summarizing all things

 - Using PSE bit for swap entries as indicator of soft dirty page is safe because
   swap entries as saved in pte as non-presen and when #pf happens kernel generates
   valid pte entry from vma->vm_page_prot

 - __swp_entry() helper is clearing PSE bit explicitly so even without softdirty
   patch it's not saved once page reach swap (with softdirty tracking we simply
   reuse this bit for own needs).

 - Using PSE bit allows to not modify swap encoding on all 3 page schemes (2level,
   3level, 4level) because it's a spare bit there not intersected with swap format.

Thus I would *_really_* like to save current scheme. Probably I should add comment
into header where _PAGE_SWP_SOFT_DIRTY defined that it's valid only when PRESENT
bit clear? Similar to

/* If _PAGE_BIT_PRESENT is clear, we use these: */
/* - if the user mapped it with PROT_NONE; pte_present gives true */
#define _PAGE_BIT_PROTNONE	_PAGE_BIT_GLOBAL
/* - set: nonlinear file mapping, saved PTE; unset:swap */
#define _PAGE_BIT_FILE		_PAGE_BIT_DIRTY

Have I conviced you guys?

The former problem report came from impression that this PSE bit may be touched
(set and clean) on present PTE, but it's not the case for pages being swapped.
