Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaETQRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:17:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56001 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaETQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <1400276595-6965-8-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org> <1400276595-6965-8-git-send-email-andi@firstfloor.org>
From: =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <maraeo@gmail.com>
Date: Tue, 20 May 2014 18:16:48 +0200
Message-ID: <CAAxE2A4YvKRNMu6ogYOX2zE2=N1Q6hd1c0niB3jf9f3P8rwoRw@mail.gmail.com>
Subject: Re: [PATCH 7/8] radeon: Out of line radeon_get_ib_value
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the function should stay in the header file. It's used in
performance-critical code, so we want it to be inlined.

Marek

On Fri, May 16, 2014 at 11:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Saves about 5k of text
>
>    text    data     bss     dec     hex filename
> 14080360        2008168 1507328 17595856        10c7dd0 vmlinux-before-radeon
> 14074978        2008168 1507328 17590474        10c68ca vmlinux-radeon
>
> Cc: alexander.deucher@amd.com
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/gpu/drm/radeon/radeon.h        | 10 +---------
>  drivers/gpu/drm/radeon/radeon_device.c |  9 +++++++++
>  2 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 6852861..8cae409 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -1032,15 +1032,7 @@ struct radeon_cs_parser {
>         struct ww_acquire_ctx   ticket;
>  };
>
> -static inline u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
> -{
> -       struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
> -
> -       if (ibc->kdata)
> -               return ibc->kdata[idx];
> -       return p->ib.ptr[idx];
> -}
> -
> +u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx);
>
>  struct radeon_cs_packet {
>         unsigned        idx;
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 0e770bb..1cbd171 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -112,6 +112,15 @@ bool radeon_is_px(struct drm_device *dev)
>         return false;
>  }
>
> +u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
> +{
> +       struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
> +
> +       if (ibc->kdata)
> +               return ibc->kdata[idx];
> +       return p->ib.ptr[idx];
> +}
> +
>  /**
>   * radeon_program_register_sequence - program an array of registers.
>   *
> --
> 1.9.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
