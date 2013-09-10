Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3IJSnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:43:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58189 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IJSna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:43:30 -0400
Date: Tue, 10 Sep 2013 19:43:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        moneta.mace@gmail.com
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
Message-ID: <20130910184324.GY13318@ZenIV.linux.org.uk>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
 <CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
 <CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
 <CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
 <CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:25:44AM -0700, Linus Torvalds wrote:
>                 nd->flags &= ~LOOKUP_RCU;
>                 if (!(nd->flags & LOOKUP_ROOT))
>                         nd->root.mnt = NULL;
>                 unlock_rcu_walk();
> 
> and my unlazy_walk() essentially terminated the walk _without_
> clearing that nd->root.mnt thing (it did clear the LOOKUP_RCU bit and
> unlock_rcy_walk(). So then later, we'd end up doing an extra
> path_put(). Explaining a zero d_lockref.count.
> 
> The whole damn root.mnt behavior with !LOOKUP_ROOT is a mystery and
> needs more comments. But the attached trivial patch should do the
> missing portion of terminate_walk().
>
> Al, can you walk us through the rules for what "root.mnt == NULL"
> really means? It's basically used as a flag for whether we've gotten
> the root pointer or not. But it's pretty damn esoteric.

LOOKUP_ROOT: the caller has set nd->root and we shouldn't touch that
at all.

!LOOKUP_ROOT: we set nd->root the first time we need / (in the very
beginning if it's an absolute pathname, on the first absolute symlink
otherwise).  In non-RCU mode we hold a reference to it; in RCU mode
we do not.  As the result, leaving RCU mode should either grab
a reference to the damn thing (if we intend to go on) or zero it out.
