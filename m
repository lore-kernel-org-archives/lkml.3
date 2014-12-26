Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaLZVjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 16:39:14 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:64479 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLZVjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 16:39:09 -0500
MIME-Version: 1.0
In-Reply-To: <1419629187-13916-1-git-send-email-jmmahler@gmail.com>
References: <1419629187-13916-1-git-send-email-jmmahler@gmail.com>
Date: Fri, 26 Dec 2014 16:39:08 -0500
X-Google-Sender-Auth: gbuoD7hrQpARnJNYViXSTjFWq2c
Message-ID: <CAKb7Uvi2jXTeD9+pUg6YiQrwK1HaVt2aoC-to1Xw1htvmJao-w@mail.gmail.com>
Subject: Re: [PATCH] nouveau: fix ambiguous backlight controls
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 4:26 PM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> If a display supports backlight control using the nouveau driver, and
> also supports standard ACPI backlight control, there will be two sets of
> controls.
>
> /sys/class/backlight/acpi_video0
> /sys/class/backlight/nv_backlight
>
> This creates ambiguity because these controls can be out of sync with
> each other.  One could be at 100% while the other is at 0% and the
> actual display brightness depends on which one was used last.  This also
> creates anomalies in Powertop which will show two values for brightness
> with potentially different values.
>
> Fix this ambiguity by having the nouveau driver only enable its
> backlight controls if the standard ACPI controls are not present.
>
> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_backlight.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> index e566c5b..3a52bd4 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> @@ -221,6 +221,11 @@ nouveau_backlight_init(struct drm_device *dev)
>         struct nvif_device *device = &drm->device;
>         struct drm_connector *connector;
>
> +       if (acpi_video_backlight_support()) {

None of the other drivers have this. Is nouveau somehow different
than, say, radeon in this respect?

Unfortunately the backlight situation is pretty fubar'd... sometimes
the acpi controls don't work, sometimes the card controls don't work,
sometimes they both work but in different ways (and then everyone's
favourite -- neither works, and there's some third platform thing).
I'm pretty sure this code existed before, but got removed. See commit
bee564430feec1175ee64bcfd4913cacc519f817 and the previous commit
5bead799d3f8 before that. The ping-pong is probably not the right way
to go.

> +               dev_info(dev->dev, "Standard ACPI backlight control supported, disabling local control.\n");
> +               return 0;
> +       }
> +
>         list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
>                 if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS &&
>                     connector->connector_type != DRM_MODE_CONNECTOR_eDP)
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
