Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3CVBWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:22:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39235 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3CVBWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:22:14 -0400
Date: Fri, 22 Mar 2013 01:22:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS deadlock ?
Message-ID: <20130322012208.GJ21522@ZenIV.linux.org.uk>
References: <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321221256.GA30620@redhat.com>
 <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
 <20130321233630.GE21522@ZenIV.linux.org.uk>
 <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
 <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
 <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 05:22:59PM -0700, Linus Torvalds wrote:
> On Thu, Mar 21, 2013 at 5:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > What we should do, IMO, is to turn /proc/<pid>/net into a honest symlink -
> > to ../nets/<netns ID>/net.  Hell, might even make it a magical symlink
> > instead...
> 
> Ok, having seen the error of my ways, I'm starting to agree with you..
>  How painful would that be? Especially since we'd need to backport
> it..

Not sure; right now I'm looking through the guts of what procfs had become.
Unfortunately, there are fairly subtle interactions with other shit -
tomoyo, etc.  Sigh...

BTW, the variant with d_ancestor() modification is also not enough -
/proc/1/net and /proc/2/net have different inodes, so for the pair
(/proc/net/1, /proc/2/net/stat) d_ancestor() won't trigger
even with this change.  And we have /proc/net/1 < /proc/net/1/stat,
since the latter is a subdirectory of the former.  With /proc/net/{1,2}/stat
having the same inode...

In theory, we can make vfs_rmdir() and vfs_unlink() check the presense of
the corresponding method before locking the victim; that would suffice to
kludge around that mess on procfs.  Along with ->d_inode comparison in
lock_rename() it *might* suffice.  OTOH, there are places in fs/dcache.c
where we rely on the lack of such aliases; they might or might not trigger
in case of procfs.

We are talking about the violation of fundamental assert used in
correctness analysis all over the place, unfortunately.  The right fix
is to restore it; I'll try to come up with something that could be
reasonably easily backported - the kludge above is a fallback in case if
no real fix turns out to be easy to backport.  Assuming that this kludge
is sufficient, that is...  For 3.9 and later we *definitely* want to
restore that assertion.

PS: Once more, with feeling, to everyone even thinking of pulling something
like that again:
	Hardlinks to directories do not work.  Don't do that, or we'll be
sorry, and then so will you.
					A Very Peeved BOFH
