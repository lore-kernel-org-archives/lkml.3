Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3IJTNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:13:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58320 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3IJTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:13:23 -0400
Date: Tue, 10 Sep 2013 20:13:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Mace Moneta <moneta.mace@gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
Message-ID: <20130910191319.GZ13318@ZenIV.linux.org.uk>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
 <CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
 <CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
 <CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
 <CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
 <20130910184324.GY13318@ZenIV.linux.org.uk>
 <CA+55aFwFQei-j47xZU06MZZ+S2ki2-dyi=7b7+U+QX_3FAYevQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwFQei-j47xZU06MZZ+S2ki2-dyi=7b7+U+QX_3FAYevQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 12:01:22PM -0700, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 11:43 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > !LOOKUP_ROOT: we set nd->root the first time we need / (in the very
> > beginning if it's an absolute pathname, on the first absolute symlink
> > otherwise).  In non-RCU mode we hold a reference to it; in RCU mode
> > we do not.  As the result, leaving RCU mode should either grab
> > a reference to the damn thing (if we intend to go on) or zero it out.
> 
> Yeah, that was what I was thinking. But in particular, I was wondering
> if we could simplify unlazy_walk() to _not_ take that root reference
> at all, and just always zero it out even if we succeed.
> 
> IOW, doing the attached patch (_instead_ of the one I sent out).
> 
> Or is there something in path lookup retrying that might get uphappy
> if we go back to a NULL root.mnt, and doesn't check it?

Ugh...  I really don't like that - your patch introduces the situations
when race with chroot can lead to two absolute symlinks in the same path
being interpreted wrt different roots.  And yes, sure, anybody who gets
in that kind of races isn't going to get particulary sane results, but
still, I'd rather have simpler semantics here...

Anyway, I think I see how to tidy the things up in a different way; let's
go with your original fix for now and deal with the cleanups a bit later.

Another thing: could you merge vfs.git#for-linus?  It's getting really
messy to keep track of changes both in mainline and in vfs.git, especially
since there's a pile of pending stuff (lru_list work) that needs to be
resolved wrt both...
