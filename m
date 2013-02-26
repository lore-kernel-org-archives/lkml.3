Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3BZWIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:08:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56840 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3BZWIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:08:48 -0500
Date: Tue, 26 Feb 2013 09:24:41 -0800
From: Matt Helsley <matthltc@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        netdev@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] proc connector: reject unprivileged listener bumps
Message-ID: <20130226172441.GA6312@us.ibm.com>
References: <20130226073225.GA15489@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226073225.GA15489@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022622-9360-0000-0000-000011136C60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:32:25PM -0800, Kees Cook wrote:
> While PROC_CN_MCAST_LISTEN/IGNORE is entirely advisory, it was possible
> for an unprivileged user to turn off notifications for all listeners by
> sending PROC_CN_MCAST_IGNORE. Instead, require the same privileges as
> required for a multicast bind.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/connector/cn_proc.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index fce2000..1110478 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -313,6 +313,12 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  	    (task_active_pid_ns(current) != &init_pid_ns))
>  		return;
> 
> +	/* Can only change if privileged. */

I think this comment doesn't tell us anything above and beyond the
what capability check already tells us. I think you could improve it
by noting that since the connector is multicast and not namespace-safe
it's not yet appropriate to use ns_capable() here.

Acked-by: Matt Helsley <matthltc@us.ibm.com>

> +	if (!capable(CAP_NET_ADMIN)) {
> +		err = EPERM;
> +		goto out;
> +	}

