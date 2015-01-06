Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbbAFTKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:10:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbbAFTKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:10:21 -0500
Date: Tue, 6 Jan 2015 14:10:10 -0500
From: Brian Foster <bfoster@redhat.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH v7 9/11] xfstests: generic/043: Test multiple fallocate
 insert/collapse range calls
Message-ID: <20150106191010.GJ5874@bfoster.bfoster>
References: <004701d02670$73dcb0a0$5b9611e0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004701d02670$73dcb0a0$5b9611e0$@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 06:42:41PM +0900, Namjae Jeon wrote:
> This testcase(043) tries to test finsert range a single alternate block
> mulitiple times and test merge code of collase range.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Cc: Brian Foster <bfoster@redhat.com>
> ---
>  tests/generic/043     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/043.out |   7 ++++
>  tests/generic/group   |   1 +
>  3 files changed, 115 insertions(+)
>  create mode 100644 tests/generic/043
>  create mode 100644 tests/generic/043.out
> 
> diff --git a/tests/generic/043 b/tests/generic/043
> new file mode 100644
> index 0000000..6aebc1e
> --- /dev/null
> +++ b/tests/generic/043
> @@ -0,0 +1,107 @@
> +#! /bin/bash
> +# FS QA Test No. generic/043
> +#
> +# Test multiple fallocate insert/collapse range calls on same file.
> +# For different blocksizes, Call insert range a single alternate block
> +# multiple times until the file is left with 100 extents and as much
> +# number of extents. And Call collapse range about the previously inserted
> +# ranges to test merge code of collapse range.
> +# Also check for file system consistency after completing this operation
> +# for each blocksize.
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Samsung Electronics.  All Rights Reserved.
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
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_scratch
> +_require_xfs_io_command "fiemap"
> +_require_xfs_io_command "finsert"
> +_require_xfs_io_command "fcollapse"
> +_do_die_on_error=y
> +testfile=$SCRATCH_MNT/$seq.$$
> +BLOCKS=100
> +
> +for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
> +
> +	length=$(($BLOCKS * $BSIZE))
> +	case $FSTYP in
> +	xfs)
> +	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
> +	;;
> +	ext4)
> +	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
> +	;;
> +	esac

I think we typically try to define things like blocksize in the test
configuration. The MKFS_OPTIONS env. var. can be defined with the
correct options for the associated fs being tested. That eliminates the
need to loop and for the fs-specific _scratch_mkfs calls above.

> +	_scratch_mount >> $seqres.full 2>&1
> +
> +	# Write file
> +	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
> +
> +
> +	# Insert alternate blocks 

Trailing space in the above comment.

> +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> +		offset=$((($j*$BSIZE)*2))
> +		$XFS_IO_PROG -c "finsert $offset $BSIZE" $testfile > /dev/null
> +	done
> +
> +	# Check if 100 extents are present
> +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> +
> +	_check_scratch_fs
> +	if [ $? -ne 0 ]; then
> +		status=1
> +		exit
> +	fi
> +
> +	# Collapse alternate blocks 

... and here as well.

> +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> +		offset=$((($j*$BSIZE)))
> +		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
> +	done
> +
> +	# Check if 1 extents are present
> +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> +
> +	_check_scratch_fs
> +	if [ $? -ne 0 ]; then
> +		status=1
> +		exit
> +	fi
> +

Maybe create a copy of the original file before we run through the
insert and collapse sequence and cmp the files here as a last step?

Brian

> +	umount $SCRATCH_MNT
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/043.out b/tests/generic/043.out
> new file mode 100644
> index 0000000..fd4b804
> --- /dev/null
> +++ b/tests/generic/043.out
> @@ -0,0 +1,7 @@
> +QA output created by 043
> +100
> +1
> +100
> +1
> +100
> +1
> diff --git a/tests/generic/group b/tests/generic/group
> index c0944b3..0a10bdd 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -45,6 +45,7 @@
>  040 auto quick prealloc
>  041 auto quick prealloc
>  042 auto quick prealloc
> +043 auto quick prealloc
>  053 acl repair auto quick
>  062 attr udf auto quick
>  068 other auto freeze dangerous stress
> -- 
> 1.8.5.5
> 
