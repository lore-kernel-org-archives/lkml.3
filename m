Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3HMUbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:31:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64295 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758995Ab3HMUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:31:46 -0400
X-IronPort-AV: E=Sophos;i="4.89,872,1367971200"; 
   d="scan'208";a="43938683"
Message-ID: <1376425904.9273.25.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it
 also work on HVM guests.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Date: Tue, 13 Aug 2013 21:31:44 +0100
In-Reply-To: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 10:55 -0400, Konrad Rzeszutek Wilk wrote:
> The xen_raw_printk works great for debugging purposes and for
> it print anything the Xen hypervisor has to be built with 'debug=y'.
> 
> As such there is no difference between a PV or an PVHVM guest
> using the hypercall, so lets use it.
>
> Lastly if the hyper-page is not setup yet (for example during
> early HVM boot), then use the 0xe9 port if it has detected
> that it is running under an Xen hypervisor.

Does this really do what you say?

I think xen_pv_domain returns false for a PVHVM guest, meaning that we
only use the hypercall for proper PV guests and for PVHVM we use port
0xe9 until the hypercall page is setup at which point we silently
discard any attempt to print via this mechanism.

or am I reading it wrong?

> 
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/tty/hvc/hvc_xen.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index 682210d..69454a0 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -641,7 +641,17 @@ struct console xenboot_console = {
>  
>  void xen_raw_console_write(const char *str)
>  {
> -	dom0_write_console(0, str, strlen(str));
> +	if (!xen_domain())
> +		return;
> +
> +	if (xen_pv_domain())
> +		dom0_write_console(0, str, strlen(str));
> +	else if (xen_hvm_domain() || xen_cpuid_base()) {
> +		/* The hyperpage has not been setup yet. */
> +		int i, len = strlen(str);
> +		for (i = 0; i < len; i++)
> +			 outb(str[i], 0xe9);
> +	}
>  }
>  
>  void xen_raw_printk(const char *fmt, ...)


