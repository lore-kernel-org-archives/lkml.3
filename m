Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaAWV10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:27:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaAWV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:27:24 -0500
Date: Thu, 23 Jan 2014 13:27:14 -0800
From: Joel Becker <jlbec@evilplan.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Chris Mason <clm@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Message-ID: <20140123212714.GB25376@localhost>
Mail-Followup-To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	Chris Mason <clm@fb.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"mgorman@suse.de" <mgorman@suse.de>
References: <52DFD168.8080001@redhat.com>
 <20140122143452.GW4963@suse.de>
 <52DFDCA6.1050204@redhat.com>
 <20140122151913.GY4963@suse.de>
 <1390410233.1198.7.camel@ret.masoncoding.com>
 <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
 <1390413819.1198.20.camel@ret.masoncoding.com>
 <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
 <1390415924.1198.36.camel@ret.masoncoding.com>
 <1390416421.2372.68.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390416421.2372.68.camel@dabdike.int.hansenpartnership.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:47:01AM -0800, James Bottomley wrote:
> On Wed, 2014-01-22 at 18:37 +0000, Chris Mason wrote:
> > On Wed, 2014-01-22 at 10:13 -0800, James Bottomley wrote:
> > > On Wed, 2014-01-22 at 18:02 +0000, Chris Mason wrote:
> [agreement cut because it's boring for the reader]
> > > Realistically, if you look at what the I/O schedulers output on a
> > > standard (spinning rust) workload, it's mostly large transfers.
> > > Obviously these are misalgned at the ends, but we can fix some of that
> > > in the scheduler.  Particularly if the FS helps us with layout.  My
> > > instinct tells me that we can fix 99% of this with layout on the FS + io
> > > schedulers ... the remaining 1% goes to the drive as needing to do RMW
> > > in the device, but the net impact to our throughput shouldn't be that
> > > great.
> > 
> > There are a few workloads where the VM and the FS would team up to make
> > this fairly miserable
> > 
> > Small files.  Delayed allocation fixes a lot of this, but the VM doesn't
> > realize that fileA, fileB, fileC, and fileD all need to be written at
> > the same time to avoid RMW.  Btrfs and MD have setup plugging callbacks
> > to accumulate full stripes as much as possible, but it still hurts.
> > 
> > Metadata.  These writes are very latency sensitive and we'll gain a lot
> > if the FS is explicitly trying to build full sector IOs.
> 
> OK, so these two cases I buy ... the question is can we do something
> about them today without increasing the block size?
> 
> The metadata problem, in particular, might be block independent: we
> still have a lot of small chunks to write out at fractured locations.
> With a large block size, the FS knows it's been bad and can expect the
> rolled up newspaper, but it's not clear what it could do about it.
> 
> The small files issue looks like something we should be tackling today
> since writing out adjacent files would actually help us get bigger
> transfers.

ocfs2 can actually take significant advantage here, because we store
small file data in-inode.  This would grow our in-inode size from ~3K to
~15K or ~63K.  We'd actually have to do more work to start putting more
than one inode in a block (thought that would be a promising avenue too
once the coordination is solved generically.

Joel


-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

			http://www.jlbec.org/
			jlbec@evilplan.org
