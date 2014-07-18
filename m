Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbaGRBmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:42:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaGRBmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:42:49 -0400
Date: Thu, 17 Jul 2014 18:37:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 4/5] mei: nfc: clean nfc internal struct on host
 exit
Message-ID: <20140718013758.GA31846@kroah.com>
References: <1405583618-8229-1-git-send-email-tomas.winkler@intel.com>
 <1405583618-8229-5-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405583618-8229-5-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:53:37AM +0300, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> NFC internal structure cleaning was dropped by commit
> 
> commit 5ad1550a15cd5b75ed8aa3009e162822f720375e
> Author: Tomas Winkler <tomas.winkler@intel.com>
> Date:   Sun Jan 26 11:53:06 2014 +0200
> 
>     mei: Remove all bus devices from the mei_dev list when stopping the MEI
> 
> Bring back cleaning of structure only, because it broke
> host init after host exit scenario (like after S3):
> mei_nfc_host_init checks ndev->cl_info and does nothing if it's dirty.
> 
> Cc: stable@vger.kernel.org # 3.15+
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/nfc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
> index 3095fc5..257f01f 100644
> --- a/drivers/misc/mei/nfc.c
> +++ b/drivers/misc/mei/nfc.c
> @@ -553,6 +553,7 @@ void mei_nfc_host_exit(struct mei_device *dev)
>  {
>  	struct mei_nfc_dev *ndev = &nfc_dev;
>  	cancel_work_sync(&ndev->init_work);
> +	memset(ndev, 0, sizeof(struct mei_nfc_dev));

This implies that something is using a "static" device structure, which
isn't allowed by the driver core.  So please fix the root cause here,
don't paper over the bug.

thanks,

greg k-h
