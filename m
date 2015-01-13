Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbbAMNwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:52:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbbAMNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:52:43 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>, kys@microsoft.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, haiyangz@microsoft.com
Subject: Re: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer failure
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
Date: Tue, 13 Jan 2015 14:52:26 +0100
In-Reply-To: <1417093747-21073-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Thu, 27 Nov 2014 05:09:07 -0800")
Message-ID: <8761caeqjp.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> In the case the user-space daemon crashes, hangs or is killed, we
> need to down the semaphore, otherwise, after the daemon starts next
> time, the obsolete data in fcopy_transaction.message or
> fcopy_transaction.fcopy_msg will be used immediately.

It seems this patch got lost and I don't see it in recent 'resend'
series. K.Y., Dexuan, can you please take a look?

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
>     I removed the pr_debug (it isn't so meaningful)and added a comment instead.
>
>  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> index 23b2ce2..faa6ba6 100644
> --- a/drivers/hv/hv_fcopy.c
> +++ b/drivers/hv/hv_fcopy.c
> @@ -86,6 +86,18 @@ static void fcopy_work_func(struct work_struct *dummy)
>  	 * process the pending transaction.
>  	 */
>  	fcopy_respond_to_host(HV_E_FAIL);
> +
> +	/* In the case the user-space daemon crashes, hangs or is killed, we
> +	 * need to down the semaphore, otherwise, after the daemon starts next
> +	 * time, the obsolete data in fcopy_transaction.message or
> +	 * fcopy_transaction.fcopy_msg will be used immediately.
> +	 *
> +	 * NOTE: fcopy_read() happens to get the semaphore (very rare)? We're
> +	 * still OK, because we've reported the failure to the host.
> +	 */
> +	if (down_trylock(&fcopy_transaction.read_sema))
> +		;
> +
>  }
>
>  static int fcopy_handle_handshake(u32 version)
> @@ -351,6 +363,13 @@ static int fcopy_release(struct inode *inode, struct file *f)
>  	 */
>  	in_hand_shake = true;
>  	opened = false;
> +
> +	if (cancel_delayed_work_sync(&fcopy_work)) {
> +		/* We haven't up()-ed the semaphore(very rare)? */
> +		if (down_trylock(&fcopy_transaction.read_sema))
> +			;
> +		fcopy_respond_to_host(HV_E_FAIL);
> +	}
>  	return 0;
>  }

-- 
  Vitaly
