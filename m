Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaKLR1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:27:54 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:57389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaKLR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:27:51 -0500
Date: Wed, 12 Nov 2014 09:27:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org
Subject: Re: [V2 PATCH 3/4] scsi:stex.c Add reboot support
Message-ID: <20141112172750.GB18862@infradead.org>
References: <5462D62C.50602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462D62C.50602@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int stex_reboot_callback(struct notifier_block *self,
> +							  unsigned long val,
> +							  void *data)
> +{
> +	if (val == SYS_RESTART)
> +		isRestart = 1;
> +	return NOTIFY_OK;
> +}
> 
> @@ -1832,7 +1859,14 @@ static void stex_shutdown(struct pci_dev *pdev)
>  {
>  	struct st_hba *hba = pci_get_drvdata(pdev);
> 
> -	stex_hba_stop(hba);
> +	if (hba->yellowstone == 1)
> +		stex_hba_stop(hba, ST_IGNORED);
> +	else {
> +		if (isRestart)
> +			stex_hba_stop(hba, ST_S6);
> +		else
> +			stex_hba_stop(hba, ST_S5);
> +	}

This sort of check for reboot vs restart isn't really something
we want in drivers.  I don't really know how we could find this
out assuming we even want drivers to behave differently.

Maybe Greg or someone on lkml has an idea how to best handle this case.
