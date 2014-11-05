Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaKEPvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:51:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:7907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbaKEPvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:51:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484755696"
Message-ID: <1415202707.958.129.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 07/35] UBI: Fastmap: Fix races in ubi_wl_get_peb()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Wed, 05 Nov 2014 17:51:47 +0200
In-Reply-To: <1414586758-9972-8-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
	 <1414586758-9972-8-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
> ubi_wl_get_peb() has two problems, it reads the pool
> size and usage counters without any protection.
> While reading one value would be perfectly fine it reads multiple
> values and compares them. This is racy and can lead to incorrect
> pool handling.
> Furthermore ubi_update_fastmap() is called without wl_lock held,
> before incrementing the used counter it needs to be checked again.
> It could happen that another thread consumed all PEBs from the
> pool and the counter goes beyond ->size.

So wl_lock protects the 'pool->*' variables? Could you please add this
information to ubi.h. Namely, in the huge comment above 'struct device'
we document each lock, and we list the variables the lock protects.

> -	if (!pool->size || !wl_pool->size || pool->used == pool->size ||
> -	    wl_pool->used == wl_pool->size)
> +again:
> +	spin_lock(&ubi->wl_lock);

Is it possible to add a little comment here which translates the
condition below into English?

> +	if (!pool->size || !wl_pool->size || pool->used >= pool->size ||
> +	    wl_pool->used >= wl_pool->size) {
> +		spin_unlock(&ubi->wl_lock);
>  		ubi_update_fastmap(ubi);
> -


