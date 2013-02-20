Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935371Ab3BTMcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:32:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37798 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935035Ab3BTMc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:32:29 -0500
Date: Wed, 20 Feb 2013 15:31:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] staging: android: ashmem: get_name,set_name not to
 hold ashmem_mutex
Message-ID: <20130220123159.GD9138@mwanda>
References: <1361363039-11984-1-git-send-email-shankoo77@gmail.com>
 <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 05:53:59PM +0530, Shankar Brahadeeswaran wrote:
>  static int set_name(struct ashmem_area *asma, void __user *name)
>  {
>  	int ret = 0;
> -
> -	mutex_lock(&ashmem_mutex);
> +	char local_name[ASHMEM_NAME_LEN];
>  
>  	/* cannot change an existing mapping's name */
>  	if (unlikely(asma->file)) {
> @@ -423,9 +422,22 @@ static int set_name(struct ashmem_area *asma, void __user *name)
>  		goto out;

You're not holding the lock here so you can return directly.
Otherwise it's a double unlock.

>  	}
>  
> -	if (unlikely(copy_from_user(asma->name + ASHMEM_NAME_PREFIX_LEN,
> -				    name, ASHMEM_NAME_LEN)))
> +	/*
> +	 * Holding the ashmem_mutex while doing a copy_from_user might cause
> +	 * an data abourt which would try to access mmap_sem. If another
> +	 * thread has invoked ashmem_mmap then it will be holding the
> +	 * semaphore and will be waiting for ashmem_mutex, there by leading to
> +	 * deadlock. We'll release the mutex  and take the name to a local
> +	 * variable that does not need protection and later copy the local
> +	 * variable to the structure member with lock held.
> +	 */
> +	if (unlikely(copy_from_user(local_name, name, ASHMEM_NAME_LEN))) {
>  		ret = -EFAULT;
> +		return ret;

		return -EFAULT;

These weren't there in the original, only when you redid it at my
request.  :/  Sorry for that.

regards,
dan carpenter

