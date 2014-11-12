Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaKLJmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:42:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbaKLJlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:41:20 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer failure
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
Date: Wed, 12 Nov 2014 10:41:03 +0100
In-Reply-To: <1415768606-28538-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Tue, 11 Nov 2014 21:03:26 -0800")
Message-ID: <87oasc69jk.fsf@vitty.brq.redhat.com>
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
>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

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
> +
>  }
>
>  static int fcopy_handle_handshake(u32 version)

-- 
  Vitaly
