Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaFFHYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:24:37 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:37815 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaFFHYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:24:36 -0400
MIME-Version: 1.0
In-Reply-To: <1401980308-5116-2-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
	<1401980308-5116-2-git-send-email-daniel.vetter@ffwll.ch>
Date: Fri, 6 Jun 2014 09:24:35 +0200
Message-ID: <CANq1E4QpST-ZQbhm8FS-xuyda0dnYAFjasqFCspTPKdzJ6zW6w@mail.gmail.com>
Subject: Re: [PATCH 2/5] vt: Fix up unregistration of vt drivers
From: David Herrmann <dh.herrmann@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jun 5, 2014 at 4:58 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> A bunch of issues:
> - We should not kick out the default console (which is tracked in
>   conswitchp), so check for that.
> - Add better error codes so callers can differentiate between "something
>   went wrong" and "your driver isn't registered already". i915 needs
>   that so it doesn't fall over when reloading the driver and hence
>   vga_con is already unregistered.
> - There's a mess with the driver flags: What we need to check for is
>   that the driver isn't used any more, i.e. unbound completely (FLAG_INIT).
>   And not whether it's the boot console or not (which is the only one
>   which doesn't have FLAG_MODULE). Otherwise there's no way to kick
>   out the boot console, which i915 wants to do to prevent havoc with
>   vga_con interferring (which tends to hang machines).
>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/tty/vt/vt.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index ea600f482eeb..5077fe87324d 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3573,17 +3573,20 @@ err:
>   */
>  int do_unregister_con_driver(const struct consw *csw)
>  {
> -       int i, retval = -ENODEV;
> +       int i;
>
>         /* cannot unregister a bound driver */
>         if (con_is_bound(csw))
> -               goto err;
> +               return -EBUSY;
> +
> +       if (csw == conswitchp)
> +               return -EINVAL;

Ugh, that fix is correct, but I'd rather like to see
do_unbind_con_driver() do the right thing. It currently resets
conswitchp _only_ if the new fallback is unbound. Why not _always_ set
conswitchp to defcsw _iff_ conswitchp == csw there?

This way, you _know_ here that if !con_is_bound(csw), then csw != conswitchp.

>
>         for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
>                 struct con_driver *con_driver = &registered_con_driver[i];
>
>                 if (con_driver->con == csw &&
> -                   con_driver->flag & CON_DRIVER_FLAG_MODULE) {
> +                   con_driver->flag & CON_DRIVER_FLAG_INIT) {

That makes FLAG_MODULE almost a no-op except for ->unbind(). I wonder
why FLAG_MODULE exists, anyway.

Otherwise looks good.

Thanks
David

>                         vtconsole_deinit_device(con_driver);
>                         device_destroy(vtconsole_class,
>                                        MKDEV(0, con_driver->node));
> @@ -3594,12 +3597,11 @@ int do_unregister_con_driver(const struct consw *csw)
>                         con_driver->flag = 0;
>                         con_driver->first = 0;
>                         con_driver->last = 0;
> -                       retval = 0;
> -                       break;
> +                       return 0;
>                 }
>         }
> -err:
> -       return retval;
> +
> +       return -ENODEV;
>  }
>  EXPORT_SYMBOL_GPL(do_unregister_con_driver);
>
> --
> 1.8.1.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
