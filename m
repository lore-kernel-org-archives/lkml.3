Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358Ab3BTOtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:49:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18080 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462Ab3BTOtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:49:15 -0500
Date: Wed, 20 Feb 2013 17:48:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH V2 1/1] staging: android: ashmem: get_name,set_name not
 to hold ashmem_mutex
Message-ID: <20130220144853.GE9189@mwanda>
References: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
 <1361370428-30632-1-git-send-email-shankoo77@gmail.com>
 <1361370428-30632-2-git-send-email-shankoo77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361370428-30632-2-git-send-email-shankoo77@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 07:57:08PM +0530, Shankar Brahadeeswaran wrote:
> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -413,50 +413,66 @@ out:
>  
>  static int set_name(struct ashmem_area *asma, void __user *name)
>  {
> -	int ret = 0;
> -
> -	mutex_lock(&ashmem_mutex);
> +	char local_name[ASHMEM_NAME_LEN];
>  
>  	/* cannot change an existing mapping's name */
> -	if (unlikely(asma->file)) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	if (unlikely(asma->file))
> +		return -EINVAL;

Gar.  No.  Sorry I wasn't paying attention properly last time.  This
isn't right but I didn't explain things properly from the beginning.
When you drop a lock, obviously the first thing I'm going to look at
is if it introduces race conditions.  The problem is that checking
asma->file has to be done under lock and also we can't drop the lock
before we set the name.  Otherwise someone could set asma->file
while we were waiting for the copy to complete.

It should be something like this:

	char local_name[ASHMEM_NAME_LEN];
	int ret = 0;

	if (copy_from_user(local_name, name, ASHMEM_NAME_LEN))
		return -EFAULT;
	local_name[ASHMEM_FULL_NAME_LEN - 1] = '\0';

	mutex_lock(&ashmem_mutex);
	if (asma->file) {
		ret = -EINVAL;
		goto out;
	}
	memcpy(asma->name + ASHMEM_NAME_PREFIX_LEN, local_name,
	       ASHMEM_NAME_LEN);
out:
	mutex_unlock(&ashmem_mutex);

	return ret;

(I removed some calls to likely/unlikely() because putting those
around copy_from_user() is probably not going to speed anything up.)

Sorry, again for the miscommunication.

regards,
dan carpenter
