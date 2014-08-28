Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaH1PNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:13:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:35861 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaH1PM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:12:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,418,1406617200"; 
   d="scan'208";a="591178053"
Date: Thu, 28 Aug 2014 11:11:26 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/5] brd: Add getgeo to block ops
Message-ID: <20140828151126.GI3285@linux.intel.com>
References: <53FDF7AD.5000709@plexistor.com>
 <53FDF919.6020006@plexistor.com>
 <20140827175327.GF3285@linux.intel.com>
 <53FED9A7.3020608@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FED9A7.3020608@plexistor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 10:26:31AM +0300, Boaz Harrosh wrote:
> On 08/27/2014 08:53 PM, Matthew Wilcox wrote:
> > On Wed, Aug 27, 2014 at 06:28:25PM +0300, Boaz Harrosh wrote:
> >> We set all hd_geometry members to 1, because this way fdisk
> >> math will not try its crazy geometry math and get stuff totally wrong.
> >>
> >> I was trying to get some values that will make fdisk Want to align
> >> first sector on 4K (like 8, 16, 20, ... sectors) but nothing worked,
> >> I searched the net the math is not your regular simple multiplication
> >> at all.
> >>
> >> If you managed to get these please tell me. I would love to solve
> >> this.
> >>
> >> But for now we use 4k physical sectors for fixing fdisk alignment
> >> issues, and setting these here to something that will not make
> >> fdisk serve us with crazy numbers.
> > 
> > Are you saying that fdisk ignores the 4k physical sectors (that you set up
> > in patch 5/5) in favour of the geometry exposed here?  That doesn't make
> > sense to me, since it would misalign 4k-physical ATA drives if it did.
> > 
> 
> No with patch 5/5 the 4k stuff is good.
> 
> What I'm saying is that with (64, 32, x) fdisk offers a very high first
> sector and with all 1(s) it will allow a low value like 4k
> 
> For example with (64, 32, x) + the 4k patch in 5/5 with a 4M brd disk it
> will offer 40 (20K) as first possible sector.
> 
> With this patch applied it will offer 8 (4K) as first sector, which is what
> I want

That makes for a much better changelog entry than what you wrote above :-)

> > I don't see anywhere else in the kernel reporting (1,1,1).  The most common
> > form to fake a geometry uses (64, 32, x), including SCSI.
> >
> 
> But is it wrong? why?
> 
> I guess that until now no one cared about wasted space at the beginning
> but with brd I do. Your words this is all "fake" then why at all.
> With all 1(s) the CHS convoluted math just disappears and gets out of the
> way.

It is all fake.  Nobody's reported their real CHS geometry in twenty
years.  A drive's geometry has been more complex than a fixed number
of sectors per track, and anyway the hd_geometry struct tops out at
describing a 500GB drive (with 63 heads and 255 sectors).

My concern is that clearly (64, 32, x) works since other drivers are
doing it.  (1, 1, 1) is stepping into the unknown, and we don't know
what applications are going to make of this value.

This really needs to be something that's handled by the block midlayer.
Forcing drivers to make this stuff up is only leading to pain and
suffering.  Drivers that don't have a getgeo method should be given a
default geometry that makes all known users of getgeo do the right thing.

