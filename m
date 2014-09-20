Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbaITNw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 09:52:26 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:52338 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbaITNwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 09:52:24 -0400
Message-ID: <541D867C.6080407@roeck-us.net>
Date: Sat, 20 Sep 2014 06:51:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, wim@iguana.be
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: restart the counter immediately
 after enabling WDT
References: <1411108199-1280-1-git-send-email-jszhang@marvell.com> <1411108199-1280-2-git-send-email-jszhang@marvell.com>
In-Reply-To: <1411108199-1280-2-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.541D8697.010E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 11:29 PM, Jisheng Zhang wrote:
> The TOP_INIT may be zero, so the timeout period may be very short after
> initialization is done, thus the system may be reset soon after enabling.
> We fix this problem by restarting the counter immediately after enabling
> WDT.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>   drivers/watchdog/dw_wdt.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> index 9f21029..ad0619d 100644
> --- a/drivers/watchdog/dw_wdt.c
> +++ b/drivers/watchdog/dw_wdt.c
> @@ -146,6 +146,7 @@ static int dw_wdt_open(struct inode *inode, struct file *filp)
>   		dw_wdt_set_top(DW_WDT_MAX_TOP);
>   		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
>   		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
> +		dw_wdt_keepalive();
>   	}
>
>   	dw_wdt_set_next_heartbeat();
>
After getting access to the datasheet, I concluded that this fix is wrong
or at least more risky than necessary. The datasheet states that top_init,
ie bit 4-7 of the wdt_torr register, needs to be initialized with the desired
timeout period prior to enabling the watchdog. dw_wdt_set_top() sets it to
0 instead, ie to the lowest possible timeout period.

Guenter

