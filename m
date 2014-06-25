Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbaFYU2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:28:17 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63847 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbaFYU2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:28:15 -0400
Date: Wed, 25 Jun 2014 16:28:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] fs/omfs/inode.c: replace count*size kzalloc by
 kcalloc
Message-ID: <20140625202806.GA20575@localhost>
References: <1403720237-19131-1-git-send-email-fabf@skynet.be>
 <CA+55aFypOwqaxfMwG5H8QSsRyMrMV7ibW_k5CQdc=EPXYmrfLg@mail.gmail.com>
 <20140625190250.GB399@localhost>
 <810210906.61891.1403726606049.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <810210906.61891.1403726606049.open-xchange@webmail.nmp.skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:03:26PM +0200, Fabian Frederick wrote:
> > >     bitmap_size = DIV_ROUND_UP(sbi->s_num_blocks, 8);
> > >
> > Agreed - even though the FS data structures support 64-bit block
> > count, I've never seen an OMFS fs with more than about 2M blocks
> > (typical device had 20 gigs w/ 8k blocks).  So it would make
> > sense to bail in omfs_fill_super if that number is greater than
> > 2^31 or so.
> We could use unsigned int for bitmap instead of int or simply u64 ?

It doesn't really make sense to be a signed int, sure -- but even so
making it a u64 without at least including a sanity check is probably
not the way to go.

OMFS allocates space for the entire free-space bitmap in memory, rather
than loading its blocks on demand.  That's admittedly pretty dumb, but I
did it so that I could eventually support those FSes without a free-space
bitmap (I've never been asked for that feature, though, and didn't have
ReplayTV myself, so I don't believe that actually happened).

If s_num_blocks won't fit in a u32, well then that's a pretty huge chunk of
memory to allocate, and would represent a disk much bigger than the ones
that were available when this FS was used on a few devices.

(As for why the designers used u64 for all data structures, I guess just
optimism?)

-- 
Bob Copeland %% www.bobcopeland.com
