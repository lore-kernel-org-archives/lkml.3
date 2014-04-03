Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162663AbaDCIi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:38:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17747 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162583AbaDCIiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:38:23 -0400
Date: Thu, 3 Apr 2014 11:38:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: s626: use comedi_timeout() on
 remaining loops
Message-ID: <20140403083804.GB6991@mwanda>
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
 <1395805438-12259-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395805438-12259-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:43:58PM -0500, Chase Southwood wrote:
> There were just a handful of more while loops in this file that needed
> timeouts, and this patch takes care of them.  One new callback is
> introduced, and all of the proper comedi_timeout() calls are then used.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: s626_i2c_handshake_eoc() can be used in s626_initialize() as noted by
> Ian.  So, s626_initialize_eoc() has been removed, and its uses swapped
> for s626_i2c_handshake_eoc().
> 
>  drivers/staging/comedi/drivers/s626.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 95fadf3..865cf93 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -295,10 +295,24 @@ static void s626_debi_replace(struct comedi_device *dev, unsigned int addr,
>  
>  /* **************  EEPROM ACCESS FUNCTIONS  ************** */
>  
> +static int s626_i2c_handshake_eoc(struct comedi_device *dev,
> +				 struct comedi_subdevice *s,
> +				 struct comedi_insn *insn,
> +				 unsigned long context)
> +{
> +	unsigned int status;

This should probably be bool.

> +
> +	status = s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> +	if (status)
> +		return 0;
> +	return -EBUSY;
> +}
> +
>  static uint32_t s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
>  {
>  	struct s626_private *devpriv = dev->private;
>  	unsigned int ctrl;
> +	uint32_t ret;

This should be int.  I get really suspicious when people start using
uint32_t types.  Why does it have to be 32 bits?  Unsigned is wrong as
well.

regards,
dan carpenter

