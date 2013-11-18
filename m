Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3KRT3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:29:35 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43412 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3KRT3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <20131118181440.GA2996@google.com>
References: <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
	<CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
	<5270BFE7.4000602@huawei.com>
	<alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
	<20131031130647.0ff6f2c7@gandalf.local.home>
	<alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
	<20131113032804.GB19394@mtj.dyndns.org>
	<20131113073806.GA23244@mtj.dyndns.org>
	<20131116002820.GA31073@google.com>
	<20131116045356.GA5618@mtj.dyndns.org>
	<20131118181440.GA2996@google.com>
Date: Mon, 18 Nov 2013 11:29:32 -0800
X-Google-Sender-Auth: RVHEP3Y4VedjKkvXamfeqZsqBOk
Message-ID: <CAE9FiQW07ZAU_0bjkrwK54TAn48ByyS=kXNFwQJ-G2FFkK_W3A@mail.gmail.com>
Subject: Re: Possible regression with cgroups in 3.11
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>,
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
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:14 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> A bit of comment here would be nice but yeah I think this should work.
>> Can you please also queue the revert of c2fda509667b ("workqueue:
>> allow work_on_cpu() to be called recursively") after this patch?
>> Please feel free to add my acked-by.
>
> OK, below are the two patches (Alex's fix + the revert) I propose to
> merge.  Unless there are objections, I'll ask Linus to pull these
> before v3.13-rc1.
>
>
>
> commit 84f23f99b507c2c9247f47d3db0f71a3fd65e3a3
> Author: Alexander Duyck <alexander.h.duyck@intel.com>
> Date:   Mon Nov 18 10:59:59 2013 -0700
>
>     PCI: Avoid unnecessary CPU switch when calling driver .probe() method
>
>     If we are already on a CPU local to the device, call the driver .probe()
>     method directly without using work_on_cpu().
>
>     This is a workaround for a lockdep warning in the following scenario:
>
>       pci_call_probe
>         work_on_cpu(cpu, local_pci_probe, ...)
>           driver .probe
>             pci_enable_sriov
>               ...
>                 pci_bus_add_device
>                   ...
>                     pci_call_probe
>                       work_on_cpu(cpu, local_pci_probe, ...)
>
>     It would be better to fix PCI so we don't call VF driver .probe() methods
>     from inside a PF driver .probe() method, but that's a bigger project.
>
>     [bhelgaas: disable preemption, open bugzilla, rework comments & changelog]
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
>     Link: http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ@mail.gmail.com
>     Link: http://lkml.kernel.org/r/20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com
>     Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Tejun Heo <tj@kernel.org>

Tested-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>

>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 9042fdbd7244..add04e70ac2a 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -288,12 +288,24 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>         int error, node;
>         struct drv_dev_and_id ddi = { drv, dev, id };
>
> -       /* Execute driver initialization on node where the device's
> -          bus is attached to.  This way the driver likely allocates
> -          its local memory on the right node without any need to
> -          change it. */
> +       /*
> +        * Execute driver initialization on node where the device is
> +        * attached.  This way the driver likely allocates its local memory
> +        * on the right node.
> +        */
>         node = dev_to_node(&dev->dev);
> -       if (node >= 0) {
> +       preempt_disable();
> +
> +       /*
> +        * On NUMA systems, we are likely to call a PF probe function using
> +        * work_on_cpu().  If that probe calls pci_enable_sriov() (which
> +        * adds the VF devices via pci_bus_add_device()), we may re-enter
> +        * this function to call the VF probe function.  Calling
> +        * work_on_cpu() again will cause a lockdep warning.  Since VFs are
> +        * always on the same node as the PF, we can work around this by
> +        * avoiding work_on_cpu() when we're already on the correct node.
> +        */
> +       if (node >= 0 && node != numa_node_id()) {
>                 int cpu;
>
>                 get_online_cpus();
> @@ -305,6 +317,8 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>                 put_online_cpus();
>         } else
>                 error = local_pci_probe(&ddi);
> +
> +       preempt_enable();
>         return error;
>  }
