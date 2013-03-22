Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423522Ab3CVXQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:16:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423395Ab3CVXQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:16:12 -0400
Date: Fri, 22 Mar 2013 16:16:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Paul Taysom <taysom@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>
Subject: Re: [dm-devel] dm: dm-cache fails to write the cache device in
 writethrough mode
Message-ID: <20130322231600.GD5357@blackbox.djwong.org>
References: <20130322201151.GB5357@blackbox.djwong.org>
 <20130322223425.GA5638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322223425.GA5638@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 06:34:28PM -0400, Mike Snitzer wrote:
> On Fri, Mar 22 2013 at  4:11pm -0400,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > The new writethrough strategy for dm-cache issues a bio to the origin device,
> > remaps the bio to the cache device, and issues the bio to the cache device.
> > However, the block layer modifies bi_sector and bi_size, so we need to preserve
> > these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> > problem where someone writes a block through the cache, but a subsequent reread
> > (from the cache) returns old contents.
> 
> Your writethrough blkid test results are certainly strange.  But I'm not
> aware of where the block layer would modify bi_size and bi_sector;
> please elaborate.
> 
> I cannot reproduce your original report.  I developed
> 'test_writethrough_ext4_uuids_match', apologies for the ruby code:

Hmm... I'm building my kernels off 0a7e453103b9718d357688b83bb968ee108cc874 in
Linus' tree (post 3.9-rc3).  This is the full output of dmsetup table:

moocache-blocks: 0 1039360 linear 8:16 9088
moocache-metadata: 0 8704 linear 8:16 384
moocache: 0 67108864 cache 253:0 253:1 8:0 512 1 writethrough default 4 random_threshold 4 sequential_threshold 32768

253:0 -> moocache-metadata and 253:1 -> moocache-blocks.

I'm curious what your setup is...

--D

> 
>   def test_writethrough_ext4_uuids_match
>     size = meg(10)
>   
>     # wipe the origin to ensure we don't accidentally have the same
>     # data on it.
>     with_standard_linear(:data_size => size) do |origin|
>       wipe_device(origin)
>     end
> 
>     uuid = "deadbeef-cafe-dead-beef-cafedeadbeef"
> 
>     # format the cache device with a specific uuid
>     with_standard_cache(:format => true,
>                         :io_mode => :writethrough,
>                         :data_size => size) do |cache|
>       fs = FS::file_system(:ext4, cache)
>       fs.format(:uuid => uuid)
>       FS::assert_fs_uuid(uuid, cache)
>     end
> 
>     # origin should have the same uuid as the cache
>     with_standard_linear(:data_size => size) do |origin|
>       FS::assert_fs_uuid(uuid, origin)
>     end
>   end
> 
> This test was committed to the 'devel' branch of my thinp-test-suite
> tree: git://github.com/snitm/thinp-test-suite.git
> 
> Also the existing 'test_writethrough' test works fine.
> 
> So for now:
> 
> Nacked-by: Mike Snitzer <snitzer@redhat.com>
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
