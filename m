Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaGISCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:02:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47817 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaGISCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:02:03 -0400
Message-ID: <53BD8398.6020507@codeaurora.org>
Date: Wed, 09 Jul 2014 11:02:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2] tty: serial: msm_serial.c:  Cleaning up uninitialized
 variables
References: <1404665232-14311-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1404665232-14311-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/14 09:47, Rickard Strandqvist wrote:
> Set reasonable initial value of some variables, in case
> they do not get set to something otherwise.
> And I've also added a plausibility control of the values.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---

This patch doesn't look right...

> @@ -930,17 +930,21 @@ static int __init msm_console_setup(struct console *co, char *options)
>  
>  	msm_init_clock(port);
>  
> -	if (options)
> +	if (options) {
>  		uart_parse_options(options, &baud, &parity, &bits, &flow);
> +		if (baud < 300 || baud > 115200)
> +			baud = 115200;
> +		if (NULL == strchr("noeNOE", parity))
> +			parity = 'n';
> +		if (bits != 7)
> +			bits = 8;
> +		if (flow != 'r')
> +			flow = 'n';
> +	}
>  
> -	bits = 8;
> -	parity = 'n';
> -	flow = 'n';
>  	msm_write(port, UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE,
>  		  UART_MR2);	/* 8N1 */
>  

because this code is overriding whatever is parsed from
uart_parse_options() on purpose. The hardware is configured for 8 bits,
no parity, no flow control with this msm_write() statement. Maybe we
should extend the code to configure the parity and flow control bits
instead.

> -	if (baud < 300 || baud > 115200)
> -		baud = 115200;
>  	msm_set_baud_rate(port, baud);
>  
>  	msm_reset(port);


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

