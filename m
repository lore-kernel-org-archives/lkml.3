Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLOQIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:08:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:21123 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaLOQId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:08:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,580,1413270000"; 
   d="scan'208";a="637805535"
Message-ID: <1418659681.15837.32.camel@intelbox>
Subject: Re: [PATCH v2 1/3] vt: fix check for system/busy console drivers
 when unregistering them
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2014 18:08:01 +0200
In-Reply-To: <CAKMK7uH4Lwv1CVqxrTnQm-HzeT5rJp_owXiCr4vwSc2rmrGqnQ@mail.gmail.com>
References: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
	 <1418505257-5591-1-git-send-email-imre.deak@intel.com>
	 <CAKMK7uH4Lwv1CVqxrTnQm-HzeT5rJp_owXiCr4vwSc2rmrGqnQ@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 16:05 +0100, Daniel Vetter wrote:
> This seems to partially revert
> 
> commit d9c660e750fdf982e1e2bdd0e76c1e6c4db4217b
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Thu Jun 5 16:29:56 2014 +0200
> 
>     vt: Fix up unregistration of vt drivers
> 
>     A bunch of issues:
>     - We should not kick out the default console (which is tracked in
>       conswitchp), so check for that.
>     - Add better error codes so callers can differentiate between "something
>       went wrong" and "your driver isn't registered already". i915 needs
>       that so it doesn't fall over when reloading the driver and hence
>       vga_con is already unregistered.
>     - There's a mess with the driver flags: What we need to check for is
>       that the driver isn't used any more, i.e. unbound completely (FLAG_INIT).
>       And not whether it's the boot console or not (which is the only one
>       which doesn't have FLAG_MODULE). Otherwise there's no way to kick
>       out the boot console, which i915 wants to do to prevent havoc with
>       vga_con interferring (which tends to hang machines).
> 
>     Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Cc: Jiri Slaby <jslaby@suse.cz>
>     Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>     Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> We really need to unregister vgacon when i915 loads since we
> completely kill vga support - just unbinding is not enough since then
> vgacon will be resurrect on module unload, killing the machine. And
> module unload is really important to stay sane as kernel driver
> hacker.
> 
> If we need more precise checks for unregistering then I think we need
> to fix up that mess with the flags ...

Ok, after discussing on IRC with Daniel, I agree this would break the
module reload case for i915 and we should allow to unload system console
drivers too. The only important thing seems to be that we have at least
one console driver left, let it be system or non-system, but that's
already guaranteed by the (csw == conswitchp) check. So I'll send a new
version removing the con_driver->flag check.

--Imre


> -Daniel
> 
> 
> On Sat, Dec 13, 2014 at 10:14 PM, Imre Deak <imre.deak@intel.com> wrote:
> > System console drivers (without the CON_DRIVER_FLAG_MODULE flag) and
> > busy drivers bound to a console (as reported by con_is_bound())
> > shouldn't be unregistered. The current code checks for the
> > CON_DRIVER_FLAG_INIT flag but this doesn't really correspond to either
> > of the above two conditions. CON_DRIVER_FLAG_INIT is set whenever its
> > associated console's con_startup() function is called, which first
> > happens when the console driver is registered (so before the console
> > gets bound) and gets cleared when the console gets unbound. The
> > purpose of this flag is to show if we need to call con_startup() on a
> > console before we use it.
> >
> > Based on the above, do_unregister_con_driver() in its current form will
> > incorrectly allow unregistering a console driver only if it was never
> > bound, but will refuse to unregister one that was bound and later
> > unbound. It will also allow unregistering a system console driver.
> >
> > Fix this by checking for CON_DRIVER_FLAG_MODULE to allow non-system
> > console drivers to unregister and prevent system console drivers from
> > unregistering. Rely on the existing con_is_bound() check earlier in the
> > function to refuse unregistering a busy console driver.
> >
> > v2:
> > - reword the third paragraph to clarify how the fix works (Peter Hurley)
> >
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/tty/vt/vt.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> > index b33b00b..1862e89 100644
> > --- a/drivers/tty/vt/vt.c
> > +++ b/drivers/tty/vt/vt.c
> > @@ -3660,7 +3660,7 @@ int do_unregister_con_driver(const struct consw *csw)
> >                 struct con_driver *con_driver = &registered_con_driver[i];
> >
> >                 if (con_driver->con == csw &&
> > -                   con_driver->flag & CON_DRIVER_FLAG_INIT) {
> > +                   con_driver->flag & CON_DRIVER_FLAG_MODULE) {
> >                         vtconsole_deinit_device(con_driver);
> >                         device_destroy(vtconsole_class,
> >                                        MKDEV(0, con_driver->node));
> > --
> > 1.8.4
> >
> 
> 
> 


