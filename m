Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619Ab3GRXSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:18:04 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62401 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab3GRXSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:18:01 -0400
Date: Thu, 18 Jul 2013 18:17:55 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/5] initmpfs v2: use tmpfs instead of ramfs for rootfs
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>, Jeff Layton <jlayton@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Jim Cromie <jim.cromie@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <alpine.LNX.2.00.1307171706050.4294@eggly.anvils> (from
	hughd@google.com on Wed Jul 17 19:15:29 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374189475.3719.17@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew: I'll save you the time of reading this message.

   tl;dr: "I agree with what Hugh said".

You're welcome. :)

On 07/17/2013 07:15:29 PM, Hugh Dickins wrote:
> On Wed, 17 Jul 2013, Andrew Morton wrote:
> > On Tue, 16 Jul 2013 08:31:13 -0700 (PDT) Rob Landley  
> <rob@landley.net> wrote:
> >
> > > Use tmpfs for rootfs when CONFIG_TMPFS=y and there's no root=.
> > > Specify rootfstype=ramfs to get the old initramfs behavior.
> > >
> > > The previous initramfs code provided a fairly crappy root  
> filesystem:
> > > didn't let you --bind mount directories out of it, reported zero
> > > size/usage so it didn't show up in "df" and couldn't run things  
> like
> > > rpm that query available space before proceeding, would fill up  
> all
> > > available memory and panic the system if you wrote too much to  
> it...
> >
> > The df problem and the mount --bind thing are ramfs issues, are they
> > not?  Can we fix them?  If so, that's a less intrusive change, and  
> we
> > also get a fixed ramfs.
> 
> I'll leave others to comment on "mount --bind",

It's unrelated to tmpfs but _is_ related to exposing a non-broken rootfs
to the user.

> but with regard to "df":
> yes, we could enhance ramfs with accounting such as tmpfs has, to  
> allow
> it to support non-0 "df".  We could have done so years ago; but have
> always preferred to leave ramfs as minimal, than import tmpfs features
> into it one by one.

Ramfs reporting 0 size is not a new issue, here it is 13 years ago:

http://lkml.indiana.edu/hypermail/linux/kernel/0011.2/0098.html

And people proposed adding resource limits to ramfs at the time (yes,
13 years ago):

http://lkml.indiana.edu/hypermail/linux/kernel/0011.2/0713.html

And Linus complained about complicating ramfs which he thought was a  
good
educational example and could be turned into a reusable code library.
(Somewhere around  
http://lkml.indiana.edu/hypermail/linux/kernel/0112.3/0257.html
or http://lkml.indiana.edu/hypermail/linux/kernel/0101.0/1167.html or...
I'd have to dig for that one. I remember reading it but my google roll
missed.)

Way back when Linus also mentioned embedded users benefitting from
rootfs, ala:

http://lkml.indiana.edu/hypermail/linux/kernel/0112.3/0307.html

Which is why I documented rootfs to be ramfs "or tmpfs, if that's
enabled" back in 2005:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/ramfs-rootfs-initramfs.txt#n57

And when I found out it still wasn't the case a year later I went
"um, hey!" on the list, but ironically I got pushback from the same
guy who objected to my perl removal patches as an "academic"
exercise because it's not how _he_ uses linux...

http://lkml.indiana.edu/hypermail/linux/kernel/0607.3/2480.html
https://lkml.org/lkml/2013/3/20/321

(And you wonder why embedded guys don't speak up more? I'm an
outright "bullhorn and plackard" guy in this community. Random
example: a guy named Rich Felker has been hanging out on the
busybox and uclibc lists and IRC channels for years, and recently
wrote musl-libc.org from "git init" to "builds linux from scratch"
in 2 years. He's on the posix committe list and posts there
multiple times per week. Number of times he's posted to
linux-kernel: zero. I'm sure Sarah Sharp just facepalmed...)

I was recently reminded of initmpfs because I'm finishing up a
contract at Cray and they wanted to do this on their supercomputers
and I went "oh, that's easy", and then had to make it work.
(Embedded and supercomputing have always been closer to each other
than either is to the desktop...) This is very much Not My Area
but I've been waiting a _decade_ for other people to do this and
nada. Really, you could see this as just "fixing my documentation"
from way back when, by changing the code to match the docs. :)

> I prefer Rob's approach of making tmpfs usable for rootfs.

Me too. The resource accounting logic in tmpfs is hundreds of lines,
with shmem_default_max_blocks and shmem_default_max_inodes to specify
default size limits, mount-time option parsing to specify different
values for those limits, plus remount logic (what if you specify a
smaller size after the fact?), plus displaying the settings per-mount
in /proc/mounts... see mm/shmem.c lines 2414 through 2581 for the
largest chunk of it.

That's why we got tmpfs/shmfs as a separate filesystem in the first
place: it's a design decision. Ramfs is intentionally minimalist.

Ramfs can't say how big it is because it doesn't _know_ how big it is.
If you write unlimited data to ramfs, the OOM killer zaps everything but
init and then the system hangs in a page eviction loop. (The OOM killer
can't free pinned page cache with nowhere to evict it to.)

My patch series switching over tmpfs is much smaller than the tmpfs
size accounting code, and we get the swap backing store for free. Plus
hooking up years-old existing tested code (instead of putting new  
untested
logic in the boot path), without duplicating functionality.

I.E. "what Hugh said."

Rob