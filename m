Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3BFI1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:27:07 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:44922 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3BFI1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:27:05 -0500
Date: Wed, 6 Feb 2013 00:27:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shuah Khan <shuah.khan@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH linux-next] x86/mm: Fix compile warning in
 remove_pagetable()
In-Reply-To: <1360119136.8356.4.camel@lorien2>
Message-ID: <alpine.DEB.2.02.1302060017410.6630@chino.kir.corp.google.com>
References: <1360119136.8356.4.camel@lorien2>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Shuah Khan wrote:

> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 67bad4b..ed78400 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -987,7 +987,7 @@ remove_pud_table(pud_t *pud_start, unsigned long addr, unsigned long end,
>  static void __meminit
>  remove_pagetable(unsigned long start, unsigned long end, bool direct)
>  {
> -	unsigned long next;
> +	unsigned long next = pgd_addr_end(start, end);
>  	pgd_t *pgd;
>  	pud_t *pud;
>  	bool pgd_changed = false;

This isn't enough, there's a potential for an infinite loop if 
!pgd_present() is ever true in the iteration since "next" remains 
constant.  Theoretical, maybe.

I think it's better to just set next before checking for !pgd_present() in 
the iteration so it's clear what's happening.  Or, even better, change 
this into the standard do-while loop that everything else uses.
