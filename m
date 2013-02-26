Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab3BZUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:52:49 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:32479 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759674Ab3BZUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:52:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhcJAEMgLVF5LKqk/2dsb2JhbABFhWa2dIUbfxdzgh8BAQQBOhwjBQsIAw4KCSUPBSUDIROIDQXAGxWOICI9B4NAA5Y/iWSHBYMc
Date: Wed, 27 Feb 2013 07:52:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tony Lu <zlu@tilera.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <dchinner@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
 xlog_bread_noalign()
Message-ID: <20130226205241.GT5551@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
 <20130223000802.GB26081@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
 <20130223235546.GA5551@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
 <20130224141017.GC5551@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 07:28:19AM +0000, Tony Lu wrote:
> I get a reliable way to reproduce this bug. The logprint and metadump are attached.
> 
> Kernel version: 2.6.38.8

This is important....

....

.... because this:

> 4 umount /dev/sda1 /mnt
> 5 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> Ending XFS recovery on filesystem: sda1 (logdev: internal)

Indicates that the unmount record is either not being written, it is
being written when there log has not been fully flushed or log
recovery is not finding it. You need to copy out the log
first to determine what the state of the log is before you mount the
filesystem - that way if log recovery is run you can see whether it
was supposed to run. (i.e. a clean log should never run recovery,
and unmount should always leave a clean log).

Either way, I'm more than 10,000 iterations into a run of 100k
iterations of this script on 3.8.0, and I have not seen a single log
recovery attempt occur. That implies you are seeing a bug in 2.6.38
that has since been fixed. It would be a good idea for you to
upgrade the system to a 3.8 kernel and determine if you can still
reproduce the problem on your system - that way we'll know if the
bug really has been fixed or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
