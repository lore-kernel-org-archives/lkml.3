Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaJBKoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:44:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaJBKoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:44:13 -0400
Date: Thu, 2 Oct 2014 12:44:10 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Subject: Re: [PATCHv8.1] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
Message-ID: <20141002104410.GB19748@quack.suse.cz>
References: <cover.1411562410.git.ydroneaud@opteya.com>
 <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
 <542481B3.8070300@gmx.de>
 <1411721898.7778.18.camel@localhost.localdomain>
 <542666B2.9080700@gmx.de>
 <1411980555-10818-1-git-send-email-ydroneaud@opteya.com>
 <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 01-10-14 15:36:21, Andrew Morton wrote:
> On Mon, 29 Sep 2014 10:49:15 +0200 Yann Droneaud <ydroneaud@opteya.com> wrote:
> 
> > According to commit 80af258867648 ('fanotify: groups can specify
> > their f_flags for new fd'), file descriptors created as part of
> > file access notification events inherit flags from the
> > event_f_flags argument passed to syscall fanotify_init(2).
> > 
> > So while it is legal for userspace to call fanotify_init() with
> > O_CLOEXEC as part of its second argument, O_CLOEXEC is currently
> > silently ignored.
> > 
> > Indeed event_f_flags are only given to dentry_open(), which only
> > seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
> > O_DIRECT in open_check_o_direct() and O_LARGEFILE in
> > generic_file_open().
> > 
> > But it seems logical to set close-on-exec flag on the file
> > descriptor if userspace is allowed to request it with O_CLOEXEC.
> > 
> > In fact, according to some lookup on http://codesearch.debian.net/
> > and various search engine, there's already some userspace code
> > requesting it:
> > 
> > - in systemd's readahead[2]:
> > 
> >     fanotify_fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);
> > 
> > - in clsync[3]:
> > 
> >     #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)
> > 
> >     int fanotify_d = fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);
> > 
> > - in examples [4] from "Filesystem monitoring in the Linux
> >   kernel" article[5] by Aleksander Morgado:
> > 
> >     if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
> >                                       O_RDONLY | O_CLOEXEC | O_LARGEFILE)) < 0)
> 
> So we have a number of apps which are setting O_CLOEXEC, but it doesn't
> actually work.  With this change it *will* work, so the behaviour of
> those apps might change, possibly breaking them?
  Possibly. OTOH I'd dare to say that most of the apps specifying O_CLOEXEC
want that behavior and their security may be weakened by the fact that
O_CLOEXEC is ignored. So we are weighting possible security issues for apps
doing things right (and Mihai mentioned in this thread that at least he has
an application which needs O_CLOEXEC working) against possible breakage for
apps which just randomly set O_CLOEXEC without wanting. So I'm really for
fixing O_CLOEXEC behavior.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
