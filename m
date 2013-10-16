Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab3JPK04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:26:56 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6739 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760625Ab3JPK0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:26:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkHANhoXlJ5LFuj/2dsb2JhbABagwe9VIVEgSAXdIIlAQEFJxMcIxAIAw4KCSUPBSUDIROIBb5hFo87B4MfgQYDmAOKQIdDgzgo
Date: Wed, 16 Oct 2013 21:26:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fs/attr.c:notify_change locking warning.
Message-ID: <20131016102651.GF4446@dastard>
References: <20131005005210.GA25773@redhat.com>
 <20131005031918.GL4446@dastard>
 <20131015201905.GA7509@infradead.org>
 <20131015213618.GU4446@dastard>
 <20131016070528.GB18721@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016070528.GB18721@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:05:28AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 16, 2013 at 08:36:18AM +1100, Dave Chinner wrote:
> > Sure, but file_remove_suid() doesn't actually modify any VFS inode
> > structures until we process the flags and the modifications within
> > ->setattr, which in XFS are all done under the XFS_ILOCK_EXCL via
> > xfs_setattr_mode(). i.e. both the VFS and XFS inodes S*ID bits are
> > removed only under XFS_ILOCK_EXCL....
> 
> It can set S_NOSEC after calling into ->setattr at least.
> 
> > Hence I see no point in adding extra serialisation via the i_mutex
> > to this path when we can just do something like:
> > 
> > 	killsuid = should_remove_suid(file->f_path.dentry);
> > 	if (killsuid) {
> > 		struct iattr	newattr;
> > 
> > 		newattr.ia_valid = ATTR_FORCE | killsuid;
> > 		error = xfs_setattr_nonsize(ip, &newattr, 0);
> > 		if (error)
> > 			return error;
> > 	}
> 
> We'd still need all the other magic in file_remove_suid, which I don't
> actually quite undersdtand fully yet.

The killpriv calls? I couldn't find anything that implemented those
security hooks nor any documentation about it, so I'm pretty much
clueless about it. FWIW, ocfs2 doesn't implement them, either....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
