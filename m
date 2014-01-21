Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaAUEqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 23:46:47 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6208 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbaAUEqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 23:46:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHAOX63VJ5LKVw/2dsb2JhbABZgwu3FYVSgQwXdIIlAQEBAwE6HCMFCwgDDgoJJQ8FJQMhE4d9B8QGFxaOIEkHgySBFASYIZIZg0EogS0
Date: Tue, 21 Jan 2014 15:46:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: Dirty deleted files cause pointless I/O storms (unless truncated
 first)
Message-ID: <20140121044632.GA25923@dastard>
References: <CALCETrVT29DULWg16_oKpGgSSBwZh-yWtygV1oYjH5iQH5jGyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVT29DULWg16_oKpGgSSBwZh-yWtygV1oYjH5iQH5jGyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 04:59:23PM -0800, Andy Lutomirski wrote:
> The code below runs quickly for a few iterations, and then it slows
> down and the whole system becomes laggy for far too long.
> 
> Removing the sync_file_range call results in no I/O being performed at
> all (which means that the kernel isn't totally screwing this up), and
> changing "4096" to SIZE causes lots of I/O but without
> the going-out-to-lunch bit (unsurprisingly).

More details please. hardware, storage, kernel version, etc.

I can't reproduce any slowdown with the code as posted on a VM
running 3.31-rc5 with 16GB RAM and an SSD w/ ext4 or XFS. The
workload is only generating about 80 IOPS on ext4 so even a slow
spindle should be able handle this without problems...

> Surprisingly, uncommenting the ftruncate call seems to fix the
> problem.  This suggests that all the necessary infrastructure to avoid
> wasting time writing to deleted files is there but that it's not
> getting used.

Not surprising at all - if it's stuck in a writeback loop somewhere,
truncating the file will terminate writeback because it end up being
past EOF and so stops immediately...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
