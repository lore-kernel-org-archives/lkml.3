Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3EGH3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:29:43 -0400
Received: from cyclops.biessmann.org ([134.0.25.77]:57896 "EHLO
	cyclops.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3EGH3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:29:41 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 03:29:41 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 May 2013 09:18:51 +0200
From: =?UTF-8?Q?Andreas_Bie=C3=9Fmann?= <andreas@biessmann.de>
To: =?UTF-8?Q?Andreas_Bie=C3=9Fmann?= <andreas@biessmann.de>
Cc: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, Ben Hutchings <ben@decadent.org.uk>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] =?UTF-8?Q?register=5Fconsole=3A=20prevent=20adding?=
 =?UTF-8?Q?=20the=20same=20console=20twice?=
In-Reply-To: <1364201964-2990-1-git-send-email-andreas@biessmann.de>
References: <1364201964-2990-1-git-send-email-andreas@biessmann.de>
Message-ID: <4776724114a6170424db01471c422892@biessmann.de>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

Am 2013-03-25 09:59, schrieb Andreas Bießmann:
> This patch guards the console_drivers list to be corrupted. The
> for_each_console() macro insist on a strictly forward list ended by 
> NULL:
> 
>  con0->next->con1->next->NULL
> 
> Without this patch it may happen easily to destroy this list for 
> example by
> adding 'earlyprintk' twice, especially on embedded devices where the 
> early
> console is often a single static instance.  This will result in the 
> following
> list:
> 
>  con0->next->con0
> 
> This in turn will result in an endless loop in console_unlock() later 
> on by
> printing the first __log_buf line endlessly.
> 
> Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@kernel.org
> ---
> since v1:
>  * use WARN() as Ben suggested
>  * print 'already registered' instead of 'prevent registering'
> 
>  kernel/printk.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index abbdd9e..180ee25 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -2214,6 +2214,13 @@ void register_console(struct console *newcon)
>  	unsigned long flags;
>  	struct console *bcon = NULL;
> 
> +	if (console_drivers)
> +		for_each_console(bcon)
> +			if (WARN(bcon == newcon,
> +					"console '%s%d' already registered\n",
> +					bcon->name, bcon->index))
> +				return;
> +
>  	/*
>  	 * before we register a new CON_BOOT console, make sure we don't
>  	 * already have a valid console
