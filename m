Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3KTVJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:09:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49225 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3KTVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:09:50 -0500
Message-ID: <528D258C.1020102@oracle.com>
Date: Wed, 20 Nov 2013 16:11:40 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        david.vrabel@citrix.com
Subject: Re: [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is
 not yet up.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 12:38 PM, Konrad Rzeszutek Wilk wrote:
> The user can launch the guest in this sequence:
>
> xl create -p /vm.cfg	[launch, but pause it]
> xl shutdown latest	[sets control/shutdown=poweroff]
> xl unpause latest
> xl console latest	[and see that the guest has completely
> ignored the shutdown request]
>
> In reality the guest hasn't ignored it. It registers a watch
> and gets a notification that there is value. It then calls
> the shutdown_handler which ends up calling orderly_shutdown.
>
> Unfortunately that is so early in the bootup that there
> are no user-space. Which means that the orderly_shutdown fails.
> But since the force flag was set to false it continues on without
> reporting.
>
> We check if the system is still in the booting stage and if so
> enable the force option (which will shutdown in early bootup
> process). If in normal running case we don't force it.
>
> Fixes-Bug: http://bugs.xenproject.org/xen/bug/6
> Reported-by:  Alex Bligh <alex@alex.org.uk>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> [v2: Add switch statement]

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

> ---
>   drivers/xen/manage.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 624e8dc..3f8496c 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -185,7 +185,18 @@ struct shutdown_handler {
>   static void do_poweroff(void)
>   {
>   	shutting_down = SHUTDOWN_POWEROFF;
> -	orderly_poweroff(false);
> +	switch (system_state) {
> +	case SYSTEM_BOOTING:
> +		orderly_poweroff(true);
> +		break;
> +	case SYSTEM_RUNNING:
> +		orderly_poweroff(false);
> +		break;
> +	default:
> +		/* Don't do it when we are halting/rebooting. */
> +		pr_info("Ignoring Xen toolstack shutdown.\n");
> +		break;
> +	}
>   }
>   
>   static void do_reboot(void)

