Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbaEJBRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 21:17:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49778 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507AbaEJBRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 21:17:50 -0400
Message-ID: <536D7E18.4040502@ti.com>
Date: Fri, 9 May 2014 20:17:12 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>, Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robherring2@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 RFC 12/15] hwspinlock/core: add OF helper to parse reserved
 locks
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-13-git-send-email-s-anna@ti.com> <53680639.1080405@ti.com> <20140505215422.GD5546@joshc.qualcomm.com>
In-Reply-To: <20140505215422.GD5546@joshc.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 05/05/2014 04:54 PM, Josh Cartwright wrote:
> On Mon, May 05, 2014 at 04:44:25PM -0500, Suman Anna wrote:
>> Hi Rob,
>>
>> On 04/30/2014 07:34 PM, Suman Anna wrote:
>>> The property 'hwlock-reserved-locks' will be used to represent
>>> the number of locks to be reserved for clients that would need
>>> to request/operate on specific locks. A new OF helper function,
>>> of_hwspin_lock_get_num_reserved_locks(), is added to minimize
>>> duplication in different platform implementations.
>>>
>>> The function will return a value of 0 if the property is not
>>> defined, so as to support a default behavior of marking all
>>> locks as unused and open for anonymous allocations.
>>>
>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>> ---
>>>  .../devicetree/bindings/hwlock/hwlock.txt          |  3 +++
>>>  drivers/hwspinlock/hwspinlock_core.c               | 25 ++++++++++++++++++++++
>>>  include/linux/hwspinlock.h                         |  1 +
>>>  3 files changed, 29 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>> index d538a9b..88d16d2 100644
>>> --- a/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>> @@ -18,6 +18,9 @@ Common properties:
>>>  			property is needed on hwlock devices, where the number
>>>  			of supported locks within a hwlock device cannot be
>>>  			read from a register.
>>> +- hwlock-reserved-locks: Number of locks to reserve for clients requiring
>>> +			specific locks. This value cannot exceed the value of
>>> +			hwlock-num-locks.
>>
>> Any suggestions here on the approach? This property falls into a gray
>> area as well, as the current approach is somewhat limiting (it doesn't
>> support sparse reserved locks, and expects them at the beginning of the
>> lock range).
> 
> Is it possible to implement a pinctrl-like hogging approach, whereby the
> specific locks that need to be reserved are consumed by the controller
> itself?
> 

Thanks for the suggestion. I did take a look at pinctrl and while it is
possible to implement something similar, I feel it is a bit heavy for
hwspinlock framework with no added advantages. It requires that the
controller and clients always need to be updated together. Ohad had
already brought this up [1]. Here's an alternate approach that does not
require any additional property to the controller itself, while the
client node usage is as before. The logic is based on parsing through
the DT blob and marking only those that are used by any clients. The RFC
patch below is a replacement for Patches 11 to 15, and do not require
any changes to platform implementations or additional DT properties.

It currently marks locks as reserved even for disabled client nodes
(very easy to change that behavior). It will also impose a standard
property name "hwlocks" on the client nodes. What do you think of this
approach?

regards
Suman

[1] http://marc.info/?l=linux-omap&m=139514977622964&w=2

----
>From 4f4cbe91e56c1be8faa6a3ee863add4df6e6714b Mon Sep 17 00:00:00 2001
From: Suman Anna <s-anna@ti.com>
Date: Fri, 9 May 2014 14:26:54 -0500
Subject: [RFC PATCH] hwspinlock/core: add support for reserved locks

The HwSpinlock core allows requesting either a specific lock or an
available normal lock. The specific locks are usually reserved during
board init time, while the normal available locks are intended to be
assigned at runtime.

The HwSpinlock core has been enhanced to mark certain locks as 'reserved'
by parsing through the DT blob. Thes

The HwSpinlock core has been enhanced to:
  1. mark certain locks as 'reserved' by parsing the DT blob for any
     locks used by client nodes.
  2. restrict the anonymous hwspin_lock_request() API to allocate only
     from non-reserved locks for DT boots.
  3. limit these reserved locks to be allocated only using the
     _request_specific() API variants for DT boots.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/hwspinlock/hwspinlock_core.c | 50
++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c
b/drivers/hwspinlock/hwspinlock_core.c
index c2063bc..0c924c9 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -425,6 +425,42 @@ static int hwspinlock_device_add(struct
hwspinlock_device *bank)
        return ret;
 }

+static void hwspin_mark_reserved_locks(struct hwspinlock_device *bank)
+{
+       struct device_node *np = bank->dev->of_node;
+       const char *prop_name = "hwlocks";
+       const char *cells_name = "#hwlock-cells";
+       struct device_node *node = NULL;
+       struct of_phandle_args args;
+       struct hwspinlock *hwlock;
+       int i, id, count, ret;
+
+       for_each_node_with_property(node, prop_name) {
+               count = of_count_phandle_with_args(node, prop_name,
cells_name);
+               if (count <= 0)
+                       continue;
+
+               for (i = 0; i < count; i++) {
+                       ret = of_parse_phandle_with_args(node, prop_name,
+                                                        cells_name, i,
&args);
+                       if (ret || np != args.np)
+                               continue;
+
+                       id = bank->ops->of_xlate(bank, &args);
+                       if (id < 0 || id >= bank->num_locks)
+                               continue;
+
+                       hwlock = &bank->lock[id];
+                       if (hwlock->type == HWSPINLOCK_RESERVED) {
+                               dev_err(bank->dev, "potential reuse of
hwspinlock %d between multiple clients on %s\n",
+                                       id, np->full_name);
+                               continue;
+                       }
+                       hwlock->type = HWSPINLOCK_RESERVED;
+               }
+       }
+}
+
 /**
  * hwspin_lock_register() - register a new hw spinlock device
  * @bank: the hwspinlock device, which usually provides numerous hw locks
@@ -463,12 +499,16 @@ int hwspin_lock_register(struct hwspinlock_device
*bank, struct device *dev,
        if (ret)
                return ret;

+       if (dev->of_node)
+               hwspin_mark_reserved_locks(bank);
+
        for (i = 0; i < num_locks; i++) {
                hwlock = &bank->lock[i];

                spin_lock_init(&hwlock->lock);
                hwlock->bank = bank;
-               hwlock->type = HWSPINLOCK_UNUSED;
+               if (hwlock->type != HWSPINLOCK_RESERVED)
+                       hwlock->type = HWSPINLOCK_UNUSED;

                ret = hwspin_lock_register_single(hwlock, base_id + i);
                if (ret)
@@ -651,7 +691,13 @@ struct hwspinlock
*hwspin_lock_request_specific(unsigned int id)
        /* sanity check (this shouldn't happen) */
        WARN_ON(hwlock_to_id(hwlock) != id);

-       /* make sure this hwspinlock is unused */
+       if (hwlock->type != HWSPINLOCK_RESERVED) {
+               pr_warn("hwspinlock %u is not a reserved lock\n", id);
+               hwlock = NULL;
+               goto out;
+       }
+
+       /* make sure this hwspinlock is an unused reserved lock */
        ret = radix_tree_tag_get(&hwspinlock_tree, id, hwlock->type);
        if (ret == 0) {
                pr_warn("hwspinlock %u is already in use\n", id);
-- 
1.9.2


