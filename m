Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaFFH5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:57:03 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65111 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaFFH5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:57:01 -0400
Date: Fri, 6 Jun 2014 09:56:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/5] vt: Fix up unregistration of vt drivers
Message-ID: <20140606075655.GC7416@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
 <1401980308-5116-2-git-send-email-daniel.vetter@ffwll.ch>
 <CANq1E4QpST-ZQbhm8FS-xuyda0dnYAFjasqFCspTPKdzJ6zW6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4QpST-ZQbhm8FS-xuyda0dnYAFjasqFCspTPKdzJ6zW6w@mail.gmail.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 09:24:35AM +0200, David Herrmann wrote:
> Hi
> 
> On Thu, Jun 5, 2014 at 4:58 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > A bunch of issues:
> > - We should not kick out the default console (which is tracked in
> >   conswitchp), so check for that.
> > - Add better error codes so callers can differentiate between "something
> >   went wrong" and "your driver isn't registered already". i915 needs
> >   that so it doesn't fall over when reloading the driver and hence
> >   vga_con is already unregistered.
> > - There's a mess with the driver flags: What we need to check for is
> >   that the driver isn't used any more, i.e. unbound completely (FLAG_INIT).
> >   And not whether it's the boot console or not (which is the only one
> >   which doesn't have FLAG_MODULE). Otherwise there's no way to kick
> >   out the boot console, which i915 wants to do to prevent havoc with
> >   vga_con interferring (which tends to hang machines).
> >
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/tty/vt/vt.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> > index ea600f482eeb..5077fe87324d 100644
> > --- a/drivers/tty/vt/vt.c
> > +++ b/drivers/tty/vt/vt.c
> > @@ -3573,17 +3573,20 @@ err:
> >   */
> >  int do_unregister_con_driver(const struct consw *csw)
> >  {
> > -       int i, retval = -ENODEV;
> > +       int i;
> >
> >         /* cannot unregister a bound driver */
> >         if (con_is_bound(csw))
> > -               goto err;
> > +               return -EBUSY;
> > +
> > +       if (csw == conswitchp)
> > +               return -EINVAL;
> 
> Ugh, that fix is correct, but I'd rather like to see
> do_unbind_con_driver() do the right thing. It currently resets
> conswitchp _only_ if the new fallback is unbound. Why not _always_ set
> conswitchp to defcsw _iff_ conswitchp == csw there?

Ha, that's what I've thought, too. But do_unbind doesn't actually change
conswitchp, it only restores it because apparently the
vga_con->con_startup function is a real con and changes it behind
everyones back for no good reason. Or at least that's what the comment
claims. Note how defconsw != defcsw ...

I've tried to follow around how conswitchp is actually used, but besides
that it's used to select the boot console I'm not sure at all what's going
hence.

> This way, you _know_ here that if !con_is_bound(csw), then csw != conswitchp.

Hence why I dropped this approach again (I've done it originally) and
opted for the straightforward but albeit crude direct check.

> >
> >         for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
> >                 struct con_driver *con_driver = &registered_con_driver[i];
> >
> >                 if (con_driver->con == csw &&
> > -                   con_driver->flag & CON_DRIVER_FLAG_MODULE) {
> > +                   con_driver->flag & CON_DRIVER_FLAG_INIT) {
> 
> That makes FLAG_MODULE almost a no-op except for ->unbind(). I wonder
> why FLAG_MODULE exists, anyway.

I've dug around in git history and it's less than useful. It was renamed
from FLAG_BIND (which makes somewhat sense, since it roughly tracks
whether a console is bound). But there's never been a justification for
it, neither in the original patch nor in the one that renamed it.

So I decided to not tempt fate and went with the small change here that
I've understood somewhat (I've tried other, more invasive changes and
failed).

> Otherwise looks good.

I'm really reluctant to do the right thing here since the code overall has
very unclear semantics with conswitchp and FLAG_MODULE. Can I convince
yout that the more direct approach here is the right one?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
