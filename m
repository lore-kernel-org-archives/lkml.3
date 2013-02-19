Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3BSOT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:19:29 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44677 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628Ab3BSOT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:19:27 -0500
Message-ID: <512389CB.1000906@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2013 08:18:51 -0600
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, josh.h.morris@us.ibm.com
Subject: Re: [PATCH 1/1] block: IBM RamSan 70/80 driver fixes.
References: <20130218200028.GA7350@oc6784271780.ibm.com>
In-Reply-To: <20130218200028.GA7350@oc6784271780.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021914-9360-0000-0000-000010C64DCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 02:00 PM, Philip J. Kelleher wrote:
> diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/config.c linux-block/drivers/block/rsxx/config.c
> --- linux-block-vanilla/drivers/block/rsxx/config.c	2013-02-12 11:25:37.756352070 -0600
> +++ linux-block/drivers/block/rsxx/config.c	2013-02-15 09:01:43.221166194 -0600
> @@ -31,7 +31,7 @@
> 
>  static void initialize_config(void *config)
>  {
> -	struct rsxx_card_cfg *cfg = (struct rsxx_card_cfg *) config;
> +	struct rsxx_card_cfg *cfg = config;

Why not pass a struct rsxx_card_cfg * here instead of a void*?



> @@ -126,7 +126,11 @@ static void creg_issue_cmd(struct rsxx_c
>  					  cmd->buf, cmd->stream);
>  	}
> 
> -	/* Data copy must complete before initiating the command. */
> +	/*
> +	 * Data copy must complete before initiating the command. This is
> +	 * needed for weakly ordered processors (i.e. PowerPC), so that all
> +	 * neccessary registers are written before we kick the hardware.
> +	 */
>  	wmb();

When you say data copy are you referring to the writes to the host DMA
buffer that occurred previously? If so, the iowrite / writel macros
already ensure this, as they have a sync instruction built in to them
to cover this case, so a wmb would be redundant.

If its to ensure that all the iowrite's make it to the device as one
transaction and don't get interleaved with some other iowrite's, as
long as you have a spinlock protecting these writes, the PowerPC
spin_unlock will guarantee an mmiowb, so this shouldn't be an issue
either.


> diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx.h linux-block/drivers/block/rsxx/rsxx.h
> --- linux-block-vanilla/drivers/block/rsxx/rsxx.h	2013-02-12 11:25:37.780170779 -0600
> +++ linux-block/drivers/block/rsxx/rsxx.h	2013-02-18 08:54:59.692973434 -0600
> @@ -35,6 +35,8 @@ struct rsxx_reg_access {
>  	__u32 data[8];
>  };
> 
> +#define RSXX_MAX_REG_CNT	(8 * (sizeof(__u32)))

Is this 8 related to the 8 in the array above? If so, why not have a literal
to define the 8 and use it in both places to make this clear?

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


