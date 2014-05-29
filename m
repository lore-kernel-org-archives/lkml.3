Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbaE2PLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:11:03 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60805 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaE2PK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140529133036.GJ18016@ZenIV.linux.org.uk>
References: <20140528073751.GB1757@lahna.fi.intel.com>
	<20140528115701.GY18016@ZenIV.linux.org.uk>
	<20140528131136.GA1643@lahna.fi.intel.com>
	<20140528141937.GZ18016@ZenIV.linux.org.uk>
	<20140528183954.GA18016@ZenIV.linux.org.uk>
	<20140529031149.GE18016@ZenIV.linux.org.uk>
	<20140529035233.GF18016@ZenIV.linux.org.uk>
	<20140529053444.GI18016@ZenIV.linux.org.uk>
	<20140529105107.GB1938@lahna.fi.intel.com>
	<20140529110439.GA2006@lahna.fi.intel.com>
	<20140529133036.GJ18016@ZenIV.linux.org.uk>
Date: Thu, 29 May 2014 08:10:57 -0700
X-Google-Sender-Auth: 93gDwwJfg6Hn0RxI_hfzgCDfbA0
Message-ID: <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
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

On Thu, May 29, 2014 at 6:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Great...  OK, saner splitup of that sucker (equivalent to combination of
> these two patches) is in vfs.git#for-linus.
>
> Review and testing would be very welcome.

So looking at the "dealing with the rest of shrink_dentry_list()
livelock" patch, I think the "release the parents" case is now big and
complicated enough to be split into a function of its own.

However, I have a bigger question too: the "release the parent" case
_should_ be possible to do with just a "dput()" on the parent, and the
only reason we're doing the special case is that since we are
shrinking things, we try to be more aggressive and shrink all the
parents if possible. Right?

If so, though, that brings up two questions:

 (a) do we really want to be that aggressive? Can we ever traverse
_past_ the point we're actually trying to shrink in
shrink_dcache_parent()?

 (b) why does the "dput()" (or rather, the dentry_kill()) locking
logic have to retain the old trylock case rather than share the parent
locking logic?

I'm assuming the answer to (b) is that we can't afford to drop the
dentry lock in dentry_kill(), but I'd like that answer to the "Why" to
be documented somewhere.

I don't much care what the answer to (a) is, but again, it would be
good to have that mentioned somewhere.

                 Linus
