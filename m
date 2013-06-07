Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3FGIyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:54:31 -0400
Received: from mail.abilis.ch ([195.70.19.74]:24407 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab3FGIy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:54:27 -0400
Date: Fri, 7 Jun 2013 10:53:39 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: i2c: designware: prevent signals from aborting I2C transfers
Message-ID: <20130607085327.GA570@ab42.lan>
References: <1369216991-13334-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1369216991-13334-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 10:03:11AM -0000, Mika Westerberg wrote:
> If a process receives signal while it is waiting for I2C transfer to
> complete, an error is returned to the caller and the transfer is aborted.
> This can cause the driver to fail subsequent transfers. Also according to
> commit d295a86eab2 (i2c: mv64xxx: work around signals causing I2C
> transactions to be aborted) I2C drivers aren't supposed to abort
> transactions on signals.
> 
> To prevent this switch to use wait_for_completion_timeout() instead of
> wait_for_completion_interruptible_timeout() in the designware I2C driver.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
> 
> ---
> drivers/i2c/busses/i2c-designware-core.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> index c41ca63..db20a28 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -580,14 +580,13 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>  	i2c_dw_xfer_init(dev);
>  
>  	/* wait for tx to complete */
> -	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete, HZ);
> +	ret = wait_for_completion_timeout(&dev->cmd_complete, HZ);
>  	if (ret == 0) {
>  		dev_err(dev->dev, "controller timed out\n");
>  		i2c_dw_init(dev);
>  		ret = -ETIMEDOUT;
>  		goto done;
> -	} else if (ret < 0)
> -		goto done;
> +	}
>  
>  	if (dev->msg_err) {
>  		ret = dev->msg_err;

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
