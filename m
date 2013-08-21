Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3HUUit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:38:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37890 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3HUUis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:38:48 -0400
Message-ID: <5215254B.7000000@infradead.org>
Date: Wed, 21 Aug 2013 13:38:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: add sysfs_create/remove_groups()
References: <20130821203506.GA1663@kroah.com>
In-Reply-To: <20130821203506.GA1663@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/13 13:35, Greg Kroah-Hartman wrote:
> 
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -131,6 +131,39 @@ int sysfs_create_group(struct kobject *k
>  }
>  
>  /**
> + * sysfs_create_groups - given a directory kobject, create a bunch of attribute groups
> + * @kobj:	The kobject to create the group on
> + * @groups:	The attribute groups to create, NULL terminated
> + *
> + * This function creates a bunch of attribute groups.  If an error occurs when
> + * creating a group, all previously created groups will be removed, unwinding
> + * everything back to the original state when this function was called.
> + * It will explicitly warn and error if any of the attribute files being
> + * created already exist.
> + *
> + * Returns 0 on success or error.

ambiguous.  How about:
      Returns 0 on success or error code on error.

> + */
> +int sysfs_create_groups(struct kobject *kobj,
> +			const struct attribute_group **groups)
> +{
> +	int error = 0;
> +	int i;
> +
> +	if (!groups)
> +		return 0;
> +
> +	for (i = 0; groups[i]; i++) {
> +		error = sysfs_create_group(kobj, groups[i]);
> +		if (error) {
> +			while (--i >= 0)
> +				sysfs_remove_group(kobj, groups[i]);
> +			break;
> +		}
> +	}
> +	return error;
> +}


-- 
~Randy
