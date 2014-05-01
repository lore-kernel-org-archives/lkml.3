Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaEAOxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:53:42 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:54048 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaEAOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:53:41 -0400
Date: Thu, 1 May 2014 10:53:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com, olebowle@gmx.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/base: add managed token devres interfaces
Message-ID: <20140501145337.GC31611@htj.dyndns.org>
References: <cover.1398797954.git.shuah.kh@samsung.com>
 <6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 29, 2014 at 01:49:23PM -0600, Shuah Khan wrote:
> +/* creates a token devres and marks it available */
> +int devm_token_create(struct device *dev, const char *id)
> +{
> +	struct token_devres *tkn;
> +	size_t tkn_size;
> +
> +	tkn_size = sizeof(struct token_devres) + strlen(id) + 1;
> +	tkn = devres_alloc(devm_token_release, tkn_size, GFP_KERNEL);
> +	if (!tkn)
> +		return -ENOMEM;

Is nesting devres inside devres really necessary?  I think it should
work but why do it this way?  Just kzalloc here and free from release.

> +
> +	strcpy(tkn->id, id);
> +	tkn->in_use = false;
> +	mutex_init(&tkn->lock);
> +
> +	devres_add(dev, tkn);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_token_create);
> +
> +/* If token is available, lock it for the caller, If not return -EBUSY */
> +int devm_token_lock(struct device *dev, const char *id)

trylock probably is a more apt name.

> +{
> +	struct token_devres *tkn_ptr;
> +	int rc = 0;
> +
> +	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match,
> +				(void *)id);
> +	if (tkn_ptr == NULL)
> +		return -ENODEV;
> +
> +	if (!mutex_trylock(&tkn_ptr->lock))
> +		return -EBUSY;

How is this lock supposed to be used?  Have you tested it with lockdep
enabled?  Does it ever get released by a task which is different from
the one which locked it?  If the lock ownership is really about driver
association rather than tasks, it might be necessary to nullify
lockdep protection and add your own annotation to at least track that
unlocking driver (identified how? maybe impossible?) actually owns the
lock.

> +	if (tkn_ptr->in_use)
> +		rc = -EBUSY;
> +	else
> +		tkn_ptr->in_use = true;

Wat?  Why would you have in_use protected by trylock?  What's the
reasonsing behind that?  What would you need "try"lock there?  Okay,
strick everything I wrote above.

 Nacked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
