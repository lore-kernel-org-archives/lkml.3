Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3CWVJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 17:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3CWVJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 17:09:05 -0400
Date: Sat, 23 Mar 2013 17:08:53 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Paul Taysom <taysom@chromium.org>
Subject: Re: dm: dm-cache fails to write the cache device in writethrough mode
Message-ID: <20130323210853.GA12164@redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org>
 <20130322223425.GA5638@redhat.com>
 <20130322231600.GD5357@blackbox.djwong.org>
 <20130323032715.GA7692@redhat.com>
 <20130323051549.GE5357@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323051549.GE5357@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23 2013 at  1:15am -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Fri, Mar 22, 2013 at 11:27:16PM -0400, Mike Snitzer wrote:
> > On Fri, Mar 22 2013 at  7:16pm -0400,
> > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > > On Fri, Mar 22, 2013 at 06:34:28PM -0400, Mike Snitzer wrote:
> > > > On Fri, Mar 22 2013 at  4:11pm -0400,
> > > > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > > 
> > > > > The new writethrough strategy for dm-cache issues a bio to the origin device,
> > > > > remaps the bio to the cache device, and issues the bio to the cache device.
> > > > > However, the block layer modifies bi_sector and bi_size, so we need to preserve
> > > > > these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> > > > > problem where someone writes a block through the cache, but a subsequent reread
> > > > > (from the cache) returns old contents.
> > > > 
> > > > Your writethrough blkid test results are certainly strange.  But I'm not
> > > > aware of where the block layer would modify bi_size and bi_sector;
> > > > please elaborate.
> > > > 
> > > > I cannot reproduce your original report.  I developed
> > > > 'test_writethrough_ext4_uuids_match', apologies for the ruby code:
> > > 
> > > Hmm... I'm building my kernels off 0a7e453103b9718d357688b83bb968ee108cc874 in
> > > Linus' tree (post 3.9-rc3).  This is the full output of dmsetup table:
> > > 
> > > moocache-blocks: 0 1039360 linear 8:16 9088
> > > moocache-metadata: 0 8704 linear 8:16 384
> > > moocache: 0 67108864 cache 253:0 253:1 8:0 512 1 writethrough default 4 random_threshold 4 sequential_threshold 32768
> > > 
> > > 253:0 -> moocache-metadata and 253:1 -> moocache-blocks.
> > > 
> > > I'm curious what your setup is...
> > 
> > Here are the tables:
> > test-dev-238267: 0 8192 linear /dev/stec/metadata 0
> > test-dev-255913: 0 2097152 linear /dev/stec/metadata 8192
> > test-dev-655144: 0 20480 linear /dev/spindle/data 0
> > 0 20480 cache /dev/mapper/test-dev-238267 /dev/mapper/test-dev-255913 /dev/mapper/test-dev-655144 512 1 writethrough default 0
> > 
> > And I tweaked 'test_writethrough_ext4_uuids_match' to make sure to use the
> > same thresholds you're using, full status output:
> > 0 20480 cache 15/1024 0 19 0 0 0 0 0 0 1 writethrough 2 migration_threshold 32768 4 random_threshold 4 sequential_threshold 512
> > 
> > So the big difference is the thinp-test-suite uses intermediate linear
> > DM layers above the slower sd device (spindle/data) -- whereas in your
> > setup the origin device is direct to sd (8:0).
> > 
> > I'll re-run with the origin directly on sd in the morning and will
> > report back.
> 
> Interesting ... if I set up this:
> 
> # echo "0 67108864 linear /dev/sda 0" | dmsetup create origin
> 
> And then repeat the test, but using /dev/mapper/origin as the origin instead
> of /dev/sda, the problem goes away.

Using the extra dm-linear layer is implicitly leveraging the DM core's
bio cloning to restore the original bio that was sent to the linear
target.

But even after having changed my test to use /dev/sdb for the origin
device I cannot reproduce the problem you've reported.  Do you have any
further details on how/why the bios are being altered?  Are you
reliably hitting partial completions within the origin's driver?  If so
how?

Having looked at this for a bit it seems pretty clear writethrough_endio
is missing partial completion handling, e.g.:
   if (!bio_flagged(bio, BIO_UPTODATE) && !err)
      err = -EIO;

But I haven't yet come to terms with what the partial completion
handling implementation needs to be for the writethrough support.
