Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaDYJ03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:26:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29104 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaDYJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:26:26 -0400
Date: Fri, 25 Apr 2014 12:26:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>, Mark Hounschell <markh@compro.net>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140425092607.GH26890@mwanda>
References: <20140425070459.GA9155@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425070459.GA9155@devel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, maybe you should add yourself to the MAINTAINERS entry for this
driver?

On Fri, Apr 25, 2014 at 04:04:59PM +0900, Daeseok Youn wrote:
> @@ -1263,7 +1277,8 @@ static int dgap_tty_register(struct board_t *brd)
>  		/* Register tty devices */
>  		rc = tty_register_driver(brd->SerialDriver);
>  		if (rc < 0)
> -			return rc;
> +			goto free_print_ttys;
> +
>  		brd->dgap_Major_Serial_Registered = TRUE;
>  		dgap_BoardsByMajor[brd->SerialDriver->major] = brd;
>  		brd->dgap_Serial_Major = brd->SerialDriver->major;
> @@ -1273,13 +1288,29 @@ static int dgap_tty_register(struct board_t *brd)
>  		/* Register Transparent Print devices */
>  		rc = tty_register_driver(brd->PrintDriver);
>  		if (rc < 0)
> -			return rc;
> +			goto unregister_serial_drv;
> +
>  		brd->dgap_Major_TransparentPrint_Registered = TRUE;
>  		dgap_BoardsByMajor[brd->PrintDriver->major] = brd;
>  		brd->dgap_TransparentPrint_Major = brd->PrintDriver->major;
>  	}
>  
>  	return rc;
> +
> +unregister_serial_drv:
> +	tty_unregister_driver(brd->SerialDriver);

We only register the ->SerialDriver if someone else hasn't registered it
first?  So this should be:

	if (we_were_the_ones_who_registered_the_serial_driver)
		tty_unregister_driver(brd->SerialDriver);

I haven't followed looked at this.  Who else is registering the serial
driver?  You have looked at this, what do you think?  Or Mark.

regards,
dan carpenter

