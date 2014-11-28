Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbaK1Gro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:47:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaK1Grn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:47:43 -0500
Date: Fri, 28 Nov 2014 06:55:23 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, kys@microsoft.com, vkuznets@redhat.com,
        haiyangz@microsoft.com
Message-Id: <1417157243.3268.1@smtp.corp.redhat.com>
In-Reply-To: <1417093747-21073-1-git-send-email-decui@microsoft.com>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, Nov 27, 2014 at 9:09 PM, Dexuan Cui <decui@microsoft.com> wrote:
> In the case the user-space daemon crashes, hangs or is killed, we
> need to down the semaphore, otherwise, after the daemon starts next
> time, the obsolete data in fcopy_transaction.message or
> fcopy_transaction.fcopy_msg will be used immediately.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
> 
> v2: I removed the "FCP" prefix as Greg asked.
> 
>     I also updated the output message a little:
>     "FCP: failed to acquire the semaphore" --> 
>     "can not acquire the semaphore: it is benign"
> 
> v3: I added the code in fcopy_release() as Jason Wang suggested.
>     I removed the pr_debug (it isn't so meaningful)and added a 
> comment instead.
> 
>  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> index 23b2ce2..faa6ba6 100644
> --- a/drivers/hv/hv_fcopy.c
> +++ b/drivers/hv/hv_fcopy.c
> @@ -86,6 +86,18 @@ static void fcopy_work_func(struct work_struct 
> *dummy)
>  	 * process the pending transaction.
>  	 */
>  	fcopy_respond_to_host(HV_E_FAIL);
> +
> +	/* In the case the user-space daemon crashes, hangs or is killed, we
> +	 * need to down the semaphore, otherwise, after the daemon starts 
> next
> +	 * time, the obsolete data in fcopy_transaction.message or
> +	 * fcopy_transaction.fcopy_msg will be used immediately.
> +	 *
> +	 * NOTE: fcopy_read() happens to get the semaphore (very rare)? 
> We're
> +	 * still OK, because we've reported the failure to the host.
> +	 */
> +	if (down_trylock(&fcopy_transaction.read_sema))
> +		;

Sorry, I'm not quite understand how if () ; can help here.

Btw, a question not relate to this patch.

What happens if a daemon is resume from SIGSTOP and expires the check 
here?
> 
> +
>  }
>  
>  static int fcopy_handle_handshake(u32 version)
> @@ -351,6 +363,13 @@ static int fcopy_release(struct inode *inode, 
> struct file *f)
>  	 */
>  	in_hand_shake = true;
>  	opened = false;
> +
> +	if (cancel_delayed_work_sync(&fcopy_work)) {
> +		/* We haven't up()-ed the semaphore(very rare)? */
> +		if (down_trylock(&fcopy_transaction.read_sema))
> +			;

And this.
> 
> +		fcopy_respond_to_host(HV_E_FAIL);
> +	}
>  	return 0;
>  }
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

