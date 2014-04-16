Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaDPGZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:25:24 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28805 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbaDPGZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:25:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AslSAFkhTlN5LEcvPGdsb2JhbABZgwaDU4UKtgyFXoEdFwMBAQEBODWCJQEBAQQ6HCMQCAMYCSUPBSUDBxoTh3vGQxcWjkwHhDgBA5hiimeLIys
Date: Wed, 16 Apr 2014 16:25:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 16/19] VFS: use GFP_NOFS rather than GFP_KERNEL in
 __d_alloc.
Message-ID: <20140416062520.GG15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
 <20140416040337.10604.61837.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416040337.10604.61837.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 02:03:37PM +1000, NeilBrown wrote:
> __d_alloc can be called with i_mutex held, so it is safer to
> use GFP_NOFS.
> 
> lockdep reports this can deadlock when loop-back NFS is in use,
> as nfsd may be required to write out for reclaim, and nfsd certainly
> takes i_mutex.

But not the same i_mutex as is currently held. To me, this seems
like a false positive? If you are holding the i_mutex on an inode,
then you have a reference to the inode and hence memory reclaim
won't ever take the i_mutex on that inode.

FWIW, this sort of false positive was a long stabding problem for
XFS - we managed to get rid of most of the false positives like this
by ensuring that only the ilock is taken within memory reclaim and
memory reclaim can't be entered while we hold the ilock.

You can't do that with the i_mutex, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
