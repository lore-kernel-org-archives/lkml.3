Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaFMIcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:32:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41188 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFMIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:32:19 -0400
Date: Fri, 13 Jun 2014 11:32:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] staging: dgap: cleanup dgap_firmware_load() function
Message-ID: <20140613083200.GD5015@mwanda>
References: <20140613074337.GA31632@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613074337.GA31632@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:43:37PM +0900, Daeseok Youn wrote:
> @@ -583,8 +585,51 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc)
>  		return rc;
>  
> -	dgap_numboards++;
> -	return dgap_firmware_load(pdev, ent->driver_data);
> +	brd = dgap_board[dgap_numboards++];

I don't like the way the current code uses dgap_numboards and hiding
the ++ in here makes it even worse.

My thinking is that dgap_found_board() shouldn't touch dgap_board[] but
instead of instead it should return a pointer to "brd".  Then the code
in dgap_init_one() does:

	brd = dgap_found_board();
	if (!brd)
		return -ENODEV;

	/* code until the end of the function */

	dgap_board[dgap_numboards++] = brd;
	return 0;

tty_free:
	/* error path */

This could be done in a follow on patch.

TODO-list: 2014-06-13: dgap: make dgap_found_board() return a brd pointer.

> +	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
> +	if (rc)
> +		goto free_brd;
> +
> +	rc = dgap_alloc_flipbuf(brd);
> +	if (rc)
> +		goto free_brd;
> +
> +	rc = dgap_tty_register(brd);
> +	if (rc)
> +		goto free_flipbuf;
> +
> +	rc = dgap_request_irq(brd);
> +	if (rc)
> +		goto unregister_tty;
> +
> +	/*
> +	 * Do tty device initialization.
> +	 */
> +	rc = dgap_tty_init(brd);
> +	if (rc < 0)
> +		goto free_irq;
> +
> +	rc = dgap_tty_register_ports(brd);
> +	if (rc)
> +		goto tty_free;
> +
> +	brd->state = BOARD_READY;
> +	brd->dpastatus = BD_RUNNING;
> +
> +	return 0;
> +
> +tty_free:
> +	dgap_tty_free(brd);
> +free_irq:
> +	dgap_free_irq(brd);
> +unregister_tty:
> +	dgap_tty_unregister(brd);
> +free_flipbuf:
> +	dgap_free_flipbuf(brd);
> +free_brd:
> +	kfree(brd);

This isn't complete.  We need a dgap_unfound_board() which frees brd
and calls the inverse of dgap_do_remap().  Obviously "found" and
"unfound" are not the smartest names in the universe.

That said, I'm inclined to say that we can fix this up in a later patch.
This patch is clearly an improvement on the existing code and I'm not
sure it's possible to fix *everything* in one go.

TODO-list:  2014-06-13: dgap: call dgap_unfound_board() on error in dgap_init_one()

> +	dgap_board[--dgap_numboards] = NULL;
> +	return rc;
>  }

regards,
dan carpenter
