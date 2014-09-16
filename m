Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaIPGbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:31:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22749 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaIPGbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:31:34 -0400
Date: Tue, 16 Sep 2014 09:31:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgap: use schedule_timeout_interruptible()
 instead of dgap_ms_sleep()
Message-ID: <20140916063115.GF17875@mwanda>
References: <20140916033333.GA26821@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916033333.GA26821@devel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 12:33:33PM +0900, Daeseok Youn wrote:
> @@ -2297,12 +2273,12 @@ static void dgap_tty_close(struct tty_struct *tty, struct file *file)
>  			 * Go to sleep to ensure RTS/DTR
>  			 * have been dropped for modems to see it.
>  			 */
> -			if (ch->ch_close_delay) {
> -				spin_unlock_irqrestore(&ch->ch_lock,
> -						       lock_flags);
> -				dgap_ms_sleep(ch->ch_close_delay);
> -				spin_lock_irqsave(&ch->ch_lock, lock_flags);
> -			}
> +			spin_unlock_irqrestore(&ch->ch_lock,
> +					lock_flags);
> +			/* .25 second delay for dropping RTS/DTR */
> +			schedule_timeout_interruptible(msecs_to_jiffies(250));
> +			signal_pending(current);

There is no point in calling signal_pending() if you don't care about
the return value.

> +			spin_lock_irqsave(&ch->ch_lock, lock_flags);
>  		}
>  

regards,
dan carpenter
