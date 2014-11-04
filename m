Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaKDKCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:02:52 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:52577 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKDKCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:02:46 -0500
Message-ID: <1415095355.2064.9.camel@sipsolutions.net>
Subject: Re: [PATCH v1 02/11] backports: extend module_init() module_exit()
 for built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 04 Nov 2014 11:02:35 +0100
In-Reply-To: <1415090582-14129-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20141104_094850_244065_E63B2A7F)
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415090582-14129-3-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141104_094850_244065_E63B2A7F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 00:42 -0800, Luis R. Rodriguez wrote:

> +#ifndef MODULE
> +/*
> + * Forcing the backports module to load allows us to easily
> + * identify the backport.
> + */

That comment is wrong really, making the dependency on the symbol forced
the backport module to load but if it's built-in that makes no sense.

> +#undef module_init
> +#define module_init(fn)							\
> +	static int __init __init_backport_##fn(void)			\
> +	{								\
> +		backport_dependency_symbol();				\

That won't do anything at all after all.

> +		return fn();						\
> +	}								\
> +	__initcall(__init_backport_##fn);
> +
> +#undef module_exit
> +#define module_exit(fn)							\
> +	static void __exit __exit_backport_##fn(void)			\
> +	{								\
> +		fn();							\
> +		rcu_barrier();						\
> +	}								\
> +	__exitcall(__exit_backport_##fn);

This is also pointless if it's built-in.

I don't think this patch makes sense, you just want to add the "#ifdef
MODULE" I guess.

johannes


