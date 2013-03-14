Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3CNOD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:03:29 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:60743 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CNOD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <1358762191-13839-1-git-send-email-matthieu.castet@parrot.com>
References: <1358762191-13839-1-git-send-email-matthieu.castet@parrot.com>
Date: Thu, 14 Mar 2013 15:03:26 +0100
X-Google-Sender-Auth: JByxg3M5RnL18ctQmCljGhUHJxU
Message-ID: <CANnE-qdjPOikHTkU9OPJOJWzm=96COwg4EaCGg3iNLiDaLW6mQ@mail.gmail.com>
Subject: Re: [PATCH] slab : allow SLAB_RED_ZONE and SLAB_STORE_USER to work on arm
From: Castet Matthieu <matthieu.castet@parrot.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 10:56 AM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> The current slab code only allow to put redzone( and user store) info if "buffer
> alignment(ralign) <= __alignof__(unsigned long long)". This was done because we
> want to keep the buffer aligned for user even after adding redzone at the
> beginning of the buffer (the user store is stored after user buffer) [1]
>
> But instead of disabling this feature when "ralign > __alignof__(unsigned long
> long)", we can force the alignment by allocating ralign before user buffer.
>
> This is done by setting ralign in obj_offset when "ralign > __alignof__(unsigned
> long long)" and keeping the old behavior when  "ralign <= __alignof__(unsigned
> long long)" (we set sizeof(unsigned long long)).
>
> The 5c5e3b33b7cb959a401f823707bee006caadd76e commit wasn't handling "ralign <=
> __alignof__(unsigned long long)", that's why it broked some configuration.
>
> This was tested on omap3 (ralign is 64 and __alignof__(unsigned long long) is 8)
>
> [1]
> /*
>  * memory layout of objects:
>  * 0        : objp
>  * 0 .. cachep->obj_offset - BYTES_PER_WORD - 1: padding. This ensures that
>  *      the end of an object is aligned with the end of the real
>  *      allocation. Catches writes behind the end of the allocation.
>  * cachep->obj_offset - BYTES_PER_WORD .. cachep->obj_offset - 1:
>  *      redzone word.
>  * cachep->obj_offset: The real object.
>  * cachep->buffer_size - 2* BYTES_PER_WORD: redzone word [BYTES_PER_WORD long]
>  * cachep->buffer_size - 1* BYTES_PER_WORD: last caller address
>  *                  [BYTES_PER_WORD long]
>  */

Ping,

Thanks,

Matthieu


>
> Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
> CC: Russell King <rmk@arm.linux.org.uk>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slab.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index e7667a3..d2380d9 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2392,9 +2392,6 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
>         if (ralign < cachep->align) {
>                 ralign = cachep->align;
>         }
> -       /* disable debug if necessary */
> -       if (ralign > __alignof__(unsigned long long))
> -               flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>         /*
>          * 4) Store it.
>          */
> @@ -2414,8 +2411,9 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
>          */
>         if (flags & SLAB_RED_ZONE) {
>                 /* add space for red zone words */
> -               cachep->obj_offset += sizeof(unsigned long long);
> -               size += 2 * sizeof(unsigned long long);
> +               int offset = max(ralign, sizeof(unsigned long long));
> +               cachep->obj_offset += offset;
> +               size += offset + sizeof(unsigned long long);
>         }
>         if (flags & SLAB_STORE_USER) {
>                 /* user store requires one word storage behind the end of
> --
> 1.7.10.4
>
