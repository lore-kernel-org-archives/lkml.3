Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3EOJep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:34:45 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54276 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3EOJen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:34:43 -0400
Date: Wed, 15 May 2013 02:34:07 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130515093407.GF16164@moria.home.lan>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-18-git-send-email-koverstreet@google.com>
 <20130514134859.GA17587@redhat.com>
 <20130514142442.GA19392@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514142442.GA19392@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 04:24:42PM +0200, Oleg Nesterov wrote:
> On 05/14, Oleg Nesterov wrote:
> >
> > I must admit, I do not understand what this code actually does ;)
> > I didn't try to read it carefully though, but perhaps at least the
> > changelog could explain more?
> 
> OK, this is clear...
> 
> But perhaps the changelog could explain who needs the "fast" version
> of, say, find_next_zero_bit + test_and_set_bit ;) Just curious.

Originally I wrote it for a driver (which still isn't open source) - but
find_next_zero_bit()/test_and_set_bit() is exactly what it was using
before and the performance gain was significant :)

The reason I'm posting it now is because AIO currently uses a linked
list for tracking outstanding kiocbs - for cancellation - and that
linked list needs to be replaced; I'm implementing cancellation for
regular direct IO and the linked list is a performance issue.

All we need for cancellation is a way to iterate over all the
(potentially) allocated kiocbs - it's really exactly the same problem as
managing tags in the drivers I was working on before (they also need to
be able to time out tags which is exactly the same as AIO cancellation).

What I found really annoying about the problem is that the existing slab
allocator tracks exactly what we need... but it's not exposed (and
honestly probably shouldn't be).

So, there were two choices:
 * hack up slab/slob/slub - fuck no
 * reuse my tag allocator, allocate kiocbs out of an array of pages.
   Also allocate the pages lazily so we don't regress on memory
   overhead.

So, that's what I did.
