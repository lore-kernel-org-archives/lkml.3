Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3EUXyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:54:55 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64935 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab3EUXyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:54:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwOAJwInFF5LNn3/2dsb2JhbABagwi8eoUcBAGBBRd0giMBAQUnExwzCAMYCSUPBSUDIQESiAy7bhaNZ4Ekg1QDlzeRQYMhKg
Date: Wed, 22 May 2013 09:54:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130521235410.GY29466@dastard>
References: <20130521225257.GA12713@redhat.com>
 <20130521233429.GW29466@dastard>
 <20130521234016.GB14347@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521234016.GB14347@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 07:40:16PM -0400, Dave Jones wrote:
> On Wed, May 22, 2013 at 09:34:29AM +1000, Dave Chinner wrote:
>  > On Tue, May 21, 2013 at 06:52:57PM -0400, Dave Jones wrote:
>  > > [  464.210598] XFS: Assertion failed: (mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID| ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 719
>  > 
>  > Never seen that fire before, but this is why we have ASSERT()s like
>  > this - we're being handed something by the VFS we don't expect...
>  > 
>  > Can you give me some context of the file permissions before the
>  > syscall and what the syscall parameters are? i.e. is this likely to
>  > be trying to strip SUID/SGID during the truncate operation?
> 
> no idea tbh. Is there something I can add to that assert to dump
> which file it was triggered by ?

Convert the assert to a if (), and then in the body do something
like:

	if (mask & (...) {
		char buf[MAX_PATHLEN];

		d_path(VFS_I(ip)->i_dentry, buf, MAXPATHLEN);
		xfs_warn(mp, "%s: mask 0x%x mismatch on file %s\n",
			 __func__, mask, buf);
		ASSERT(0);
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
