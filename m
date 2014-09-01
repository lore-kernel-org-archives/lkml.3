Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaIAPge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:36:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaIAPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:36:30 -0400
Date: Mon, 1 Sep 2014 08:36:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@infradead.org>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Message-ID: <20140901153629.GA29938@infradead.org>
References: <5403AB47.3040706@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5403AB47.3040706@interlog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/scsi/scsi_debug.c	2014-08-26 13:24:51.646948507 -0400
> +++ b/drivers/scsi/scsi_debug.c	2014-08-30 18:04:54.589226679 -0400
> @@ -2743,6 +2743,13 @@ static int stop_queued_cmnd(struct scsi_
>  		if (test_bit(k, queued_in_use_bm)) {
>  			sqcp = &queued_arr[k];
>  			if (cmnd == sqcp->a_cmnd) {
> +				devip = (struct sdebug_dev_info *)
> +					cmnd->device->hostdata;
> +				if (devip)
> +					atomic_dec(&devip->num_in_q);
> +				sqcp->a_cmnd = NULL;

Why would the hostdata every be NULL here?  We should never
call ->slave_destroy on a device that has outstanding commands.

