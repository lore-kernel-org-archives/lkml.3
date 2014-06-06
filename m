Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaFFHt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:49:59 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50928 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFFHt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:49:58 -0400
Date: Fri, 6 Jun 2014 09:49:53 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] vt: Fix replacement console check when unbinding
Message-ID: <20140606074953.GB7416@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
 <CANq1E4RE+B+AhCfybzbJE--iQ_T7Z4TOsSSp7KEHNjpBM=4eqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4RE+B+AhCfybzbJE--iQ_T7Z4TOsSSp7KEHNjpBM=4eqQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 09:16:13AM +0200, David Herrmann wrote:
> Hi
> 
> On Thu, Jun 5, 2014 at 4:58 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > I don't fully understand the magic of the vt register/unregister
> > logic, but apparently everything but the inital console (as set
> > in the conswitchp pointer) is marked with FLAG_MODULE. Which means
> > if something unregistered the boot vt driver (e.g. i915.ko kicking
> > out vga_con) there's nothing left when trying to unbind e.g. fbcon
> > through sysfs.
> >
> > But we always have the dummy console hanging around, so this test
> > is fairly dubious. What we actually want is simply a different console
> > than the one we want to unbind.
> 
> For unknown reasons, you can disable the dummy console via Kconfig, so
> it's not guaranteed to be around. But your comment is still valid.

Right, I'll reword this a bit to clarify.
> 
> >
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/tty/vt/vt.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> > index 3ad0b61e35b4..ea600f482eeb 100644
> > --- a/drivers/tty/vt/vt.c
> > +++ b/drivers/tty/vt/vt.c
> > @@ -3155,8 +3155,7 @@ int do_unbind_con_driver(const struct consw *csw, int first, int last, int deflt
> >         for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
> >                 con_back = &registered_con_driver[i];
> >
> > -               if (con_back->con &&
> > -                   !(con_back->flag & CON_DRIVER_FLAG_MODULE)) {
> > +               if (con_back->con && con_back->con != csw) {
> 
> Funny thing is, if you run do_bind_con_driver() on the range first,
> you kick out the existing driver and can then unload it regardless
> whether the fallback was FLAG_MODULE or not. Therefore, I think that
> change is safe. This is:
> 
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> 
> Thanks
> David
> 
> >                         defcsw = con_back->con;
> >                         retval = 0;
> >                         break;
> > --
> > 1.8.1.4
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
