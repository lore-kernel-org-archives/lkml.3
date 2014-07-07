Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaGGRAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:00:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56784 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaGGRAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:00:18 -0400
Subject: Re: [PATCH -v3 3/4] MCE, CE: Wire in the CE collector
From: Max Asbock <masbock@linux.vnet.ibm.com>
Reply-To: masbock@linux.vnet.ibm.com
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1404242623-10094-4-git-send-email-bp@alien8.de>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
	 <1404242623-10094-4-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jul 2014 10:00:11 -0700
Message-ID: <1404752411.4484.25.camel@oc3432500282.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070717-9332-0000-0000-0000014C9421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 21:23 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Add the CE collector to the polling path which collects the correctable
> errors. Collect only DRAM ECC errors for now.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 84 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 76 insertions(+), 8 deletions(-)
> 

> +
> +static void __log_ce(struct mce *m, enum mcp_flags flags)
> +{
> +	/*
> +	 * Don't get the IP here because it's unlikely to have anything to do
> +	 * with the actual error location.
> +	 */

The above comment doesn't belong here. This function is about how to
dispose of corrected errors, not what data should be collected.
(Besides this comment is obsolete as the IP is always collected in
mce_gather_info()).

> +	if ((flags & MCP_DONTLOG) || mca_cfg.dont_log_ce)
> +		return;
> +

> +	if (dram_ce_error(m)) {
> +		/*
> +		 * In the cases where we don't have a valid address after all,
> +		 * do not collect but log.
> +		 */
> +		if (!(m->status & MCI_STATUS_ADDRV))
> +			goto log;
> +
> +		mce_ring_add(&__get_cpu_var(ce_ring), m->addr >> PAGE_SHIFT);
> +		return;
> +	}
> +
> +log:
> +		mce_log(m);
> +}
The above code is a bit convoluted, it amounts to:

if (we have a corrected dram error && we have an address for it)
	mce_ring_add()
else
	mcelog()

Is that the intention? This might be problematic for downstream
consumers of the errors such as the EDAC drivers which keep counts of
errors. If errors are silently removed from the stream these counts will
be bogus. Somebody might wonder why a page was off-lined while the EDAC
driver reports zero corrected DRAM error counts.

- Max


