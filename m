Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3C0V2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:28:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3C0V2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:28:34 -0400
Date: Wed, 27 Mar 2013 14:28:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: Re: [PATCH v6 1/2] mm: limit growth of 3% hardcoded other user
 reserve
Message-Id: <20130327142832.8505be7276064bf4b1daab5c@linux-foundation.org>
In-Reply-To: <20130318214442.GA1441@localhost.localdomain>
References: <20130318214442.GA1441@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013 17:44:42 -0400 Andrew Shewmaker <agshew@gmail.com> wrote:

> Add user_reserve_kbytes knob.
> 
> Limit the growth of the memory reserved for other user
> processes to min(3% current process size, user_reserve_pages).
> 
> user_reserve_pages defaults to min(3% free pages, 128MB)

That was an epic changelog ;)

>
> ...
>
> +int __meminit init_user_reserve(void)
> +{
> +	unsigned long free_kbytes;
> +
> +	free_kbytes = global_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
> +
> +	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
> +	return 0;
> +}
> +module_init(init_user_reserve)

Problem is, the initial default values will become wrong if memory if
hot-added or hot-removed.

That could be fixed up by appropriate use of
register_memory_notifier(), but what would the notification handler do
if the operator has modified the value?  Proportionally scale it?
