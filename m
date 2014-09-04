Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaIDGZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:25:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaIDGZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:25:22 -0400
Date: Thu, 4 Sep 2014 08:24:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@kernel.org>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        hpa@zytor.com, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140904062439.GD3190@worktop.ger.corp.intel.com>
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140904052034.GA29146@gmail.com>
 <5407FB37.2070306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5407FB37.2070306@jp.fujitsu.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 02:40:07PM +0900, Yasuaki Ishimatsu wrote:
> (2014/09/04 14:20), Ingo Molnar wrote:
> >
> >* Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
> >
> >>BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> >>IP: [..] find_busiest_group
> >>PGD 5a9d5067 PUD 13067 PMD 0
> >>Oops: 0000 [#3] SMP
> >>[...]
> >>Call Trace:
> >>load_balance
> >>? _raw_spin_unlock_irqrestore
> >>idle_balance
> >>__schedule
> >>schedule
> >>schedule_timeout
> >>? lock_timer_base
> >>schedule_timeout_uninterruptible
> >>msleep
> >>lock_device_hotplug_sysfs
> >>online_store
> >>dev_attr_store
> >>sysfs_write_file
> >>vfs_write
> >>SyS_write
> >>system_call_fastpath
> >>
> >>Last level cache shared map is built during cpu up and build sched domain
> >>routine takes advantage of it to setup sched domain cpu topology, however,
> >>llc shared map is unreleased during cpu disable which lead to invalid sched
> >>domain cpu topology. This patch fix it by release llc shared map correctly
> >>during cpu disable.
> >
> >Very little is said in this changelog about how the bug was
> >found, how likely it is to occur for others, what systems are
> >affected, etc.
> 
> Hi Wanpeng,
> 
> In my understanding, the panic occurs by just onlining CPU as follows:
> echo 1 > /sys/devices/system/cpu/cpuX/online
> 
> So, how about add the information?

>From what I remember you need a special kind of hardware too, one that
doesn't preserve cpu numbers across hotplug. Most systems do; just not
this magic special one.

We want to fix that, but the only reason for this patch is consistency
with the rest of the code, we do indeed clear and set these bits in all
other masks, but not this one.

But yes, the Changelog needs help.
