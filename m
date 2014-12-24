Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaLXLIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 06:08:36 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:36376 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbaLXLIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 06:08:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:8603:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: thumb05_2d533b63e4c37
X-Filterd-Recvd-Size: 2239
Message-ID: <1419419309.6157.13.camel@perches.com>
Subject: Re: [PATCH v2] usb: gadget: ffs: Fix sparse error
From: Joe Perches <joe@perches.com>
To: Rohith Seelaboyina <rseelaboyina@nvidia.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, mina86@mina86.com,
        r.baldyga@samsung.com, andrzej.p@samsung.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Dec 2014 03:08:29 -0800
In-Reply-To: <1419412728-12846-1-git-send-email-rseelaboyina@nvidia.com>
References: <1419412728-12846-1-git-send-email-rseelaboyina@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 14:48 +0530, Rohith Seelaboyina wrote:
> Dynamic memory allocation through kcalloc is more safer
> than declaring variable array size, Fix this error by
> using kcalloc for memory allocation, Check if memory
> allocation is successful and return -ENOMEM on failure.
> 
> Signed-off-by: Rohith Seelaboyina <rseelaboyina@nvidia.com>
> ---
> Changes in v2:
>    - Use kcalloc to allocate memory instead of using
>      kmalloc and memset.

style trivia:

> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
[]
> @@ -397,10 +397,13 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
>  	 * We are holding ffs->ev.waitq.lock and ffs->mutex and we need
>  	 * to release them.
>  	 */
> -	struct usb_functionfs_event events[n];
>  	unsigned i = 0;
> +	int ret;
> +	struct usb_functionfs_event *events = kcalloc(n,
> +			sizeof(struct usb_functionfs_event), GFP_KERNEL);
>  
> -	memset(events, 0, sizeof events);
> +	if (unlikely(!events))
> +		return -ENOMEM;

unlikely is not commonly used here.

I might be better to separate the declaration and the alloc
{
	[...]
	struct usb_functionfs_event *events;

	events = kcalloc(n, sizeof(*events), GFP_KERNEL);
	if (!events)
		return -ENOMEM;


