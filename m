Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3KAN3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:29:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3KAN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:29:54 -0400
Date: Fri, 1 Nov 2013 06:31:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomas Henzl <thenzl@redhat.com>
Cc: scameron@beardog.cce.hp.com, Jens Axboe <axboe@kernel.dk>,
        stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success,
 not 1
Message-Id: <20131101063110.6a390f48.akpm@linux-foundation.org>
In-Reply-To: <5273A765.6080705@redhat.com>
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com>
	<52700541.70405@kernel.dk>
	<20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org>
	<20131031215444.GN31390@beardog.cce.hp.com>
	<20131031150618.fa9430269e0de7a5ebad1387@linux-foundation.org>
	<5273A765.6080705@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 14:06:45 +0100 Tomas Henzl <thenzl@redhat.com> wrote:

> The problem in kernel is that the error handling in local_pci_probe
> and  in __pci_device_probe is different for ret values > 0,
> so we should fix it somewhere so it is in sync.
> The documentation states that the probe function should return zero on success
> so what about this -
> 
> This would bring the handling to sync
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 98f7b9b..200a071 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -317,8 +317,6 @@ __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
>  		id = pci_match_device(drv, pci_dev);
>  		if (id)
>  			error = pci_call_probe(drv, pci_dev, id);
> -		if (error >= 0)
> -			error = 0;
>  	}
>  	return error;
>  }

ah, there it is.

This change would turn semi-kaput drivers into kaput-kaput drivers.  It
would be better to add a runtime warning here so those drivers get
fixed.  Such a warning would need to reliably identify the offending
probe function so a simple WARN_ON() wouldn't be sufficient.


