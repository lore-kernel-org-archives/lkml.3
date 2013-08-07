Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab3HGU2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:28:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3HGU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:28:14 -0400
Date: Wed, 7 Aug 2013 13:28:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
        gorcunov@openvz.org, xemul@parallels.com, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 2/2] [PATCH] mm: Save soft-dirty bits on file pages
Message-Id: <20130807132812.60ad4bfe85127794094d385e@linux-foundation.org>
In-Reply-To: <20130730204654.966378702@gmail.com>
References: <20130730204154.407090410@gmail.com>
	<20130730204654.966378702@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013 00:41:56 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> +#define pte_to_pgoff(pte)						\
> +	((((pte).pte_low >> (PTE_FILE_SHIFT1))				\
> +	  & ((1U << PTE_FILE_BITS1) - 1)))				\
> +	+ ((((pte).pte_low >> (PTE_FILE_SHIFT2))			\
> +	    & ((1U << PTE_FILE_BITS2) - 1))				\
> +	   << (PTE_FILE_BITS1))						\
> +	+ ((((pte).pte_low >> (PTE_FILE_SHIFT3))			\
> +	    & ((1U << PTE_FILE_BITS3) - 1))				\
> +	   << (PTE_FILE_BITS1 + PTE_FILE_BITS2))			\
> +	+ ((((pte).pte_low >> (PTE_FILE_SHIFT4)))			\
> +	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3))
> +
> +#define pgoff_to_pte(off)						\
> +	((pte_t) { .pte_low =						\
> +	 ((((off)) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
> +	 + ((((off) >> PTE_FILE_BITS1)					\
> +	     & ((1U << PTE_FILE_BITS2) - 1))				\
> +	    << PTE_FILE_SHIFT2)						\
> +	 + ((((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
> +	     & ((1U << PTE_FILE_BITS3) - 1))				\
> +	    << PTE_FILE_SHIFT3)						\
> +	 + ((((off) >>							\
> +	      (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)))	\
> +	    << PTE_FILE_SHIFT4)						\
> +	 + _PAGE_FILE })

Good god.

I wonder if these can be turned into out-of-line functions in some form
which humans can understand.

or

#define pte_to_pgoff(pte)
	frob(pte, PTE_FILE_SHIFT1, PTE_FILE_BITS1) +
	frob(PTE_FILE_SHIFT2, PTE_FILE_BITS2) +
	frob(PTE_FILE_SHIFT3, PTE_FILE_BITS3) +
	frob(PTE_FILE_SHIFT4, PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)


