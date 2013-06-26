Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3FZLyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:54:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:34699 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3FZLyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:54:01 -0400
Message-ID: <51CAD655.2070208@atmel.com>
Date: Wed, 26 Jun 2013 12:53:57 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <shigekatsu.tateno@atmel.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@linuxdriverproject.org>
Subject: Re: [PATCH] staging: ozwpan: Use normal Makefile, convert oz_trace
 to oz_dbg
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com> <20130625170205.GA21328@kroah.com> <1372181390.1245.68.camel@joe-AO722> <20130625173840.GA8930@kroah.com> <1372208429.1245.94.camel@joe-AO722>
In-Reply-To: <1372208429.1245.94.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/13 02:00, Joe Perches wrote:
> Use a normal Makefile.
> Convert oz_trace and oz_trace2 to a more normal oz_dbg.
> Consolidate oztrace and ozconfig files to ozdbg.h
> Update #include files.
> Reflow modified lines, fit to 80 cols, align arguments.
>
> Add a couple more oz_<foo>_dbg macros to show how more
> verbose device specific debugging could be added when a
> struct device * or struct netdevice * is available.

Isn't this patch doing too many changes in single patch? Can we split 
this patch into smaller patch series ?
In addition to above, it also :-
1. Removes few unwanted logs.
2. Changes macro definition for oz_remember_urb() & oz_forget_urb() to 
static inline function when WANT_URB_PARANOIA is not defined.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/staging/ozwpan/{Kbuild => Makefile} |   6 +-
>   drivers/staging/ozwpan/ozcdev.c             |  52 +++--
>   drivers/staging/ozwpan/ozconfig.h           |  26 ---
>   drivers/staging/ozwpan/ozdbg.h              |  54 +++++
>   drivers/staging/ozwpan/ozeltbuf.c           |  32 ++-
>   drivers/staging/ozwpan/ozhcd.c              | 296 +++++++++++++---------------
>   drivers/staging/ozwpan/ozmain.c             |   7 +-
>   drivers/staging/ozwpan/ozpd.c               |  67 +++----
>   drivers/staging/ozwpan/ozproto.c            |  60 +++---
>   drivers/staging/ozwpan/ozproto.h            |   2 +-
>   drivers/staging/ozwpan/oztrace.c            |  36 ----
>   drivers/staging/ozwpan/oztrace.h            |  35 ----
>   drivers/staging/ozwpan/ozurbparanoia.c      |  14 +-
>   drivers/staging/ozwpan/ozurbparanoia.h      |   4 +-
>   drivers/staging/ozwpan/ozusbsvc.c           |  25 +--
>   drivers/staging/ozwpan/ozusbsvc1.c          |  19 +-
>   16 files changed, 334 insertions(+), 401 deletions(-)
>   rename drivers/staging/ozwpan/{Kbuild => Makefile} (93%)
>   delete mode 100644 drivers/staging/ozwpan/ozconfig.h
>   create mode 100644 drivers/staging/ozwpan/ozdbg.h
>   delete mode 100644 drivers/staging/ozwpan/oztrace.c
>   delete mode 100644 drivers/staging/ozwpan/oztrace.h
<snip>...

> diff --git a/drivers/staging/ozwpan/ozdbg.h b/drivers/staging/ozwpan/ozdbg.h
> new file mode 100644
> index 0000000..976c33b
> --- /dev/null
> +++ b/drivers/staging/ozwpan/ozdbg.h
> @@ -0,0 +1,54 @@
> +/* -----------------------------------------------------------------------------
> + * Copyright (c) 2011 Ozmo Inc
> + * Released under the GNU General Public License Version 2 (GPLv2).
> + * ---------------------------------------------------------------------------*/
> +
> +#ifndef _OZDBG_H
> +#define _OZDBG_H
> +
> +#define OZ_WANT_DBG 0
> +#define OZ_WANT_VERBOSE_DBG 1
> +
> +#define OZ_DBG_ON		0x0
> +#define OZ_DBG_STREAM		0x1
> +#define OZ_DBG_URB		0x2
> +#define OZ_DBG_CTRL_DETAIL	0x4
> +#define OZ_DBG_HUB		0x8
> +#define OZ_DBG_RX_FRAMES	0x10
> +#define OZ_DBG_TX_FRAMES	0x20
> +
> +#define OZ_DEFAULT_DBG_MASK			\
> +	(					\
> +	/* OZ_DBG_STREAM | */			\
> +	/* OZ_DBG_URB | */			\
> +	/* OZ_DBG_CTRL_DETAIL | */		\
> +	OZ_DBG_HUB |				\
> +	/* OZ_DBG_RX_FRAMES | */		\
> +	/* OZ_DBG_TX_FRAMES | */		\
> +	0)
> +
> +extern unsigned int oz_dbg_mask;
> +
> +#define oz_want_dbg(mask)						\
> +	((OZ_WANT_DBG && (OZ_DBG_##mask == OZ_DBG_ON)) ||		\
> +	 (OZ_WANT_VERBOSE_DBG && (OZ_DBG_##mask & oz_dbg_mask)))
> +
> +#define oz_dbg(mask, fmt, ...)						\
> +do {									\
> +	if (oz_want_dbg(mask))						\
> +		pr_debug(fmt, ##__VA_ARGS__);				\
> +} while (0)
> +
> +#define oz_cdev_dbg(cdev, mask, fmt, ...)				\
> +do {									\
> +	if (oz_want_dbg(mask))						\
> +		netdev_dbg((cdev)->dev, fmt, ##__VA_ARGS__);		\
> +} while (0)
> +
> +#define oz_pd_dbg(pd, mask, fmt, ...)					\
> +do {									\
> +	if (oz_want_dbg(mask))						\
> +		pr_debug(fmt, ##__VA_ARGS__);				\
> +} while (0)
> +

Above macros look good, however Greg have objection to define new macros 
& he had suggested to use dev_dbg() & pr_debug().
I will leave it to him, if he is all right to accept new macros for 
debug logs.

Greg,
Your comments please.

<snip>...
> +#endif /* _OZCONFIG_H */

Need to change to -
#endif  /* _OZDBG_H */



-- 
Regards,
Rupesh Gujare

