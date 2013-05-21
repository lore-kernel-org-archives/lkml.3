Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3EUBHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 21:07:50 -0400
Received: from mail-gg0-f170.google.com ([209.85.161.170]:52160 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3EUBHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 21:07:49 -0400
Message-ID: <519AC7B3.5060902@gmail.com>
Date: Mon, 20 May 2013 21:02:43 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, shli@kernel.org,
        kzak@redhat.com, jmoyer@redhat.com, riel@redhat.com,
        lwoodman@redhat.com, mgorman@suse.de, kosaki.motohiro@gmail.com
Subject: Re: [RFC PATCH 02/02] swapon: add "cluster-discard" support
References: <cover.1369092449.git.aquini@redhat.com> <398ace0dd3ca1283372b3aad3fceeee59f6897d7.1369084886.git.aquini@redhat.com>
In-Reply-To: <398ace0dd3ca1283372b3aad3fceeee59f6897d7.1369084886.git.aquini@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +.B "\-c, \-\-cluster\-discard"
> +Swapping will discard clusters of swap pages in between freeing them
> +and re-writing to them, if the swap device supports that. This option
> +also implies the
> +.I \-d, \-\-discard
> +swapon flag.

I'm not sure this is good idea. Why can't we make these flags orthogonal?


>  /* If true, don't complain if the device/file doesn't exist */
>  static int ifexists;
> @@ -570,8 +574,11 @@ static int do_swapon(const char *orig_special, int prio,
>  			   << SWAP_FLAG_PRIO_SHIFT);
>  	}
>  #endif
> -	if (fl_discard)
> +	if (fl_discard) {
>  		flags |= SWAP_FLAG_DISCARD;
> +		if (fl_discard > 1)
> +			flags |= SWAP_FLAG_DISCARD_CLUSTER;

This is not enough, IMHO. When running this code on old kernel, swapon() return EINVAL.
At that time, we should fall back swapon(0x10000).

