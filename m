Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaK0HOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:14:45 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:43418 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaK0HOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:14:44 -0500
Date: Thu, 27 Nov 2014 02:14:31 -0500 (EST)
From: Jason Wang <jasowang@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, kys@microsoft.com, vkuznets@redhat.com,
        haiyangz@microsoft.com
Message-ID: <1245181972.17067189.1417072471636.JavaMail.zimbra@redhat.com>
In-Reply-To: <1417073491-19388-1-git-send-email-decui@microsoft.com>
References: <1417073491-19388-1-git-send-email-decui@microsoft.com>
Subject: Re: [PATCH v2] hv: hv_fcopy: drop the obsolete message on transfer
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC39 (Linux)/8.0.6_GA_5922)
Thread-Topic: hv_fcopy: drop the obsolete message on transfer failure
Thread-Index: dC/w/W1VLatewoFkX93uyi5FxZIfGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> In the case the user-space daemon crashes, hangs or is killed, we
> need to down the semaphore, otherwise, after the daemon starts next
> time, the obsolete data in fcopy_transaction.message or
> fcopy_transaction.fcopy_msg will be used immediately.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
>  drivers/hv/hv_fcopy.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> index 23b2ce2..c518ad9 100644
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

Looks still racy, what happens if the daemon start before down_trylock()
but after fcopy_respont_to_host() here?

> +	if (down_trylock(&fcopy_transaction.read_sema))
> +		pr_debug("can not acquire the semaphore: it is benign\n");

typo
> +
>  }
>  
>  static int fcopy_handle_handshake(u32 version)
> --
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
