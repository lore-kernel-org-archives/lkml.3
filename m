Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaBRXOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:14:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaBRXOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:14:52 -0500
Date: Tue, 18 Feb 2014 15:14:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        John David Anglin <dave.anglin@bell.net>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Carsten Otte <cotte@de.ibm.com>, Jared Hulbert <jaredeh@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, "[3.11.x+]" <stable@vger.kernel.org>
Subject: Re: [PATCH akpm] mm: include VM_MIXEDMAP flag in the VM_SPECIAL
 list to avoid m(un)locking
Message-Id: <20140218151450.4cb1ee9c491f3026ab34c04d@linux-foundation.org>
In-Reply-To: <1392562785-15790-1-git-send-email-dborkman@redhat.com>
References: <1392562785-15790-1-git-send-email-dborkman@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Feb 2014 15:59:45 +0100 Daniel Borkmann <dborkman@redhat.com> wrote:

> Daniel Borkmann reported a bug (stack trace above) with VM_BUG_ON
> assertions failing where munlock_vma_pages_range() thinks it's
> unexpectedly in the middle of a THP page. This can be reproduced
> with default config since 3.11 kernels. A reproducer can be found
> in the kernel's selftest directory for networking by running
> ./psock_tpacket.
> 
> The problem is that an order=2 compound page (allocated by
> alloc_one_pg_vec_page() is part of the munlocked VM_MIXEDMAP
> vma (mapped by packet_mmap()) and mistaken for a THP page and
> assumed to be order=9.
> 
> The checks for THP in munlock came with commit ff6a6da60b89 ("mm:
> accelerate munlock() treatment of THP pages"), i.e. since 3.9,
> but did not trigger a bug. It just makes munlock_vma_pages_range()
> skip such compound pages until the next 512-pages-aligned page,
> when it encounters a head page. This is however not a problem
> for vma's where mlocking has no effect anyway, but it can distort
> the accounting.
> 
> Since commit 7225522bb ("mm: munlock: batch non-THP page isolation
> and munlock+putback using pagevec") this can trigger a VM_BUG_ON
> in PageTransHuge() check.
> 
> This patch fixes the issue by adding VM_MIXEDMAP flag to VM_SPECIAL,
> a list of flags that make vma's non-mlockable and non-mergeable.
> The reasoning is that VM_MIXEDMAP vma's are similar to VM_PFNMAP,
> which is already on the VM_SPECIAL list, and both are intended
> for non-LRU pages where mlocking makes no sense anyway. Related
> Lkml discussion can be found in [2].
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Daniel Borkmann <dborkman@redhat.com>
> Tested-by: Daniel Borkmann <dborkman@redhat.com>

I'll add your signed-of-by: here.  As per
Documentation/SubmittingPatches 12) (c) ;)

>  Took the liberty to resubmit it, as people hit that on distribution
>  kernels; tested and it looks to fix the issue.

hm, I wonder why I missed this.
