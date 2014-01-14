Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaANIUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:20:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37876 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaANIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:20:19 -0500
Date: Tue, 14 Jan 2014 11:19:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Subject: Re: [PATCH 3/3] memstick: Add realtek USB memstick host driver
Message-ID: <20140114081953.GG7499@mwanda>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-4-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389685656-880-4-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:47:36PM +0800, rogerable@realtek.com wrote:
> +static int ms_pull_ctl_disable(struct rtsx_ucr *ucr)
> +{
> +	rtsx_usb_init_cmd(ucr);
> +
> +	if (CHECK_PKG(ucr, LQFP48)) {
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL1, 0xFF, 0x55);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL2, 0xFF, 0x55);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL3, 0xFF, 0x95);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL4, 0xFF, 0x55);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL5, 0xFF, 0x55);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL6, 0xFF, 0xA5);
> +	} else {
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL1, 0xFF, 0x65);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL2, 0xFF, 0x55);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL3, 0xFF, 0x95);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL4, 0xFF, 0x55);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL5, 0xFF, 0x56);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL6, 0xFF, 0x59);
> +	}
> +

I'm fine with this patch going in as-is, but I just wanted to comment on
this for future reference/cleanups.  These blocks where all the lines
are over 80 characters are hard to look at.  We could break it into
separate functions.

static int ms_pull_ctl_disable_lqfp48(struct rtsx_ucr *ucr)
{
	rtsx_usb_init_cmd(ucr);

	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL1, 0xFF, 0x55);
	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL2, 0xFF, 0x55);
	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL3, 0xFF, 0x95);
	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL4, 0xFF, 0x55);
	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL5, 0xFF, 0x55);
	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL6, 0xFF, 0xA5);

	return rtsx_usb_send_cmd(ucr, MODE_C, 100);
}

Or another option would be to remove the "CARD_" prefix.  I don't think
we would miss it.

	if (CHECK_PKG(ucr, LQFP48)) {
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL1, 0xFF, 0x55);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL2, 0xFF, 0x55);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL3, 0xFF, 0x95);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL4, 0xFF, 0x55);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL5, 0xFF, 0x55);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL6, 0xFF, 0xA5);
	} else {
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL1, 0xFF, 0x65);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL2, 0xFF, 0x55);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL3, 0xFF, 0x95);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL4, 0xFF, 0x55);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL5, 0xFF, 0x56);
		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, PULL_CTL6, 0xFF, 0x59);
	}

Another option might be to remove the "_usb" from the
rtsx_usb_add_cmd().

Just some ideas.

regards,
dan carpenter

