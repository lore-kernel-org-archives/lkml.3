Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab3CMWJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:09:20 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:45390 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab3CMWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:09:12 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130313185249.GL21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
	<CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
	<20130312222350.GK21522@ZenIV.linux.org.uk>
	<20130313185249.GL21522@ZenIV.linux.org.uk>
Date: Wed, 13 Mar 2013 23:09:07 +0100
Message-ID: <CAJfpeguViuL52fYw922KU1YxRs2YyD=T6tdFVg+buJPw7YUV_Q@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 7:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Mar 12, 2013 at 10:23:50PM +0000, Al Viro wrote:
>
>> I'll post a review tonight or tomorrow.  FWIW, I was not too happy with
>> it the last time I looked, but I'll obviously need to reread the whole
>> thing.
>
> OK...  Here's the first pass at that:
>
> * use of xattrs for whiteouts/opaque is a Bloody Bad Idea(tm).  That's one
> thing you definitely can share with unionmount.  In particular, the games
> with creds you have to pull off in ovl_do_lookup() are very clear indications
> that xattr is simply a wrong interface for that.

I'm not so sure.  The advantages of using xattrs are:

 - already available on lots of filesystems
 - no new, backward incompatible disk-format needed
 - no new userspace interfaces needed to view/manipluate them

Just looked, union mounts supports patchset has whiteout support for
tmpfs, ext2 and jffs2.  That means I can't try it out on my root
filesystem (and couldn't even if ext4 were supported, because of the
incompatible changes required).

>
> * I don't see anything that would protect you from attacker playing silly
> buggers with upper layer; mount it r/w elsewhere and do some renames...
> Note that your ->lookup() relies on having the result of ovl_lookup_real()
> remain the child of dentry we'd passed it as the first argument.  What's
> there to guarantee that it will remain such?  The similar question goes for
> malicious modifications of xattrs...

All of the above are privileged (xattrs are in the "trusted."
namespace).  Behavior is unspecified in those cases, and "attacker"
can do no worse than confuse itself.

BTW. I had plans of adding infrastructure to make sure that only one
instance of "upper" is writable and that instance is only visible
through the overlay.  But then decided to postpone this as it didn't
seem to be very important.

>  For that matter, what's to prevent
> the same sucker mounted as upper layer in two places, with two unrelated lower
> layers?  AFAICS, things will break rather badly if that happens, and I'm not
> sure if you avoid deadlocks in such scenario...  Interfering with copyup
> in progress is also possible.

I don't see how that would deadlock.  We follow VFS locking rules on
upper and lower filesystem and never lock both at the same time.  And
we
only lock overlay first and then upper *or* lower.

As for same upper on unrelated lower: just don't do it.  As I said, we
could enforce this, but I don't think this is top priority.

>
> * I think you might have an unpleasant problem in your ->setattr(); suppose
> you've got through the checks in notify_change() and ovl_setattr() got called.
> With ATTR_SIZE present.  OK, you do a truncated copyup; fair enough.  But
> then you do notify_change() on upper layer dentry to do the rest of the job.
> What happens if that fails?  Moreover, what's to prevent it being e.g. opened
> by another process *before* you get around to that notify_change() part?

Okay, the truncated copyup doesn't seem to be a good idea.  Or rather,
it needs to be done more carefully, only actually revealing the copied
up dentry once the setattr operation has completed successfully.

>
> * ->follow_link():  Why the hell do you bother with struct ovl_link_data???
> Just to avoid calling ovl_dentry_real() in ovl_put_link()?

Yes, a copy-up between ovl_follow_link and ovl_put_link will break that.

Thanks,
Miklos
