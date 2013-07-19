Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3GSW4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 18:56:12 -0400
Received: from longford.logfs.org ([213.229.74.203]:59830 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3GSW4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 18:56:10 -0400
Date: Fri, 19 Jul 2013 17:24:32 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] [SCSI] sg: checking sdp->detached isn't
 protected when open
Message-ID: <20130719212432.GC29404@logfs.org>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374075246-22923-4-git-send-email-vaughan.cao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374075246-22923-4-git-send-email-vaughan.cao@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 July 2013 23:34:05 +0800, Vaughan Cao wrote:
>
> -static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
> +static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev, int * reason);

You can use ERR_PTR and friends instead of adding another parameter.

>  static void sg_remove_sfp(struct kref *);
>  static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
>  static Sg_request *sg_add_request(Sg_fd * sfp);
> @@ -295,21 +295,14 @@ sg_open(struct inode *inode, struct file *filp)
>  	if (flags & O_EXCL)
>  		sdp->exclude = 1;	/* used by release lock */
>  
> -	if (sdp->detached) {
> -		retval = -ENODEV;
> -		goto sem_out;
> -	}
>  	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
>  		sdp->sgdebug = 0;
>  		q = sdp->device->request_queue;
>  		sdp->sg_tablesize = queue_max_segments(q);
>  	}
> -	if ((sfp = sg_add_sfp(sdp, dev)))
> -		filp->private_data = sfp;
> -	else {
> -		retval = -ENOMEM;
> +	if (!(sfp = sg_add_sfp(sdp, dev, &retval)))
>  		goto sem_out;
> -	}

	sfp = sg_add_sfp(sdp, dev);
	if (IS_ERR(sfp)) {
		retval = PTR_ERR(sfp);
		goto sem_out;
	}

> +	filp->private_data = sfp;
>  	retval = 0;
>  
>  	if (retval) {
> @@ -2047,15 +2040,18 @@ sg_remove_request(Sg_fd * sfp, Sg_request * srp)
>  }
>  
>  static Sg_fd *
> -sg_add_sfp(Sg_device * sdp, int dev)
> +sg_add_sfp(Sg_device * sdp, int dev, int * reason)
>  {
>  	Sg_fd *sfp;
>  	unsigned long iflags;
>  	int bufflen;
>  
>  	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
> -	if (!sfp)
> +	if (!sfp) {
> +		if (reason)
> +			*reason = -ENOMEM;
>  		return NULL;
> +	}

	if (!sfp)
		return ERR_PTR(-ENOMEM);

Jörn

--
Luck is when opportunity meets good preparation.
-- Chinese proverb
