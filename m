Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaI3CVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:21:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54264 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3CVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:21:35 -0400
Date: Tue, 30 Sep 2014 03:21:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Removing shared subtrees?
Message-ID: <20140930022133.GR7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
 <20140930000924.GO7996@ZenIV.linux.org.uk>
 <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
 <20140930002948.GP7996@ZenIV.linux.org.uk>
 <CALCETrVnXXjDjh9+vOGfFh08-wtjJeuC=n=PtNusOS_nq0puFA@mail.gmail.com>
 <20140930011446.GQ7996@ZenIV.linux.org.uk>
 <CALCETrXXFCfwEdi+AYELdr4umWPTr8=2x4AzvSTBX6E55Do2sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXXFCfwEdi+AYELdr4umWPTr8=2x4AzvSTBX6E55Do2sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 06:24:05PM -0700, Andy Lutomirski wrote:
> On Mon, Sep 29, 2014 at 6:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Mon, Sep 29, 2014 at 05:36:27PM -0700, Andy Lutomirski wrote:
> >
> >> Ideally it would leave them around until the whole subtree had no
> >> references, at which point /mnt and everything under it would
> >> disappear with no side effects, because it has no references.
> >
> > So, assuming you've got a stuck NFS mount with a bunch of local stuff
> > bound on top of it, in your ideal we'd have the latter all remaining
> > mounted until the server comes back.  Lovely, that...
> 
> No, not at all.

Er...  How so?  /mnt is stuck NFS.  /mnt/foo/bar and /mnt/foo/barf have
/dev/sda1 and /dev/sda2 mounted on them.  Both are currently not busy.
/mnt is - there's that shell trying to expand *.c in /mnt/splat, sitting
around blocked with opened directory in its descriptor table.

Just how would your ideal prevent sda1 and sda2 staying mounted?  You can't
say umount /mnt/foo/bar; it'll get blocked trying to revalidate foo and
waiting for server to reply.  In real world you can say umount -l /mnt and
be done with that - everything in there becomes detached, what used to be
/mnt stays alive (but not mounted on /mnt anymore) until it ceases to be
busy.  What used to be /mnt/foo/bar and /mnt/foo/barf end up shut down
immediately (what with not being busy).  In your ideal they would stay around
until the "whole subtree" (of what?) loses all references, i.e. until that
shell closes opened directory.

> Let me try this one more time:
> 
> I don't *care* whether MNT_DETACH unmounts submounts immediately or
> when all the references are finally gone.  I didn't read the docs or
> the code to see which is the case *because I don't care*.
> 
> I think it's somewhere between ridiculous and flat-out broken that
> MNT_DETACH of the *root* of a shared subtree *propagates* the unmount
> of submounts to the parent of the shared subtree.  This is IMO
> completely bogus.

Parent in which sense?  Try to experiment with this: mount something on
/tmp/foo, then mount --rbind /tmp/foo /mnt/foo, mount something on /mnt/bar
and /tmp/bar and umount -l /mnt/foo.  Then think what does and does not
happen.

> IOW, if I do:
> 
> mount --make-rshared /
> mount --rbind / /mnt
> umount -l /mnt/dev
> 
> then I fully expect /dev to be unmounted (although I think that this
> is a misfeature).
> 
> But I did:
> 
> mount --make-rshared /
> mount --rbind / /mnt
> umount -l /mnt  <- the ROOT of the fscking shared subtree
> 
> And /dev got unmounted.  How does this make any sense at all?

Sigh... umount -l /mnt *includes* unmounting /mnt/dev.  Which you
do expect to take /dev out.  "I expect Y to cause Z; I don't care if X
causes Y; why does it end up causing W?!!!?"  Where W is vague as hell
and depending on what is meant either refers to Z or to something more
than that; in the letter case the answer would be "W isn't happening".
