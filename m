Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaDAPNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:13:34 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37666 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAPNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140331113442.0d628362@annuminas.surriel.com>
References: <20140331113442.0d628362@annuminas.surriel.com>
Date: Tue, 1 Apr 2014 08:13:31 -0700
X-Google-Sender-Auth: IF_YAs4zYe_LuQaa0l1JgAH4-lo
Message-ID: <CA+55aFzG=B3t_YaoCY_H1jmEgs+cYd--ZHz7XhGeforMRvNfEQ@mail.gmail.com>
Subject: Re: [PATCH] x86,mm: delay TLB flush after clearing accessed bit
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, shli@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 8:34 AM, Rik van Riel <riel@redhat.com> wrote:
>
> However, clearing the accessed bit does not lead to any
> consistency issues, there is no reason to flush the TLB
> immediately. The TLB flush can be deferred until some
> later point in time.

Ugh. I absolutely detest this patch.

If we're going to leave the TLB dirty, then dammit, leave it dirty.
Don't play some half-way games.

Here's the patch you should just try:

 int ptep_clear_flush_young(struct vm_area_struct *vma,
        unsigned long address, pte_t *ptep)
 {
     return ptep_test_and_clear_young(vma, address, ptep);
 }

instead of complicating things.

Rationale: if the working set is so big that we start paging things
out, we sure as hell don't need to worry about TLB flushing. It will
flush itself.

And conversely - if it doesn't flush itself, and something stays
marked as "accessed" in the TLB for a long time even though we've
cleared it in the page tables, we don't care, because clearly there
isn't enough memory pressure for the accessed bit to matter.

                  Linus
