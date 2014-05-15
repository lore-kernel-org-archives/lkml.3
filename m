Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaEOOPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:15:30 -0400
Received: from imap.thunk.org ([74.207.234.97]:41871 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbaEOOP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:15:27 -0400
Date: Thu, 15 May 2014 10:15:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515141515.GA21632@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@redhat.com>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Eric Sandeen <esandeen@redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <20140514215457.GC5421@dastard>
 <20140515094236.GE10637@mguzik.redhat.com>
 <20140515100157.GB27289@quack.suse.cz>
 <20140515124725.GA8194@thunk.org>
 <20140515134610.GB660@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515134610.GB660@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 03:46:10PM +0200, Jan Kara wrote:
> > Saving it in the superblock would require changing a bunch of file
> > systems.  What if we store this information in memory, and print it
> > out under certain conditions (i.e., after a soft lockup detection, or
> > upon request of some magic sysrq request)?
>   By 'superblock' I meant 'struct super_block' ;) So we are in agreement I
> believe.

Ah, yes, we're in agreement.  I thought you were talking about the
on-disk superblock.

> > Or we could create a tunable threshold and print a message after a
> > file system has been frozen more than a particular specified duration,
> > with that duration set conservatively to something like 60 or 120
> > seconds by default.
>   I was thinking about this as well but all these "warn after X seconds"
> warnings tend to have quite a few false positives in practice so dumping
> this in emergency-thaw sysrq handler or exposing the information somewhere
> in proc (e.g. mountinfo) would look like a better option to me.

Well, we already have the soft lockup warning, which sometimes has
some false positives, but in practice, if a process is runable but
doesn't get to run in 2 minutes (the default is 20 seconds, but we've
used 2 minutes to avoid the false positive problem on a super busy
system), something is probably clearly wrong.

Similarly, if a process is trying to write to a frozen file system,
and can't after two minutes, something is almost certainly wrong, or
least, it's something a system administrator should know about it.  We
can argue over whether the default threshold should be 20 seconds, or
120 seconds, or 2 hours, but I think there would be agreement that for
pretty much any configuration, there is some delay after which
printing a message is actually the right thing to do.  (Yes, "time
that a process is waiting to write to a frozen file system != time the
file system is frozen" --- the latter is easier to implement, but if
people feel strongly about it, the former isn't that much more
difficult.)

The problem with using an sysrq handler is the user has to know how to
use it.  If the user files a bug saying the system has mysteriously
hung, the fact that the system log contains a hint as to what might be
going on would be very useful for an enterprise distribiution's help
desk.  (Yes, this won't help if it's the root file system is the one
that's been frozen, unless the customer has configured remote syslog.
But for many cases, it might provide a vital clue that could save a
lot of time and support costs.)

						- Ted
