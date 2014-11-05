Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaKEW4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:56:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKEW4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:56:42 -0500
Date: Wed, 5 Nov 2014 14:56:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: Matthew Casey <mdcasey@chabloom.com>, Ben Hutchings <ben@decadent.org.uk>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: rtl8192e: Fix segfault upon alloc failure
Message-ID: <20141105225641.GA26985@kroah.com>
References: <danieru.dressler@gmail.com>
 <1415203879-17261-1-git-send-email-danieru.dressler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415203879-17261-1-git-send-email-danieru.dressler@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 01:11:17AM +0900, Daniel Dressler wrote:
> Kernel space allocations can fail. This patch
> fixes a crash condition upon allocation failure.
> 
> Should this condition occur init_firmware() will
> goto its error handler and declare download failure.
> 
> Of interesting note is that prior to this patch
> fw_download_code() could never fail yet our caller
> checked the return value.
> 
> Reported-by: RUC_Soft_Sec <rucsoftsec@gmail.com>
> Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 2e28744..e4257fe 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -61,6 +61,9 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  		}
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
> +		if (!skb)
> +			return false;

Lots of people try to fix this "warning" in this manner.  But you have
to do more work here than just a simple "return false;", you need to
unwind all of the work you have done up to this point, which is a
non-trivial task...

I'd recommend looking at how other drivers of this manufacturer handle
this type of operation to get a better idea of how to rewrite this
function.

good luck,

greg k-h
