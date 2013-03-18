Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3CRCcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:32:08 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32109 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab3CRCcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:32:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAYAER8RlF5LEnC/2dsb2JhbABDwACFGgEDAYFWF3SCJAEBBTocIxAIAw4KCSUPBSUDIROIEw3BWhWNZSAeXQeDQAOWXYlthxaDHig
Date: Mon, 18 Mar 2013 13:31:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130318023155.GO6369@dastard>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1944.1363525619@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 01:06:59PM +0000, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Export do_splice_direct() to modules.  Needed by overlay filesystem.
> 
> Apparently you cannot call this from any function that is holding an i_mutex
> if the target of the splice uses generic_file_splice_write().
> 
> The problem is a potential deadlock situation:
> 
> We have places already that do:
> 
> 	mnt_want_write()
> 	mutex_lock()
> 
> This can be found in do_last() for example.
> 
> However, mnt_want_write() calls sb_start_write() as does
> generic_file_splice_write().  So now in ovl_copy_up_locked() you're adding:
> 
> 	mutex_lock()
> 	sb_start_write()
> 
> which lockdep reports as a potential ABBA deadlock.
> 
> Now, looking at __sb_start_write(), I'm not entirely sure how the deadlock
> might operate, so it's possible that this is a false alarm.  Maybe Jan Kara can
> illuminate further, so I've added him to the cc list.
> 
> I've attached the report I got with unionmount.

There's plenty of problems with splice locking that can lead to
deadlocks. Here's another that's been known for ages:

http://oss.sgi.com/archives/xfs/2011-08/msg00168.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
