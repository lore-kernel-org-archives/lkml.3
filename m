Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab3JCUTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:19:19 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:61217 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3JCUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <20131003194351.GK13318@ZenIV.linux.org.uk>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
	<CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
	<20131003105130.GE13318@ZenIV.linux.org.uk>
	<CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
	<20131003174439.GG13318@ZenIV.linux.org.uk>
	<CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
	<20131003194351.GK13318@ZenIV.linux.org.uk>
Date: Thu, 3 Oct 2013 13:19:16 -0700
X-Google-Sender-Auth: 95FV1YxxsbePVGwbufzxsZWK9sY
Message-ID: <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 12:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> In the common case it's ->mnt_ns is *not* NULL; that's what we get if
> the damn thing is still mounted.

Yeah, I misread the profile assembly code. The point being that the
nice fast case now has the smp_mb() in it, and it accounts for about
60% of the cost of that function on my performance profile.

> What we need to avoid is this:
>
> mnt_ns non-NULL, mnt_count is 2
> CPU1: umount -l                                 CPU2: mntput
> umount_tree() clears mnt_ns
> drop mount_lock.lock
> namespace_unlock() calls mntput()
> decrement mnt_count
> see that mnt_ns is NULL
> grab mount_lock.lock
> check mnt_count
>                                                 decrement mnt_count
>                                                 see old value of mnt_ns
>                                                 decide to bugger off
> see it equal to 1 (i.e. miss decrement on CPU2)
> decide to bugger off
>
> The barrier in mntput() is to prevent that combination, so that either CPU2
> would see mnt_ns cleared by CPU1, or CPU1 would see mnt_count decrement done
> by CPU2.  Its counterpart on CPU1 is provided by spin_unlock/spin_lock we've
> done between clearing mnt_ns and checking mnt_count.  Note that
> synchronize_rcu() in namespace_unlock() and rcu_read_lock() in mntput() are
> irrelevant here - the latter on CPU2 might very well have happened after the
> former on CPU1, so umount -l did *not* wait for CPU2 to do anything.
>
> Any suggestions re getting rid of that barrier?

Hmm. The CPU2 mntput can only happen under RCU readlock, right? After
the RCU grace period _and_ if the umount is going ahead, nothing
should have a mnt pointer, right?

So I'm wondering if you couldn't just have a synchronize_rcu() in that
umount path, after clearing mnt_ns. At that point you _know_ you're
the only one that should have access to the mnt.

You'd need to drop the mount-hash lock for that. But I think you can
do it in umount_tree(), right? IOW, you could make the rule be that
umount_tree() must be called with the namespace lock and the
mount-hash lock, and it will drop both. Or does that get too painful
too?

                Linus
