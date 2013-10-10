Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3JJKBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:01:10 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39461 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3JJKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131009233421.GQ4446@dastard>
References: <1381090432-2863-1-git-send-email-linkinjeon@gmail.com>
	<20131009233421.GQ4446@dastard>
Date: Thu, 10 Oct 2013 19:01:01 +0900
Message-ID: <CAKYAXd84D8XpYTDZuaY=rUzZdyxSD0NKaV8nCkYvj_XRs_gV_Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 5/7] xfstest: Add test case to check various corner
 cases for collapsing range
From: Namjae Jeon <linkinjeon@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#
>> +_test_generic_collapse()
>> +{
>
> This function is just a copy and paste of _test_generic_punch() with
> all the ranges increased by a factor of 4. Why can't you simply use
> _test_generic_punch() and pass in a different $zero_cmd?
Yes, you're right. We can use test_generic_punch as you said.
I will update.
>
>
>>
>> +# check that xfs_io, kernel and filesystem all support fallocate with collapse
>> +# range
>> +_require_xfs_io_falloc_collapse()
>> +{
>> +     testfile=$TEST_DIR/$$.falloc
>> +     testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
>> +             -c "fcollapse 4k 8k" $testfile 2>&1`
>
> No need for the -F parameter anymore.
Okay.

>
>> +     rm -f $testfile 2>&1 > /dev/null
>> +     echo $testio | grep -q "not found" && \
>> +             _notrun "xfs_io fallocate collapse range support is missing"
>> +     echo $testio | grep -q "Operation not supported" && \
>> +             _notrun "xfs_io fallocate collapse range failed (no fs support?)"
>> +}
>> +
>>  # check that xfs_io, kernel and filesystem support fiemap
>>  _require_xfs_io_fiemap()
>>  {
>> diff --git a/tests/shared/316 b/tests/shared/316
>> new file mode 100644
>> index 0000000..66a8489
>> --- /dev/null
>> +++ b/tests/shared/316
>
> You don't need to number this 316. shared/001 is not taken, so start
> there....
okay.

>
>> @@ -0,0 +1,70 @@
>> +#! /bin/bash
>> +# FS QA Test No. 316
>> +#
>> +# Test fallocate collapse range
>
> A more verbose test description is preferred. A paragraph describing
> that the test exercises boundary conditions across different extent
> types for the FALLOC_FL_COLLAPSE_RANGE operation would be ideal.
Okay.

>
>> +trap "_cleanup ; exit \$status" 0 1 2 3 15
>> +
>> +# get standard environment, filters and checks
>> +# we need to include common/punch to get defination fo filter functions
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/punch
>> +. ./common/collapse
>> +
>> +# real QA test starts here
>> +_supported_fs xfs ext4
>> +_supported_os Linux
>> +
>> +_require_xfs_io_falloc_punch
>> +_require_xfs_io_falloc
>> +_require_xfs_io_fiemap
>> +_require_xfs_io_falloc_collapse
>> +
>> +testfile=$TEST_DIR/316.$$
>
> If you are going to use the test number to identify the file, you
> should use $seq rather than hard coding the number....
Okay.

>
>> +# Standard collapse range tests
>> +_test_generic_collapse falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
>> +
>> +# Delayed allocation collapse range tests
>> +_test_generic_collapse -d falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
>> +
>> +# Multi collapse tests
>> +_test_generic_collapse -k falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
>> +
>> +# Delayed allocation multi collapse range tests
>> +_test_generic_collapse -d -k falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
>
> What I'd prefer is each of these is a separate unit test. i.e:
>
> shared/001: Standard collapse range tests
> shared/002: Delayed allocation collapse range tests
> shared/003: Multi collapse tests
> shared/004: Delayed allocation multi collapse range tests
>
> The reason for doing this is that it means that:
>
>         a) we can track failures of the different types of tests
>            independently; and
>         b) the filesystem the tests are being run on is checked for
>            consistency between each test
>
> I know, the punch tests you copied this from lump them all into the
> one test, but I'd really like to get away from the complex tests
> that aggregate lots of different things into a single pass/fail test
> as it makes it hard to isolate failures and track them over the long
> term...
>
Okay, I will do it as your suggestion.

>> +
>> +status=0 ; exit
>
> separate lines
>
>> diff --git a/tests/shared/group b/tests/shared/group
>> index 0ad640b..3a69294 100644
>> --- a/tests/shared/group
>> +++ b/tests/shared/group
>> @@ -11,4 +11,4 @@
>>  289 auto quick
>>  298 auto trim
>>  305 aio dangerous enospc rw stress
>> -
>> +316 auto quick collapse
>
> I'd put this in the prealloc group rather than create a new one
> called "collapse".
Okay.

Thanks for review.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
