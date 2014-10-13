Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaJMIC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:02:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:51156 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbaJMICu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:02:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,708,1406617200"; 
   d="scan'208";a="613502425"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH v2] gpu: drm: drm_dp_mst_topology.c: Fix improper use of strncat
In-Reply-To: <1413064952-10466-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1413064952-10466-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Notmuch/0.18.1+110~gd9ec63c (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Oct 2014 11:02:40 +0300
Message-ID: <87y4skgzxb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> Fixed wrong usage of strncat, switched to strlcpy.
> While sending the string size to function to reduce
> the potential for misuse in future.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> index ac3c273..2a146d1 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -995,19 +995,20 @@ static void drm_dp_check_port_guid(struct drm_dp_mst_branch *mstb,
>  
>  static void build_mst_prop_path(struct drm_dp_mst_port *port,
>  				struct drm_dp_mst_branch *mstb,
> -				char *proppath)
> +				char *proppath,
> +				size_t proppath_size)
>  {
>  	int i;
>  	char temp[8];
> -	snprintf(proppath, 255, "mst:%d", mstb->mgr->conn_base_id);
> +	snprintf(proppath, proppath_size, "mst:%d", mstb->mgr->conn_base_id);
>  	for (i = 0; i < (mstb->lct - 1); i++) {
>  		int shift = (i % 2) ? 0 : 4;
>  		int port_num = mstb->rad[i / 2] >> shift;
> -		snprintf(temp, 8, "-%d", port_num);
> -		strncat(proppath, temp, 255);
> +		snprintf(temp, sizeof(temp), "-%d", port_num);
> +		strlcat(proppath, temp, proppath_size);
>  	}
> -	snprintf(temp, 8, "-%d", port->port_num);
> -	strncat(proppath, temp, 255);
> +	snprintf(temp, sizeof(temp), "-%d", port->port_num);
> +	strlcat(proppath, temp, proppath_size);
>  }
>  
>  static void drm_dp_add_port(struct drm_dp_mst_branch *mstb,
> @@ -1078,7 +1079,7 @@ static void drm_dp_add_port(struct drm_dp_mst_branch *mstb,
>  
>  	if (created && !port->input) {
>  		char proppath[255];
> -		build_mst_prop_path(port, mstb, proppath);
> +		build_mst_prop_path(port, mstb, proppath, sizeof(proppath));
>  		port->connector = (*mstb->mgr->cbs->add_connector)(mstb->mgr, port, proppath);
>  	}
>  
> -- 
> 1.7.10.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
