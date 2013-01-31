Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3AaEIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:08:09 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54359 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470Ab3AaEIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:08:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAFAFLsCVG2/3vK/2dsb2JhbAArGoVfuTwWc4IeAQEEATo0CwULCAMNCwklDwUoIROICwUNLME8kQwDlgyGEQOKOIML
Date: Thu, 31 Jan 2013 15:07:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com, linux-xfs@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.8-rc5 xfs corruption
Message-ID: <20130131040748.GH32297@disturbed.disaster>
Mail-Followup-To: CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com,
	linux-xfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <614607656.11545086.1359601991846.JavaMail.root@redhat.com>
 <473604401.11548931.1359602207833.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473604401.11548931.1359602207833.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 10:16:47PM -0500, CAI Qian wrote:
> Hello,
> 
> (Sorry to post to xfs mailing lists but unsure about which one is the
> best for this.)

Trimmed to just xfs@oss.sgi.com.

> I have seen something like this once during testing on a system with a
> EMC VNX FC/multipath back-end.

This is a trace from the verifier code that was added in 3.8-rc1 so
I doubt it has anything to do with any problem you've seen in the
past....

Can you tell us what workload you were running and what hardware you
are using as per:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

As it is, if you mounted the filesystem after this problem was
detected, log recovery probably propagated it to disk. I'd suggest
that you run xfs_repair -n on the device and post the output so we
can see if any corruption has actaully made it to disk. If no
corruption made it to disk, it's possible that we've got the
incorrect verifier attached to the buffer.

> [ 3025.063024] ffff8801a0d50000: 2e 2e 2f 2e 2e 2f 75 73 72 2f 6c 69 62 2f 6d 6f  ../../usr/lib/mo 

The start of a block contains a path and the only
type of block that can contain this format of metadata is remote
symlink block. Remote symlink blocks don't have a verifier attached
to them as there is nothing that can currently be used to verify
them as correct.

I can't see exactly how this can occur as stale buffers have the
verifier ops cleared before being returned to the new user, and
newly allocated xfs_bufs are zeroed before being initialised. I
really need to know what you are doing to be able to get to the
bottom of it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
