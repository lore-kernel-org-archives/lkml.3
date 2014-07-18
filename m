Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbaGRIfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:35:33 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:57755 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGRIf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:35:27 -0400
Date: Fri, 18 Jul 2014 10:35:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sparc: Add support for seek and shorter read to
 /dev/mdesc
Message-ID: <20140718083522.GA20146@ravnborg.org>
References: <1405618910-17667-1-git-send-email-khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405618910-17667-1-git-send-email-khalid.aziz@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Khalid.

Looks better now - thanks.

A few nits remaining.
Please fix and submit a v3 - then we will see if David approves.

	Sam

> +/* mdesc_open() - Grab a reference to mdesc_handle when /dev/mdesc is
> + *	opened. Hold this reference until /dev/mdesc is closed to ensure
> + *	mdesc data structure is not released underneath us. Store the
> + *	pointer to mdesc structure in private_data for read and seek to use
Please use one space between "*" and "text" - not a tab.
This is how it is done in the rest of the sparc code.



> + */
> +static int mdesc_open(struct inode *inode, struct file *file)
>  {
>  	struct mdesc_handle *hp = mdesc_grab();
> -	int err;
>  
>  	if (!hp)
>  		return -ENODEV;
>  
> -	err = hp->handle_size;
> -	if (len < hp->handle_size)
> -		err = -EMSGSIZE;
> -	else if (copy_to_user(buf, &hp->mdesc, hp->handle_size))
> -		err = -EFAULT;
> -	mdesc_release(hp);
> +	file->private_data = hp;
> +	return 0;
> +}

Personally I would add an empty line before the return.
But this is not something mandatory.

> +static loff_t mdesc_llseek(struct file *file, loff_t offset, int whence)
> +{
> +	struct mdesc_handle *hp;
> +
> +	switch (whence) {
> +	case SEEK_CUR:
> +		offset += file->f_pos;
> +		break;
> +	case SEEK_SET:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	hp = file->private_data;
> +	if (offset > hp->handle_size)
> +		return -EINVAL;
> +	else
> +		file->f_pos = offset;
> +	return offset;
> +}
Likewise regarning empty line.

> +
> +/* mdesc_close() - /dev/mdesc is being closed, release the reference to
> + *	mdesc structure.
> + */
Tab => space


	Sam
