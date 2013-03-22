Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3CVFSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:18:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3CVFSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:18:20 -0400
Date: Fri, 22 Mar 2013 05:18:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [CFT] Re: VFS deadlock ?
Message-ID: <20130322051817.GM21522@ZenIV.linux.org.uk>
References: <20130321233630.GE21522@ZenIV.linux.org.uk>
 <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
 <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
 <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
 <20130322012208.GJ21522@ZenIV.linux.org.uk>
 <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
 <20130322014037.GK21522@ZenIV.linux.org.uk>
 <20130322043715.GL21522@ZenIV.linux.org.uk>
 <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:55:10PM -0700, Linus Torvalds wrote:
> However, I do wonder if we could take another approach... There's
> really no reason why we should look up an old inode with iget_locked()
> in proc_get_inode() and only fill it in if it is new. We might as well
> just always create a new inode. The "iget_locked()" logic really comes
> from the bad old days when the inode was the primary data structure,
> but it's really the dentry that is the important data structure, and
> the inode might as well follow the dentry, instead of the other way
> around.
> 
> So why not just use "new_inode_pseudo()" instead? IOW, something like
> this (totally untested, natch) patch? This way, if you have a new
> dentry, you are guaranteed to always have a new inode. None of the
> silly inode alias issues..
> 
> This seems too simple, but I don't see why iget_locked() would be any
> better. It just wastes time hashing the inode that we aren't really
> interested in hashing. The inode is always filled by the caller
> anyway, so we migth as well just get a fresh pseudo-filesystem inode
> without any crazy hashing..

Umm...
static int proc_delete_dentry(const struct dentry * dentry)
{
        return 1;
}

static const struct dentry_operations proc_dentry_operations =
{
        .d_delete       = proc_delete_dentry,
};

IOW, dcache retention in procfs is inexistent and the damn thing tries
to cut down on the amount of inode allocation/freeing/filling.

I agree that we could get rid of icache retention there and everything
ought to keep working.  Hell knows...  It applies only to the stuff that
isn't per-process, so it's probably not particulary hot anyway, but it
does need profiling...  OTOH, we probably could mark "stable" dentries
in some way and let proc_delete_dentry() check that flag in proc_dir_entry -
I seriously suspect that really hot non-per-process ones are of the
"never become invalid" variety.
