Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3KYV6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:58:25 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:62956 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3KYV6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:58:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4bXfVbxcJ6-LcByDRX25DSa8Pa+9dLtcaW631YK88Gcw@mail.gmail.com>
References: <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org> <20131113073806.GA23244@mtj.dyndns.org>
 <20131116002820.GA31073@google.com> <20131116045356.GA5618@mtj.dyndns.org>
 <20131118181440.GA2996@google.com> <CAE9FiQW07ZAU_0bjkrwK54TAn48ByyS=kXNFwQJ-G2FFkK_W3A@mail.gmail.com>
 <20131118203925.GA26682@google.com> <528D8B6A.40008@oracle.com> <CAErSpo4bXfVbxcJ6-LcByDRX25DSa8Pa+9dLtcaW631YK88Gcw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 25 Nov 2013 14:57:59 -0700
Message-ID: <CAErSpo5S4GqbOPfGUMOw2vsMFewrB4p4kXfW5D1MB9MC_WTWPQ@mail.gmail.com>
Subject: Re: Possible regression with cgroups in 3.11
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Li Zefan <lizefan@huawei.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, cgroups@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 9:47 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Jiri]
>
> On Wed, Nov 20, 2013 at 9:26 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> On 11/18/2013 03:39 PM, Bjorn Helgaas wrote:
>>>
>>> On Mon, Nov 18, 2013 at 11:29:32AM -0800, Yinghai Lu wrote:
>>>>
>>>> On Mon, Nov 18, 2013 at 10:14 AM, Bjorn Helgaas <bhelgaas@google.com>
>>>> wrote:
>>>>>>
>>>>>> A bit of comment here would be nice but yeah I think this should work.
>>>>>> Can you please also queue the revert of c2fda509667b ("workqueue:
>>>>>> allow work_on_cpu() to be called recursively") after this patch?
>>>>>> Please feel free to add my acked-by.
>>>>>
>>>>>
>>>>> OK, below are the two patches (Alex's fix + the revert) I propose to
>>>>> merge.  Unless there are objections, I'll ask Linus to pull these
>>>>> before v3.13-rc1.
>>>>>
>>>>>
>>>>>
>>>>> commit 84f23f99b507c2c9247f47d3db0f71a3fd65e3a3
>>>>> Author: Alexander Duyck <alexander.h.duyck@intel.com>
>>>>> Date:   Mon Nov 18 10:59:59 2013 -0700
>>>>>
>>>>>      PCI: Avoid unnecessary CPU switch when calling driver .probe()
>>>>> method
>>>>>
>>>>>      If we are already on a CPU local to the device, call the driver
>>>>> .probe()
>>>>>      method directly without using work_on_cpu().
>>>>>
>>>>>      This is a workaround for a lockdep warning in the following
>>>>> scenario:
>>>>>
>>>>>        pci_call_probe
>>>>>          work_on_cpu(cpu, local_pci_probe, ...)
>>>>>            driver .probe
>>>>>              pci_enable_sriov
>>>>>                ...
>>>>>                  pci_bus_add_device
>>>>>                    ...
>>>>>                      pci_call_probe
>>>>>                        work_on_cpu(cpu, local_pci_probe, ...)
>>>>>
>>>>>      It would be better to fix PCI so we don't call VF driver .probe()
>>>>> methods
>>>>>      from inside a PF driver .probe() method, but that's a bigger
>>>>> project.
>>>>>
>>>>>      [bhelgaas: disable preemption, open bugzilla, rework comments &
>>>>> changelog]
>>>>>      Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
>>>>>      Link:
>>>>> http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ@mail.gmail.com
>>>>>      Link:
>>>>> http://lkml.kernel.org/r/20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com
>>>>>      Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>>>>>      Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>>>>      Acked-by: Tejun Heo <tj@kernel.org>
>>>>
>>>>
>>>> Tested-by: Yinghai Lu <yinghai@kernel.org>
>>>> Acked-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>>
>>> Thanks, I added these and pushed my for-linus branch for -next to
>>> pick up before I ask Linus to pull them.
>>
>>
>> Hi guys,
>>
>> This patch seems to be causing virtio (wouldn't it happen with any other
>> driver too?) to give
>> the following spew:
>
> Yep, Jiri Slaby reported this earlier.  I dropped those patches for
> now.  Yinghai and I both tested this without incident, but we must
> have tested quite the same scenario you did.
>
> I'll look at this more tomorrow.  My first thought is that it's
> probably silly to worry about preemption when checking the node.  It's
> unlikely that we'd be preempted (probably not even possible except at
> hot add-time), and the worst that can happen is we run the .probe()
> method on the wrong node, which means worse performance but correct
> functionality.

I dropped the preempt_disable() and re-added this to my for-linus
branch.  Let me know if you see any more issues.

Bjorn
