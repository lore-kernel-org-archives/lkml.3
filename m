Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab3DZGUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:20:55 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:59266 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3DZGUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:20:53 -0400
MIME-Version: 1.0
In-Reply-To: <5179FC4A.4080000@huawei.com>
References: <1366940820-15302-1-git-send-email-yinghai@kernel.org>
	<5179FC4A.4080000@huawei.com>
Date: Thu, 25 Apr 2013 23:20:53 -0700
X-Google-Sender-Auth: FKG9YPneZ-6_wq85TjVXdO6--Vo
Message-ID: <CAE9FiQXOQJRxqAW4q8G1OsiHAgFqz8=oD6-f-gvizSL0fR60hQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
From: Yinghai Lu <yinghai@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        David Bulkow <David.Bulkow@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 9:02 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> Hi Yinghai,
>    We should not remove this additional pci_disable_device().
> Because we enable pcie port device twice before. The first is pci_enable_brides(),
> in x86, it was called in pci_assign_unassigned_resources(). The second in pcie_port_device_register().
> So we should call pci_disable_device() twice for pci_dev->enable_cnt balance.
>
> But there is still a problem here. If we unbind a pcie port device pcie port driver, we can not
> use its child devices again, because this pcie port device was disabled absolutely.
>
> So I think we should move the second pci_disable_device() to remove.c.
>
> I sent this patch to Bjorn and following is Bjorn reply
> "And it's not clear to me whether unbinding the
> pcie port driver should disable the bridge at all.  I think one could
> argue that the bridge should remain functional even if the driver is
> unloaded, because the PCI core *enables* the bridge even if the driver
> is never loaded."
>
> Yinghai, how do you think about this issue?

1. we always enable bridges after assign unassigned resource for boot path
and hotplug path.
we should never call disable for that.

2. driver should be keep enable/disable during probe/remove

looks like we need to rethink pci enable bridge.

if we want to enable one pci device, we should go up  to enable all bridges till
root.

let if we disable one pci device, we need to go up to disable bridge if its all
pci device children get disabled.

if there is pci driver is bound with bridge device, those
disable/enable bridge should be skipped.

Thanks

Yinghai
