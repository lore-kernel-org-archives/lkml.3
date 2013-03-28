Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3C1FcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 01:32:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34521 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3C1FcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 01:32:21 -0400
Date: Wed, 27 Mar 2013 22:32:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Shawn Nematbakhsh <shawnn@chromium.org>
Cc: JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chung-yih Wang <cywang@chromium.org>
Subject: Re: [PATCH] Input: trackpoint - Optimize trackpoint init to use
 power-on reset
Message-ID: <20130328053218.GB2812@core.coreip.homeip.net>
References: <1364326601-16571-1-git-send-email-shawnn@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364326601-16571-1-git-send-email-shawnn@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Tue, Mar 26, 2013 at 12:36:41PM -0700, Shawn Nematbakhsh wrote:
> The trackpoint driver sets various parameter default values, all of
> which happen to be power-on defaults (Source: IBM TrackPoint Engineering
> Specification, Version 4.0. Also confirmed by empirical data).
> 
> By sending the power-on reset command to reset all parameters to
> power-on state, we can skip the lengthy process of programming all
> parameters. In testing, ~2.5 secs of time writing parameters was reduced
> to .35 seconds waiting for power-on reset to complete.
> 
> Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
> ---
>  drivers/input/mouse/trackpoint.c | 223 +++++++++++++++++++++++++--------------
>  drivers/input/mouse/trackpoint.h |   7 +-
>  2 files changed, 149 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
> index f310249..17e9b36 100644
> --- a/drivers/input/mouse/trackpoint.c
> +++ b/drivers/input/mouse/trackpoint.c
> @@ -20,6 +20,26 @@
>  #include "trackpoint.h"
>  
>  /*
> + * Power-on Reset: Resets all trackpoint parameters, including RAM values,
> + * to defaults.
> + * Returns zero on success, non-zero on failure.
> + */
> +static int trackpoint_power_on_reset(struct ps2dev *ps2dev)
> +{
> +	unsigned char results[2];
> +
> +	if (ps2_command(ps2dev, NULL, MAKE_PS2_CMD(0, 0, TP_COMMAND)) ||
> +	    ps2_command(ps2dev, results, MAKE_PS2_CMD(0, 2, TP_POR))) {
> +		return -1;
> +	}
> +
> +	/* POR response should be 0xAA00 or 0xFC00 */
> +	if ((results[0] != 0xAA && results[0] != 0xFC) || results[1] != 0x00)
> +		return -1;

I am a bit concerned about this. 0xfc00 indicates POR failure. In this
case shouldn't we try to reset the device, issue another POR and bail if
it fails again?

>  
>  static struct attribute *trackpoint_attrs[] = {
>  	&psmouse_attr_sensitivity.dattr.attr,
> @@ -179,6 +241,9 @@ static struct attribute *trackpoint_attrs[] = {
>  	&psmouse_attr_press_to_select.dattr.attr,
>  	&psmouse_attr_skipback.dattr.attr,
>  	&psmouse_attr_ext_dev.dattr.attr,
> +	&psmouse_attr_twohand.dattr.attr,
> +	&psmouse_attr_source_tag.dattr.attr,
> +	&psmouse_attr_mb.dattr.attr,

What is the benefit of adding these 3 new attributes?

Thanks.

-- 
Dmitry
