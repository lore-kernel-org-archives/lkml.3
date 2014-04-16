Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161306AbaDPV60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:58:26 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:53554 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbaDPV6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:58:25 -0400
Date: Wed, 16 Apr 2014 17:58:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [RFC PATCH 2/2] drivers/base: add managed token devres interfaces
Message-ID: <20140416215821.GG26632@htj.dyndns.org>
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 09, 2014 at 09:21:08AM -0600, Shuah Khan wrote:
> +#define TOKEN_DEVRES_FREE	0
> +#define TOKEN_DEVRES_BUSY	1
> +
> +struct token_devres {
> +	int	status;
> +	char	id[];
> +};

Please just do "bool busy" and drop the constants.

> +struct tkn_match {
> +	int	status;
> +	const	char *id;
> +};
> +
> +static void __devm_token_lock(struct device *dev, void *data)
> +{
> +	struct token_devres *tptr = data;
> +
> +	if (tptr && tptr->status == TOKEN_DEVRES_FREE)
> +		tptr->status = TOKEN_DEVRES_BUSY;

How can this function be called with NULL @tptr and what why would you
need to check tptr->status before assigning to it if the value is
binary anyway?  And how is this supposed to work as locking if the
outcome doesn't change depending on the current value?

> +
> +	return;

No need to return from void function.

> +static int devm_token_match(struct device *dev, void *res, void *data)
> +{
> +	struct token_devres *tkn = res;
> +	struct tkn_match *mptr = data;
> +	int rc;
> +
> +	if (!tkn || !data) {
> +		WARN_ON(!tkn || !data);
> +		return 0;
> +	}

How would the above be possible?

> +
> +	/* compare the token data and return 1 if it matches */
> +	if (strcmp(tkn->id, mptr->id) == 0)
> +			rc = 1;
> +	else
> +		rc = 0;
> +
> +	return rc;

	return !strcmp(tkn->id, mptr->id);

> +/* If token is available, lock it for the caller, If not return -EBUSY */
> +int devm_token_lock(struct device *dev, const char *id)
> +{
> +	struct token_devres *tkn_ptr;
> +	struct tkn_match tkn;
> +	int rc = 0;
> +
> +	if (!id)
> +		return -EFAULT;

The function isn't supposed to be called with NULL @id, right?  I
don't really think it'd be necessary to do the above.

> +
> +	tkn.id = id;
> +
> +	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match, &tkn);
> +	if (tkn_ptr == NULL)
> +		return -ENODEV;

What guarantees that the lock is not taken by someone else inbetween?

> +
> +	if (tkn_ptr->status == TOKEN_DEVRES_FREE) {
> +		devres_update(dev, devm_token_release, devm_token_match,
> +				&tkn, __devm_token_lock);
> +		rc = 0;
> +	} else
> +		rc = -EBUSY;
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(devm_token_lock);
> +
> +/* If token is locked, unlock */
> +int devm_token_unlock(struct device *dev, const char *id)
> +{
> +	struct token_devres *tkn_ptr;
> +	struct tkn_match tkn;
> +
> +	if (!id)
> +		return -EFAULT;
> +
> +	tkn.id = id;
> +
> +	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match, &tkn);
> +	if (tkn_ptr == NULL)
> +		return -ENODEV;
> +
> +	if (tkn_ptr->status == TOKEN_DEVRES_BUSY) {
> +		devres_update(dev, devm_token_release, devm_token_match,
> +				&tkn, __devm_token_unlock);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_token_unlock);

Why is devres_update() even necessary?  You can just embed lock in the
data part and operate on it, no?

This is among the most poorly written code that I've seen in a long
time.  I don't know whether the token thing is the right appraoch or
not but just purely on code quality,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
