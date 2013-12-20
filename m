Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3LTKsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:48:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48236 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3LTKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:48:51 -0500
Date: Fri, 20 Dec 2013 13:45:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wenliang Fan <fanwlexca@gmail.com>
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com, tulinizer@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/bcm: Integer overflow
Message-ID: <20131220104519.GW5443@mwanda>
References: <1387534796-31901-1-git-send-email-fanwlexca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387534796-31901-1-git-send-email-fanwlexca@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 06:19:56PM +0800, Wenliang Fan wrote:
> The checking condition in 'validateFlash2xReadWrite()' is not
> sufficient. A large number invalid would cause an integer overflow and
> pass the condition, which could cause further integer overflows in
> 'Bcmchar.c:bcm_char_ioctl()'.
> 
> Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
> ---
>  drivers/staging/bcm/nvm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
> index 9e5f955..7f3dd4b 100644
> --- a/drivers/staging/bcm/nvm.c
> +++ b/drivers/staging/bcm/nvm.c
> @@ -3944,6 +3944,11 @@ int validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2
>  
>  	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, NVM_RW, DBG_LVL_ALL, "End offset :%x\n", uiSectEndOffset);
>  
> +	/* psFlash2xReadWrite->offset and uiNumOfBytes are user controlled and can lead to integer overflows */
> +	if (uiSectStartOffset + psFlash2xReadWrite->offset < uiSectStartOffset)
> +		return false;
> +	if (uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes < uiNumOfBytes)
> +		return false;

Please don't do this...  :( Just do it exactly like I explained before.

Using this style of overflow checking causes static checkers which look
for integer overflows to complain and it is too complicated.

Just do:

	if (uiSectStartOffset > uiSectEndOffset)
		return false;
	if (psFlash2xReadWrite->offset > uiSectEndOffset)
		return false;

>  	/* Checking the boundary condition */
>  	if ((uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes) <= uiSectEndOffset)
>  		return TRUE;

Reverse this condition so it does:
	if (uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes > uiSectEndOffset)
		return false;

Then if everything is valid do:

	return true;

Compare how these two statements sound in English:

	If psFlash2xReadWrite->offset is larger than uiSectEndOffset
	return false.

Vs:
	If we uiSectStartOffset plus psFlash2xReadWrite->offset plus
	uiNumOfBytes is less than uiNumOfBytes then it means we
	overflowed.  Since we verified that uiSectStartOffset plus
	psFlash2xReadWrite->offset don't overflow that means
	uiNumOfBytes is too large so return false.

The first one is simple and the second one is complicated.  Don't do
complicated things for no reason.  Also the first one is fewer
operations for the CPU.

regards,
dan carpenter
