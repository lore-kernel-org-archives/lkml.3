Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803Ab3BLOID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:08:03 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:56039 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3BLOIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:08:01 -0500
MIME-Version: 1.0
In-Reply-To: <1360618472-14821-1-git-send-email-tim.gardner@canonical.com>
References: <1360618472-14821-1-git-send-email-tim.gardner@canonical.com>
Date: Tue, 12 Feb 2013 09:07:58 -0500
Message-ID: <CADnq5_OMZzZYx66L===VmqjZt5+rb2_+BOm1fiFbHmrZ6_cW+A@mail.gmail.com>
Subject: Re: [PATCH linux-next] drm/radeon: Avoid NULL pointer dereference
 from atom_index_iio() allocation failure
From: Alex Deucher <alexdeucher@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        dri-devel@lists.freedesktop.org, Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 4:34 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Smatch anlysis:
>
> drivers/gpu/drm/radeon/atom.c:1242 atom_index_iio() error: potential null
>  dereference 'ctx->iio'.  (kzalloc returns null)
>
> Also cleaned up some checks before calls to kfree(). kfree(NULL) is OK.
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Michel Dänzer" <michel.daenzer@amd.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: "Christian König" <christian.koenig@amd.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Applied to my -next tree.  thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/atom.c          |    9 +++++++--
>  drivers/gpu/drm/radeon/radeon_device.c |    9 ++++++++-
>  2 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
> index 5ce9bf5..46a9c37 100644
> --- a/drivers/gpu/drm/radeon/atom.c
> +++ b/drivers/gpu/drm/radeon/atom.c
> @@ -1238,6 +1238,8 @@ static int atom_iio_len[] = { 1, 2, 3, 3, 3, 3, 4, 4, 4, 3 };
>  static void atom_index_iio(struct atom_context *ctx, int base)
>  {
>         ctx->iio = kzalloc(2 * 256, GFP_KERNEL);
> +       if (!ctx->iio)
> +               return;
>         while (CU8(base) == ATOM_IIO_START) {
>                 ctx->iio[CU8(base + 1)] = base + 2;
>                 base += 2;
> @@ -1287,6 +1289,10 @@ struct atom_context *atom_parse(struct card_info *card, void *bios)
>         ctx->cmd_table = CU16(base + ATOM_ROM_CMD_PTR);
>         ctx->data_table = CU16(base + ATOM_ROM_DATA_PTR);
>         atom_index_iio(ctx, CU16(ctx->data_table + ATOM_DATA_IIO_PTR) + 4);
> +       if (!ctx->iio) {
> +               atom_destroy(ctx);
> +               return NULL;
> +       }
>
>         str = CSTR(CU16(base + ATOM_ROM_MSG_PTR));
>         while (*str && ((*str == '\n') || (*str == '\r')))
> @@ -1335,8 +1341,7 @@ int atom_asic_init(struct atom_context *ctx)
>
>  void atom_destroy(struct atom_context *ctx)
>  {
> -       if (ctx->iio)
> -               kfree(ctx->iio);
> +       kfree(ctx->iio);
>         kfree(ctx);
>  }
>
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 8794de1..44b8034 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -759,6 +759,11 @@ int radeon_atombios_init(struct radeon_device *rdev)
>         atom_card_info->pll_write = cail_pll_write;
>
>         rdev->mode_info.atom_context = atom_parse(atom_card_info, rdev->bios);
> +       if (!rdev->mode_info.atom_context) {
> +               radeon_atombios_fini(rdev);
> +               return -ENOMEM;
> +       }
> +
>         mutex_init(&rdev->mode_info.atom_context->mutex);
>         radeon_atom_initialize_bios_scratch_regs(rdev->ddev);
>         atom_allocate_fb_scratch(rdev->mode_info.atom_context);
> @@ -778,9 +783,11 @@ void radeon_atombios_fini(struct radeon_device *rdev)
>  {
>         if (rdev->mode_info.atom_context) {
>                 kfree(rdev->mode_info.atom_context->scratch);
> -               kfree(rdev->mode_info.atom_context);
>         }
> +       kfree(rdev->mode_info.atom_context);
> +       rdev->mode_info.atom_context = NULL;
>         kfree(rdev->mode_info.atom_card_info);
> +       rdev->mode_info.atom_card_info = NULL;
>  }
>
>  /* COMBIOS */
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
