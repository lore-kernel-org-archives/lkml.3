Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaAQHnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:43:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:7967 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaAQHnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:43:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="460348327"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Yijing Wang <wangyijing@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-acpi@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>, Yijing Wang <wangyijing@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v3] ACPI: Fix acpi_evaluate_object() return value check
In-Reply-To: <1389932513-27684-1-git-send-email-wangyijing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1389932513-27684-1-git-send-email-wangyijing@huawei.com>
User-Agent: Notmuch/0.17+27~gabca3dcf08ba (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Jan 2014 09:46:48 +0200
Message-ID: <87d2jr82zb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jan 2014, Yijing Wang <wangyijing@huawei.com> wrote:
> Fix acpi_evaluate_object() return value check,
> shoud acpi_status not int.

Please spellcheck.

>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
> v2->v3: Fix compile error pointed out by Hanjun.
> v1->v2: Add CC to related subsystem MAINTAINERS
> ---
>  drivers/gpu/drm/i915/intel_acpi.c              |   24 ++++++++++++++----------
>  drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |    9 +++++----
>  drivers/gpu/drm/nouveau/nouveau_acpi.c         |   23 +++++++++++++----------
>  drivers/pci/pci-label.c                        |    9 ++++++---
>  4 files changed, 38 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
> index dfff090..87e8f74 100644
> --- a/drivers/gpu/drm/i915/intel_acpi.c
> +++ b/drivers/gpu/drm/i915/intel_acpi.c
> @@ -35,7 +35,8 @@ static int intel_dsm(acpi_handle handle, int func)
>  	union acpi_object params[4];
>  	union acpi_object *obj;
>  	u32 result;
> -	int ret = 0;
> +	acpi_status status;
> +	int ret;
>  
>  	input.count = 4;
>  	input.pointer = params;
> @@ -50,10 +51,11 @@ static int intel_dsm(acpi_handle handle, int func)
>  	params[3].package.count = 0;
>  	params[3].package.elements = NULL;
>  
> -	ret = acpi_evaluate_object(handle, "_DSM", &input, &output);
> -	if (ret) {
> -		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
> -		return ret;
> +	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
> +	if (ACPI_FAILURE(status)) {
> +		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %s\n",
> +				acpi_format_exception(status));
> +		return -EINVAL;
>  	}
>  
>  	obj = (union acpi_object *)output.pointer;
> @@ -141,7 +143,8 @@ static void intel_dsm_platform_mux_info(void)
>  	struct acpi_object_list input;
>  	union acpi_object params[4];
>  	union acpi_object *pkg;
> -	int i, ret;
> +	acpi_status status;
> +	int i;
>  
>  	input.count = 4;
>  	input.pointer = params;
> @@ -156,10 +159,11 @@ static void intel_dsm_platform_mux_info(void)
>  	params[3].package.count = 0;
>  	params[3].package.elements = NULL;
>  
> -	ret = acpi_evaluate_object(intel_dsm_priv.dhandle, "_DSM", &input,
> -				   &output);
> -	if (ret) {
> -		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
> +	acpi_status = acpi_evaluate_object(intel_dsm_priv.dhandle,
> +			"_DSM", &input, &output);
> +	if (ACPI_FAILURE(status)) {
> +		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %s\n",
> +				acpi_format_exception(status));
>  		goto out;
>  	}

In the two hunks above, one of the error paths calls
kfree(output.pointer), the other doesn't. Which one is wrong?

The fix for that should probably be a follow-up patch; this patch is

Reviewed-by: Jani Nikula <jani.nikula@intel.com>


>  
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
> index 1291204..c5e7a2b 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
> @@ -114,15 +114,16 @@ mxm_shadow_dsm(struct nouveau_mxm *mxm, u8 version)
>  	struct acpi_buffer retn = { ACPI_ALLOCATE_BUFFER, NULL };
>  	union acpi_object *obj;
>  	acpi_handle handle;
> -	int ret;
> +	acpi_status status;
>  
>  	handle = ACPI_HANDLE(&device->pdev->dev);
>  	if (!handle)
>  		return false;
>  
> -	ret = acpi_evaluate_object(handle, "_DSM", &list, &retn);
> -	if (ret) {
> -		nv_debug(mxm, "DSM MXMS failed: %d\n", ret);
> +	status = acpi_evaluate_object(handle, "_DSM", &list, &retn);
> +	if (ACPI_FAILURE(status)) {
> +		nv_debug(mxm, "DSM MXMS failed: %s\n",
> +				acpi_format_exception(status));
>  		return false;
>  	}
>  
> diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> index ba0183f..de3068b 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> @@ -82,7 +82,8 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
>  	struct acpi_object_list input;
>  	union acpi_object params[4];
>  	union acpi_object *obj;
> -	int i, err;
> +	acpi_status status;
> +	int i;
>  	char args_buff[4];
>  
>  	input.count = 4;
> @@ -101,10 +102,11 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
>  		args_buff[i] = (arg >> i * 8) & 0xFF;
>  	params[3].buffer.pointer = args_buff;
>  
> -	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
> -	if (err) {
> -		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
> -		return err;
> +	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
> +	if (ACPI_FAILURE(status)) {
> +		pr_info("failed to evaluate _DSM: %s\n",
> +				acpi_format_exception(status));
> +		return -EINVAL;
>  	}
>  
>  	obj = (union acpi_object *)output.pointer;
> @@ -134,7 +136,7 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
>  	struct acpi_object_list input;
>  	union acpi_object params[4];
>  	union acpi_object *obj;
> -	int err;
> +	acpi_status status;
>  
>  	input.count = 4;
>  	input.pointer = params;
> @@ -148,10 +150,11 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
>  	params[3].type = ACPI_TYPE_INTEGER;
>  	params[3].integer.value = arg;
>  
> -	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
> -	if (err) {
> -		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
> -		return err;
> +	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
> +	if (ACPI_FAILURE(status)) {
> +		pr_info("failed to evaluate _DSM: %s\n",
> +				acpi_format_exception(status));
> +		return -EINVAL;
>  	}
>  
>  	obj = (union acpi_object *)output.pointer;
> diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
> index d51f45a..7ba4de6 100644
> --- a/drivers/pci/pci-label.c
> +++ b/drivers/pci/pci-label.c
> @@ -213,7 +213,7 @@ dsm_get_label(acpi_handle handle, int func,
>  	union acpi_object *obj;
>  	int len = 0;
>  
> -	int err;
> +	acpi_status status;
>  
>  	input.count = 4;
>  	input.pointer = params;
> @@ -228,9 +228,12 @@ dsm_get_label(acpi_handle handle, int func,
>  	params[3].package.count = 0;
>  	params[3].package.elements = NULL;
>  
> -	err = acpi_evaluate_object(handle, "_DSM", &input, output);
> -	if (err)
> +	status = acpi_evaluate_object(handle, "_DSM", &input, output);
> +	if (ACPI_FAILURE(status)) {
> +		pr_info("failed to evaluate _DSM: %s\n",
> +				acpi_format_exception(status));
>  		return -1;
> +	}
>  
>  	obj = (union acpi_object *)output->pointer;
>  
> -- 
> 1.7.1
>
>

-- 
Jani Nikula, Intel Open Source Technology Center
