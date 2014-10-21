Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaJUNng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:43:36 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:59291 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaJUNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:43:34 -0400
Message-ID: <54465CD5.5070002@roeck-us.net>
Date: Tue, 21 Oct 2014 06:17:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?B?UGhpbGlwcGUgUsOpdG9ybmF6?= <philippe.retornaz@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-2-git-send-email-linux@roeck-us.net> <41603148.RJg26vx0Wv@vostro.rjw.lan>
In-Reply-To: <41603148.RJg26vx0Wv@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.54466306.02DF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
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

On 10/21/2014 05:26 AM, Rafael J. Wysocki wrote:
> On Monday, October 20, 2014 09:12:17 PM Guenter Roeck wrote:
>> Various drivers implement architecture and/or device specific means to
>> remove power from the system.  For the most part, those drivers set the
>> global variable pm_power_off to point to a function within the driver.
>>
>> This mechanism has a number of drawbacks.  Typically only one scheme
>> to remove power is supported (at least if pm_power_off is used).
>> At least in theory there can be multiple means remove power, some of
>> which may be less desirable. For example, some mechanisms may only
>> power off the CPU or the CPU card, while another may power off the
>> entire system.  Others may really just execute a restart sequence
>> or drop into the ROM monitor. Using pm_power_off can also be racy
>> if the function pointer is set from a driver built as module, as the
>> driver may be in the process of being unloaded when pm_power_off is
>> called. If there are multiple poweroff handlers in the system, removing
>> a module with such a handler may inadvertently reset the pointer to
>> pm_power_off to NULL, leaving the system with no means to remove power.
>>
>> Introduce a system poweroff handler call chain to solve the described
>> problems.  This call chain is expected to be executed from the
>> architecture specific machine_power_off() function.  Drivers providing
>> system poweroff functionality are expected to register with this call chain.
>> By using the priority field in the notifier block, callers can control
>> poweroff handler execution sequence and thus ensure that the poweroff
>> handler with the optimal capabilities to remove power for a given system
>> is called first.
>
> Well, I must admit to having second thoughts regarding this particular
> mechanism.  Namely, notifiers don't seem to be the best way of expressing
> what's needed from the design standpoint.
>
> It looks like we need a list of power off methods and a way to select one
> of them, so it seems that using a plist would be a natural choice here?
>
Isn't a notifier call chain nothing but a list of methods, with its priority
the means to select which one to use (first) ?

The only difference I can see is that you would only select one of them,
meaning the one with the highest priority, and not try the others.
Am I missing something ?

Thanks,
Guenter

