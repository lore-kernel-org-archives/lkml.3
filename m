Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaE3FAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:00:52 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47407 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaE3FAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140530045059.GP18016@ZenIV.linux.org.uk>
References: <20140529105107.GB1938@lahna.fi.intel.com>
	<20140529110439.GA2006@lahna.fi.intel.com>
	<20140529133036.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
	<20140529154454.GK18016@ZenIV.linux.org.uk>
	<20140529162307.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
	<20140529165351.GM18016@ZenIV.linux.org.uk>
	<20140529185201.GN18016@ZenIV.linux.org.uk>
	<CA+55aFwNv2-9=uXxzYH9UpN_x209Cv_BBu-9j2prSh2xVmmsAg@mail.gmail.com>
	<20140530045059.GP18016@ZenIV.linux.org.uk>
Date: Thu, 29 May 2014 22:00:49 -0700
X-Google-Sender-Auth: ekWko7rZwVGsIcE8tKsdSdJlAnI
Message-ID: <CA+55aFxGYDX6PTcMjYO3bsXTj+M0yF76Xtf_BCPmU+DrZ9hfzQ@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 9:50 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, how serious is the problem with __lockref_is_dead(&dentry->d_lockref)
> with only ->d_parent->d_lock held?  From my reading of lib/lockref.c it
> should be safe - we only do lockref_mark_dead() with ->d_parent->d_lock
> held, and it'll provide all the serialization and barriers we need.
>
> If I'm right, we could get rid of DCACHE_DENTRY_KILLED completely

Yeah, I think that would be good. Except I think you should create a
"dentry_is_dead()" helper function that then has that "if you hold the
dentry or parent lock, this is safe" comment, because for lockref in
general you do need to have the lock in the lockref itself. The fact
that dentries have more locking is very much dentry-specific.

But with that, go wild. I'd love to get rid of some of the redundant stuff.

For another example, the

    BUG_ON((int)dentry->d_lockref.count > 0);

test makes very little sense any more with lockrefs and the whole dead
marker (that should make sure that it never gets incremented), but
exists due to the direct conversion.

              Linus
