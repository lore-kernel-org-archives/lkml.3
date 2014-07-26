Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbaGZAjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:39:18 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35125 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbaGZAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:39:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkRADr40lN5LHOd/2dsb2JhbABZgw6BKa97AQEBAQEBBqMRAYEMF3cEhAABBTocIxAIAw4KCSUPBSUDIROIQb8QFxiFY4lQB4MugRsFm0aUS4NaKy8
Date: Sat, 26 Jul 2014 10:38:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zach Brown <zab@redhat.com>
Cc: Abhijith Das <adas@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
Message-ID: <20140726003859.GF20518@dastard>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
 <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
 <20140725175257.GK17798@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725175257.GK17798@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:52:57AM -0700, Zach Brown wrote:
> On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
> > Hi all,
> > 
> > The topic of a readdirplus-like syscall had come up for discussion at last year's
> > LSF/MM collab summit. I wrote a couple of syscalls with their GFS2 implementations
> > to get at a directory's entries as well as stat() info on the individual inodes.
> > I'm presenting these patches and some early test results on a single-node GFS2
> > filesystem.
> > 
> > 1. dirreadahead() - This patchset is very simple compared to the xgetdents() system
> > call below and scales very well for large directories in GFS2. dirreadahead() is
> > designed to be called prior to getdents+stat operations.
> 
> Hmm.  Have you tried plumbing these read-ahead calls in under the normal
> getdents() syscalls?

The issue is not directory block readahead (which some filesystems
like XFS already have), but issuing inode readahead during the
getdents() syscall.

It's the semi-random, interleaved inode IO that is being optimised
here (i.e. queued, ordered, issued, cached), not the directory
blocks themselves. As such, why does this need to be done in the
kernel?  This can all be done in userspace, and even hidden within
the readdir() or ftw/ntfw() implementations themselves so it's OS,
kernel and filesystem independent......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
