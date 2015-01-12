Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbbALUVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:21:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbbALUVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:21:39 -0500
Date: Mon, 12 Jan 2015 12:21:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Chris Clayton <chris2553@googlemail.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Michal Hocko <mhocko@suse.cz>,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] mm: fix corner case in anon_vma endless growing
 prevention
Message-Id: <20150112122138.f173c6279af0b49565e956d3@linux-foundation.org>
In-Reply-To: <20150111135406.13266.42007.stgit@zurg>
References: <20150111135406.13266.42007.stgit@zurg>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2015 16:54:06 +0300 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> Fix for BUG_ON(anon_vma->degree) splashes in unlink_anon_vmas()
> ("kernel BUG at mm/rmap.c:399!").
> 
> Anon_vma_clone() is usually called for a copy of source vma in destination
> argument. If source vma has anon_vma it should be already in dst->anon_vma.
> NULL in dst->anon_vma is used as a sign that it's called from anon_vma_fork().
> In this case anon_vma_clone() finds anon_vma for reusing.
> 
> Vma_adjust() calls it differently and this breaks anon_vma reusing logic:
> anon_vma_clone() links vma to old anon_vma and updates degree counters but
> vma_adjust() overrides vma->anon_vma right after that. As a result final
> unlink_anon_vmas() decrements degree for wrong anon_vma.
> 
> This patch assigns ->anon_vma before calling anon_vma_clone().
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Fixes: 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy")

I've asked Greg not to take 7a3ef208e662 into -stable because of this
problem.  So if you still think we should fix this in -stable, could
you please prepare an updated patch and send it to Greg?

> Tested-by: Chris Clayton <chris2553@googlemail.com>
> Tested-by: Oded Gabbay <oded.gabbay@amd.com>
> Cc: Daniel Forrest <dan.forrest@ssec.wisc.edu>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Rik van Riel <riel@redhat.com>
