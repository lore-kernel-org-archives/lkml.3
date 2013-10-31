Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab3JaP4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:56:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3JaP4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:56:54 -0400
Date: Thu, 31 Oct 2013 08:56:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        vaughan <vaughan.cao@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Message-ID: <20131031155653.GA16944@infradead.org>
References: <52718713.7050906@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52718713.7050906@interlog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	struct semaphore or_sem;  /* protect co-incident opens and releases */

Seems like this should be a mutex.

> sfds_list_empty(Sg_device *sdp)
>  {
>  	unsigned long flags;
>  	int ret;
>  
> +	spin_lock_irqsave(&sdp->sfd_lock, flags);
> +	ret = list_empty(&sdp->sfds);
> +	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
>  	return ret;

Protecting just a list_empty check with a local will give you racy
results.  Seems like you should take the look over the check and the
resulting action that modifies the list.  That'd also mean replacing the
wait_event* calls with open coded prepare_wait / finish_wait loops.

> +	down(&sdp->or_sem);
> +	alone = sfds_list_empty(sdp);
> +	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
> +		retval = -EPERM; /* Don't allow O_EXCL with read only access */
> +		goto error_out;
> +	}

Seems like the pure flags check should move to the beginning of the
function before taking any locks.

