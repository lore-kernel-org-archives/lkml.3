Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab3BXEqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 23:46:37 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:58499 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab3BXEqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 23:46:36 -0500
From: Tony Lu <zlu@tilera.com>
To: Dave Chinner <david@fromorbit.com>
CC: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <dchinner@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: RE: [PATCH] xfs: Fix possible truncation of log data in
 xlog_bread_noalign()
Thread-Topic: [PATCH] xfs: Fix possible truncation of log data in
 xlog_bread_noalign()
Thread-Index: Ac4Q1GkSs67IJq+zR5aVm2NJSgVsAwAr1ggAACdj+ZYACHDHQA==
Date: Sun, 24 Feb 2013 04:46:30 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
 <20130223000802.GB26081@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
 <20130223235546.GA5551@dastard>
In-Reply-To: <20130223235546.GA5551@dastard>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> For example, if xlog_bread_noalign() wants to read blocks from #1
>> to # 9, in which case the passed parameter blk_no is 1, and nbblks
>> is 8, sectBBsize is 8, after the round down and round up
>> operations, we get blk_no as 0, and nbblks as still 8. We
>> definitely lose the last block of the log data.
>
>Yes, I fully understand that. But I also understand how the log
>works and that this behaviour *should not happen*. That's why
>I'm asking questions about what the problem you are trying to fix.

I am not sure about this, since I saw many reads on non-sector-align blocks even when successfully mounting good XFS partitions. 
-sh-4.1# mount /dev/sda3 /home/
XFS (sda3): Mounting Filesystem
xlog_bread_noalign:blk_no=0,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=61447,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=0,nbblks=1,l_sectBBsize=8
.......
xlog_bread_noalign:blk_no=8695,nbblks=1,l_sectBBsize=8
xlog_bread_noalign:blk_no=4600,nbblks=4096,l_sectBBsize=8
xlog_bread_noalign:blk_no=8184,nbblks=512,l_sectBBsize=8

And also there is code in xlog_write_log_records() which handles non-sector-align reads and writes.

	/* We may need to do a read at the start to fill in part of
	 * the buffer in the starting sector not covered by the first
	 * write below.
	 */
	balign = round_down(start_block, sectbb);
	if (balign != start_block) {
		error = xlog_bread_noalign(log, start_block, 1, bp);
		if (error)
			goto out_put_bp;

		j = start_block - balign;
	}

>Ramdisks don't persist over a reboot, so you must have had some
>other way of reproducing the problem. Can you tell me how you
>reproduced it on a ramdisk? Better yet, send me a script that
>reproduces the problem?

I will try to reproduce it. Basically it is a loop of mount, creating many files and unmount.

Thanks
-Tony
