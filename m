Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaBCXTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:19:33 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:51379 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbaBCXTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:19:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsIAHgj8FJ5LGaB/2dsb2JhbABZgwyDPrYRhVKBDBd0giUBAQUnExwjEAgDDgcDCSUPBSUDIROIBM4fFxaOcgeEOASYKZIig0Eo
Date: Tue, 4 Feb 2014 10:17:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH RESEND 5/10] xfstest: shared/001: Standard collapse range
 tests
Message-ID: <20140203231737.GV13997@dastard>
References: <1391319958-3275-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391319958-3275-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 02:45:58PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This testcase(001) tries to test various corner cases
> for fcollapse range functionality over different type of extents.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Couple of things:

>  			-c "$map_cmd -v" $testfile | $filter_cmd
>  		[ $? -ne 0 ] && die_now
>  		_md5_checksum $testfile
> @@ -415,10 +425,10 @@ _test_generic_punch()
>  		if [ "$remove_testfile" ]; then
>  			rm -f $testfile
>  		fi
> -		$XFS_IO_PROG -f -c "truncate 20k" \
> -			-c "$alloc_cmd 0 8k" \
> -			-c "pwrite 8k 8k" $sync_cmd \
> -			-c "$zero_cmd 4k 8k" \
> +		$XFS_IO_PROG -f -c "truncate $(($multiple * 20))k" \
> +			-c "$alloc_cmd 0 $(($multiple * 8))k" \
> +			-c "pwrite $(($multiple * 8))k $(($multiple * 8))k" $sync_cmd \
> +			-c "$zero_cmd $(($multiple * 4))k $(($multiple * 8))k" \
>  			-c "$map_cmd -v" $testfile | $filter_cmd

This is unreadable, and therefore I'd consider that these changes
render _test_generic_punch unmaintainable.

Either it needs tobe factored to be more readable, or we need a more
readable way of representing the offsets and sizes if we want them
to be variable. For example:

_4k="$((multiple * 4))k"
_8k="$((multiple * 8))k"
_20k="$((multiple * 20))k"

leads to:

		$XFS_IO_PROG -f -c "truncate $_20k" \
			-c "$alloc_cmd 0 $_8k" \
			-c "pwrite $_8k $_8k" $sync_cmd \
			-c "$zero_cmd $_4k $_8k" \
			-c "$map_cmd -v" $testfile | $filter_cmd

which is still readable and allows us to arbitrarily scale the
parameters. It even allows us to handle different filesystem block
sizes if we really want to....

>  		-c "$map_cmd -v" $testfile | $filter_cmd
>  	[ $? -ne 0 ] && die_now
>  	_md5_checksum $testfile
>  
> +	# If zero_cmd is fcollpase, don't check unaligned offsets
> +	if [ "$zero_cmd" == "fcollapse" ]; then
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +			rm -f $testfile.2
> +		fi
> +		return
> +	fi

No need to remove the test files here - we remove them at
test startup to ensure we have a known initial state....

> +0: [0..63]: extent
> +bb7df04e1b0a2570657527a7e108ae23
> +	13. data -> unwritten -> data
> +0: [0..63]: extent
> +0f0151cbed83e4bf6e5bde26e82ab115
> +	14. data -> hole @ EOF
> +fallocate: Invalid argument
> +0: [0..159]: extent

This error appears in all the golden outputs. If it's correct, then
perhaps it should be filtered out or commented somewhere to explain
why it is expected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
