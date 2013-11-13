Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab3KMHiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:38:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36171 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3KMHiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:38:16 -0500
Date: Wed, 13 Nov 2013 16:38:06 +0900
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, cgroups@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: Possible regression with cgroups in 3.11
Message-ID: <20131113073806.GA23244@mtj.dyndns.org>
References: <5258E584.70500@huawei.com>
 <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
 <525CB337.8050105@huawei.com>
 <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
 <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
 <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113032804.GB19394@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

cc'ing people from "workqueue, pci: INFO: possible recursive locking
detected" thread.

  http://thread.gmane.org/gmane.linux.kernel/1525779

So, to resolve that issue, we ripped out lockdep annotation from
work_on_cpu() and cgroup is now experiencing deadlock involving
work_on_cpu().  It *could* be that workqueue is actually broken or
memcg is looping but it doesn't seem like a very good idea to not have
lockdep annotation around work_on_cpu().

IIRC, there was one pci code path which called work_on_cpu()
recursively.  Would it be possible for that path to use something like
work_on_cpu_nested(XXX, depth) so that we can retain lockdep
annotation on work_on_cpu()?

Thanks.

-- 
tejun
