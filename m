Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaAWTtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:49:41 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:38466 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbaAWTti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:49:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugJAOtx4VJ5LGaB/2dsb2JhbABaDoJ+gzq0O4VQgRMXdIIlAQEBBDocMwgDEgYJJQ8FJQMNFAESiATHJBaOIVCEOASYIpIZgW9/UyiBLQ
Date: Fri, 24 Jan 2014 06:49:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Chris Mason <clm@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Message-ID: <20140123194931.GS13997@dastard>
References: <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
 <1390413819.1198.20.camel@ret.masoncoding.com>
 <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
 <52E00B28.3060609@redhat.com>
 <1390415703.2372.62.camel@dabdike.int.hansenpartnership.com>
 <52E0106B.5010604@redhat.com>
 <1390419019.2372.89.camel@dabdike.int.hansenpartnership.com>
 <20140122115002.bb5d01dee836b567a7aad157@linux-foundation.org>
 <20140123083558.GQ13997@dastard>
 <20140123125550.GB6853@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123125550.GB6853@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 07:55:50AM -0500, Theodore Ts'o wrote:
> On Thu, Jan 23, 2014 at 07:35:58PM +1100, Dave Chinner wrote:
> > > 
> > > I expect it would be relatively simple to get large blocksizes working
> > > on powerpc with 64k PAGE_SIZE.  So before diving in and doing huge
> > > amounts of work, perhaps someone can do a proof-of-concept on powerpc
> > > (or ia64) with 64k blocksize.
> > 
> > Reality check: 64k block sizes on 64k page Linux machines has been
> > used in production on XFS for at least 10 years. It's exactly the
> > same case as 4k block size on 4k page size - one page, one buffer
> > head, one filesystem block.
> 
> This is true for ext4 as well.  Block size == page size support is
> pretty easy; the hard part is when block size > page size, due to
> assumptions in the VM layer that requires that FS system needs to do a
> lot of extra work to fudge around.  So the real problem comes with
> trying to support 64k block sizes on a 4k page architecture, and can
> we do it in a way where every single file system doesn't have to do
> their own specific hacks to work around assumptions made in the VM
> layer.
> 
> Some of the problems include handling the case where you get someone
> dirties a single block in a sparse page, and the FS needs to manually
> fault in the other 56k pages around that single page.  Or the VM not
> understanding that page eviction needs to be done in chunks of 64k so
> we don't have part of the block evicted but not all of it, etc.

Right, this is part of the problem that fsblock tried to handle, and
some of the nastiness it had was that a page fault only resulted in
the individual page being read from the underlying block. This means
that it was entirely possible that the filesystem would need to do
RMW cycles in the writeback path itself to handle things like block
checksums, copy-on-write, unwritten extent conversion, etc. i.e. all
the stuff that the page cache currently handles by doing RMW cycles
at the page level.

The method of using compound pages in the page cache so that the
page cache could do 64k RMW cycles so that a filesystem never had to
deal with new issues like the above was one of the reasons that
approach is so appealing to us filesystem people. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
