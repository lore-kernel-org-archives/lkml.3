Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaK0ClQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:41:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaK0ClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:41:14 -0500
Date: Wed, 26 Nov 2014 15:54:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com, haiyangz@microsoft.com, vkuznets@redhat.com
Subject: Re: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Message-ID: <20141126235425.GA5313@kroah.com>
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415768606-28538-1-git-send-email-decui@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:03:26PM -0800, Dexuan Cui wrote:
> In the case the user-space daemon crashes, hangs or is killed, we
> need to down the semaphore, otherwise, after the daemon starts next
> time, the obsolete data in fcopy_transaction.message or
> fcopy_transaction.fcopy_msg will be used immediately.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/hv/hv_fcopy.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> index 23b2ce2..177122a 100644
> --- a/drivers/hv/hv_fcopy.c
> +++ b/drivers/hv/hv_fcopy.c
> @@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct *dummy)
>  	 * process the pending transaction.
>  	 */
>  	fcopy_respond_to_host(HV_E_FAIL);
> +
> +	/* In the case the user-space daemon crashes, hangs or is killed, we
> +	 * need to down the semaphore, otherwise, after the daemon starts next
> +	 * time, the obsolete data in fcopy_transaction.message or
> +	 * fcopy_transaction.fcopy_msg will be used immediately.
> +	 */
> +	if (down_trylock(&fcopy_transaction.read_sema))
> +		pr_debug("FCP: failed to acquire the semaphore\n");

Why is "FCP:" needed?  pr_debug() should never need any type of prefix.

Please fix.

thanks,

greg k-h
