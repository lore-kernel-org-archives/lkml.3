Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3EULRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:17:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16362 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3EULRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:17:03 -0400
X-Spam-Score: -100.8
Message-ID: <519B577B.8080204@asianux.com>
Date: Tue, 21 May 2013 19:16:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Ben Dooks <ben@fluff.org>
Subject: Re: [PATCH] include/linux/posix_acl.h: need 'return NULL' when BUG(),
 if neither CONFIG_BUG nor HAVE_ARCH_BUG is defined.
References: <5199DBE2.5080707@asianux.com> <97dada79-cd78-4799-8f18-ed2bf8eee508@email.android.com> <20130520163118.GX18614@n2100.arm.linux.org.uk> <519AD33D.1030106@asianux.com> <20130521105959.GZ18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130521105959.GZ18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 06:59 PM, Russell King - ARM Linux wrote:
> On Tue, May 21, 2013 at 09:51:57AM +0800, Chen Gang wrote:
>> On 05/21/2013 12:31 AM, Russell King - ARM Linux wrote:
>>> On Mon, May 20, 2013 at 07:40:24AM -0700, Eric W. Biederman wrote:
>>>> Seriously?  The correct fix it would seem is to give a useful default BUG
>>>> definition.  Say *NULL.
>>>
>>> Absolutely.
>>>
>>> The real question is... how is this happening.  I've seen it occasionally
>>> in the randconfig builds - though I don't have any logs to hand which
>>> show that in the build system at the moment.  So, looking at the files:
>>>
>>
>> Maybe it is my fault for the incorrect configuration.
>>
>> My operation:
>>   make EXTRA_CFLAGS=-W ARCH=arm randconfig
>>   make EXTRA_CFLAGS=-W ARCH=arm menuconfig
>>     set 'arm-linux-gnu-' as cross compiler prefix.
>>     select "MMU-based Paged Memory" in "System Type".
>>     select "Samsung S5PV210/S5PC110" in "ARM System type"
>>   make EXTRA_CFLAGS=-W ARCH=arm
>>   ...
>>
>> In menuconfig, I do not touch the "S5PV210 Machines" or "S5PC110
>> Machines" in "System Type", and no machines will be chosen as default.
> 
> You know, telling us that you're using a random configuration to produce
> a problem and not providing the actual configuration file is utterly
> insane.  How many iterations do you think it might take to generate a
> random configuration which shows the same problem you're seeing?
> 
> 

Oh, it is my fault for my original reply (it is another issue which
also need further discussed)

But for current issue, we can repeat it only in menuconfig, unset " >
General setup > Configure standard kernel features (expert users) >
BUG() Support ", it will report related warnings.

For arm architecture, allmodconfig

  make ARCH=arm  allmodconfig
  make ARCH=arm  menuconfig
    set "arm-linux-gnu-" as cross compiler prefix.
    unset " > General setup > Configure standard kernel features (expert users) > BUG() Support "
  make ARCH=arm
  ...
  kernel/sched/core.c:2353:1: warning: control reaches end of non-void function [-Wreturn-type]
  mm/bootmem.c:386:1: warning: control reaches end of non-void function [-Wreturn-type]
  include/linux/posix_acl.h:108:1: warning: control reaches end of non-void function [-Wreturn-type]
  ...

For x86 architecture, allmodconfig:

  make allmodconfig
  make menuconfig
    unset " > General setup > Configure standard kernel features (expert users) > BUG() Support "
  make ARCH=arm
  ...
  arch/x86/kvm/x86.c:4298:5: warning: ‘exchanged’ may be used uninitialized in this function [-Wuninitialized]
  kernel/sched/core.c:2353:1: warning: control reaches end of non-void function [-Wreturn-type]
  mm/mempolicy.c:1755:1: warning: control reaches end of non-void function [-Wreturn-type]
  include/linux/posix_acl.h:108:1: warning: control reaches end of non-void function [-Wreturn-type]
  ...


So, we need fix the generic bug.h code, it is not arm specific.


Thanks.-- 
Chen Gang

Asianux Corporation
