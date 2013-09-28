Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3I1Unx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:43:53 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47110 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3I1Unu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130928202728.GK13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
Date: Sat, 28 Sep 2013 13:43:49 -0700
X-Google-Sender-Auth: dAcsEJebaIrVhzb2cMs3E5ZMmT8
Message-ID: <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
Subject: Re: [rfc][possible solution] RCU vfsmounts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 1:27 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         FWIW, I think I have a kinda-sorta solution for that and I'd like
> to hear your comments on that.  I want to replace vfsmount_lock with seqlock
> and store additional seq number in nameidata, set to vfsmount_seq in the
> beginning and rechecked in unlazy_walk/complete_walk.

Yes, that would be lovely.

>         The obvious variant would be to have unlazy_walk/complete_walk to
> grab refcount, check vfsmount_seq and mntput on mismatch.  The trouble
> with that is race with what would've been the final mntput() done by
> umount(2); complete_walk() would drop that temporary reference and
> fail, all right, but... we would get a umount(2) returning without having
> actually shut the filesystem down.  Said shutdown would happen in whoever
> had been doing pathname resolution that stepped into the race.

Sounds reasonable to to me.

Side note: I really wish there was some way to avoid having to
finalize the vfsmount entirely for some common things. For example,
"[l]stat[at]()" really doesn't need it for the common cases (network
filesystems may need to revalidate), and is a very critical operation,
and we *could* just look up the inode under RCU and never finalize the
dentry _or_ the vfsmount. However, very annoyingly, the security layer
wants the vfsmount, and we don't know if that is RCU-safe...

                Linus
