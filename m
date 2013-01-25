Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3AYPzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:55:43 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56319 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3AYPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:55:39 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1359078224-3327-1-git-send-email-airlied@gmail.com>
References: <1359078224-3327-1-git-send-email-airlied@gmail.com>
Date: Fri, 25 Jan 2013 16:55:37 +0100
X-Google-Sender-Auth: DpprhvwIJNVcKvDlUwJP0aHpo9g
Message-ID: <CAKMK7uEe7J=yKWO4ARSy_jMbAkGFX7LSs3Z5aEuMuNE=hx2Gzg@mail.gmail.com>
Subject: Re: [PATCH] fbcon: fix locking harder
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 2:43 AM, Dave Airlie <airlied@gmail.com> wrote:
> Okay so Alan's patch handled the case where there was no registered fbcon,
> however the other path entered in set_con2fb_map pit.
>
> In there we called fbcon_takeover, but we also took the console lock in a couple
> of places. So push the console lock out to the callers of set_con2fb_map,
>
> this means fbmem and switcheroo needed to take the lock around the fb notifier
> entry points that lead to this.
>
> This should fix the efifb regression seen by Maarten.
>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/gpu/vga/vga_switcheroo.c |  3 +++
>  drivers/video/console/fbcon.c    | 11 ++++++++---
>  drivers/video/fbmem.c            |  2 ++
>  3 files changed, 13 insertions(+), 3 deletions(-)
>
[cut]

>         ret = vgasr_priv.handler->switchto(new_client->id);
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index 2aef9ca..2e2d959 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -842,6 +842,8 @@ static void con2fb_init_display(struct vc_data *vc, struct fb_info *info,
>   *
>   *     Maps a virtual console @unit to a frame buffer device
>   *     @newidx.
> + *
> + *     This should be called with the console lock held.
>   */
>  static int set_con2fb_map(int unit, int newidx, int user)
>  {

What about throwing a WARN_CONSOLE_UNLOCKED(); in here to make sure
this new rule is obeyed?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
