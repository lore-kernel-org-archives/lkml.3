Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3IIRpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:45:41 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49996 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3IIRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:45:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130909172905.GN13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
	<1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
	<20130909172905.GN13318@ZenIV.linux.org.uk>
Date: Mon, 9 Sep 2013 10:45:38 -0700
X-Google-Sender-Auth: 1lMBWeevhrAT4fp9_FymXdi4po4
Message-ID: <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 10:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I'm not sure I like mixing rcu_read_lock() into that - d_path() and friends
> can do that themselves just fine (it needs to be taken when seq is even),
> and e.g. d_walk() doesn't need it at all.  Other than that, I'm OK with
> this variant.

Hmm.. I think you need the RCU read lock even when you get the write_seqlock().

Yes, getting the seqlock for write implies that you get a spinlock and
in many normal circumstances that basically is equvalent to being
rcu-locked, but afaik in some configurations that is *not* sufficient
protection against an RCU grace period on another CPU. You need to do
a real rcu_read_lock that increments that whole rcu_read_lock_nesting
level, which a spinlock won't do.

And while the rename sequence lock protects against _renames_, it does
not protect against just plain dentries getting free'd under memory
pressure.

So I think the RCU-readlockness really needs to be independent of the
sequence lock.

            Linus
