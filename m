Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaFHFlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 01:41:00 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:45741 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaFHFk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 01:40:58 -0400
Date: Sat, 7 Jun 2014 22:40:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>
Subject: Re: [PATCH] Input - synaptics: fix resolution for manually provided
 min/max
Message-ID: <20140608054055.GA6982@core.coreip.homeip.net>
References: <1401818375-7212-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401818375-7212-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:59:35PM -0400, Benjamin Tissoires wrote:
> commit 421e08c41fda fixed the reported min/max for the X and Y axis,
> but unfortunately, it broke the resolution of those same axis.
> 
> On the t540p, the resolution is the same regarding X and Y. It is not
> a problem for xf86-input-synaptics because this driver is only interested
> in the ratio between X and Y.
> Unfortunately, xf86-input-cmt uses directly the resolution, and having a
> null resolution leads to some divide by 0 errors, which are translated by
> -infinity in the resulting coordinates.
> 
> Reported-by: Peter Hutterer <peter.hutterer@who-t.net>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> 
> Hi Dmitry,
> 
> in the original submission, the test for the quirk was at the end of the
> synaptics_resolution() function. However, there was a mixmatch with the config
> in this original submission and you had to change the patch slightly.
> Unfortunately, this change created this bug which was hard to notice, which is
> why it comes that late in the cycle (and also because we are trying to find out
> if xf86-input-cmt could replace xf86-input-synaptics).

Hmm, I guess we are not going to quirk very old hardware so the change
is fine, applied.

> 
> Anyway, as mentioned in the commit message, this will not harm a big majority
> of users, because only those using ChromeOS will be impacted (not sure they
> have the Lenovo 40 series in their kernel either).
> 
> Again, it's your call to leave or not the stable@ tag, but given that all we
> put regarding those crappy devices are tagged as such, I put it there also.
> 
> Cheers,
> Benjamin
> 
>  drivers/input/mouse/synaptics.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index c5ec703..9cff1f8 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -347,15 +347,6 @@ static int synaptics_resolution(struct psmouse *psmouse)
>  	unsigned char resp[3];
>  	int i;
>  
> -	for (i = 0; min_max_pnpid_table[i].pnp_ids; i++)
> -		if (matches_pnp_id(psmouse, min_max_pnpid_table[i].pnp_ids)) {
> -			priv->x_min = min_max_pnpid_table[i].x_min;
> -			priv->x_max = min_max_pnpid_table[i].x_max;
> -			priv->y_min = min_max_pnpid_table[i].y_min;
> -			priv->y_max = min_max_pnpid_table[i].y_max;
> -			return 0;
> -		}
> -
>  	if (SYN_ID_MAJOR(priv->identity) < 4)
>  		return 0;
>  
> @@ -366,6 +357,15 @@ static int synaptics_resolution(struct psmouse *psmouse)
>  		}
>  	}
>  
> +	for (i = 0; min_max_pnpid_table[i].pnp_ids; i++)
> +		if (matches_pnp_id(psmouse, min_max_pnpid_table[i].pnp_ids)) {
> +			priv->x_min = min_max_pnpid_table[i].x_min;
> +			priv->x_max = min_max_pnpid_table[i].x_max;
> +			priv->y_min = min_max_pnpid_table[i].y_min;
> +			priv->y_max = min_max_pnpid_table[i].y_max;
> +			return 0;
> +		}
> +
>  	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 5 &&
>  	    SYN_CAP_MAX_DIMENSIONS(priv->ext_cap_0c)) {
>  		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_MAX_COORDS, resp)) {
> -- 
> 1.9.0
> 

-- 
Dmitry
