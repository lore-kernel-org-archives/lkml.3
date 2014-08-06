Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaHFVPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:15:05 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:62861 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaHFVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:15:04 -0400
MIME-Version: 1.0
In-Reply-To: <201408061838.s76Ic6lV014201@farm-0039.internal.tilera.com>
References: <1406383386-1400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <53E13D78.6000903@tilera.com> <CAFo99gZ1rOqD-RFN7Shx4mWO4kfVLCXpuxUWqOwK5uY6uwAh3Q@mail.gmail.com>
 <201408061838.s76Ic6lV014201@farm-0039.internal.tilera.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Wed, 6 Aug 2014 23:14:43 +0200
Message-ID: <CAFo99gYqETVSk0=s=RX2UG+FL2UYAFWEdpGO9xB7v6scMhkJfA@mail.gmail.com>
Subject: Re: [PATCH v2] tile: avoid errors from truncating long strings in
 mpipe gxio
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-06 20:16 GMT+02:00 Chris Metcalf <cmetcalf@tilera.com>:
> Using strncpy() will just silently truncate long strings; we should
> instead return an appropriate error.  Using strlcpy() would suffer from
> the same problem.  Instead, use strnlen()+memcpy(), and add an
> error-checking step to make sure the lengths are reasonable.
>
> I called the convenience wrapper strscpy(), and a case could be made for
> making it more generic (possibly with a better name), but that seems
> outside the scope of this initial commit.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> v2: use strnlen instead of strlen
>
>  arch/tile/gxio/mpipe.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/arch/tile/gxio/mpipe.c b/arch/tile/gxio/mpipe.c
> index 5301a9ffbae1..27a56be8d583 100644
> --- a/arch/tile/gxio/mpipe.c
> +++ b/arch/tile/gxio/mpipe.c
> @@ -29,6 +29,25 @@
>  /* HACK: Avoid pointless "shadow" warnings. */
>  #define link link_shadow
>
> +/*
> + * Use this routine to avoid copying too-long strings.  Unlike strncpy
> + * or strlcpy, we don't enable programmers who don't check return codes;
> + * partially-copied strings can be problematic.  The routine returns
> + * the total number of bytes copied (including the trailing NUL) or
> + * zero if the buffer wasn't big enough.
> + */
> +static size_t strscpy(char *dest, const char *src, size_t size)
> +{
> +       size_t ret = strnlen(src, size) + 1;
> +       if (ret > size) {
> +               if (size)
> +                       dest[0] = '\0';
> +               return 0;
> +       }
> +       memcpy(dest, src, ret);
> +       return ret;
> +}
> +
>  int gxio_mpipe_init(gxio_mpipe_context_t *context, unsigned int mpipe_index)
>  {
>         char file[32];
> @@ -511,8 +530,8 @@ int gxio_mpipe_link_instance(const char *link_name)
>         if (!context)
>                 return GXIO_ERR_NO_DEVICE;
>
> -       strncpy(name.name, link_name, sizeof(name.name));
> -       name.name[GXIO_MPIPE_LINK_NAME_LEN - 1] = '\0';
> +       if (strscpy(name.name, link_name, sizeof(name.name)) == 0)
> +               return GXIO_ERR_NO_DEVICE;
>
>         return gxio_mpipe_info_instance_aux(context, name);
>  }
> @@ -529,7 +548,8 @@ int gxio_mpipe_link_enumerate_mac(int idx, char *link_name, uint8_t *link_mac)
>
>         rv = gxio_mpipe_info_enumerate_aux(context, idx, &name, &mac);
>         if (rv >= 0) {
> -               strncpy(link_name, name.name, sizeof(name.name));
> +               if (strscpy(link_name, name.name, sizeof(name.name)) == 0)
> +                       return GXIO_ERR_INVAL_MEMORY_SIZE;
>                 memcpy(link_mac, mac.mac, sizeof(mac.mac));
>         }
>
> @@ -545,8 +565,8 @@ int gxio_mpipe_link_open(gxio_mpipe_link_t *link,
>         _gxio_mpipe_link_name_t name;
>         int rv;
>
> -       strncpy(name.name, link_name, sizeof(name.name));
> -       name.name[GXIO_MPIPE_LINK_NAME_LEN - 1] = '\0';
> +       if (strscpy(name.name, link_name, sizeof(name.name)) == 0)
> +               return GXIO_ERR_NO_DEVICE;
>
>         rv = gxio_mpipe_link_open_aux(context, name, flags);
>         if (rv < 0)
> --
> 1.8.3.1
>


Looks good to me, and I did some tests to of the strncpy funktion.

Reviewed-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Kind regards
Rickard Strandqvist
