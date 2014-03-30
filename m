Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaC3Xo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:44:29 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58095 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893AbaC3XoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:44:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai1lAMqrOFN5LEcvPGdsb2JhbABYgwY7gw+nOAWZIIERFwMBAQEBODWCJQEBAQQnExwzCAMYCSUPBSUDBxoBEod4DtB4FxaOGAEBVoMkgRQEmE2BNIkpix0pgTU
Date: Mon, 31 Mar 2014 10:43:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140330234335.GB16336@dastard>
References: <20140329223109.GA24098@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140329223109.GA24098@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 06:31:09PM -0400, Dave Jones wrote:
> Not sure if I've reported this already (it looks familiar, though I've not managed
> to find it in my sent mail folder).  This is rc8 + a diff to fix the stack usage reports
> I was seeing (diff at http://paste.fedoraproject.org/89854/13210913/raw)
> 
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.14.0-rc8+ #153 Not tainted
>  -------------------------------------------------------
>  git/32710 is trying to acquire lock:
>   (&(&ip->i_lock)->mr_lock){++++.+}, at: [<ffffffffc03bd782>] xfs_ilock+0x122/0x250 [xfs]
>  
> but task is already holding lock:
>   (&mm->mmap_sem){++++++}, at: [<ffffffffae7b816a>] __do_page_fault+0x14a/0x610
> 
> which lock already depends on the new lock.

filldir on a directory inode vs page fault on regular file. Known
issue, definitely a false positive. We have to change locking
algorithms to avoid such deficiencies of lockdep (a case of "lockdep
considered harmful", perhaps?) so it's not something I'm about to
rush...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
