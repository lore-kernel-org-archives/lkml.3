Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab3D2Qti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:49:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55234 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab3D2Qth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:49:37 -0400
Message-ID: <517EA36E.2050106@ti.com>
Date: Mon, 29 Apr 2013 11:44:30 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: <jassisinghbrar@gmail.com>
CC: <loic.pallardy@st.com>, <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [RFC 3/3] mailbox: pl320: Introduce common API driver
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com> <1367086496-28647-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1367086496-28647-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2013 01:14 PM, jassisinghbrar@gmail.com wrote:
> From: Jassi Brar <jaswinder.singh@linaro.org>
> 
> Convert the PL320 controller driver to work with the common
> mailbox API. Also convert the only user of PL320, highbank-cpufreq.c
> to work with thee API. Drop the obsoleted driver pl320-ipc.c

I think the conversion is fine based on your API, but you have
eliminated the stand-alone Rx interrupt code in the conversion. I
searched for if anybody is registering these rx atomic notifiers in 3.9,
and didn't find any. Is this expected to stay like this or is it some
future functionality not yet added, but getting removed in this patch.

> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>  drivers/cpufreq/highbank-cpufreq.c       |   22 +++-
>  drivers/mailbox/Makefile                 |    2 +-
>  drivers/mailbox/{pl320-ipc.c => pl320.c} |  194 ++++++++++++++++--------------
>  include/linux/pl320-ipc.h                |   17 ---
>  4 files changed, 125 insertions(+), 110 deletions(-)
>  rename drivers/mailbox/{pl320-ipc.c => pl320.c} (51%)
>  delete mode 100644 include/linux/pl320-ipc.h
> 
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index 3118b87..5c057e0 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -19,7 +19,7 @@
>  #include <linux/cpu.h>
>  #include <linux/err.h>
>  #include <linux/of.h>
> -#include <linux/pl320-ipc.h>
> +#include <linux/mailbox_client.h>
>  #include <linux/platform_device.h>
>  
>  #define HB_CPUFREQ_CHANGE_NOTE	0x80000001
> @@ -29,8 +29,26 @@
>  static int hb_voltage_change(unsigned int freq)
>  {
>  	u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
> +	struct ipc_client cl;
> +	int ret = -ETIMEDOUT;
> +	void *chan;
>  
> -	return pl320_ipc_transmit(msg);
> +	cl.rxcb = NULL;
> +	cl.txcb = NULL;
> +	cl.tx_block = true;
> +	cl.tx_tout = 1000; /* 1 sec */
> +	cl.cntlr_data = NULL;
> +	cl.knows_txdone = false;
> +	cl.chan_name = "pl320:A9_to_M3";
> +
> +	chan = ipc_request_channel(&cl);
> +
> +	if (ipc_send_message(chan, (void *)msg))
> +		ret = msg[1]; /* PL320 updates buffer with FIFO after ACK */
> +
> +	ipc_free_channel(chan);

I think I understand why you have done this, but do you really want to
request and free every time in the highbank cpufreq driver?

regards
Suman
