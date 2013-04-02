Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab3DBGIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:08:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3DBGIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:08:09 -0400
Date: Tue, 2 Apr 2013 07:08:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ayan George <ayan@ayan.net>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Salman Qazi <sqazi@google.com>,
        Guo Chao <yan@linux.vnet.ibm.com>
Subject: Re: [PATCH] loop: prevent bdev freeing while device in use
Message-ID: <20130402060804.GI21522@ZenIV.linux.org.uk>
References: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
 <CA+55aFzqYkX27E8R7Bu8pvn3xO+hKrgMEC7ec5gDz4kr1JbVtQ@mail.gmail.com>
 <CAOMFOmWuo5W53G1-eAONgMqPRrt7HUorVk-HfpBzuddOJD=fjQ@mail.gmail.com>
 <CA+55aFx1UsimN8AKvNP=UzM_4E2h48XuDxhBwk3MYQ7NC2Zazg@mail.gmail.com>
 <CAOMFOmUDuBomyp-kVRc3m9FuJSwkpg25MNYKo5ckbWuOExsn=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmUDuBomyp-kVRc3m9FuJSwkpg25MNYKo5ckbWuOExsn=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 10:58:55PM -0700, Anatol Pomozov wrote:
> >>
> >> loop_set_fd/loop_clr_fd (and any other loop ioctl) is called under
> >> loop_device->lo_ctl_mutex.
> >
> > Ok, good enough for me, I applied it, and it's commit
> > c1681bf8a7b1b98edee8b862a42c19c4e53205fd in my tree.
> >
> > I assume it should go to stable too, because none of this is new, is
> > it? Did you check how far back this applies? I assume this goes back
> > pretty much forever, no?
> 
> I bisected kernel using test from my commit and it points to
> 4c823cc3d568277aa6340d8df6981e34f4c4dee5 (appeared in kernel 3.2).
> 
> But even despite i cannot repro the crash on 3.0-stable, the
> underlying issue (block_device is not locked) still exists there. So I
> think patch should go to stable as well.

... except that you are doing invalidate *after* having done bdput.  Which
is probably valid (we have the same bdev pinned down by opened file used
to issue the ioclt), but it's a really bad style; this should be in opposite
order.
