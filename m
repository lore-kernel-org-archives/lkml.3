Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3CUVSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:18:17 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:44063 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3CUVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130321210255.GD16406@redhat.com>
References: <20130321190653.GA15479@redhat.com>
	<20130321192935.GY21522@ZenIV.linux.org.uk>
	<CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
	<20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
Date: Thu, 21 Mar 2013 14:18:15 -0700
X-Google-Sender-Auth: ngs5EwwxOIUbS8KDKuqRHOx-nz4
Message-ID: <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 2:02 PM, Dave Jones <davej@redhat.com> wrote:
>
> here we go...
>
> WARNING: at fs/namei.c:2335 lock_rename+0x156/0x160()
> p1=irda p2=irda

Ok, good. I ssupect it's /proc or /sys, we do have that entry there.

But in fact I suspect we do want the parent name after all, because I
think we have multiple "irda" directories. There's the one in
/proc/net/ (added by net/irda/irproc.c), and there's a sysctl  CTL_DIR
"irda" directory (kernel/sysctl_binary.c). And there might even be a
few other ones in /sys too, thanks to the ldisc called "irda" etc.

I don't see where the shared inode comes from, but I suspect that
would be easier to guess if we actually see which particular case it
ends up being..

> followed by...
> =====================================
> [ BUG: bad unlock balance detected! ]

Oh, ok, that's just because the unlock path doesn't have the same
logic for unlocking identical inodes that the thing just added to the
locking path. You'd need to add a check for "same inode" and only
unlock it once.

So that was my fault in asking for a non-BUG_ON and not doing the
complete thing. See "unlock_rename()" - you'd need to change the "p1
!= p2" test there to "p1->d_inode != p2->d_inode" there to match the
logic in lock_rename()

            Linus
