Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415Ab3CMXT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:19:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3CMXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:19:25 -0400
Date: Wed, 13 Mar 2013 23:19:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
Message-ID: <20130313231918.GP21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
 <CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
 <20130312222350.GK21522@ZenIV.linux.org.uk>
 <20130313185249.GL21522@ZenIV.linux.org.uk>
 <CAJfpeguViuL52fYw922KU1YxRs2YyD=T6tdFVg+buJPw7YUV_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguViuL52fYw922KU1YxRs2YyD=T6tdFVg+buJPw7YUV_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 11:09:07PM +0100, Miklos Szeredi wrote:
> I don't see how that would deadlock.  We follow VFS locking rules on
> upper and lower filesystem and never lock both at the same time.  And
> we
> only lock overlay first and then upper *or* lower.
> 
> As for same upper on unrelated lower: just don't do it.  As I said, we
> could enforce this, but I don't think this is top priority.

Tell that to container crowd - they seem to be hell-bent on making everything
mount-related non-priveleged ;-/

FWIW, the thing that worries me is the fun involved in situations when
topology of dentry tree of your fs becomes completely unrelated to that
of one (or both) layers; if somebody can start playing with cross-directory
renames in said layers, things can get really nasty.  Another thing is,
you cache some properties of underlying directories in your tree; are you
sure that this cached information becoming stale will _not_ do anything
bad?

> > * ->follow_link():  Why the hell do you bother with struct ovl_link_data???
> > Just to avoid calling ovl_dentry_real() in ovl_put_link()?
> 
> Yes, a copy-up between ovl_follow_link and ovl_put_link will break that.

*blink*

Er...  What's wrong with simply unhashing the sucker on copyup if it's
a symlink?

BTW, looking at your ovl_copy_up() - you do realize that dget_parent(d)
does *not* guarantee that returned dentry will remain the parent of d?
rename() can very well move it away just as dget_parent() is returning
to caller.  As the result, you are not guaranteed that ovl_copy_up_one()
arguments will be anywhere near each other in the tree.  Your locking
and rechecks might be enough to prevent trouble there, but it's not
obvious, to put it mildly.

I'm _very_ sceptical about the idea of delaying copyups that much, BTW;
there's a damn good reason why all implementations starting with Sun's
one in 80s did copy directories up as soon as they got looked up.  Saves
a lot of headache...

As for whiteouts... I think we ought to pull these bits of unionmount
queue into the common stem and add the missing filesystems to them;
ext* and ufs are trivial (keep in mind that FFS derivatives, including
ext*, have d_type in directory entry and type 14 (DT_WHT) is there
precisely for that purpose).  btrfs also has "dir_type" thing - 8bit
field...

Note that upper layer in *any* union would better not change unpredictably
under you - anybody trying to do e.g. NFS as top (either, actually) layer
is welcome to all kinds of PITA when it comes to need to revalidate stale
dentries.  IOW, realistically the upper layer is going to be local,
read-write and not something like sysfs or procfs, where things can disappear
at will.  What does "having xattr is enough" really buy?
