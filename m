Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3E0SW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 14:22:26 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57778 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3E0SWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 14:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <1369626821-28494-1-git-send-email-acourbot@nvidia.com>
References: <1369626821-28494-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 27 May 2013 20:22:21 +0200
Message-ID: <CANq1E4Qa6g-zrA6o_u3w6mpVcUk8-ZPPR+edu6EXgpk-kGQULQ@mail.gmail.com>
Subject: Re: [PATCH v2] video: simplefb: add mode parsing function
From: David Herrmann <dh.herrmann@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Rob Clark <robclark@gmail.com>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, May 27, 2013 at 5:53 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> The naming scheme of simplefb's mode is precise enough to allow building
> the mode structure from it instead of using a static list of modes. This
> patch introduces a function that does this. In case exotic modes that
> cannot be represented from their name alone are needed, the static list
> of modes is still available as a backup.
>
> It also changes the order in which colors are declared from MSB first to
> the more standard LSB first.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Changes from v1:
> - amended documentation following Stephen's suggestion
> - allow parsing of bitfields larger than 9 bits
> - made it clear that the parsing order of bits is changed with respect
>   to the original patch
>
> Andrew, since this patch introduces a (small) change in the DT bindings,
> could we try to merge it during the -rc cycle so we don't have to come
> with a more complex solution in the future?
>
>  .../bindings/video/simple-framebuffer.txt          | 12 +++-
>  drivers/video/simplefb.c                           | 72 +++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/video/simple-framebuffer.txt b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> index 3ea4605..18d03e2 100644
> --- a/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> +++ b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> @@ -10,8 +10,16 @@ Required properties:
>  - width: The width of the framebuffer in pixels.
>  - height: The height of the framebuffer in pixels.
>  - stride: The number of bytes in each line of the framebuffer.
> -- format: The format of the framebuffer surface. Valid values are:
> -  - r5g6b5 (16-bit pixels, d[15:11]=r, d[10:5]=g, d[4:0]=b).
> +- format: The format of the framebuffer surface. Described as a sequence of
> +       channel/num-bits pairs, where each pair describes how many bits are used
> +       by a given color channel. Value channels are "r" (red), "g" (green),
> +       "b" (blue), "a" (alpha) and "x" (unused). Channels are listed in bit
> +       order, starting from the LSB. For instance, a format named "r5g6b5"
> +       describes a 16-bit format where red is encoded in the 5 less significant
> +       bits, green in the 6 following ones, and blue in the 5 last:
> +                               BBBBBGGG GGGRRRRR
> +                               ^               ^
> +                              MSB             LSB

Is there a specific reason why we need arbitrary RGB formats? I have a
KMS/DRM driver based on dvbe that can provide the exact same
functionality as this fbdev driver (including an fbdev
backwards-compat layer). However, DRM does not allow arbitrary formats
but rather provides a huge list of supported formats.

If we apply this patch it will get very hard to support this with a
KMS driver. So any reason why we cannot use the DRM FOURCC constants
instead?

The dvbe proposal is available here: (also see the two following patches)
  http://lkml.indiana.edu/hypermail/linux/kernel/1302.2/00274.html

it provides a simple DRM driver that uses VESA / VBE. I am currently
trying to rework it to "SimpleDRM" which can support arbitrary
firmware framebuffers.

Cheers
David

>  Example:
>
> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
> index e2e9e3e..1430752 100644
> --- a/drivers/video/simplefb.c
> +++ b/drivers/video/simplefb.c
> @@ -21,6 +21,7 @@
>   */
>
>  #include <linux/errno.h>
> +#include <linux/ctype.h>
>  #include <linux/fb.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> @@ -82,8 +83,72 @@ struct simplefb_format {
>         struct fb_bitfield transp;
>  };
>
> +static struct simplefb_format *simplefb_parse_format(struct device *dev,
> +                                                    const char *str)
> +{
> +       struct simplefb_format *format;
> +       unsigned int offset = 0;
> +       unsigned int i = 0;
> +
> +       format = devm_kzalloc(dev, sizeof(*format), GFP_KERNEL);
> +       if (!format)
> +               return ERR_PTR(-ENOMEM);
> +
> +       while (str[i] != 0) {
> +               struct fb_bitfield *field = NULL;
> +               int length = 0;
> +
> +               switch (str[i++]) {
> +               case 'r':
> +               case 'R':
> +                       field = &format->red;
> +                       break;
> +               case 'g':
> +               case 'G':
> +                       field = &format->green;
> +                       break;
> +               case 'b':
> +               case 'B':
> +                       field = &format->blue;
> +                       break;
> +               case 'a':
> +               case 'A':
> +                       field = &format->transp;
> +                       break;
> +               case 'x':
> +               case 'X':
> +                       break;
> +               default:
> +                       goto error;
> +               }
> +
> +               if (!isdigit(str[i]))
> +                       goto error;
> +
> +               while (isdigit(str[i])) {
> +                       length = length * 10 + (str[i++] - '0');
> +               }
> +
> +               if (field) {
> +                       field->offset = offset;
> +                       field->length = length;
> +               }
> +
> +               offset += length;
> +       }
> +
> +       format->bits_per_pixel = (offset + 7) & ~0x7;
> +       format->name = str;
> +       return format;
> +
> +error:
> +       dev_err(dev, "Invalid format string\n");
> +       return ERR_PTR(-EINVAL);
> +}
> +
> +/* if you use exotic modes that simplefb_parse_format cannot decode, you can
> +   specify them here. */
>  static struct simplefb_format simplefb_formats[] = {
> -       { "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
>  };
>
>  struct simplefb_params {
> @@ -131,7 +196,10 @@ static int simplefb_parse_dt(struct platform_device *pdev,
>                 params->format = &simplefb_formats[i];
>                 break;
>         }
> -       if (!params->format) {
> +       if (!params->format)
> +               params->format = simplefb_parse_format(&pdev->dev, format);
> +
> +       if (IS_ERR(params->format)) {
>                 dev_err(&pdev->dev, "Invalid format value\n");
>                 return -EINVAL;
>         }
> --
> 1.8.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
