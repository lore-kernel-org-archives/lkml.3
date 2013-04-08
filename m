Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285Ab3DHJbd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 8 Apr 2013 05:31:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab3DHJb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:31:29 -0400
Date: Mon, 8 Apr 2013 11:31:25 +0200
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Ramkumar Ramachandra <artagnon@gmail.com>,
        linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
        Thomas Rast <trast@inf.ethz.ch>, Duy Nguy???n <pclouds@gmail.com>,
        Jeff King <peff@peff.net>, Karsten Blees <karsten.blees@gmail.com>
Subject: Re: Beyond inotify recursive watches
Message-ID: <20130408093125.GA6847@quack.suse.cz>
References: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
 <20130405155534.GC21852@quack.suse.cz>
 <20130405161229.GC4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405161229.GC4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-04-13 17:12:29, Al Viro wrote:
> On Fri, Apr 05, 2013 at 05:55:34PM +0200, Jan Kara wrote:
> 
> > What your question reminds me is an idea of recursive modification time
> > stamp on directories. That is a time stamp that gets updated whenever
> > anything in the tree under the directory changes. Now this would be too
> > expensive to maintain so there's also a trick implemented that you update
> > the time stamp (and continue updating recursive time stamps upwards) only
> > if a special flag is set on the directory. And you clear the flag at that
> > moment. So until someone checks the time stamp and resets the flag no
> > further updates of the recursive modification time happen.
> > 
> > This scheme works for arbitrary number of processes interested in recursive
> > time stamps (only updates of the time stamps get more frequent). What is
> > somewhat inconvenient is that this only tells you something in the
> > directory or its subtree changed so you still have to scan all the
> > directories on the path to modified file. So I'm not sure of how much use
> > this would be to you.
> 
> Feel free to write up the details of locking you'll need for that.  It will
> *not* be fun...
  Actually, it shouldn't be too bad if we don't guarantee we walk exactly
the path used for modification. Then it is enough to do the same thing as
following .. from each directory.

And for userspace that should be enough because if timestamp update races
with renames or similar actions somewhere up in the three then these
operations will generate modification events and update time stamps as
well. So userspace will notice there was a change.

So this part should be doable. But as I wrote before, we might need some
fs-internal index to allow efficient tracking of what has changed in one
directory anyway and locking rules / costs for that are non-obvious.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
