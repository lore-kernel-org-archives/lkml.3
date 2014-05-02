Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaEBWcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:32:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32795 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEBWcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:32:08 -0400
Date: Fri, 2 May 2014 23:32:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140502223206.GI18016@ZenIV.linux.org.uk>
References: <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
 <20140502055127.GH18016@ZenIV.linux.org.uk>
 <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
 <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:08:13PM +0200, Miklos Szeredi wrote:
> There's more of the "delete from shrink list not owned by us" in select parent.
> Proposed patch appended.

While it certainly looks like dentry_lru_del() should die, I really wonder if
"let's pretend that dentry isn't there if it's on some other shrink list"
is the right approach.  You've already noticed one problem (check-and-drop
giving false busy indications), but shrink_dcache_parent() has similar
issues.  How about incrementing data->found instead?  That'll end up
rescanning the tree in case if it's not ours; so what?  If it's another
process doing the same shrinking in a subtree, we want to let it do its
job anyway.  Sure, somebody doing mount -o remount in a loop might be
able to stall the living hell out of us, for as long as new non-busy
dentries are being added in our subtree, but the second part in itself
is sufficient; we will keep picking those new non-busy dentries as long
as they keep coming.  And if they do not, eventually they will be all
taken out by us or by those other shrinkers and we'll be done.
 
> And I'm not sure what umount_collect() is supposed to do.  Can other shrinkers
> still be active at that point?  That would present other problems, no?

No other shrinkers - prune_dcache_sb() and shrink_dcache_sb() are also
serialized by ->s_umount, shrink_dcache_parent() and check_submounts_and_drop()
are called only when an active reference is held, which obviously prevents
fs shutdown.

> Also somewhat related is the question: how check_submounts_and_drop() could be
> guaranteed correctness (timely removal of all unsed dentries) in the presence of
> other shrinkers?

Another interesting question is what the hell are shrink_dcache_parent()
callers expecting.  E.g. what's going on in fuse_reverse_inval_entry()?
And what is nilfs_tree_is_busy() about?

FWIW, I'm not at all sure that vfs_rmdir() and vfs_rename() have any reason
to call it these days, and dentry_unhash() one simply ought to die - it's used
only by hpfs unlink() in case it wants to truncate in order to work around
-ENOSPC.  And _that_ won't have any subdirectories to deal with anyway, so
shrink_dcache_parent() there is a no-op, even if we keep the damn helper alive.
The rest of callers also look dubious...
