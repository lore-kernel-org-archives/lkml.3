Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824Ab3FSOLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:11:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:41729 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3FSOKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,896,1363158000"; 
   d="scan'208";a="356172777"
Date: Wed, 19 Jun 2013 17:10:08 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 3/5] tty/8250_dw: Add support for OCTEON UARTS.
Message-ID: <20130619141008.GA32331@xps8300>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
 <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:12:53PM -0700, David Daney wrote:
> A few differences needed by OCTEON:
> 
> o These are DWC UARTS, but have USR at a different offset.
> 
> o OCTEON must have 64-bit wide register accesses, so we have OCTEON
>   specific register accessors.
> 
> o No UCV register, so we hard code some properties.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

<snip>

> @@ -270,10 +301,8 @@ static int dw8250_probe(struct platform_device *pdev)
>  	uart.port.serial_out = dw8250_serial_out;
>  	uart.port.private_data = data;
>  
> -	dw8250_setup_port(&uart);
> -
>  	if (pdev->dev.of_node) {
> -		err = dw8250_probe_of(&uart.port);
> +		err = dw8250_probe_of(&uart.port, data);
>  		if (err)
>  			return err;
>  	} else if (ACPI_HANDLE(&pdev->dev)) {
> @@ -284,6 +313,9 @@ static int dw8250_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> +	if (!data->no_ucv)
> +		dw8250_setup_port(&uart);

Moving the dw8250_setup_port() call here breaks dw8250_probe_acpi(). It
expects values from the CPR register for the DMA burst size calculation.

The DMA support can be moved to a separate function. This way it can
be called after this point, and it will then be available for both DT
and ACPI. I can make a patch tomorrow. That should solve this issue.

Thanks,

-- 
heikki
