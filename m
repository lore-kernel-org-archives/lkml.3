Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3LEIhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:37:02 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46976 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3LEIg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:36:59 -0500
Date: Thu, 5 Dec 2013 11:36:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Subject: Re: [PATCH v1 2/9] staging: android: binder: Add
 binder_copy_to_user()
Message-ID: <20131205083637.GV28413@mwanda>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-3-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386180581-6710-3-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:09:34PM +0000, Serban Constantinescu wrote:
> This patch adds binder_copy_to_user() to be used for copying binder
> commands to user address space. This way we can abstract away the
> copy_to_user() calls and add separate handling for the compat layer.
> 
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/binder.c |   39 ++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 233889c..6fbb340 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2117,6 +2117,18 @@ static int binder_has_thread_work(struct binder_thread *thread)
>  		(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN);
>  }
>  
> +static int binder_copy_to_user(uint32_t cmd, void *parcel,
> +			       void __user **ptr, size_t size)
> +{

Bike shedding:  Put the **ptr as the first argument.
binder_copy_to_user(dest, cmd, src, size);

> +	if (put_user(cmd, (uint32_t __user *)*ptr))
> +		return -EFAULT;
> +	*ptr += sizeof(uint32_t);
> +	if (copy_to_user(*ptr, parcel, size))
> +		return -EFAULT;
> +	*ptr += size;
> +	return 0;
> +}

regards,
dan carpenter


