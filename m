Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3HTQBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:01:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab3HTQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:01:06 -0400
Date: Tue, 20 Aug 2013 18:00:57 +0200
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
 deferred cmtime update
Message-ID: <20130820160057.GC2862@quack.suse.cz>
References: <cover.1376679411.git.luto@amacapital.net>
 <ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
 <20130820023615.GE6023@dastard>
 <CALCETrV-Toj-NGpmWnmoUbCwrMUXOSbjQdYsSVuTiH+2dEgPTQ@mail.gmail.com>
 <20130820040814.GH6023@dastard>
 <CALCETrWreWBwKdKS2w=fS+MwdaZv1eEsKjYo=P9eeXe7fZS6Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWreWBwKdKS2w=fS+MwdaZv1eEsKjYo=P9eeXe7fZS6Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-08-13 21:14:44, Andy Lutomirski wrote:
> >> I could require ->writepages *and* ->flush_cmtime to handle the time
> >> update, but that would complicate non-transactional filesystems.
> >> Those filesystems should just flush cmtime at the end of writepages.
> >
> > do_writepages() is the wrong place to do such updates - we can get
> > writeback directly through .writepage, so the time updates need to
> > be in .writepage. That first .writepage call will clear the bit on
> > the mapping, so it's only done on the first call to .writepage on
> > the given mapping.
> 
> Last time I checked, all the paths that actually needed the timestamp
> update went through .writepages.  I'll double-check.
  kswapd can call just .writepage to do the writeout so timestamp update
should be handled there as well. Otherwise all pages in a mapping can be
cleaned without timestamp being updated.

Which btw made me realize that even your scheme doesn't completely make
sure timestamp is updated after mmap write - if you have pages 0 and 1, you
write to both of them - CMTIME flag gets set. Then fsync_range(fd, 0, 4096)
is called. We write the page 0, writeprotect it, update timestamps. But
page 1 is still writeable so writes to it won't set CMTIME flag, neither
update the timestamp... Not that I think this can be reasonably solved but
it is a food for thought.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
