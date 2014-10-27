Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaJ0QmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:42:16 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:55463 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0QmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:42:14 -0400
Date: Mon, 27 Oct 2014 09:42:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 12/47] mfd: ab8500-sysctrl: Register with kernel
 poweroff handler
Message-ID: <20141027164210.GA11974@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-13-git-send-email-linux@roeck-us.net>
 <CACRpkdY8C3rCZsUGgoM+47bwepvPZwdwCv1NPsb0zk9WbHAKOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY8C3rCZsUGgoM+47bwepvPZwdwCv1NPsb0zk9WbHAKOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=1.5
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.544E75E5.0239,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On Mon, Oct 27, 2014 at 04:59:00PM +0100, Linus Walleij wrote:
> On Tue, Oct 21, 2014 at 6:12 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Register with kernel poweroff handler instead of setting pm_power_off
> > directly. Register with low priority to reflect that the original code
> > only sets pm_power_off if it was not already set.
> >
> > sysctrl_dev is set prior to poweroff handler registration, and the
> > poweroff handler is unregistered prior to clearing sysrctrl_dev.
> > It is therefore not necessary to check if sysctrl_dev is NULL in the
> > poweroff handler, and the check was removed. Setting sysctrl_dev to NULL
> > in the remove function was also removed as unnecessary. With those changes,
> > devm_register_power_off_handler can be used to register the poeroff handler.
> > The now empty remove function was retained since the ab8500_restart function,
> > which is currently unused, would likely need some cleanup if it was ever used.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v2:
> > - Use define to specify poweroff handler priority
> > - Use devm_register_power_off_handler
> > - Use dev_warn instead of dev_err
> > - Since we use devm_register_power_off_handler,
> >   we need to check if sysctrl_dev in the poweroff handler to avoid
> >   a race condition on unload, so this check is no longer removed
> 
> I can't compile this, I guess because of a dependency on some
> other patch?
> 
Hi Linus,

can you try v3 ? It has a number of improvements, and POWEROFF_PRIORITY_LOW
was replaced with POWER_OFF_PRIORITY_LOW. You will need patch 01/47 of the
series as well to get the definition.

>   CC      drivers/mfd/ab8500-sysctrl.o
> ../drivers/mfd/ab8500-sysctrl.c:94:14: error: ‘POWEROFF_PRIORITY_LOW’
> undeclared here (not in a function)
>   .priority = POWEROFF_PRIORITY_LOW,
>               ^
> ../drivers/mfd/ab8500-sysctrl.c: In function ‘ab8500_sysctrl_probe’:
> ../drivers/mfd/ab8500-sysctrl.c:206:2: error: implicit declaration of
> function ‘devm_register_power_off_handler’
> [-Werror=implicit-function-declaration]
>   err = devm_register_power_off_handler(sysctrl_dev, &ab8500_poweroff_nb);
> 
> I wanted to provide a Tested-by but I guess I can only give this:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
Thanks!
Guenter
