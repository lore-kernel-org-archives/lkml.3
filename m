Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaHWPRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:17:03 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60348 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaHWPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:17:00 -0400
X-Originating-IP: 50.43.15.134
Date: Sat, 23 Aug 2014 08:16:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Airlie <airlied@linux.ie>, kernel-janitors@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] drm: use c99 initializers in structures
Message-ID: <20140823151648.GA2074@thin>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
 <1408792831-25615-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408792831-25615-7-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 01:20:28PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use c99 initializers for structures.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @decl@
> identifier i1,fld;
> type T;
> field list[n] fs;
> @@
> 
> struct i1 {
>  fs
>  T fld;
>  ...};
> 
> @bad@
> identifier decl.i1,i2;
> expression e;
> initializer list[decl.n] is;
> @@
> 
> struct i1 i2 = { is,
> + .fld = e
> - e
>  ,...};
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

For this patch, I think it would make sense to drop
initializations of preferred/quirks/modes to 0, since a designated
initializer may skip fields to leave them initialized to 0.

With that change:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> 
>  drivers/gpu/drm/sti/sti_vtac.c |   12 ++++++++++--
>  drivers/gpu/drm/drm_edid.c     |   34 +++++++++++++++++++++++++---------
>  2 files changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/sti/sti_vtac.c b/drivers/gpu/drm/sti/sti_vtac.c
> index 82a51d4..4576536 100644
> --- a/drivers/gpu/drm/sti/sti_vtac.c
> +++ b/drivers/gpu/drm/sti/sti_vtac.c
> @@ -56,8 +56,16 @@ struct sti_vtac_mode {
>  	u32 phyts_per_pixel;
>  };
>  
> -static const struct sti_vtac_mode vtac_mode_main = {0x2, 0x2, VTAC_5_PPP};
> -static const struct sti_vtac_mode vtac_mode_aux = {0x1, 0x0, VTAC_17_PPP};
> +static const struct sti_vtac_mode vtac_mode_main = {
> +	.vid_in_width = 0x2,
> +	.phyts_width = 0x2,
> +	.phyts_per_pixel = VTAC_5_PPP
> +};
> +static const struct sti_vtac_mode vtac_mode_aux = {
> +	.vid_in_width = 0x1,
> +	.phyts_width = 0x0,
> +	.phyts_per_pixel = VTAC_17_PPP
> +};
>  
>  /**
>   * VTAC structure
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 1dbf3bc..a28c330 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -2103,7 +2103,11 @@ static int
>  add_inferred_modes(struct drm_connector *connector, struct edid *edid)
>  {
>  	struct detailed_mode_closure closure = {
> -		connector, edid, 0, 0, 0
> +		.connector = connector,
> +		.edid = edid,
> +		.preferred = 0,
> +		.quirks = 0,
> +		.modes = 0
>  	};
>  
>  	if (version_greater(edid, 1, 0))
> @@ -2169,7 +2173,11 @@ add_established_modes(struct drm_connector *connector, struct edid *edid)
>  		((edid->established_timings.mfg_rsvd & 0x80) << 9);
>  	int i, modes = 0;
>  	struct detailed_mode_closure closure = {
> -		connector, edid, 0, 0, 0
> +		.connector = connector,
> +		.edid = edid,
> +		.preferred = 0,
> +		.quirks = 0,
> +		.modes = 0
>  	};
>  
>  	for (i = 0; i <= EDID_EST_TIMINGS; i++) {
> @@ -2227,7 +2235,11 @@ add_standard_modes(struct drm_connector *connector, struct edid *edid)
>  {
>  	int i, modes = 0;
>  	struct detailed_mode_closure closure = {
> -		connector, edid, 0, 0, 0
> +		.connector = connector,
> +		.edid = edid,
> +		.preferred = 0,
> +		.quirks = 0,
> +		.modes = 0
>  	};
>  
>  	for (i = 0; i < EDID_STD_TIMINGS; i++) {
> @@ -2313,7 +2325,11 @@ static int
>  add_cvt_modes(struct drm_connector *connector, struct edid *edid)
>  {	
>  	struct detailed_mode_closure closure = {
> -		connector, edid, 0, 0, 0
> +		.connector = connector,
> +		.edid = edid,
> +		.preferred = 0,
> +		.quirks = 0,
> +		.modes = 0
>  	};
>  
>  	if (version_greater(edid, 1, 2))
> @@ -2357,11 +2373,11 @@ add_detailed_modes(struct drm_connector *connector, struct edid *edid,
>  		   u32 quirks)
>  {
>  	struct detailed_mode_closure closure = {
> -		connector,
> -		edid,
> -		1,
> -		quirks,
> -		0
> +		.connector = connector,
> +		.edid = edid,
> +		.preferred = 1,
> +		.quirks = quirks,
> +		.modes = 0
>  	};
>  
>  	if (closure.preferred && !version_greater(edid, 1, 3))
> 
