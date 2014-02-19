Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaBSJro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:47:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:45371 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbaBSJri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:47:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="483952340"
Message-ID: <53047DAB.10200@linux.intel.com>
Date: Wed, 19 Feb 2014 17:47:23 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        David Airlie <airlied@linux.ie>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Emil Velikov <emil.l.velikov@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nouveau, ACPI: fix regression caused by b072e53
References: <1392785628-30633-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1392785628-30633-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maarten,
	Forgot to refresh my working tree. Please help to
apply this patch on top of previous one to solve a compilation bug.

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c
b/drivers/gpu/drm/nouveau/no
index c6c7d0d..83face3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -119,7 +119,7 @@ static int nouveau_check_optimus_dsm(acpi_handle handle)
         * Function 0 returns a Buffer containing available functions.
         * The args parameter is ignored for function 0, so just put 0 in it
         */
-       if (nouveau_optimus_dsm(handle, 0, 0, &result)
+       if (nouveau_optimus_dsm(handle, 0, 0, &result))
                return 0;



On 2014/2/19 12:53, Jiang Liu wrote:
> On some platforms, ACPI _DSM method (nouveau_op_dsm_muid, function 0)
> has special requirements on the fourth parameter, which is different
> from ACPI specifications. So revert to the private implementation
> to check availability of _DSM functions instead of using common
> acpi_check_dsm() interface.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
> Hi Maarten,
> 	Thanks for bisecting. Could you please help to verify whether
> this patch fixes the regression?
> 
> Thanks!
> Gerry
> ---
>  drivers/gpu/drm/nouveau/nouveau_acpi.c |   26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> index 4ef83df..c6c7d0d 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
> @@ -106,6 +106,29 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
>  	return 0;
>  }
>  
> +/*
> + * On some platforms, _DSM(nouveau_op_dsm_muid, func0) has special
> + * requirements on the fourth parameter, so a private implementation
> + * instead of using acpi_check_dsm().
> + */
> +static int nouveau_check_optimus_dsm(acpi_handle handle)
> +{
> +	int result;
> +
> +	/*
> +	 * Function 0 returns a Buffer containing available functions.
> +	 * The args parameter is ignored for function 0, so just put 0 in it
> +	 */
> +	if (nouveau_optimus_dsm(handle, 0, 0, &result)
> +		return 0;
> +
> +	/*
> +	 * ACPI Spec v4 9.14.1: if bit 0 is zero, no function is supported.
> +	 * If the n-th bit is enabled, function n is supported
> +	 */
> +	return result & 1 && result & (1 << NOUVEAU_DSM_OPTIMUS_CAPS);
> +}
> +
>  static int nouveau_dsm(acpi_handle handle, int func, int arg)
>  {
>  	int ret = 0;
> @@ -207,8 +230,7 @@ static int nouveau_dsm_pci_probe(struct pci_dev *pdev)
>  			   1 << NOUVEAU_DSM_POWER))
>  		retval |= NOUVEAU_DSM_HAS_MUX;
>  
> -	if (acpi_check_dsm(dhandle, nouveau_op_dsm_muid, 0x00000100,
> -			   1 << NOUVEAU_DSM_OPTIMUS_CAPS))
> +	if (nouveau_check_optimus_dsm(dhandle))
>  		retval |= NOUVEAU_DSM_HAS_OPT;
>  
>  	if (retval & NOUVEAU_DSM_HAS_OPT) {
> 
