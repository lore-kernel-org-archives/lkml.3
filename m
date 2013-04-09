Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3DIVLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:11:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934864Ab3DIVLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:11:32 -0400
Date: Tue, 9 Apr 2013 23:11:28 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Shuge <shugelinux@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, Kevin <kevin@allwinnertech.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] [RESEND] mm: Make snapshotting pages for stable
 writes a per-bio operation
Message-ID: <20130409211128.GD15214@quack.suse.cz>
References: <20130409180617.GB8907@blackbox.djwong.org>
 <20130409140432.cd69f999302a02caf73788fc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409140432.cd69f999302a02caf73788fc@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-04-13 14:04:32, Andrew Morton wrote:
> On Tue, 9 Apr 2013 11:06:17 -0700 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> > +		 * Here we write back pagecache data that may be mmaped. Since
> > +		 * we cannot afford to clean the page and set PageWriteback
> > +		 * here due to lock ordering (page lock ranks above transaction
> > +		 * start), the data can change while IO is in flight. Tell the
> > +		 * block layer it should bounce the bio pages if stable data
> > +		 * during write is required.
> 
> I think there are already ab/ba deadlocks between lock_page() and
> journal_start().  iirc one path was write(), I forget which was the
> other path.  This was 10+ years ago and nobody else noticed and I
> didn't know how to fix it so I didn't tell anyone ;)
  Hum, I don't think they are there anymore ;)

> It would be neat to be able to hook things like journal_start() into
> lockdep but I don't think that lockdep has easy provision for wiring
> oddball things into its mechanisms.
  Actually if you look at fs/jbd/transaction.c:start_this_handle(), you
will notice that it is wired into lockdep (the lock_map_acquire() call
there). And it works since I've seen quite some reports from it ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
