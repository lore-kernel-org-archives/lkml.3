Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890AbaLPFCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:02:41 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35547 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaLPFCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:02:39 -0500
Date: Mon, 15 Dec 2014 21:02:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Vadim Klishko <vadim@cirque.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] input: alps: Set correct name of psmouse device in
 alps_init()
Message-ID: <20141216050234.GA35408@dtor-ws>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
 <1415993906-13307-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415993906-13307-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Fri, Nov 14, 2014 at 08:38:20PM +0100, Pali Rohár wrote:
> On some laptops after starting them from off state (not after reboot), function
> alps_probe_trackstick_v3() (called from function alps_identify()) does not
> detect trackstick. To fix this problem we need to reset device. But function
> alps_identify() is called also from alps_detect() and we do not want to reset
> device in detect function because it will slow down initialization of all other
> non alps devices.
> 
> This patch moves code for setting correct device name & protocol from function
> alps_detect() to alps_init() which already doing full device reset.
> 
> So this patch removes need to do trackstick detection in alps_detect() function.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/input/mouse/alps.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 8d85c79..9ffa98d 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -2392,6 +2392,10 @@ int alps_init(struct psmouse *psmouse)
>  	if (input_register_device(priv->dev2))
>  		goto init_fail;
>  
> +	if (!(priv->flags & ALPS_DUALPOINT))
> +		psmouse->name = "GlidePoint TouchPad";
> +	psmouse->model = priv->proto_version;
> +
>  	psmouse->protocol_handler = alps_process_byte;
>  	psmouse->poll = alps_poll;
>  	psmouse->disconnect = alps_disconnect;
> @@ -2422,11 +2426,18 @@ int alps_detect(struct psmouse *psmouse, bool set_properties)
>  		return -1;
>  
>  	if (set_properties) {
> +		/*
> +		 * NOTE: To detect model and trackstick presence we need to do
> +		 *       full device reset. To speed up detection and prevent
> +		 *       calling duplicate initialization sequence (both in
> +		 *       alps_detect() and alps_init()) we set model/protocol
> +		 *       version and correct name in alps_init() (which will
> +		 *       do full device reset). For now set name to DualPoint.
> +		 */
>  		psmouse->vendor = "ALPS";
> -		psmouse->name = dummy.flags & ALPS_DUALPOINT ?
> -				"DualPoint TouchPad" : "GlidePoint";
> -		psmouse->model = dummy.proto_version << 8;
> +		psmouse->name = "DualPoint TouchPad";
>  	}
> +

I do not quite like the way we change the device description back and
forth. Do you think we could allocate the "real" priv structure in
alps_detect() and have alps_init() expect to find it (and free it if
set_properties is false). This way we'd go through initialization once
in detect, it will be authoritative, and we would set the name of the
device properly from the beginning.

Thanks.

-- 
Dmitry
