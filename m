Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3JIBSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:18:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60657 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3JIBSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:18:36 -0400
Date: Wed, 9 Oct 2013 02:18:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 10/13] make dump_emit() use vfs_write() instead of
 banging at ->f_op->write directly
Message-ID: <20131009011833.GE13318@ZenIV.linux.org.uk>
References: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
 <CA+55aFxvNhuXoux88tcYemMWe5Nxdc-srfj3YgBZ7LJ-JaBEdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxvNhuXoux88tcYemMWe5Nxdc-srfj3YgBZ7LJ-JaBEdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 05:52:42PM -0700, Linus Torvalds wrote:
> On Tue, Oct 8, 2013 at 5:15 PM, Al Viro <viro@ftp.linux.org.uk> wrote:
> >
> > ... and deal with short writes properly
> 
> .. except you don't.
> 
> > +       while (nr) {
> > +               if (dump_interrupted())
> > +                       return 0;
> > +               n = vfs_write(file, addr, nr, &pos);
> > +               if (n < 0)
> > +                       return 0;
> > +               file->f_pos = pos;
> > +               cprm->written += n;
> > +               nr -= n;
> > +       }
> 
> Please handle 'n == 0' too. Maybe it never happens (ie you get EPIPE
> or ENOSPC), but write returning zero is actually possible and a valid
> return value and traditional for "end of media". Looping forever is
> not a good idea.

Point, but I would argue that we should yell very loud if we get 0 from
vfs_write() for non-zero size.  I'm not sure if POSIX allows write(2)
to return that, but a lot of userland code won't be expecting that and
won't be able to cope...
