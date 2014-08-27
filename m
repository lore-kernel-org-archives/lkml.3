Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbaH0KE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:04:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42364 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbaH0KE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:04:56 -0400
Date: Wed, 27 Aug 2014 13:04:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] Drivers: hv: vmbus: Cleanup vmbus_close_internal()
Message-ID: <20140827100430.GF5046@mwanda>
References: <1409079922-16560-1-git-send-email-kys@microsoft.com>
 <1409079952-16599-1-git-send-email-kys@microsoft.com>
 <1409079952-16599-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409079952-16599-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 12:05:51PM -0700, K. Y. Srinivasan wrote:
> -static void vmbus_close_internal(struct vmbus_channel *channel)
> +static int vmbus_close_internal(struct vmbus_channel *channel)
>  {
>  	struct vmbus_channel_close_channel *msg;
> -	int ret;
> +	int ret = 0;

GCC has a feature which warns about uninitialized variables.  Those
features are there to help prevent bugs.  You are turning the feature
off here by initializing it with a bogus value.  Don't do that.

>  
>  	channel->state = CHANNEL_OPEN_STATE;
>  	channel->sc_creation_callback = NULL;
> @@ -502,11 +502,28 @@ static void vmbus_close_internal(struct vmbus_channel *channel)
>  
>  	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));
>  
> -	BUG_ON(ret != 0);
> +	if (ret) {
> +		pr_err("Close failed: close post msg return is %d\n", ret);
> +		/*
> +		 * If we failed to post the close msg,
> +		 * it is perhaps better to leak memory.
> +		 */
> +		goto close_err;


Just return directly.  Don't introduce do-nothing gotos to lead the
reader through a series of pointless goto hops.

The goto label is poorly chosen.  Label names should be based on the
thing which they do.  "close_err" implies that something is closed but
that's not the case, the label doesn't do anything.

regards,
dan carpenter

