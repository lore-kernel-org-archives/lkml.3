Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaCUXWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:22:06 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:44573 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbaCUXWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:22:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoUGALbILFNR8cxj/2dsb2JhbABZgwbDdIEZF3SCJQEBAQMBOhwjBQsIAw4KLjkeBhOHcQwBz0YXjmoHhDgBA45SiXYBilmHWIMuPA
Date: Sat, 22 Mar 2014 00:21:59 +0100
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-Id: <20140322002159.e1428d6a58899b38b379733c@skynet.be>
In-Reply-To: <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
	<20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 13:00:55 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 21 Mar 2014 17:18:30 +0100 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > Loop around congestion_wait on allocation failure/alloc_journal_list
> > like already fixed in other FS.
> > 
> > ...
> >
> > --- a/fs/reiserfs/journal.c
> > +++ b/fs/reiserfs/journal.c
> > @@ -2487,8 +2487,13 @@ static int journal_read(struct super_block *sb)
> >  static struct reiserfs_journal_list *alloc_journal_list(struct super_block *s)
> >  {
> >  	struct reiserfs_journal_list *jl;
> > -	jl = kzalloc(sizeof(struct reiserfs_journal_list),
> > -		     GFP_NOFS | __GFP_NOFAIL);
> > +
> > +	do {
> > +		jl = kzalloc(sizeof(struct reiserfs_journal_list), GFP_NOFS);
> > +		if (unlikely(!jl))
> > +			congestion_wait(BLK_RW_ASYNC, HZ/50);
> > +	} while (!jl)
> > +
> 
> Dammit, who has been running around converting __GFP_NOFAIL into
> open-coded congestion_wait() loops?
> 
> The whole point of __GFP_NOFAIL is to centralise this
> wait-for-memory-for-ever operation.  So it is implemented in a common
> (core) place and so that we can easily locate these problematic
> callers.
> 
> This comment in ext4:
> 
> 			/*
> 			 * If __GFP_FS is not present, then we may be
> 			 * being called from inside the fs writeback
> 			 * layer, so we MUST NOT fail.  Since
> 			 * __GFP_NOFAIL is going away, we will arrange
> 			 * to retry the allocation ourselves.
> 			 */
> 
> is exactly wrong.  Yes, we'd like __GFP_NOFAIL to go away, but it
> cannot go away until buggy callsites such as this one are *fixed*. 
> Removing the __GFP_NOFAIL usage simply hides the buggy code from casual
> searchers.
> 
> argh.
> 
> What we should do is to fix all these call sites so they can handle
> memory exhaustion.  That's hard so in the interim they should be using
> __GFP_NOFAIL.
> 

Ok, if even ext4 comments are wrong, things gonna be very difficult :)
Any sample of a callsite transition done well ?  (git id ?)
