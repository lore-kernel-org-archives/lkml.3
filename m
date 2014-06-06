Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaFFHNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:13:42 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64193 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFFHNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <1401980308-5116-3-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
	<1401980308-5116-3-git-send-email-daniel.vetter@ffwll.ch>
Date: Fri, 6 Jun 2014 09:13:40 +0200
Message-ID: <CANq1E4Tg3+7VRBe+k6dbsNx=M_NO7XodK--yc+4ej4Lw6-i6KA@mail.gmail.com>
Subject: Re: [PATCH 3/5] vt: Don't ignore unbind errors in vt_unbind
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
> Otherwise the loop will never stop since we don't make any
> forward progress. Noticed while breaking this accidentally
> in a painful attempt to make vga_con unregistering work.
>
> With this patch we'll bail out on the first attempt, which
> at least leaves a useful enough system behind for debugging.
> Livelocks on console_lock just aren't fun.
>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

We used to return 0 on errors here, which is very backwards to me.. so
your change to use "retval" looks fine to me. This is:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  drivers/tty/vt/vt.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 5077fe87324d..3c00dcb3b145 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3260,6 +3260,7 @@ static int vt_unbind(struct con_driver *con)
>  {
>         const struct consw *csw = NULL;
>         int i, more = 1, first = -1, last = -1, deflt = 0;
> +       int ret;
>
>         if (!con->con || !(con->flag & CON_DRIVER_FLAG_MODULE) ||
>             con_is_graphics(con->con, con->first, con->last))
> @@ -3285,8 +3286,10 @@ static int vt_unbind(struct con_driver *con)
>
>                 if (first != -1) {
>                         console_lock();
> -                       do_unbind_con_driver(csw, first, last, deflt);
> +                       ret = do_unbind_con_driver(csw, first, last, deflt);
>                         console_unlock();
> +                       if (ret != 0)
> +                               return ret;
>                 }
>
>                 first = -1;
> --
> 1.8.1.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
