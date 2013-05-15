Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3EOEjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:39:55 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37022 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3EOEjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:39:53 -0400
Message-ID: <51931196.2030903@gmail.com>
Date: Tue, 14 May 2013 21:39:50 -0700
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yan Burman <yanb@mellanox.com>, Sathya Perla <Sathya.Perla@Emulex.Com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] PCI: Make sure VF's driver get attached after
 PF's
References: <1368586102-17661-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1368586102-17661-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 07:48 PM, Yinghai Lu wrote:
> Found kernel try to load mlx4 drivers for VFs before
> PF's is loaded when the drivers are built-in, and kernel
> command line include probe_vfs=63, num_vfs=63.
> 
> [  169.581682] calling  mlx4_init+0x0/0x119 @ 1
> [  169.595681] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
> [  169.600194] mlx4_core: Initializing 0000:02:00.0
> [  169.616322] mlx4_core 0000:02:00.0: Enabling SR-IOV with 63 VFs
> [  169.724084] pci 0000:02:00.1: [15b3:1002] type 00 class 0x0c0600
> [  169.732442] mlx4_core: Initializing 0000:02:00.1
> [  169.734345] mlx4_core 0000:02:00.1: enabling device (0000 -> 0002)
> [  169.747060] mlx4_core 0000:02:00.1: enabling bus mastering
> [  169.764283] mlx4_core 0000:02:00.1: Detected virtual function - running in slave mode
> [  169.767409] mlx4_core 0000:02:00.1: with iommu 3 : domain 11
> [  169.785589] mlx4_core 0000:02:00.1: Sending reset
> [  179.790131] mlx4_core 0000:02:00.1: Got slave FLRed from Communication channel (ret:0x1)
> [  181.798661] mlx4_core 0000:02:00.1: slave is currently in themiddle of FLR. retrying...(try num:1)
> [  181.803336] mlx4_core 0000:02:00.1: Communication channel is not idle.my toggle is 1 (cmd:0x0)
> ...
> [  182.078710] mlx4_core 0000:02:00.1: slave is currently in themiddle of FLR. retrying...(try num:10)
> [  182.096657] mlx4_core 0000:02:00.1: Communication channel is not idle.my toggle is 1 (cmd:0x0)
> [  182.104935] mlx4_core 0000:02:00.1: slave driver version is not supported by the master
> [  182.118570] mlx4_core 0000:02:00.1: Communication channel is not idle.my toggle is 1 (cmd:0x0)
> [  182.138190] mlx4_core 0000:02:00.1: Failed to initialize slave
> [  182.141728] mlx4_core: probe of 0000:02:00.1 failed with error -5
> 
> It turns that this also happen for hotadd path even drivers are
> compiled as modules and if they are loaded. Esp some VF share the
> same driver with PF.
> 
> calling path:
> 	device driver probe
> 		==> pci_enable_sriov
> 			==> virtfn_add
> 				==> pci_dev_add
> 				==> pci_bus_device_add
> when pci_bus_device_add is called, the VF's driver will be attached.
> and at that time PF's driver does not finish yet.
> 
> Need to move out pci_bus_device_add from virtfn_add and call it
> later.
> 
> bnx2x and qlcnic are ok, because it does not modules command line
> to enable sriov. They must use sysfs to enable it.
> 
> be2net is ok, according to Sathya Perla,
> he fixed this issue in be2net with the following patch (commit b4c1df93)
>   http://marc.info/?l=linux-netdev&m=136801459808765&w=2
> 
> For igb and ixgbe is ok, as Alex Duyck said:
> | The VF driver should be able to be loaded when the PF driver is not
> | present.  We handle it in igb and ixgbe last I checked, and I don't see
> | any reason why it cannot be handled in all other VF drivers.  I'm not
> | saying the VF has to be able to fully functional, but it should be able
> | to detect the PF becoming enabled and then bring itself to a fully
> | functional state.  To not handle that case is a bug.
> 
> Looks like the patch will help enic, mlx4, efx, vxge and lpfc now.
> 
> -v2: don't use schedule_callback, and initcall after Alex's patch.
> 	pci: Avoid reentrant calls to work_on_cpu
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Alexander Duyck <alexander.h.duyck@intel.com>
> Cc: Yan Burman <yanb@mellanox.com>
> Cc: Sathya Perla <Sathya.Perla@Emulex.Com>
> Cc: netdev@vger.kernel.org
> 

This is a driver bug in mlx4 and possibly a few others, not a bug in the
SR-IOV code.  My concern is your patch may introduce issues in all of
the drivers, especially the ones that don't need this workaround.
Fixing the kernel to make this work is just encouraging a poor design model.

The problem is the mlx4 driver is enabling SR-IOV before it is ready to
support VFs.  The mlx4 driver should probably be fixed by either,
changing over to sysfs, provisioning the resources before enabling
SR-IOV like be2net, or via the igb/ixgbe approach where the VF
gracefully handles the PF not being present.

Thanks,

Alex




