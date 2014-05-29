Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbaE2TOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:14:53 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:60952 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbaE2TOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140529185201.GN18016@ZenIV.linux.org.uk>
References: <20140529035233.GF18016@ZenIV.linux.org.uk>
	<20140529053444.GI18016@ZenIV.linux.org.uk>
	<20140529105107.GB1938@lahna.fi.intel.com>
	<20140529110439.GA2006@lahna.fi.intel.com>
	<20140529133036.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
	<20140529154454.GK18016@ZenIV.linux.org.uk>
	<20140529162307.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
	<20140529165351.GM18016@ZenIV.linux.org.uk>
	<20140529185201.GN18016@ZenIV.linux.org.uk>
Date: Thu, 29 May 2014 12:14:51 -0700
X-Google-Sender-Auth: nfBNnO_NSxxL8vf7gBM3q8f1pW4
Message-ID: <CA+55aFwNv2-9=uXxzYH9UpN_x209Cv_BBu-9j2prSh2xVmmsAg@mail.gmail.com>
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

On Thu, May 29, 2014 at 11:52 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Grrr...  Sadly, that's not good enough.  Leaking rcu_read_lock() on
> success is trivial, but there's more serious problem: suppose dentries
> involved get moved before we get to locking what we thought was parent.
> We end up taking ->d_lock on two dentries that might be nowhere near each
> other in the tree, with obvious nasty implications.  Would be _very_ hard
> to reproduce ;-/

Yeah, I don't think you can reproduce that, but I guess renaming
directories into each other (two renames needed) could trigger an ABBA
deadlock by changing the topological order of dentry/parent.

I suspect there's no way in hell that tiny race will ever happen in
practice, but let's not risk it.

And your solution (to re-check after just taking the parent lock)
seems sufficient and sane, since dentry_lock_for_move() will always
take the parent lock(s) before we move a dentry.

So that looks good to me.

              Linus
