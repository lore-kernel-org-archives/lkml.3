Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3CVB5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:57:19 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37737 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab3CVB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:57:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmAbALi4S1F5LAzK/2dsb2JhbABDhzy4XoU/AQMBgV0XdIIkAQEFOhwjEAgDEgYJJQ8FJQMNFBOIEw3CDRWNYSAeXQeDQAOWY4Egj2ODHig
Date: Fri, 22 Mar 2013 12:57:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
Cc: Rob Landley <rob@landley.net>, Martin Steigerwald <Martin@lichtvoll.de>,
        tux3@phunq.net, "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Lang <david@lang.hm>, linux-kernel@vger.kernel.org,
        tux3@tux3.org, linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Initial fsck has landed
Message-ID: <20130322015712.GQ17758@dastard>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
 <20130129014000.GA7003@thunk.org>
 <CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com>
 <201303200000.33356.Martin@lichtvoll.de>
 <1363762493.15703.46@driftwood>
 <CAEsagEjgDJr7stTu3iCzR4JxB3A856a7u12WcovY=746M2p0jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsagEjgDJr7stTu3iCzR4JxB3A856a7u12WcovY=746M2p0jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 06:49:49PM -0700, Daniel Phillips wrote:
> On Tue, Mar 19, 2013 at 11:54 PM, Rob Landley <rob@landley.net> wrote:
> > I'm confused, http://tux3.org/ lists a bunch of dates from 5 years ago, then
> > nothing. Is this project dead or not?
> 
> Not. We haven't done much about updating tux3.org lately, however you
> will find plenty of activity here:
> 
>      https://github.com/OGAWAHirofumi/tux3/tree/master/user
> 
> You will also find fairly comprehensive updates on where we are and
> where this is going, here:
> 
>      http://phunq.net/pipermail/tux3/
> 
> At the moment we're being pretty quiet because of being in the middle
> of developing the next-gen directory index. Not such a small task, as
> you might imagine.

Hi Daniel,

The "next-gen directory index" comment made me curious. I wanted to
know if there's anything I could learn from what you are doing and
whether anything of your new algorithms could be applied to, say,
the XFS directory structure to improve it.

I went looking for design docs and found this:

http://phunq.net/pipermail/tux3/2013-January/001938.html

In a word: Disappointment.

Compared to the XFS directory structure, the most striking
architectural similarity that I see is this:

	"the file bteee[sic] effectively is a second directory index
	that imposes a stable ordering on directory blocks".

That was the key architectural innovation in the XFS directory
structure that allowed it to provide the correct seekdir/telldir/NFS
readdir semantics and still scale. i.e. virtually mapped directory
entries. I explained this layout recently here:

http://marc.info/?l=linux-ext4&m=136081996316453&w=2
http://marc.info/?l=linux-ext4&m=136082221117399&w=2
http://marc.info/?l=linux-ext4&m=136089526928538&w=2

We could swap the relevant portions of your PHTree design doc with
my comments (and vice versa) and both sets of references would still
make perfect sense. :P

Further, the PHTree description of tag based freespace tracking is
rather close to how XFS uses tags to track free space regions,
including the fact that XFS can be lazy at updating global free
space indexes.  The global freespace tree indexing is slightly
different to the XFS method - it's closer to the original V1 dir
code in XFS (that didn't scale at all well) than the current code.
However, that's really a fine detail compared to all the major
structural and algorithmic similarities.

Hence it appears to me that at a fundamental level PHTree is just a
re-implementation of the XFS directory architecture. It's definitely
a *major* step forward from HTree, but it can hardly be considered
revolutionary or "next-gen". It's not even state of the art. Hence:
disappointment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
