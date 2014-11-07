Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaKGT5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:57:03 -0500
Received: from skprod2.natinst.com ([130.164.80.23]:42521 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751459AbaKGT5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:57:01 -0500
Date: Fri, 7 Nov 2014 13:56:12 -0600
From: Ben Shelton <ben.shelton@ni.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH 1/4] UBIFS: fix a couple bugs in UBIFS xattr length
 calculation
Message-ID: <20141107195612.GA22167@bshelton-desktop>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
 <1414781431-2911-2-git-send-email-ben.shelton@ni.com>
 <1415356480.958.315.camel@sauron.fi.intel.com>
MIME-Version: 1.0
In-Reply-To: <1415356480.958.315.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 11/07/2014 01:56:21 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 11/07/2014 01:56:21 PM,
	Serialize complete at 11/07/2014 01:56:21 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-07_08:2014-11-07,2014-11-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Artem Bityutskiy wrote:
> On Fri, 2014-10-31 at 13:50 -0500, Ben Shelton wrote:
> > From: Subodh Nijsure <snijsure@grid-net.com>
> > 
> > Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Signed-off-by: Ben Shelton <ben.shelton@ni.com>
> > Acked-by: Brad Mouring <brad.mouring@ni.com>
> > Acked-by: Gratian Crisan <gratian.crisan@ni.com>
> 
> It looks like these patches are against an old kernel. In the new kernel
> "dir_ui" was renamed to "host_ui", to show that this is not just a
> directory inode, but a directory or an xattr inode (we call the "host"
> inodes, since the "host" the xattr value).
> 
> I've pushed this patch in a modified form.
> 
> Do you have a possibility to test this series with a newer kernel?

Thanks for having a look at the patches.

We originally tested the patches against a recent stable 3.14 kernel.
I'll try to get a more recent kernel running on one of our targets that
uses UBIFS to test with -- should I use 3.18-rc3 or the latest
l2-mtd.git master?

Ben

> 
> Here is the patch I pushed:
> 
> 
> From a76284e6f89b2ae37d413fe793752257be01765a Mon Sep 17 00:00:00 2001
> From: Subodh Nijsure <snijsure@grid-net.com>
> Date: Fri, 31 Oct 2014 13:50:28 -0500
> Subject: [PATCH] UBIFS: fix a couple bugs in UBIFS xattr length calculation
> 
> The journal update function did not work for extended attributes properly,
> because extended attribute inodes carry the xattr data, and the size of this
> data was not taken into account.
> 
> Artem: improved commit message, amended the patch a bit.
> 
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Ben Shelton <ben.shelton@ni.com>
> Acked-by: Brad Mouring <brad.mouring@ni.com>
> Acked-by: Gratian Crisan <gratian.crisan@ni.com>
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/ubifs/journal.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
> index fb166e2..f6ac3f2 100644
> --- a/fs/ubifs/journal.c
> +++ b/fs/ubifs/journal.c
> @@ -571,7 +571,11 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
>  
>  	aligned_dlen = ALIGN(dlen, 8);
>  	aligned_ilen = ALIGN(ilen, 8);
> +
>  	len = aligned_dlen + aligned_ilen + UBIFS_INO_NODE_SZ;
> +	/* Make sure to also account for extended attributes */
> +	len += host_ui->data_len;
> +
>  	dent = kmalloc(len, GFP_NOFS);
>  	if (!dent)
>  		return -ENOMEM;
> @@ -648,7 +652,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
>  
>  	ino_key_init(c, &ino_key, dir->i_ino);
>  	ino_offs += aligned_ilen;
> -	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ);
> +	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs,
> +			    UBIFS_INO_NODE_SZ + host_ui->data_len);
>  	if (err)
>  		goto out_ro;
>  
> -- 
> 1.9.3
> 
> Artem.
> 
