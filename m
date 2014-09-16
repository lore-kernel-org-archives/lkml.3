Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaIPXZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:25:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaIPXZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:25:44 -0400
Date: Tue, 16 Sep 2014 16:25:49 -0700
From: Darren Hart <dvhart@infradead.org>
To: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Cc: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] intel-rst: Clean up ACPI add function
Message-ID: <20140916232549.GA18698@vmdeb7>
References: <1410902036-10282-1-git-send-email-peter.ujfalusi@gmail.com>
 <1410902036-10282-3-git-send-email-peter.ujfalusi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410902036-10282-3-git-send-email-peter.ujfalusi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 12:13:56AM +0300, Peter Ujfalusi wrote:
> There is no need to initialize the error since it is going to be assigned
> with the return status of at least on of the device_create_file() call.
> 
> We can return directly in case the first file creation fails.
> All the labels for goto can be removed (along with the gotos) as well.
> Tell the compiler that the failures are unlikely so it can create better
> binaries.

Looks reasonable to me.

Cc: linux-acpi


> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
> ---
>  drivers/platform/x86/intel-rst.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
> index 8c6a8fe..7344d84 100644
> --- a/drivers/platform/x86/intel-rst.c
> +++ b/drivers/platform/x86/intel-rst.c
> @@ -119,21 +119,16 @@ static struct device_attribute irst_timeout_attr = {
>  
>  static int irst_add(struct acpi_device *acpi)
>  {
> -	int error = 0;
> +	int error;
>  
>  	error = device_create_file(&acpi->dev, &irst_timeout_attr);
> -	if (error)
> -		goto out;
> +	if (unlikely(error))
> +		return error;
>  
>  	error = device_create_file(&acpi->dev, &irst_wakeup_attr);
> -	if (error)
> -		goto out_timeout;
> +	if (unlikely(error))
> +		device_remove_file(&acpi->dev, &irst_timeout_attr);
>  
> -	return 0;
> -
> -out_timeout:
> -	device_remove_file(&acpi->dev, &irst_timeout_attr);
> -out:
>  	return error;
>  }
>  
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Darren Hart
Intel Open Source Technology Center
