Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab3E3IdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:33:24 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40220 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967903Ab3E3IdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:33:19 -0400
Date: Thu, 30 May 2013 10:33:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: a.p.zijlstra@chello.nl, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3][PATCH 2/4] x86: warn when NMI handlers take large amounts
 of time
Message-ID: <20130530083315.GA14913@gmail.com>
References: <20130529222756.25535229@viggo.jf.intel.com>
 <20130529222759.6D8C68B2@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529222759.6D8C68B2@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> @@ -96,8 +106,24 @@ static int __kprobes nmi_handle(unsigned
>  	 * can be latched at any given time.  Walk the whole list
>  	 * to handle those situations.
>  	 */
> -	list_for_each_entry_rcu(a, &desc->head, list)
> +	list_for_each_entry_rcu(a, &desc->head, list) {
> +		u64 before, delta, whole_msecs;
> +		int decimal_msecs;
> +
> +		before = local_clock();
>  		handled += a->handler(type, regs);
> +		delta = local_clock() - before;
> +
> +		if (delta < nmi_longest_ns)
> +			continue;
> +
> +		nmi_longest_ns = delta;
> +		whole_msecs = delta / (1000 * 1000);
> +		decimal_msecs = (delta / 1000) % 1000;
> +		printk_ratelimited(KERN_INFO
> +			"INFO: NMI handler took too long to run: "
> +			"%lld.%03d msecs\n", whole_msecs, decimal_msecs);
> +	}

One more thing, would it make sense to print the symbol name of the 
->handler here? That way the message would be more actionable:

	INFO: NMI handler (nmi_handler_foo) took too long to run: 12.613 msecs

(Note, printk() has a '%ps' format string extension to print function 
pointer symbolic names, so it's easy to add.)

Thanks,

	Ingo
