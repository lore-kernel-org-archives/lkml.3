Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbbAUE3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:29:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59149 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAUE3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:29:06 -0500
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Rob Herring <robh@kernel.org>,
        "open list\:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] powerpc/powernv: Skip registering log region when CONFIG_PRINTK=n
In-Reply-To: <1421797911-23650-2-git-send-email-bobby.prani@gmail.com>
References: <1421797911-23650-1-git-send-email-bobby.prani@gmail.com> <1421797911-23650-2-git-send-email-bobby.prani@gmail.com>
User-Agent: Notmuch/0.18+16~gec02089 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-redhat-linux-gnu)
Date: Wed, 21 Jan 2015 15:28:52 +1100
Message-ID: <m3sif4u58b.fsf@oc8180480414.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012104-0009-0000-0000-0000082420AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar <bobby.prani@gmail.com> writes:
> When CONFIG_PRINTK=n, log_buf_addr_get() returns NULL and log_buf_len_get()
> return 0. Check for these return values and skip registering the dump buffer.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Michael Ellerman <mpe@ellerman.id.au>

(investigating what would occur on systems with current firmware..)

Looking at hw/fsp/fsp-mdst-table.c in skiboot it appears that we'd end
up logging an error log about being passed the size 0 and return
OPAL_PARAMETER back to Linux.

While harmless, this is, naturally, not awesome to log an error about
being unable to grab kernel log on crash every time you boot.

Reviewed-by: Stewart Smith <stewart@linux.vnet.ibm.com>

> ---
>  arch/powerpc/platforms/powernv/opal.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
> index f10b9ec..1db119f0 100644
> --- a/arch/powerpc/platforms/powernv/opal.c
> +++ b/arch/powerpc/platforms/powernv/opal.c
> @@ -667,7 +667,13 @@ static void __init opal_dump_region_init(void)
>  
>  	/* Register kernel log buffer */
>  	addr = log_buf_addr_get();
> +	if (addr == NULL)
> +		return;
> +
>  	size = log_buf_len_get();
> +	if (size == 0)
> +		return;
> +
>  	rc = opal_register_dump_region(OPAL_DUMP_REGION_LOG_BUF,
>  				       __pa(addr), size);
>  	/* Don't warn if this is just an older OPAL that doesn't
> -- 
> 1.9.1
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

