Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664Ab3GQXkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:40:55 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54388 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932141Ab3GQXky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:40:54 -0400
Date: Wed, 17 Jul 2013 18:40:49 -0500
From: Ben Myers <bpm@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130717234049.GC3572@sgi.com>
References: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
 <20130716060351.GE11674@dastard>
 <20130716193332.GB3572@sgi.com>
 <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
 <20130716204335.GH11674@dastard>
 <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
 <20130717040616.GI11674@dastard>
 <CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
 <20130717055103.GK11674@dastard>
 <CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Wed, Jul 17, 2013 at 09:03:11AM -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 10:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > But When i say "stale data" I mean that the data being returned
> > might not have originally belonged to the underlying file you are
> > reading.
> 
> We're still talking at cross purposes then.
> 
> How the hell do you handle mmap() and page faulting?

__xfs_get_blocks serializes access to the block map with the i_lock on the
xfs_inode.  This appears to be racy with respect to hole punching.

> Because if you return *that* kind of stale data, than you're horribly
> horribly buggy. And you cannot *possibly* blame
> generic_file_splice_read() on that.

Seems to me we'd need to hold the page lock on every page in the hole to
provide exclusion with splice read and mmap faults, then remove the extents,
and finally truncate the pages away.  I think at that point the reads could be
done without the iolock.  Or, is there a different lock that could do the trick?

Thanks,
	Ben
