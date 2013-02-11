Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811Ab3BKTyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:54:36 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:51454 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab3BKTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:54:34 -0500
Message-ID: <51194C75.5040302@gmail.com>
Date: Mon, 11 Feb 2013 13:54:29 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-rt-users@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH next v2] OF: convert devtree lock from rw_lock to raw
 spinlock
References: <1359993921-18145-1-git-send-email-paul.gortmaker@windriver.com> <1360182656-15898-1-git-send-email-paul.gortmaker@windriver.com> <511585A9.9090008@gmail.com> <51194685.5010904@wwwdotorg.org>
In-Reply-To: <51194685.5010904@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 01:29 PM, Stephen Warren wrote:
> On 02/08/2013 04:09 PM, Rob Herring wrote:
>> On 02/06/2013 02:30 PM, Paul Gortmaker wrote:
>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>
>>> With the locking cleanup in place (from "OF: Fixup resursive
>>> locking code paths"), we can now do the conversion from the
>>> rw_lock to a raw spinlock as required for preempt-rt.
>>>
>>> The previous cleanup and this conversion were originally
>>> separate since they predated when mainline got raw spinlock (in
>>> commit c2f21ce2e31286a "locking: Implement new raw_spinlock").
>>>
>>> So, at that point in time, the cleanup was considered plausible
>>> for mainline, but not this conversion.  In any case, we've kept
>>> them separate as it makes for easier review and better bisection.
>>>
>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>> [PG: taken from preempt-rt, update subject & add a commit log]
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>> ---
>>>
>>> [v2: recent commit e81b329 ("powerpc+of: Add /proc device tree
>>>  updating to of node add/remove") added two more instances of
>>>  write_unlock that also needed converting to raw_spin_unlock.
>>>  Retested (boot) on sbc8548, defconfig builds on arm/sparc; no
>>>  new warnings observed.]
>>>
>>>  arch/sparc/kernel/prom_common.c |   4 +-
>>>  drivers/of/base.c               | 100 ++++++++++++++++++++++------------------
>>>  include/linux/of.h              |   2 +-
>>>  3 files changed, 59 insertions(+), 47 deletions(-)
>>
>> Applied.
> 
> This commit is present in next-20130211, and causes a boot failure
> (hang) early while booting on Tegra. Reverting just this one commit
> solves the issue.
> 
> I'll see if I can track down where the issue is. Given the commit
> description, I assume there's some new recursive lock issue that snuck
> in between the previous fix for them and this commit? Any hints welcome.
> 
> One thing I wonder looking at the patch: Most paths use
> raw_spin_lock_irqsave() but a few use just raw_spin_lock(). I wonder how
> that decision was made?

I found the problem. of_get_next_available_child ->
of_device_is_available -> of_get_property -> of_get_property. An
unlocked version of of_device_is_available is needed here.

Rob
