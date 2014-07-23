Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaGWMdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:33:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40154 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbaGWMdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:33:20 -0400
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/2] powerpc/powernv: Interface to add opal dump region
In-Reply-To: <20140723092525.5170.25926.stgit@hegdevasant.in.ibm.com>
References: <20140723092506.5170.34633.stgit@hegdevasant.in.ibm.com> <20140723092525.5170.25926.stgit@hegdevasant.in.ibm.com>
User-Agent: Notmuch/0.18+16~gec02089 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-redhat-linux-gnu)
Date: Wed, 23 Jul 2014 22:33:05 +1000
Message-ID: <m3a980i7b2.fsf@oc8180480414.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-0320-0000-0000-0000000F3F3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasant Hegde <hegdevasant@linux.vnet.ibm.com> writes:
> PowerNV platform is capable of capturing host memory region when system
> crashes (because of host/firmware). We have new OPAL API to register
> memory region to be capture when system crashes.
>
> This patch adds support for new API and also registers kernel log
> buffer.

I think we do need a way to un-register regions, and I think this may be
important around kexec - unless the log buffer is in exactly the same
place, there's a window where we could dump some random memory contents
as kernel log buffer, probably causing some poor support person to
scratch their head for a good long while.

> +void __init opal_dump_region_init(void)
> +{
> +	void *addr;
> +	uint64_t size;
> +	int rc;
> +
> +	/* Register kernel log buffer */
> +	addr = get_log_buf_addr();
> +	size = get_log_buf_len();
> +	rc = add_dump_region_entry(DUMP_REGION_LOG_BUF, addr, size);
> +	if (rc)
> +		pr_warn("DUMP: Failed to register kernel log buffer. "
> +			"rc = %d\n", rc);

This is what's going to be printed in kernel log when running on OPAL
firmware that doesn't support that call. Does this include the first GA
release on POWER8 systems? If so, we probably want a nicer log message
pointing to the fact that firmware is too old to support that function.

