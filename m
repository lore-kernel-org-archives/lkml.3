Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3KPEyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 23:54:10 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38519 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3KPEyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 23:54:03 -0500
Date: Sat, 16 Nov 2013 13:53:56 +0900
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
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
        Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: Possible regression with cgroups in 3.11
Message-ID: <20131116045356.GA5618@mtj.dyndns.org>
References: <525CB337.8050105@huawei.com>
 <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
 <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
 <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org>
 <20131113073806.GA23244@mtj.dyndns.org>
 <20131116002820.GA31073@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131116002820.GA31073@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bjorn.

On Fri, Nov 15, 2013 at 05:28:20PM -0700, Bjorn Helgaas wrote:
> It would be better to fix PCI so we don't call VF driver .probe() methods
> from inside a PF driver .probe() method, but that's a bigger project.

Yeah, if pci doesn't need the recursion, we can simply revert restore
the lockdep annoation on work_on_cpu().

> @@ -293,7 +293,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  	   its local memory on the right node without any need to
>  	   change it. */
>  	node = dev_to_node(&dev->dev);
> -	if (node >= 0) {
> +	preempt_disable();
> +
> +	if (node >= 0 && node != numa_node_id()) {

A bit of comment here would be nice but yeah I think this should work.
Can you please also queue the revert of c2fda509667b ("workqueue:
allow work_on_cpu() to be called recursively") after this patch?
Please feel free to add my acked-by.

Thanks.

-- 
tejun
