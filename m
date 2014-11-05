Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaKEPXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:23:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:10879 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbaKEPXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:23:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="602799129"
Message-ID: <1415201029.958.118.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 03/35] UBI: Fastmap: Add self check to detect absent PEBs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Wed, 05 Nov 2014 17:23:49 +0200
In-Reply-To: <1414586758-9972-4-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
	 <1414586758-9972-4-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
> This self check allows Fastmap to detect absent PEBs while
> writing a new fastmap to the MTD device.
> It will help to find implementation issues in Fastmap.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/fastmap.c | 86 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 84 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index cfd5b5e..adccc1f 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2012 Linutronix GmbH
> + * Copyright (c) 2014 sigma star gmbh
>   * Author: Richard Weinberger <richard@nod.at>
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -17,6 +18,69 @@
>  #include "ubi.h"
>  
>  /**
> + * init_seen - allocate the seen logic integer array

How about

init_seen - allocate memory for used for debugging.


And I think there should be a dot at the end of the title comment. Not
that it is very important, but I tried to follow this rule everywhere.

> +/**
> + * free_seen - free the seen logic integer array
> + * @seen: integer array of @ubi->peb_count size
> + */
> +static inline void free_seen(int *seen)
> +{
> +	kfree(seen);
> +}

Just do not introduce a function for this. And the commentary does not
make it any more clear. Or if you are going to add more stuff to this
function later - rephrase the comment please.

> +/**
> + * set_seen - mark a PEB as seen
> + * @ubi: UBI device description object
> + * @pnum: the to be marked PEB
> + * @seen: integer array of @ubi->peb_count size
> + */

The dot at the end of the title line. And the return code could be
documented too.

"The to be marked PEB" is understandable, but not well-said :-)

Not sure if this adds much value, but I am trying to be consistent.

> +/**
> + * self_check_seen - check whether all PEB have been seen by fastmap
> + * @ubi: UBI device description object
> + * @seen: integer array of @ubi->peb_count size
> + */

Similar nit-picks.

> +static int self_check_seen(struct ubi_device *ubi, int *seen)
> +{
> +	int pnum, ret = 0;
> +
> +	if (!ubi_dbg_chk_fastmap(ubi) || !seen)
> +		return 0;
> +
> +	for (pnum = 0; pnum < ubi->peb_count; pnum++) {
> +		if (!seen[pnum] && ubi->lookuptbl[pnum]) {
> +			ubi_err("self-check failed for PEB %d, fastmap didn't see it", pnum);

Didn't Tanya add the 'ubi' parameter in the printing functions?

>  	int scrub_peb_count, erase_peb_count;
> +	int *seen_pebs = NULL;

Is the initialization really needed?

