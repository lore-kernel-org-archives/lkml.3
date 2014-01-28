Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaA1Kfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:35:43 -0500
Received: from smtp.citrix.com ([66.165.176.89]:30651 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbaA1Kfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:35:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,735,1384300800"; 
   d="scan'208";a="97177002"
Message-ID: <52E787FA.3080105@citrix.com>
Date: Tue, 28 Jan 2014 10:35:38 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Julien Grall <julien.grall@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <patches@linaro.org>
Subject: Re: [PATCH] xen/events: xen_evtchn_fifo_init can be called very late
References: <1390869269-12502-1-git-send-email-julien.grall@linaro.org>
In-Reply-To: <1390869269-12502-1-git-send-email-julien.grall@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/14 00:34, Julien Grall wrote:
> On ARM, xen_init_IRQ (which calls xen_evtchn_fifo_init) is called after
> all CPUs are online. It would mean that the notifier will never be called.

Why does ARM call xen_init_IRQ() so late?  Is it possible to call it
earlier when only the boot CPU is online?  There are problems with
attempting to init FIFO event channels after all CPUs are online.

If evtchn_fifo_init_control_block(cpu) fails on anything other than the
first CPU, that CPU will be unable to receive any events.  Xen will have
been switched to FIFO mode and it is not possible to revert back to
2-level mode.

> Therefore, when a secondary CPU will receive an interrupt, Linux will segfault
> because the event channel structure for this processor is not initialized.
> 
> This can be fixed by calling the init function on every online cpu when the
> event channel fifo driver is initialized.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>
> ---
>  drivers/xen/events/events_fifo.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
> index 1de2a19..15498ab 100644
> --- a/drivers/xen/events/events_fifo.c
> +++ b/drivers/xen/events/events_fifo.c
> @@ -410,12 +410,14 @@ static struct notifier_block evtchn_fifo_cpu_notifier = {
>  
>  int __init xen_evtchn_fifo_init(void)
>  {
> -	int cpu = get_cpu();
> +	int cpu;
>  	int ret;
>  
> -	ret = evtchn_fifo_init_control_block(cpu);
> -	if (ret < 0)
> -		goto out;
> +	for_each_online_cpu(cpu) {
> +		ret = evtchn_fifo_init_control_block(cpu);
> +		if (ret < 0)
> +			goto out;

You need to handle this error differently depending on whether the first
call fails or not.

Failure on first CPU: return an error and the caller will fallback to
using 2-level mode.

Failure on second or later CPU: you need to offline that CPU.  It may
not be possible to offline a CPU with standard calls (e.g., cpu_down())
as it won't have working interrupts.

David
