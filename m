Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3AXHwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:52:41 -0500
Received: from canardo.mork.no ([148.122.252.1]:58886 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab3AXHwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:52:32 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: =?utf-8?Q?J=C3=B6rn?= Engel <joern@logfs.org>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mpt2sas: prevent double free on error path
Organization: m
References: <20130123212033.GA15800@logfs.org>
Date: Thu, 24 Jan 2013 08:51:20 +0100
In-Reply-To: <20130123212033.GA15800@logfs.org> (=?utf-8?Q?=22J=C3=B6rn?=
 Engel"'s message of
	"Wed, 23 Jan 2013 16:20:33 -0500")
Message-ID: <87k3r310jr.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c6bdc92..43b3a98 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -570,6 +570,18 @@ _scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
>  	return NULL;
>  }
>  
> +static void free_sas_device(struct kref *kref)
> +{
> +	struct _sas_device *sas_device = container_of(kref, struct _sas_device,
> +			kref);
> +	kfree(sas_device);
> +}
> +
> +static void put_sas_device(struct _sas_device *sas_device)
> +{
> +	kref_put(&sas_device->kref, free_sas_device);
> +}
> +
>  /**
>   * _scsih_sas_device_remove - remove sas_device from list.
>   * @ioc: per adapter object
> @@ -583,14 +595,19 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
>      struct _sas_device *sas_device)
>  {
>  	unsigned long flags;
> +	int was_on_list = 0;
>  
>  	if (!sas_device)
>  		return;
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	list_del(&sas_device->list);
> -	kfree(sas_device);
> +	if (!list_empty(&sas_device->list)) {
> +		list_del_init(&sas_device->list);
> +		was_on_list = 1;
> +	}
>  	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	if (was_on_list)
> +		put_sas_device(sas_device);
>  }
>  


How about the copy of this code in drivers/scsi/mpt3sas/mpt3sas_scsih.c?
Is that safe, or does it need fixing as well?


Bjørn
