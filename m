Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaAZBOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 20:14:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:51998 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaAZBOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 20:14:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,721,1384329600"; 
   d="scan'208";a="470826735"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>
Subject: RE: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
	XenBus stalling shutdown/restart.
Thread-Topic: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
	XenBus stalling shutdown/restart.
Thread-Index: AQHO3KmE8nzOae4vI0ON33E2bX7xXpqWrgxw
Date: Sun, 26 Jan 2014 01:13:51 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0A9C6EC5@SHSMSX104.ccr.corp.intel.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote on 2013-11-09:
> The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
> 'process_msg' is running from within the 'xenbus' thread. Whenever a
> message shows up in XenBus it is put on a xs_state.reply_list list and
> 'read_reply' picks it up.
> 
> The problem is if the backend domain or the xenstored process is killed.
> In which case 'xenbus' is still awaiting - and 'read_reply' if called
> - stuck forever waiting for the reply_list to have some contents.
> 
> This is normally not a problem - as the backend domain can come back
> or the xenstored process can be restarted. However if the domain is in
> process of being powered off/restarted/halted - there is no point of
> waiting on it coming back - as we are effectively being terminated and
> should not impede the progress.
> 

Hi, Konrad,

Is this patch applied in Linux upstream tree? I didn't find it with latest Linux upstream source.

> This patch solves this problem by checking the 'system_state' value to
> see if we are in heading towards death. We also make the wait
> mechanism a bit more asynchronous.
> 
> Fixes-Bug: http://bugs.xenproject.org/xen/bug/8
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xenbus/xenbus_xs.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> diff --git a/drivers/xen/xenbus/xenbus_xs.c
> b/drivers/xen/xenbus/xenbus_xs.c index b6d5fff..4f22706 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -148,9 +148,24 @@ static void *read_reply(enum xsd_sockmsg_type
> *type, unsigned int *len)
> 
>  	while (list_empty(&xs_state.reply_list)) {
>  		spin_unlock(&xs_state.reply_lock);
> -		/* XXX FIXME: Avoid synchronous wait for response here. */
> -		wait_event(xs_state.reply_waitq, -			  
> !list_empty(&xs_state.reply_list));
> +		wait_event_timeout(xs_state.reply_waitq, +				  
> !list_empty(&xs_state.reply_list), +				   msecs_to_jiffies(500)); +
> +		/* +		 * If we are in the process of being shut-down there is +		 *
> no point of trying to contact XenBus - it is either +		 * killed
> (xenstored application) or the other domain +		 * has been killed or is
> unreachable. +		 */ +		switch (system_state) { +		case SYSTEM_POWER_OFF:
> +		case SYSTEM_RESTART: +		case SYSTEM_HALT: +			return ERR_PTR(-EIO);
> +		default: +			break; +		}
>  		spin_lock(&xs_state.reply_lock);
>  	}
> @@ -215,6 +230,9 @@ void *xenbus_dev_request_and_reply(struct
> xsd_sockmsg *msg)
> 
>  	mutex_unlock(&xs_state.request_mutex);
> +	if (IS_ERR(ret))
> +		return ret;
> +
>  	if ((msg->type == XS_TRANSACTION_END) ||
>  	    ((req_msg.type == XS_TRANSACTION_START) &&
>  	     (msg->type == XS_ERROR)))


Best regards,
Yang


