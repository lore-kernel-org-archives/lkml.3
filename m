Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaCCX3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:29:21 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60812 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbaCCX3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:29:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140303143834.90ebe8ec5c6a369e54a599ec@linux-foundation.org>
References: <1393625931-2858-1-git-send-email-quning@google.com>
	<CACQD4-5U3P+QiuNKzt5+VdDDi0ocphR+Jh81eHqG6_+KeaHyRw@mail.gmail.com>
	<20140228174150.8ff4edca.akpm@linux-foundation.org>
	<CACQD4-7UUDMeXdR-NaAAXvk-NRYqW7mHJkjDUM=JRvL54b_Xsg@mail.gmail.com>
	<CACQD4-5SmUf+krLbef9Yg9HhJ-ipT2QKKq-NW=2C6G=XwXcMcQ@mail.gmail.com>
	<20140303143834.90ebe8ec5c6a369e54a599ec@linux-foundation.org>
Date: Mon, 3 Mar 2014 15:29:00 -0800
X-Google-Sender-Auth: EDPsqQvVOQtb_efq2axIkwUyqZI
Message-ID: <CA+55aFzvCF-tWg7qx2_Om+Y64uJy6ujEyWgcq87UkzSkfbVGqw@mail.gmail.com>
Subject: Re: [PATCH 0/1] mm, shmem: map few pages around fault address if they
 are in page cache
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ning Qu <quning@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 2:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> When the file is uncached, results are peculiar:
>
> 0.00user 2.84system 0:50.90elapsed 5%CPU (0avgtext+0avgdata 4198096maxresident)k
> 0inputs+0outputs (1major+49666minor)pagefaults 0swaps
>
> That's approximately 3x more minor faults.

This is not peculiar.

When the file is uncached, some pages will obviously be under IO due
to readahead etc. And the fault-around code very much on purpose will
*not* try to wait for those pages, so any busy pages will just simply
not be faulted-around.

So you should still have fewer minor faults than faulting on *every*
page (ie the non-fault-around case), but I would very much expect that
fault-around will not see the full "one sixteenth" reduction in minor
faults.

And the order of IO will not matter, since the read-ahead is
asynchronous wrt the page-faults.

             Linus
