Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaCFETS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:19:18 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:60899 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaCFETQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:19:16 -0500
Date: Thu, 6 Mar 2014 13:19:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 2/2] serial: sh-sci: Add missing call to
 uart_remove_one_port() in failure path
Message-ID: <20140306041912.GB29693@verge.net.au>
References: <1393593694-30262-1-git-send-email-geert@linux-m68k.org>
 <1393593694-30262-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393593694-30262-2-git-send-email-geert@linux-m68k.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 02:21:33PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> If cpufreq_register_notifier() fails, we have to remove the port added by
> sci_probe_single(), which is not done by sci_cleanup_single().
> 
> Else the serial port stays active from the point of view of the serial
> subsystem, and it may crash when userspace getty is started, or when the
> loadable driver module is unloaded.
> 
> This was introduced by commit 6dae14216c85eea13db7b12c469475c5d30e5499
> ("serial: sh-sci: Fix probe error paths").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

This looks reasonable to me.

Greg, could you take this one?


> ---
> This depends on "serial_core: Unregister console in uart_remove_one_port()"
> when using a serial console.
> ---
>  drivers/tty/serial/sh-sci.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> index be33d2b0613b..7958115e6a51 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -2564,6 +2564,7 @@ static int sci_probe(struct platform_device *dev)
>  	ret = cpufreq_register_notifier(&sp->freq_transition,
>  					CPUFREQ_TRANSITION_NOTIFIER);
>  	if (unlikely(ret < 0)) {
> +		uart_remove_one_port(&sci_uart_driver, &sp->port);
>  		sci_cleanup_single(sp);
>  		return ret;
>  	}
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
