Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3BSDa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:30:27 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:44051 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758157Ab3BSDaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:30:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMKAF/xIlF5LHbb/2dsb2JhbABEhWC1PIUSgQQXc4IfAQEFOhwjEAgDGAklDwUlAyETiBGxQ5ADFY0+fCI9B4JfYQOWK5BZgVKBSYFe
Date: Tue, 19 Feb 2013 14:30:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alex Elder <elder@kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ben Myers <bpm@sgi.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 10/12] userns: Convert xfs to use kuid/kgid/kprojid
 where appropriate
Message-ID: <20130219033021.GF10731@dastard>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
 <1353415420-5457-10-git-send-email-ebiederm@xmission.com>
 <20121120235524.GK2591@dastard>
 <20121121195246.GN2822@localhost>
 <87obfoxetf.fsf@xmission.com>
 <20130214021908.GJ26694@dastard>
 <87621qpg4o.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87621qpg4o.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:25:43PM -0800, Eric W. Biederman wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Wed, Feb 13, 2013 at 10:13:16AM -0800, Eric W. Biederman wrote:
> >
> >> The crazy thing is that is that xfs appears to
> >> directly write their incore inode structure into their journal. 
> >
> > Off topic, but it's actually a very sane thing to do. It's called
> > logical object logging, as opposed to physical logging like ext3/4
> > and ocfs2 use. XFS uses a combination of logical logging
> > (superblock, dquots, inodes) and physical logging (via buffers).
> 
> Not putting your structures in disk-endian before putting them on-disk
> seems silly.  As far as I can tell if you switch endianness of the
> machine accessing your xfs filesystem and have to do a log recover
> it won't work because a lot of the log entries will appear corrupted.
> 
> It also seems silly to require your in-memory structure to be binary
> compatibile with your log when you immediately copy that structure to
> another buffer when it comes time to queue a version of it to put into
> the log.
> 
> The fact that you sometimes need to allocate memory and make a copy so
> you can stuff your data into the logvec whose only purpose is to then
> copy the data a second time seems silly and wasteful.
> 
> Logical logging itself seems reasonable.  I just find the implementation
> in xfs odd.
> 
> It looks like with a few little changes xfs could retain backwards
> compatibility with today, remove extra memory copies, and completely
> decouple the format of the in-core structures with the format of the
> on-disk structures.  Allowing scary comments to be removed.

If you think removing the copies is that easy, go right ahead - I'd
love to see patches that checkpoint changes directly from the
in-memory objects to the log without deadlocking....

Decoupling the in-memory structure from the log format could be done
at any time. But it's just not something that is needed, and for the
rare cases where it is needed it's better to put the format
detection and conversion code into log recovery. i.e. take the
conversion penalty once when needed on the slow path rather than on
every operation through the fast path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
