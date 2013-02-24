Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3BXOK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 09:10:28 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1233 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869Ab3BXOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 09:10:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoJADQeKlF5LJ7I/2dsb2JhbABFvD2FE4EHF3OCHwEBBAE6HCMFCwgDDgoJJQ8FJQMhE4gNBb4rFY4aIj0Hgl9hA5Y8iWKHBIMb
Date: Mon, 25 Feb 2013 01:10:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tony Lu <zlu@tilera.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <dchinner@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
 xlog_bread_noalign()
Message-ID: <20130224141017.GC5551@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
 <20130223000802.GB26081@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
 <20130223235546.GA5551@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 04:46:30AM +0000, Tony Lu wrote:
> >> For example, if xlog_bread_noalign() wants to read blocks from #1
> >> to # 9, in which case the passed parameter blk_no is 1, and nbblks
> >> is 8, sectBBsize is 8, after the round down and round up
> >> operations, we get blk_no as 0, and nbblks as still 8. We
> >> definitely lose the last block of the log data.
> >
> >Yes, I fully understand that. But I also understand how the log
> >works and that this behaviour *should not happen*. That's why
> >I'm asking questions about what the problem you are trying to fix.
> 
> I am not sure about this, since I saw many reads on
> non-sector-align blocks even when successfully mounting good XFS
> partitions.

I didn't say that non-sector align reads should not be attempted by
log recovery - it's obvious from the on disk format of the log that
we have to parse it in chunks of 512 bytes to make sense of it's
contents, and that leads to the 512 byte reads and other subsequent
unaligned reads.

*However*

Seeing that there are unaligned reads occurring does not mean that
the structures in the log should be unaligned. Your test output
indicated a log record header at an unaligned block address, and
that's incorrect. It doesn't matter what the rest of the log
recovery code does with non-aligned IO - the fact is that your debug
implies that the contents of the log is corrupt and that implies a
deeper problem....

> And also there is code in xlog_write_log_records() which handles
> non-sector-align reads and writes.

Yes, it does handle it, but that doesn't mean that it is correct to
pass unaligned block ranges to it.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
