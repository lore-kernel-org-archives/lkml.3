Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3GEXgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:36:23 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45931 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3GEXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com>
References: <20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 5 Jul 2013 17:36:01 -0600
Message-ID: <CAErSpo70VKFxJqyZJKSp=CZ2x131Kz_+0vah3juTEuEx5RLX8A@mail.gmail.com>
Subject: Re: [PATCH] pci: Avoid unnecessary calls to work_on_cpu
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rusty]

On Mon, Jun 24, 2013 at 2:05 PM, Alexander Duyck
<alexander.h.duyck@intel.com> wrote:
> This patch is meant to address the fact that we are making unnecessary calls
> to work_on_cpu.  To resolve this I have added a check to see if the current
> node is the correct node for the device before we decide to assign the probe
> task to another CPU.
>
> The advantages to this approach is that we can avoid reentrant calls to
> work_on_cpu.  In addition we should not make any calls to setup the work
> remotely in the case of a single node system that has NUMA enabled.

The description above makes it sound like this is just a minor
performance enhancement, but I think the real reason you want this is
to resolve the lockdep warning mentioned at [1].  That thread is long
and confusing, so I'd like to see a bugzilla that distills out the
useful details, and a synopsis in this changelog.

[1] https://lkml.kernel.org/r/1368498506-25857-7-git-send-email-yinghai@kernel.org

> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
>
> This patch is based off of work I submitted in an earlier patch that I never
> heard back on.  The change was originally submitted in:
>   pci: Avoid reentrant calls to work_on_cpu
>
> I'm not sure what ever happened with that patch, however after reviewing it
> some myself I decided I could do without the change to the comments since they
> were unneeded.  As such I am resubmitting this as a much simpler patch that
> only adds the line of code needed to avoid calling work_on_cpu for every call
> to probe on an NUMA node specific device.
>
>  drivers/pci/pci-driver.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 79277fb..7d81713 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -282,7 +282,7 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>            its local memory on the right node without any need to
>            change it. */
>         node = dev_to_node(&dev->dev);
> -       if (node >= 0) {
> +       if ((node >= 0) && (node != numa_node_id())) {
>                 int cpu;
>
>                 get_online_cpus();

I think it's theoretically unsafe to use numa_node_id() while
preemption is enabled.

It seems a little strange to me that this "run the driver probe method
on the correct node" code is in PCI.  I would think this behavior
would be desirable for *all* bus types, not just PCI, so maybe it
would make sense to do this up in device_attach() or somewhere
similar.

But Rusty added this (in 873392ca51), and he knows way more about this
stuff than I do.

Bjorn
