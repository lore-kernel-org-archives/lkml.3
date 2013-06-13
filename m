Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab3FMTPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:15:16 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:62697 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab3FMTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:15:14 -0400
Date: Thu, 13 Jun 2013 12:15:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613191507.GB13970@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613020536.GA10979@localhost>
 <20130612200311.7f9d938a.akpm@linux-foundation.org>
 <20130613185318.GB12075@mtj.dyndns.org>
 <20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Jun 13, 2013 at 12:04:39PM -0700, Andrew Morton wrote:
> > The thing is that id[r|a] guarantee that the lowest available slot is
> > allocated
> 
> That isn't the case for ida_get_new_above() - the caller gets to
> control the starting index.

Hmmm?  get_new_above() is the same, it must allocate the first
available ID above the given low bound - used to exclude unused or
reserved IDs.

> The worst outcome here is that idr.c remains unimproved and we merge a
> new allocator which does basically the same thing.

The lowest number guarantee makes them different.  Maybe tag
allocation can be layered on top as a caching layer, I don't know, but
at any rate we need at least two different operation modes.

> The best outcome is that idr.c gets improved and we don't have to merge
> duplicative code.
>
> So please, let's put aside the shiny new thing for now and work out how
> we can use the existing tag allocator for these applications.  If we
> make a genuine effort to do this and decide that it's fundamentally
> hopeless then this is the time to start looking at new implementations.
> 
> (I can think of at least two ways of making ida_get_new_above() an
> order of magnitude faster for this application and I'm sure you guys
> can as well.)

Oh, I'm sure the current id[r|a] can be improved upon a lot but I'm
very skeptical one can reach the level of scalability necessary for,
say, pci-e attached extremely high-iops devices while still keeping
the lowest number allocation, which can't be achieved without strong
synchronization on each alloc/free.

Maybe we can layer things so that we have percpu layer on top of
id[r|a] and, say, mapping id to point is still done by idr, or the
percpu tag allocator uses ida for tag chunk allocations, but it's
still gonna be something extra on top.

Thanks.

-- 
tejun
