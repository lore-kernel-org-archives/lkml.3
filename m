Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBGVnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:43:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaBGVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:43:30 -0500
Date: Fri, 7 Feb 2014 13:43:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH] mm/memory-failure.c: move refcount only in
 !MF_COUNT_INCREASED
Message-Id: <20140207134329.a305b169351a2538ab03785f@linux-foundation.org>
In-Reply-To: <52f54d29.89cfe00a.4277.4d3dSMTPIN_ADDED_BROKEN@mx.google.com>
References: <52f54d29.89cfe00a.4277.4d3dSMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Feb 2014 16:16:04 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> # Resending due to sending failure. Sorry if you received twice.
> ---
> mce-test detected a test failure when injecting error to a thp tail page.
> This is because we take page refcount of the tail page in madvise_hwpoison()
> while the fix in commit a3e0f9e47d5e ("mm/memory-failure.c: transfer page
> count from head page to tail page after split thp") assumes that we always
> take refcount on the head page.
> 
> When a real memory error happens we take refcount on the head page where
> memory_failure() is called without MF_COUNT_INCREASED set, so it seems to me
> that testing memory error on thp tail page using madvise makes little sense.
> 
> This patch cancels moving refcount in !MF_COUNT_INCREASED for valid testing.
> 
> ...
>
> --- v3.14-rc1.orig/mm/memory-failure.c
> +++ v3.14-rc1/mm/memory-failure.c
> @@ -1042,8 +1042,10 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
>  			 * to it. Similarly, page lock is shifted.
>  			 */
>  			if (hpage != p) {
> -				put_page(hpage);
> -				get_page(p);
> +				if (!(flags && MF_COUNT_INCREASED)) {

s/&&/&/

Please carefully retest this, make sure that both cases are covered?

> +					put_page(hpage);
> +					get_page(p);
> +				}
>  				lock_page(p);
>  				unlock_page(hpage);
>  				*hpagep = p;


