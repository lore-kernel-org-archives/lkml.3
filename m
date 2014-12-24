Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaLXFjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:39:37 -0500
Received: from smtprelay0137.hostedemail.com ([216.40.44.137]:41960 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbaLXFjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:39:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 20,1.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3352:3622:3867:3868:3871:4321:5007:6261:7904:8603:10009:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: books04_5377086e5e655
X-Filterd-Recvd-Size: 1922
Message-ID: <1419399572.6157.7.camel@perches.com>
Subject: Re: [PATCH] usb: gadget: ffs: Fix sparse error
From: Joe Perches <joe@perches.com>
To: Rohith Seelaboyina <rseelaboyina@nvidia.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, mina86@mina86.com,
        r.baldyga@samsung.com, andrzej.p@samsung.com,
        david.a.cohen@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Dec 2014 21:39:32 -0800
In-Reply-To: <1419398988-14576-1-git-send-email-rseelaboyina@nvidia.com>
References: <1419398988-14576-1-git-send-email-rseelaboyina@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 10:59 +0530, Rohith Seelaboyina wrote:
> Dynamic memory allocation through kmalloc is more safer
> than declaring variable array size, Fix this error by
> using kmalloc for memory allocation, Check if memory
> allocation is successful and return -ENOMEM on failure.
[]
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
[]
> @@ -397,10 +397,15 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
>  	 * We are holding ffs->ev.waitq.lock and ffs->mutex and we need
>  	 * to release them.
>  	 */
> -	struct usb_functionfs_event events[n];
>  	unsigned i = 0;
> +	int ret;
> +	struct usb_functionfs_event *events = kmalloc(n *
> +			sizeof(struct usb_functionfs_event), GFP_KERNEL);
> +
> +	if (unlikely(!events))
> +		return -ENOMEM;
>  
> -	memset(events, 0, sizeof events);
> +	memset(events, 0, n * sizeof(*events));

kcalloc without memset please.


