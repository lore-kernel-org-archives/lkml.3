Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaAWSV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:21:27 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43634 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaAWSVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:21:23 -0500
MIME-Version: 1.0
In-Reply-To: <1390448559-33896-1-git-send-email-wangyijing@huawei.com>
References: <1390448559-33896-1-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 23 Jan 2014 11:21:01 -0700
Message-ID: <CAErSpo7YBGnPF9gz4rwwEdk8uF2h2aNAZWhSAd-X=tAOWOhRow@mail.gmail.com>
Subject: Re: [PATCH v5] ACPI: Fix acpi_evaluate_object() return value check
To: Yijing Wang <wangyijing@huawei.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>, Hanjun Guo <guohanjun@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 8:42 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> Since acpi_evaluate_object() returns acpi_status and not plain int,
> ACPI_FAILURE() should be used for checking its return value. Also
> add some detailed debug info when acpi_evaluate_object() failed.
>
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
> v4->v5: Add some detailed debug info for acpi_evaluate_object()
>         failure suggested by Bjorn.
> v3->v4: Fix spell error, add Jani Nikula reviewed-by.
> v2->v3: Fix compile error pointed out by Hanjun.
> v1->v2: Add CC to related subsystem MAINTAINERS
> ---
>  drivers/gpu/drm/i915/intel_acpi.c              |   33 ++++++++++++++++-------
>  drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |   13 ++++++---
>  drivers/gpu/drm/nouveau/nouveau_acpi.c         |   25 +++++++++++-------
>  drivers/pci/pci-label.c                        |   10 +++++--
>  4 files changed, 54 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
> index dfff090..e7b526b 100644
> --- a/drivers/gpu/drm/i915/intel_acpi.c
> +++ b/drivers/gpu/drm/i915/intel_acpi.c
> @@ -31,11 +31,13 @@ static const u8 intel_dsm_guid[] = {
>  static int intel_dsm(acpi_handle handle, int func)
>  {
>         struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
> +       struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
>         struct acpi_object_list input;
>         union acpi_object params[4];
>         union acpi_object *obj;
>         u32 result;
> -       int ret = 0;
> +       acpi_status status;
> +       int ret;
>
>         input.count = 4;
>         input.pointer = params;
> @@ -50,10 +52,14 @@ static int intel_dsm(acpi_handle handle, int func)
>         params[3].package.count = 0;
>         params[3].package.elements = NULL;
>
> -       ret = acpi_evaluate_object(handle, "_DSM", &input, &output);
> -       if (ret) {
> -               DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
> -               return ret;
> +       status = acpi_evaluate_object(handle, "_DSM", &input, &output);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
> +               DRM_DEBUG_DRIVER(
> +                       "failed to evaluate _DSM for %s, exit status %u\n",
> +                       (char *)string.pointer, (unsigned int)status);
> +               kfree(string.pointer);
> +               return -EINVAL;

I said "too bad there isn't an *easy* way" to include more
information.  IMHO this is too ugly and error-prone to use
consistently.  And if you are going to add more information, why did
you only do it for some of the calls and not others?

I considered adding a %p extension to print the pathname; I don't know
if that's worthwhile or not.  I think it would be ideal if we had a
struct device and could use dev_info(), and then a way to connect the
struct device with an ACPI path, like maybe a dmesg note when we
create the struct device corresponding to an ACPI Device node.

Bjorn

>         }
>
>         obj = (union acpi_object *)output.pointer;
> @@ -138,10 +144,12 @@ static char *intel_dsm_mux_type(u8 type)
>  static void intel_dsm_platform_mux_info(void)
>  {
>         struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
> +       struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
>         struct acpi_object_list input;
>         union acpi_object params[4];
>         union acpi_object *pkg;
> -       int i, ret;
> +       acpi_status status;
> +       int i;
>
>         input.count = 4;
>         input.pointer = params;
> @@ -156,10 +164,15 @@ static void intel_dsm_platform_mux_info(void)
>         params[3].package.count = 0;
>         params[3].package.elements = NULL;
>
> -       ret = acpi_evaluate_object(intel_dsm_priv.dhandle, "_DSM", &input,
> -                                  &output);
> -       if (ret) {
> -               DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
> +       acpi_status = acpi_evaluate_object(intel_dsm_priv.dhandle,
> +                       "_DSM", &input, &output);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_get_name(intel_dsm_priv.dhandle,
> +                               ACPI_FULL_PATHNAME, &string);
> +               DRM_DEBUG_DRIVER(
> +                       "failed to evaluate _DSM for %s, exit status %u\n",
> +                       (char *)string.pointer, (unsigned int)status);
> +               kfree(string.pointer);
>                 goto out;
>         }
>
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
> index 1291204..c30ee88 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
> @@ -112,17 +112,22 @@ mxm_shadow_dsm(struct nouveau_mxm *mxm, u8 version)
>         };
>         struct acpi_object_list list = { ARRAY_SIZE(args), args };
>         struct acpi_buffer retn = { ACPI_ALLOCATE_BUFFER, NULL };
> +       struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
>         union acpi_object *obj;
>         acpi_handle handle;
> -       int ret;
> +       acpi_status status;
>
>         handle = ACPI_HANDLE(&device->pdev->dev);
>         if (!handle)
>                 return false;
>
> -       ret = acpi_evaluate_object(handle, "_DSM", &list, &retn);
> -       if (ret) {
> -               nv_debug(mxm, "DSM MXMS failed: %d\n", ret);
> +       status = acpi_evaluate_object(handle, "_DSM", &list, &retn);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
> +               nv_debug(mxm, "DSM MXMS failed for %s: exit status %u\n",
> +                               (char *)string.pointer,
> +                               (unsigned int)status);
> +               kfree(string.pointer);
>                 return false;
>         }
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> index ba0183f..53d24a7 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> @@ -82,7 +82,8 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
>         struct acpi_object_list input;
>         union acpi_object params[4];
>         union acpi_object *obj;
> -       int i, err;
> +       acpi_status status;
> +       int i;
>         char args_buff[4];
>
>         input.count = 4;
> @@ -101,10 +102,12 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
>                 args_buff[i] = (arg >> i * 8) & 0xFF;
>         params[3].buffer.pointer = args_buff;
>
> -       err = acpi_evaluate_object(handle, "_DSM", &input, &output);
> -       if (err) {
> -               printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
> -               return err;
> +       status = acpi_evaluate_object(handle, "_DSM", &input, &output);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_handle_info(handle,
> +                               "failed to evaluate _DSM, exit status %u\n",
> +                               (unsigned int)status);
> +               return -EINVAL;
>         }
>
>         obj = (union acpi_object *)output.pointer;
> @@ -134,7 +137,7 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
>         struct acpi_object_list input;
>         union acpi_object params[4];
>         union acpi_object *obj;
> -       int err;
> +       acpi_status status;
>
>         input.count = 4;
>         input.pointer = params;
> @@ -148,10 +151,12 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
>         params[3].type = ACPI_TYPE_INTEGER;
>         params[3].integer.value = arg;
>
> -       err = acpi_evaluate_object(handle, "_DSM", &input, &output);
> -       if (err) {
> -               printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
> -               return err;
> +       status = acpi_evaluate_object(handle, "_DSM", &input, &output);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_handle_info(handle,
> +                               "failed to evaluate _DSM, exit status %u\n",
> +                               (unsigned int)status);
> +               return -EINVAL;
>         }
>
>         obj = (union acpi_object *)output.pointer;
> diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
> index d51f45a..0216094 100644
> --- a/drivers/pci/pci-label.c
> +++ b/drivers/pci/pci-label.c
> @@ -213,7 +213,7 @@ dsm_get_label(acpi_handle handle, int func,
>         union acpi_object *obj;
>         int len = 0;
>
> -       int err;
> +       acpi_status status;
>
>         input.count = 4;
>         input.pointer = params;
> @@ -228,9 +228,13 @@ dsm_get_label(acpi_handle handle, int func,
>         params[3].package.count = 0;
>         params[3].package.elements = NULL;
>
> -       err = acpi_evaluate_object(handle, "_DSM", &input, output);
> -       if (err)
> +       status = acpi_evaluate_object(handle, "_DSM", &input, output);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_handle_info(handle,
> +                               "failed to evaluate _DSM, exit status %u\n",
> +                                (unsigned int)status);
>                 return -1;
> +       }
>
>         obj = (union acpi_object *)output->pointer;
>
> --
> 1.7.1
>
>
