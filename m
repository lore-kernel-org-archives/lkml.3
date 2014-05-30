Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbaE3RQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:16:01 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44421 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505AbaE3RP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:15:58 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20140530164815.GS18016@ZenIV.linux.org.uk>
References: <20140529133036.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
	<20140529154454.GK18016@ZenIV.linux.org.uk>
	<20140529162307.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
	<20140529165351.GM18016@ZenIV.linux.org.uk>
	<20140529185201.GN18016@ZenIV.linux.org.uk>
	<20140530081238.GA1957@lahna.fi.intel.com>
	<20140530152151.GR18016@ZenIV.linux.org.uk>
	<CA+55aFxLNvBDYtiq92DvuVqUk7byWeYiL1svbNQdXg7MRtbBcQ@mail.gmail.com>
	<20140530164815.GS18016@ZenIV.linux.org.uk>
Date: Fri, 30 May 2014 19:15:56 +0200
Message-ID: <CA+icZUXhYVMDV3-aJPYsHfJ1hLFYcUiEwJ9n5sOp06_Z2p=yYw@mail.gmail.com>
Subject: Re: [git pull] Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for
 22s! [systemd-udevd:1667]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 6:48 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, May 30, 2014 at 08:31:30AM -0700, Linus Torvalds wrote:
>> On Fri, May 30, 2014 at 8:21 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >
>> > Linus, how would you prefer it to be handled?
>>
>> I'll just have to do an rc8. I really hoped to avoid it, because we're
>> going on our family vacation when school is out in two weeks, and it
>> causes problems for the merge window, but it's not like there is much
>> choice - I can't do a 3.15 release with a known regression like that.
>
> Sorry about that... ;-/
>
>> So just send me the pull request, and I'll pull it. I'll probably do
>> the "let's increase the x86-64 stack size to 16kB" too, to close
>> _that_ issue as well.
>
> OK, here it is:
>
> Fixes for livelocks in shrink_dentry_list() introduced by fixes to shrink
> list corruption; the root cause was that trylock of parent's ->d_lock could
> be disrupted by d_walk() happening on other CPUs, resulting in
> shrink_dentry_list() making no progress *and* the same d_walk() being called
> again and again for as long as shrink_dentry_list() doesn't get past that
> mess.  Solution is to have shrink_dentry_list() treat that trylock failure not
> as "try to do the same thing again", but "lock them in the right order".
> Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus-2
>
> Shortlog:
> Al Viro (8):
>       lift the "already marked killed" case into shrink_dentry_list()
>       split dentry_kill()
>       expand dentry_kill(dentry, 0) in shrink_dentry_list()
>       shrink_dentry_list(): take parent's ->d_lock earlier
>       dealing with the rest of shrink_dentry_list() livelock
>       dentry_kill() doesn't need the second argument now
>       d_prune_alias(): just lock the parent and call __dentry_kill()
>       dcache.c: call ->d_prune() regardless of d_unhashed()
>
> Diffstat:
>  fs/dcache.c |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
>  1 file changed, 115 insertions(+), 61 deletions(-)
>

Did you push all?

$ git log --oneline v3.15-rc7..
8cbf74d dentry_kill() doesn't need the second argument now
b2b8019 dealing with the rest of shrink_dentry_list() livelock
046b961 shrink_dentry_list(): take parent's ->d_lock earlier
ff2fde9 expand dentry_kill(dentry, 0) in shrink_dentry_list()
e55fd01 split dentry_kill()
64fd72e lift the "already marked killed" case into shrink_dentry_list()
b6dd6f4 vfs: fix vmplice_to_user()

- Sedat -
