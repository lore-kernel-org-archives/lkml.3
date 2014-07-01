Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbaGAW1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:27:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325AbaGAW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:27:18 -0400
Date: Tue, 1 Jul 2014 15:27:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] hwpoison: Fix race with changing page during offlining
 v2
Message-Id: <20140701152716.b9b4b04ee67cf987844b1aa4@linux-foundation.org>
In-Reply-To: <1404174736-17480-1-git-send-email-andi@firstfloor.org>
References: <1404174736-17480-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 17:32:16 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> When a hwpoison page is locked it could change state
> due to parallel modifications.  Check after the lock
> if the page is still the same compound page.
> 
> ...
>
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1168,6 +1168,16 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
>  	lock_page(hpage);
>  
>  	/*
> +	 * The page could have changed compound pages during the locking.
> +	 * If this happens just bail out.
> +	 */
> +	if (compound_head(p) != hpage) {

How can a 4k page change compound pages?  The original compound page
was torn down and then this 4k page became part of a differently-sized
compound page?

> +		action_result(pfn, "different compound page after locking", IGNORED);
> +		res = -EBUSY;
> +		goto out;
> +	}
> +
> +	/*

I don't get it.  We just go and fail the poisoning attempt?  Shouldn't
we go back, grab the new hpage and try again?


