Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaG1MWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:22:37 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:52613 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaG1MWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:22:33 -0400
Date: Mon, 28 Jul 2014 08:22:22 -0400 (EDT)
From: Abhijith Das <adas@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Message-ID: <308078610.14129388.1406550142526.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140726003859.GF20518@dastard>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com> <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com> <20140725175257.GK17798@lenny.home.zabbo.net> <20140726003859.GF20518@dastard>
Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC36 (Linux)/8.0.6_GA_5922)
Thread-Topic: readdirplus implementations: xgetdents vs dirreadahead syscalls
Thread-Index: 8uSCoD2guXz9O2jh8hC6CjFq2vJTcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Zach Brown" <zab@redhat.com>
> Cc: "Abhijith Das" <adas@redhat.com>, linux-kernel@vger.kernel.org, "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
> "cluster-devel" <cluster-devel@redhat.com>
> Sent: Friday, July 25, 2014 7:38:59 PM
> Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead syscalls
> 
> On Fri, Jul 25, 2014 at 10:52:57AM -0700, Zach Brown wrote:
> > On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
> > > Hi all,
> > > 
> > > The topic of a readdirplus-like syscall had come up for discussion at
> > > last year's
> > > LSF/MM collab summit. I wrote a couple of syscalls with their GFS2
> > > implementations
> > > to get at a directory's entries as well as stat() info on the individual
> > > inodes.
> > > I'm presenting these patches and some early test results on a single-node
> > > GFS2
> > > filesystem.
> > > 
> > > 1. dirreadahead() - This patchset is very simple compared to the
> > > xgetdents() system
> > > call below and scales very well for large directories in GFS2.
> > > dirreadahead() is
> > > designed to be called prior to getdents+stat operations.
> > 
> > Hmm.  Have you tried plumbing these read-ahead calls in under the normal
> > getdents() syscalls?
> 
> The issue is not directory block readahead (which some filesystems
> like XFS already have), but issuing inode readahead during the
> getdents() syscall.
> 
> It's the semi-random, interleaved inode IO that is being optimised
> here (i.e. queued, ordered, issued, cached), not the directory
> blocks themselves. As such, why does this need to be done in the
> kernel?  This can all be done in userspace, and even hidden within
> the readdir() or ftw/ntfw() implementations themselves so it's OS,
> kernel and filesystem independent......
> 

I don't see how the sorting of the inode reads in disk block order can be
accomplished in userland without knowing the fs-specific topology. From my
observations, I've seen that the performance gain is the most when we can
order the reads such that seek times are minimized on rotational media.

I have not tested my patches against SSDs, but my guess would be that the
performance impact would be minimal, if any.

Cheers!
--Abhi
