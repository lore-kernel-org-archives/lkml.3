Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaHEVZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:25:49 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41001 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaHEVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <53E13D78.6000903@tilera.com>
References: <1406383386-1400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <53E13D78.6000903@tilera.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 5 Aug 2014 23:25:27 +0200
Message-ID: <CAFo99gZ1rOqD-RFN7Shx4mWO4kfVLCXpuxUWqOwK5uY6uwAh3Q@mail.gmail.com>
Subject: Re: [PATCH] arch: tile: gxio: mpipe.c: Cleaning up missing
 null-terminate in conjunction with strncpy
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-05 22:24 GMT+02:00 Chris Metcalf <cmetcalf@tilera.com>:
> On 7/26/2014 10:03 AM, Rickard Strandqvist wrote:
>>
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>
>
> While using strlcpy() instead of strncpy() and an explicit NUL termination
> is obviously an improvement, on reflection it doesn't feel like the best
> solution here - and likely in many similar APIs.  A partial string argument
> should not be passed on to other components; it's just an error by
> definition and should be treated that way.  While we could check the
> strlcpy() return value explicitly against the length, this is somewhat
> awkward as it requires naming the length twice, and also means we end
> up doing the copy pointlessly if we're about to return an error anyway.
>
> The following change includes Yet Another String Copy function; this may
> or may not be a fabulous idea, but at least it encapsulates the error
> checking in a way that seems like it makes the call sites cleaner.
>
>
> From: Chris Metcalf <cmetcalf@tilera.com>
> Date: Tue, 5 Aug 2014 16:16:13 -0400
> Subject: [PATCH] tile: avoid errors from truncating long strings in mpipe
> gxio
>
> Using strncpy() will just silently truncate long strings; we should
> instead return an appropriate error.  Using strlcpy() would suffer from
> the same problem.  Instead, use strlen()+memcpy(), and add an
> error-checking step to make sure the lengths are reasonable.
>
> I called the convenience wrapper strscpy(), and a case could be made for
> making it more generic (possibly with a better name), but that seems
> outside the scope of this initial commit.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/gxio/mpipe.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/arch/tile/gxio/mpipe.c b/arch/tile/gxio/mpipe.c
> index 5301a9ffbae1..8b3c201dfdb7 100644
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
> +       size_t ret = strlen(src) + 1;
> +       if (ret > size) {
> +               if (size)
> +                       dest[0] = '\0';
> +               return 0;
> +       }
> +       memcpy(dest, src, ret);
> +       return ret;
> +}
> +
>  int gxio_mpipe_init(gxio_mpipe_context_t *context, unsigned int
> mpipe_index)
>  {
>         char file[32];
> @@ -511,8 +530,8 @@ int gxio_mpipe_link_instance(const char *link_name)
>
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
> @@ -529,7 +548,8 @@ int gxio_mpipe_link_enumerate_mac(int idx, char
> *link_name, uint8_t *link_mac)
>
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
>
>         _gxio_mpipe_link_name_t name;
>         int rv;
>
> -       strncpy(name.name, link_name, sizeof(name.name));
> -       name.name[GXIO_MPIPE_LINK_NAME_LEN - 1] = '\0';
> +       if (strscpy(name.name, link_name, sizeof(name.name)) == 0)
> +               return GXIO_ERR_NO_DEVICE;
>
>
>         rv = gxio_mpipe_link_open_aux(context, name, flags);
>         if (rv < 0)
> --
> 1.8.3.1
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>


Hi Chris!

Very good that something takes hold of this problem!

This has recently been discussed, where even Linus did a little post:

https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5

This further clarifies the problem that really all of these functions
have same kind of problem. What Linus says about strlcpy I had not
heard before, but it's actually unusually unnecessary and stupid to
have that "feature".
Seeing that your strscpy() would have the same problem, change to
using strnlen() perhaps?


You want to have the more of a control, noaction on a error.
I would otherwise like to have an alternative to strncpy that something like:

char *strnzcpy(char *dest, const char *src, size_t count)
{
  if(0 == count)
    return dest;
  strncpy(dest, src, --count);
  dest[count] = '\0';
  return dest;
}

... But if we really going to rewrite it we should do it properly so
you can  get the equivalent to strlen as a return.
And then return = count than the string was too long. Simply return
the char *dest is so unnecessary :-)


Kind regards
Rickard Strandqvist
