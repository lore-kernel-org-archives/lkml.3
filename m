Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbaD2U4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbaD2U4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:56:05 -0400
Message-ID: <1398804953.2585.5.camel@flatline.rdu.redhat.com>
Subject: Re: fanotify API: FMODE_NONOTIFY, FMODE_EXEC, FMODE_NOCMTIME
From: Eric Paris <eparis@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 29 Apr 2014 16:55:53 -0400
In-Reply-To: <20140429201006.GD29634@quack.suse.cz>
References: <CAKgNAkiq+yA7_tnvCVXemFy6P5F0eMccw18-GdqFthuzagvF5Q@mail.gmail.com>
	 <20140429201006.GD29634@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-29 at 22:10 +0200, Jan Kara wrote:
>   Hello,
> 
> On Tue 29-04-14 15:29:12, Michael Kerrisk (man-pages) wrote:
> > Can you offer any insight on Heinrich's question, below?
> > 
> > On Sun, Apr 13, 2014 at 4:05 PM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> > > On 06.04.2014 14:18, Michael Kerrisk (man-pages) wrote:
> > >>>
> > >>> ==
> > >>> >
> > >>> >  >> I notice that the FDs returned by read()s from the FAN FD have the
> > >>> >  >> FMODE_NONOTIFY flag (fcntl(F_GETFL)) flag set. If you know what
> > >>> > that's
> > >>> >  >> about, it would be good to say something about. But, if not, do not
> > >>> >  >> worry--just place a FIXME in the page source of fanotify(7)
> > >>> >
> > >>> >Fixed in fanotify.7
> > >>> >If the listener accesses the file through the file descriptor provided
> > >>> >no additional events are created.
> > >>
> > >> Ahh -- thanks for filling in that piece. I see that you refer to
> > >> fcntl(2) when discussing that flag. But fcntl(2) does not
> > >> mention that flag. I would rather see an explanation of this flag
> > >> in the fanotify pages.
> > >>
> > >
> > > I wrote a small test program and found:
> > >
> > > The flag FMODE_NONOTIFY can be read by function fcntl from userspace.
> > > int flag = fcntl(fd, F_GETFL)
> > >
> > > In include/uapi/asm-generic/fcntl.h I found the following comment:
> > >
> > > /*
> > >  * FMODE_EXEC is 0x20
> > >  * FMODE_NONOTIFY is 0x1000000
> > >  * These cannot be used by userspace O_* until internal and external open
> > >  * flags are split.
> > >  * -Eric Paris
> > >  */
> > >
> > > The definition of FMODE_NONOTIFY is in include/linux/fs.h but this
> > > include is only used to compile the Kernel and not supposed to be used by
> > > userspace.
> > >
> > > I think it is quite annoying that fcntl can return a flag that is not
> > > described in the manpage of fcntl and that is not defined in fcntl.h.
> > >
> > > But FMODE_NONOTIFY is not the only flag:
> > >
> > > I was able to pass
> > > 0x20 (FMODE_EXEC), and
> > > 0x800 (FMODE_NOCMTIME)
> > > to fanotify_init and received them as flag in the file descriptors for the
> > > fanotify events.
> > > I wonder why fanotify_init does not check import parameter event_f_flags and
> > > return an error if any inappropriate value is set.
>   It seems to me fanotify_init() should really check event_f_flags have
> only valid flags set. In particular exclude FMODE_EXEC, FMODE_NOCMTIME, or
> FMODE_NONOTIFY.

Agreed.  Clearly a bug on my part.

> > > Should I put this into the BUGS section?
> > >
> > > Should the name of the flag FMODE_NONOTIFY be mentioned at all in the man
> > > pages?
> > >
> > > Or should we write:
> > >
> > > .I fd
> > > This is an open file descriptor for the object being accessed or
> > > .B FAN_NOFD
> > > if a queue overflow occurred.
> > > The file descriptor can be used to access the contents of the monitored file
> > > or
> > > directory.
> > > It has an internal flag set, that suppresses fanotify event generation.
> > > Hence when the receiver of the fanotify event accesses the notified file or
> > > directory using this file descriptor no additional events will be created.
> > > The reading application is responsible for closing the file descriptor.
>   So this is what I would prefer. Just mention the file descriptor does not
> generate new events. I would even go as far as masking kernel internal
> flags like FMODE_EXEC or FMODE_NONOTIFY from the result of F_GETFL. What do
> you think Al?

I agree on this point too...

