Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3GJX31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:29:27 -0400
Received: from mout.gmx.net ([212.227.17.21]:60161 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3GJX3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:29:25 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [tpmdd-devel] [PATCH 3/4] tpm: Convert tpm_tis driver to use dev_pm_ops from legacy pm_ops
Date: Thu, 11 Jul 2013 01:37:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "key@linux.vnet.ibm.com" <key@linux.vnet.ibm.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd@selhorst.net" <tpmdd@selhorst.net>,
        "tpmdd@sirrix.com" <tpmdd@sirrix.com>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1373429409-3944-1-git-send-email-shuah.kh@samsung.com> <201307110051.04726.PeterHuewe@gmx.de> <B8EFE96D1287C24090BAD9D858E15E61738933@sisaex02sj>
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61738933@sisaex02sj>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307110137.32309.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:JBGbP97Les4XFsRxBuQaUn1cm9FDUTa6IlUtdJfJR6+zTbrTlny
 GNPYGItVSdAegyDeJeIn0AMbjdsaWBxR+TPamMgHp29qeng18Rs5eU9atsNDUZWUEcGbr5o
 cz/0ax4VdY0SAAJToFdWr0iWAR9BCbu1gDV1mmZf6DTCn0HRjoZL5yvZ0E9CIHG1HvjDnyY
 Dd/vJwmqszC/B3I44burQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,
thanks for your reply.


> >> +#ifdef CONFIG_PM_SLEEP
> >> +	.driver	= {
> >> +		.pm = &tpm_tis_pm,
> >> +	},
> >> +#endif
> >> 
> >>   };
> > 
> > I don't think the #if CONFIG_PM_SLEEP is required here.
In this case, the SIMPLE_DEV_PM_OPS macro handles the case internally - i.e. 
no matter whether CONFIG_PM_SLEEP is set or not, the correct structure is set 
up and thus no ifdef needed.


> 
> tpm_tis_resume() is defined originally in CONFIG_PM_SLEEP scope. I can
> make the change to have tpm_tis_resume() not be in CONFIG_PM_SLEEP scope
> and remove this CONFIG_PM_SLEEP when defining .pm. 
> That does make sense looking at tpm_pm_suspend() and tpm_pm_resume() which  
> are defined ithout CONFIG_PM_SLEEP scope. Sounds like the right approach?
> I will redo the patch and send v2.

Hmm,
at first I thought that would be a good idea, however scrolling to the git 
history I found:

commit 07368d32f1a67e797def08cf2ee3ea1647b204b6
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Aug 9 23:00:35 2012 +0200

    tpm_tis / PM: Fix unused function warning for CONFIG_PM_SLEEP
    
    According to a compiler warning, the tpm_tis_resume() function is not
    used for CONFIG_PM_SLEEP unset, so add a #ifdef to prevent it from
    being built in that case.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

So removing it there would effectively revert the patch and re-enable the 
warning.


 
> I find that the use of CONFIG_PM, CONFIG_PM_SLEEP, and CONFIG_PM_RUNTIME
> are not very consistent. :)
Yes.

Maybe the better idea is to add the correct CONFIG_PM ifdefs for all code 
paths related to PM.
Or leave the CONFIG_PM for tpm_tis_resume as it is.


Thanks,
Peter
