Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaDDUck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:32:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35628 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaDDUcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:32:33 -0400
Message-ID: <533F178F.8090404@oracle.com>
Date: Fri, 04 Apr 2014 16:35:27 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xen/xenbus: Avoid synchronous wait on XenBus stalling
 shutdown/restart.
References: <1396637621-30113-1-git-send-email-konrad.wilk@oracle.com> <1396637621-30113-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1396637621-30113-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 02:53 PM, Konrad Rzeszutek Wilk wrote:
> The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
> 'process_msg' is running from within the 'xenbus' thread. Whenever
> a message shows up in XenBus it is put on a xs_state.reply_list list
> and 'read_reply' picks it up.
>
> The problem is if the backend domain or the xenstored process is killed.
> In which case 'xenbus' is still awaiting - and 'read_reply' if called -
> stuck forever waiting for the reply_list to have some contents.
>
> This is normally not a problem - as the backend domain can come back
> or the xenstored process can be restarted. However if the domain
> is in process of being powered off/restarted/halted - there is no
> point of waiting on it coming back - as we are effectively being
> terminated and should not impede the progress.
>
> This patch solves this problem by checking whether the guest is
> the right domain. If it is an initial domain and hurtling towards
> death - there is no point of continuing the wait. All other type
> of guests continue with their behavior.
> mechanism a bit more asynchronous.

This looks like a runaway sentence.

Other than that
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

>
> Fixes-Bug: http://bugs.xenproject.org/xen/bug/8
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> [v2: Fixed it up per David's suggestions]
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> ---
>   drivers/xen/xenbus/xenbus_xs.c | 44 +++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 41 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index b6d5fff..ba804f3 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -50,6 +50,7 @@
>   #include <xen/xenbus.h>
>   #include <xen/xen.h>
>   #include "xenbus_comms.h"
> +#include "xenbus_probe.h"
>   
>   struct xs_stored_msg {
>   	struct list_head list;
> @@ -139,6 +140,29 @@ static int get_error(const char *errorstring)
>   	return xsd_errors[i].errnum;
>   }
>   
> +static bool xenbus_ok(void)
> +{
> +	switch (xen_store_domain_type) {
> +	case XS_LOCAL:
> +		switch (system_state) {
> +		case SYSTEM_POWER_OFF:
> +		case SYSTEM_RESTART:
> +		case SYSTEM_HALT:
> +			return false;
> +		default:
> +			break;
> +		}
> +		return true;
> +	case XS_PV:
> +	case XS_HVM:
> +		/* FIXME: Could check that the remote domain is alive,
> +		 * but it is normally initial domain. */
> +		return true;
> +	default:
> +		break;
> +	}
> +	return false;
> +}
>   static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
>   {
>   	struct xs_stored_msg *msg;
> @@ -148,9 +172,20 @@ static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
>   
>   	while (list_empty(&xs_state.reply_list)) {
>   		spin_unlock(&xs_state.reply_lock);
> -		/* XXX FIXME: Avoid synchronous wait for response here. */
> -		wait_event(xs_state.reply_waitq,
> -			   !list_empty(&xs_state.reply_list));
> +		if (xenbus_ok())
> +			/* XXX FIXME: Avoid synchronous wait for response here. */
> +			wait_event_timeout(xs_state.reply_waitq,
> +					   !list_empty(&xs_state.reply_list),
> +					   msecs_to_jiffies(500));
> +		else {
> +			/*
> +			 * If we are in the process of being shut-down there is
> +			 * no point of trying to contact XenBus - it is either
> +			 * killed (xenstored application) or the other domain
> +			 * has been killed or is unreachable.
> +			 */
> +			return ERR_PTR(-EIO);
> +		}
>   		spin_lock(&xs_state.reply_lock);
>   	}
>   
> @@ -215,6 +250,9 @@ void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg)
>   
>   	mutex_unlock(&xs_state.request_mutex);
>   
> +	if (IS_ERR(ret))
> +		return ret;
> +
>   	if ((msg->type == XS_TRANSACTION_END) ||
>   	    ((req_msg.type == XS_TRANSACTION_START) &&
>   	     (msg->type == XS_ERROR)))

