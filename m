Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3IWVKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:10:30 -0400
Received: from mail.tpi.com ([74.45.170.26]:46592 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab3IWVK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:10:27 -0400
Message-ID: <5240AE43.6070708@canonical.com>
Date: Mon, 23 Sep 2013 14:10:27 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Rob Herring <rob.herring@calxeda.com>,
        Paolo Pisati <paolo.pisati@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] TTY: hvc_dcc: probe for a JTAG connection before registering
References: <1379968234-23373-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1379968234-23373-1-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 01:30 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Enabling the ARM DCC console and using without a JTAG connection will
> simply hang the system. Since distros like to turn on all options, this
> is a reoccurring problem to debug. We can do better by checking if
> anything is attached and handling characters. There is no way to probe
> this, so send a newline and check that it is handled.
> 
> Cc: Paolo Pisati <paolo.pisati@canonical.com>
> Cc: Tim Gardner <tim.gardner@canonical.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  drivers/tty/hvc/hvc_dcc.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
> index 44fbeba..44c8aff 100644
> --- a/drivers/tty/hvc/hvc_dcc.c
> +++ b/drivers/tty/hvc/hvc_dcc.c
> @@ -86,6 +86,21 @@ static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
>  	return i;
>  }
>  
> +static bool hvc_dcc_check(void)
> +{
> +	unsigned long time = jiffies;
> +
> +	/* Write a test character to check if it is handled */
> +	__dcc_putchar('\n');
> +
> +	while (jiffies < time + (HZ / 10)) {
> +		if (!(__dcc_getstatus() & DCC_STATUS_TX))
> +			return true;
> +	}

I think you should use one of the jiffies time comparison functions, e.g.,

	time = jiffies + (HZ / 10);
	while (time_before(jiffies,time) {
		...
	}

What is the possibility that __dcc_getstatus() will return garbage if no
JTAG is connected ? In that event you're likely to get a false positive
on DCC_STATUS_TX.

rtg


-- 
Tim Gardner tim.gardner@canonical.com
