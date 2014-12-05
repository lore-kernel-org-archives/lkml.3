Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbaLEDaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:30:52 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63748 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaLEDav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:30:51 -0500
MIME-Version: 1.0
In-Reply-To: <548112D8.70009@cn.fujitsu.com>
References: <1417737024-13967-1-git-send-email-bobby.prani@gmail.com>
 <20141205001148.GC25340@linux.vnet.ibm.com> <548112D8.70009@cn.fujitsu.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 4 Dec 2014 22:30:20 -0500
Message-ID: <CAJhHMCD7GVUcGsex86Tj-+oVh5a6qpmtTt88Nb8ZJj-SGYz9Nw@mail.gmail.com>
Subject: Re: [PATCH] tinification: Make SRCU optional by using CONFIG_SRCU
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 9:05 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> On 12/05/2014 08:11 AM, Paul E. McKenney wrote:
>> On Thu, Dec 04, 2014 at 06:50:24PM -0500, Pranith Kumar wrote:
>>> SRCU is not necessary to be compiled by default in all cases. For tinification
>>> efforts not compiling SRCU unless necessary is desirable.
>>>
>>> The current patch tries to make compiling SRCU optional by introducing a new
>>> Kconfig option CONFIG_SRCU which is selected when any of the components making
>>> use of SRCU are selected.
>>>
>>> If we do not select CONFIG_SRCU, srcu.o will not be compiled at all.
>>>
>>>    text    data     bss     dec     hex filename
>>>    2007       0       0    2007     7d7 kernel/rcu/srcu.o
>>>
>>> Size of arch/powerpc/boot/zImage changes from
>>>
>>>    text    data     bss     dec     hex filename
>>>  831552   64180   23944  919676   e087c arch/powerpc/boot/zImage : before
>>>  829504   64180   23952  917636   e0084 arch/powerpc/boot/zImage : after
>>>
>>> so the savings are about ~2000 bytes.
>>>
>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>> CC: Paul McKenney <paulmck@linux.vnet.ibm.com>
>>> CC: Josh Triplett <josh@joshtriplett.org>
>>
>> I have queued this for testing.
>>
>> Josh, does this look reasonable to you?
>>
>> Lai, any issues?
>>
>>                                                       Thanx, Paul
>>
>>> ---
>>>  arch/arm/kvm/Kconfig     |  1 +
>>>  arch/arm64/kvm/Kconfig   |  1 +
>>>  arch/ia64/kvm/Kconfig    |  1 +
>>>  arch/mips/kvm/Kconfig    |  1 +
>>>  arch/powerpc/kvm/Kconfig |  1 +
>>>  arch/s390/kvm/Kconfig    |  1 +
>>>  arch/tile/kvm/Kconfig    |  1 +
>>>  arch/x86/Kconfig         |  1 +
>>>  arch/x86/kvm/Kconfig     |  1 +
>>>  drivers/clk/Kconfig      |  1 +
>>>  drivers/cpufreq/Kconfig  |  1 +
>>>  drivers/devfreq/Kconfig  |  1 +
>>>  drivers/md/Kconfig       |  1 +
>>>  drivers/net/Kconfig      |  1 +
>>>  fs/btrfs/Kconfig         |  1 +
>>>  fs/notify/Kconfig        |  1 +
>>>  init/Kconfig             | 10 ++++++++++
>>>  kernel/notifier.c        |  3 +++
>>>  kernel/rcu/Makefile      |  3 ++-
>>>  lib/Kconfig.debug        |  1 +
>>>  mm/Kconfig               |  1 +
>>>  security/tomoyo/Kconfig  |  1 +
>>>  22 files changed, 34 insertions(+), 1 deletion(-)
>
> Miss fs/quota/Kconfig?
>
> ./fs/quota/dquot.c:100: * Operation of reading pointer needs srcu_read_lock(&dquot_srcu), and
> ./fs/quota/dquot.c:1609:        index = srcu_read_lock(&dquot_srcu);
> ./fs/quota/dquot.c:1657:        index = srcu_read_lock(&dquot_srcu);
> ./fs/quota/dquot.c:1695:        index = srcu_read_lock(&dquot_srcu);
> ./fs/quota/dquot.c:1724:        index = srcu_read_lock(&dquot_srcu);
> ./fs/quota/dquot.c:1756:        index = srcu_read_lock(&dquot_srcu);
> ./fs/quota/dquot.c:1797:        index = srcu_read_lock(&dquot_srcu);
> ./fs/quota/dquot.c:1827: * protect them by srcu_read_lock().
>
> And
>
> ./drivers/base/power/opp.c:90:  struct srcu_notifier_head head;
> ./drivers/base/power/opp.c:439:         srcu_init_notifier_head(&dev_opp->head);
> ./drivers/base/power/opp.c:484: srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
> ./drivers/base/power/opp.c:564:         srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ENABLE,
> ./drivers/base/power/opp.c:567:         srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_DISABLE,
> ./drivers/base/power/opp.c:625:struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev)
>
> ===

I've added the above two locations to enable SRCU.

>
> include/linux/srcu.h and ./include/linux/notifier.h should also use
> "#ifdef CONFIG_SRCU .... "
>
>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index ded8a67..1c581a0 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -137,6 +137,7 @@ config X86
>>>      select HAVE_ACPI_APEI_NMI if ACPI
>>>      select ACPI_LEGACY_TABLES_LOOKUP if ACPI
>>>      select X86_FEATURE_NAMES if PROC_FS
>>> +    select SRCU
>
>
>
>
> Why you select SRCU when X86?
>

The reason is that x86 selects PERF_EVENTS which inturn needs SRCU. We
were not sure if SRCU will be recursively enabled when PERF_EVENTS is
enabled.

>>>
>>> +config SRCU
>>> +    bool "Sleepable form of RCU"
>
> Why it has a title? Somebody need to select it manually for third party kernel module?

Yes, it is a choice given to enable SRCU even when no in-kernel module uses it.

>
>>> +    def_bool n
>>> +    help
>>> +      This option selects the sleepable version of RCU. This version
>>> +      permits arbitrary sleeping or blocking within RCU read-side critical
>>> +      sections.
>
> You used "form" and "version" at the same time.

I will fix this in the next iteration.

>
>
>>>
>>> +#ifdef CONFIG_SRCU
>>>  /*
>>>   *  SRCU notifier chain routines.    Registration and unregistration
>>>   *  use a mutex, and call_chain is synchronized by SRCU (no locks).
>>> @@ -528,6 +529,8 @@ void srcu_init_notifier_head(struct srcu_notifier_head *nh)
>>>  }
>>>  EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
>>>
>>> +#endif /* CONFIG_SRCU */
>
> Do we need a new CONFIG_SRCU_NOTIFIER ?

I am not sure actually. Why not just CONFIG_SRCU like here?

-- 
Pranith
