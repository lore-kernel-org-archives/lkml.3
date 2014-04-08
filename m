Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaDHBXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:23:30 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:64821 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbaDHBX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:23:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmpVAFxOQ1N5LEcvPGdsb2JhbABZgwaDSoULtwuFX4EjFwMBAQEBODWCJQEBAQMBOhwjBQsIAxgJJQ8FJQMHGhOHcQfLNhcWjlsHgySBFASOXYl9lgIrgSwk
Date: Tue, 8 Apr 2014 11:23:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: Re: xfstest for renameat2 system call (was: [PATCH 00/13] cross
 rename v4)
Message-ID: <20140408012322.GA22917@dastard>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <20140210105145.GW13997@dastard>
 <20140211160141.GD8204@tucsk.piliscsaba.szeredi.hu>
 <20140212171852.GA4026@tucsk.piliscsaba.szeredi.hu>
 <20140217081911.GZ13647@dastard>
 <20140319135706.GA24182@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319135706.GA24182@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 02:57:06PM +0100, Miklos Szeredi wrote:
> Hi Dave,
> 
> On Mon, Feb 17, 2014 at 07:19:11PM +1100, Dave Chinner wrote:
> > On Wed, Feb 12, 2014 at 06:18:52PM +0100, Miklos Szeredi wrote:
> > > On Tue, Feb 11, 2014 at 05:01:41PM +0100, Miklos Szeredi wrote:
> > > > On Mon, Feb 10, 2014 at 09:51:45PM +1100, Dave Chinner wrote:
> > > 
> > > > > Miklos, can you please write an xfstest for this new API? That way
> > > > > we can verify that the behaviour is as documented, and we can ensure
> > > > > that when we implement it on other filesystems it works exactly the
> > > > > same on all filesystems?
> > > 
> > > This is a standalone testprog, but I guess it's trivial to integrate into
> > > xfstests.
> > 
> > Same problem with integrating any standalone test program into
> > xfstests - we end up with a standalone pass/fail test instead of a
> > bunch of components we can reuse and refactor for other tests.  But
> > we can work around that for the moment.
> > 
> > [ FWIW, the normal way to write an xfstest like this is to write a
> > small helper program that just does the renameat2() syscall (we
> > often use xfs_io to provide this) and everything is just shell
> > scripts to drive the helper program in the necessary way. We don't
> > directly check that mode, size, destination of a file is correct -
> > just stat(1) on the expected destinations is sufficient to capture
> > this information. stdout is captured by the test harness and used to match
> > against a golden output. If the match fails, the test fails.
> > 
> > This would allow us to use the same test infrastructure for testing
> > a coreutils binary that implemented renameat2 when that comes
> > along... ]
> 
> Okay, here's a patch for xfstests implementing the above.
> 
> The renameat2 patches aren't merged yet, but I hope they will be in the 3.15
> cycle.  Until then this is just an RFC.

Hi Miklos,

Is renameat2 likely to be merged this cycle? If so, can you resubmit
this series to xfs@oss.sgi.com as a patch per test? Some other
comments are below.

> index 0000000..e235c4c
> --- /dev/null
> +++ b/common/renameat2
> @@ -0,0 +1,128 @@
> +######
> +#
> +# renameat2 helpers
....

tab indents (8 spaces), please.

.....
> +_rename_tests()
> +{
> +    flags=$1
> +
> +    #same directory renames
> +    _rename_tests_source_dest $tmp/src $tmp/dst     "samedir "
> +
> +    #cross directory renames
> +    mkdir $tmp/x $tmp/y
> +    _rename_tests_source_dest $tmp/x/src $tmp/y/dst "crossdir"
> +    rmdir $tmp/x $tmp/y
> +}

The way you are using $tmp in these tests is wrong. $tmp is used by
the test harness for temporary files that we don't want to impact
the running of a test. Hence using $tmp as the location for the test
is incorrect. You should pass the test directory into this function

_rename_tests()
{
	local testdir=$1
	local flags=$2

	#same directory renames
	_rename_tests_source_dest $testdir/src $testdir/dst "samedir "

	#cross directory renames
	mkdir $testdir/x $testdir/y
	_rename_tests_source_dest $testdir/x/src $testdir/y/dst "crossdir"
	rmdir $testdir/x $testdir/y
}

> diff --git a/tests/generic/323 b/tests/generic/323
> new file mode 100755
> index 0000000..1f17246
> --- /dev/null
> +++ b/tests/generic/323
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# FS QA Test No. 323

FS QA Test No. generic/323

> +#
> +# Check renameat2 syscall without flags
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Miklos Szeredi.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=$TEST_DIR/$$

The reason this is wrong is that there is no guarantee that
$TEST_DIR is defined here or that it remains mounted throughout the
test. Lots of internal functions rely on $tmp always being there and
anything written there can always be found, and we can unmount
TEST_DIR in the middle of tests.  Hence:

tmp=/tmp/$$

is the usual location for $tmp.

> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/renameat2
> +
> +_supported_fs generic
> +_supported_os Linux
> +
> +_requires_renameat2
> +
> +# real QA test starts here
> +
> +mkdir $tmp
> +_rename_tests
> +rmdir $tmp

rename_dir=$TEST_DIR/$$
mkdir -p $rename_dir
_rename_tests $rename_dir
rmdir $rename_dir

The other tests need the same fixes, but otherwise they look OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
