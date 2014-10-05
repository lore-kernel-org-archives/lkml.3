Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaJEWqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 18:46:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaJEWqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 18:46:43 -0400
Date: Mon, 6 Oct 2014 00:46:28 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: drm: drm_dp_mst_topology.c:  Fix improper use of
 strncat.
Message-ID: <20141005224626.GA743@mguzik>
References: <1412545563-25411-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412545563-25411-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 11:46:03PM +0200, Rickard Strandqvist wrote:
> I have now eliminate the need to use the temporary string,
> and therefore also the use of strncat.
> And I think this code is clearer and more effective.
> 
The code is definitely less clear.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> index ac3c273..c3f6571 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -997,17 +997,18 @@ static void build_mst_prop_path(struct drm_dp_mst_port *port,
>  				struct drm_dp_mst_branch *mstb,
>  				char *proppath)
>  {
> -	int i;
> -	char temp[8];
> -	snprintf(proppath, 255, "mst:%d", mstb->mgr->conn_base_id);
> +	int i, len;
> +	static const int proppath_len = 255;

Length should be passed by the caller.

> +	memset(proppath, 0, proppath_len);

Why?
> +	len = snprintf(proppath, proppath_len, "mst:%d", mstb->mgr->conn_base_id);
>  	for (i = 0; i < (mstb->lct - 1); i++) {
>  		int shift = (i % 2) ? 0 : 4;
>  		int port_num = mstb->rad[i / 2] >> shift;
> -		snprintf(temp, 8, "-%d", port_num);
> -		strncat(proppath, temp, 255);
> +		len += snprintf(&proppath[(len < proppath_len ? len : 0)],
> +						proppath_len - len, "-%d", port_num);

And if the space ran out you just overwrite from the start of the buffer
and provide negative length.

Since this function returns void (and so does its caller) it is quite
unclear what to do if the space ran out. I would just WARN.

>  	}
> -	snprintf(temp, 8, "-%d", port->port_num);
> -	strncat(proppath, temp, 255);
> +	snprintf(&proppath[(len < proppath_len ? len : 0)], proppath_len - len,
> +					"-%d", port->port_num);
>  }
>  
>  static void drm_dp_add_port(struct drm_dp_mst_branch *mstb,

-- 
Mateusz Guzik
