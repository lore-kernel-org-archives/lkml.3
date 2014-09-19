Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaISEDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:03:23 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33801 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaISEDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:03:22 -0400
Message-ID: <541BAB06.7040502@roeck-us.net>
Date: Thu, 18 Sep 2014 21:03:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: qcom: register a restart notifier
References: <cover.1411078425.git.joshc@codeaurora.org> <d0f4cd93ad3f6690d637413b1171ac3c71aba861.1411078426.git.joshc@codeaurora.org> <541B995A.6000609@roeck-us.net> <20140919033202.GF3749@joshc.qualcomm.com>
In-Reply-To: <20140919033202.GF3749@joshc.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.541BAB09.00EF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 09/18/2014 08:32 PM, Josh Cartwright wrote:
> On Thu, Sep 18, 2014 at 07:47:54PM -0700, Guenter Roeck wrote:
>> On 09/18/2014 03:27 PM, Josh Cartwright wrote:
>>> The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
>>> resort mechanism for triggering chip reset.  Usually, other restart
>>> methods (such as PS_HOLD) are preferrable for issuing a more complete
>>> reset of the chip.  As such, keep the priority of the watchdog notifier
>>> low.
>>>
>>> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> [..]
>>> +static int qcom_wdt_restart(struct notifier_block *nb, unsigned long action,
>>> +			    void *data)
>>> +{
>>> +	struct qcom_wdt *wdt = container_of(nb, struct qcom_wdt, restart_nb);
>>> +
>>> +	/*
>>> +	 * Trigger watchdog bite:
>>> +	 *    Setup BITE_TIME to be very low, and enable WDT.
>>> +	 */
>>> +	mutex_lock(&wdt->wdd.lock);
>>
>> At this time you don't need to worry about locks.
>>
>> Actually, this might be dangerous if the lock happens to be taken,
>> as it won't be released (there is no other code running anymore
>> when this function is called).
>
> Ah, great.  I'll drop the locking.
>
>>> +	writel_relaxed(0, wdt->base + WDT_EN);
>>> +	writel_relaxed(1, wdt->base + WDT_RST);
>>> +	writel_relaxed(0x31F3, wdt->base + WDT_BITE_TIME);
>>
>> What is the magic here, ie what does 0x31F3 stand for ?
>
> Nothing magic, it's just a reasonably low value to set the bite time
> counter at.  It also happens to be the value at reset.
>
Can you add a note explaining that this reflects a reset delay of <n>
milliseconds or whatever it is ?

>>> +	writel_relaxed(1, wdt->base + WDT_EN);
>>> +	mutex_unlock(&wdt->wdd.lock);
>>> +	return NOTIFY_DONE;
>>> +}
>>> +
>>>   static int qcom_watchdog_probe(struct platform_device *pdev)
>>>   {
>>>   	struct qcom_wdt *wdt;
>>> @@ -121,6 +141,17 @@ static int qcom_watchdog_probe(struct platform_device *pdev)
>>>   		return ret;
>>>   	}
>>>
>>> +	/*
>>> +	 * WDT restart notifier has priority 0 (use as a last resort)
>>> +	 */
>>> +	wdt->restart_nb.notifier_call = qcom_wdt_restart;
>>> +	ret = register_restart_handler(&wdt->restart_nb);
>>> +	if (ret) {
>>> +		dev_err(&pdev->dev, "failed to setup restart handler\n");
>>> +		watchdog_unregister_device(&wdt->wdd);
>>> +		return ret;
>>
>> Sure you want to return an error here ? The watchdog itself is still working,
>> and this is supposed to be a restart method of last resort. Causing the driver
>> to fail loading because it can not register its restart handler seems to be
>> a bit aggressive.
>
> It is a bit aggressive.  I'll at least drop it to a dev_warn(); even
> though it is a "last resort", on some boards it's the only available
> mechanism for reliable restart.
>
Sure, but the problem is that you don't let people use the watchdog just
because restart handler registration failed. dev_err or dev_warn is fine,
my concern was not the message but that you abort watchdog registration
in this case.

Kind of letting people not use their car just because one of its lights
failed.

Guenter

