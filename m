Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaAMLYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:24:20 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:34949 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaAMLYT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 13 Jan 2014 06:24:19 -0500
Message-Id: <52D3DAEE0200007800112FD4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 13 Jan 2014 11:24:14 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check
 from blkfront_setup_discard
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1389608052-7139-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.01.14 at 11:14, Olaf Hering <olaf@aepfle.de> wrote:
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1634,37 +1634,22 @@ blkfront_closing(struct blkfront_info *info)
>  
>  static void blkfront_setup_discard(struct blkfront_info *info)
>  {
> -	int err;
> -	char *type;
>  	unsigned int discard_granularity;
>  	unsigned int discard_alignment;
>  	unsigned int discard_secure;
>  
> -	type = xenbus_read(XBT_NIL, info->xbdev->otherend, "type", NULL);
> -	if (IS_ERR(type))
> +	if (xenbus_gather(XBT_NIL, info->xbdev->otherend,
> +		"discard-granularity", "%u", &discard_granularity,
> +		"discard-alignment", "%u", &discard_alignment,
> +		"discard-secure", "%u", &discard_secure,
> +		NULL))
>  		return;

You can't do this in one go - the first two and the last one may be
set independently (and are independent in their meaning), and
hence need to be queried independently (xenbus_gather() fails
on the first absent value).

Jan

