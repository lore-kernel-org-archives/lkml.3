Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3CNKr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:47:26 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:32775 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229Ab3CNKhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:52 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130313231918.GP21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
	<CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
	<20130312222350.GK21522@ZenIV.linux.org.uk>
	<20130313185249.GL21522@ZenIV.linux.org.uk>
	<CAJfpeguViuL52fYw922KU1YxRs2YyD=T6tdFVg+buJPw7YUV_Q@mail.gmail.com>
	<20130313231918.GP21522@ZenIV.linux.org.uk>
Date: Thu, 14 Mar 2013 11:37:50 +0100
Message-ID: <CAJfpegsCirmYYimr6Nn4Q4Kdc7rMYaxWhk+fsmp+BLp6mjb_MQ@mail.gmail.com>
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

On Thu, Mar 14, 2013 at 12:19 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 13, 2013 at 11:09:07PM +0100, Miklos Szeredi wrote:

>> As for same upper on unrelated lower: just don't do it.  As I said, we
>> could enforce this, but I don't think this is top priority.
>
> Tell that to container crowd - they seem to be hell-bent on making everything
> mount-related non-priveleged ;-/

Which is good, but it does need some care.  I'm happy to review those changes.

>> > * ->follow_link():  Why the hell do you bother with struct ovl_link_data???
>> > Just to avoid calling ovl_dentry_real() in ovl_put_link()?
>>
>> Yes, a copy-up between ovl_follow_link and ovl_put_link will break that.
>
> *blink*
>
> Er...  What's wrong with simply unhashing the sucker on copyup if it's
> a symlink?

Nothing, so I'll do that.  Actually we can do that for all except
directory dentries and save some worry.

> BTW, looking at your ovl_copy_up() - you do realize that dget_parent(d)
> does *not* guarantee that returned dentry will remain the parent of d?
> rename() can very well move it away just as dget_parent() is returning
> to caller.  As the result, you are not guaranteed that ovl_copy_up_one()
> arguments will be anywhere near each other in the tree.  Your locking
> and rechecks might be enough to prevent trouble there, but it's not
> obvious, to put it mildly.

This issue is documented above ovl_copy_up_one().  It's not all that
complicated, I think.

> I'm _very_ sceptical about the idea of delaying copyups that much, BTW;
> there's a damn good reason why all implementations starting with Sun's
> one in 80s did copy directories up as soon as they got looked up.  Saves
> a lot of headache...

Maybe.   If we find not trivially fixable holes in the current
implementation I'm open to that direction.

Delayed copy up has the advantage of allowing pure read-only overlays.

> As for whiteouts... I think we ought to pull these bits of unionmoun
> queue into the common stem and add the missing filesystems to them;
> ext* and ufs are trivial (keep in mind that FFS derivatives, including
> ext*, have d_type in directory entry and type 14 (DT_WHT) is there
> precisely for that purpose).  btrfs also has "dir_type" thing - 8bit
> field...

What about userspace interfaces?  Are we allowed to extend d_type and
st_mode without breaking things?

Thanks,
Miklos
