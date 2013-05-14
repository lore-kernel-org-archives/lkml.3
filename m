Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab3ENPnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:43:49 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47580 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3ENPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:43:45 -0400
MIME-Version: 1.0
In-Reply-To: <0EE9A1CDC8D6434DB00095CD7DB873462CFB0E4E@MTLDAG01.mtl.com>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
	<1368498506-25857-7-git-send-email-yinghai@kernel.org>
	<0EE9A1CDC8D6434DB00095CD7DB873462CFB0E4E@MTLDAG01.mtl.com>
Date: Tue, 14 May 2013 08:43:44 -0700
X-Google-Sender-Auth: yVTqgg18DKisoj1odXju5peV78w
Message-ID: <CAE9FiQVn4F+dTrQn0xsg-6QY9+HwbnJR=1CrjdoZkmF_LMrgpg@mail.gmail.com>
Subject: Re: [PATCH 6/7] PCI: Make sure VF's driver get attached after PF's
From: Yinghai Lu <yinghai@kernel.org>
To: Yan Burman <yanb@mellanox.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jack Morgenstein <jackm@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 1:58 AM, Yan Burman <yanb@mellanox.com> wrote:
>
>
>> -----Original Message-----
>> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>> On Behalf Of Yinghai Lu
>> Sent: Tuesday, May 14, 2013 05:31
>> To: Bjorn Helgaas
>> Cc: Gu Zheng; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Yinghai
>> Lu; netdev@vger.kernel.org
>> Subject: [PATCH 6/7] PCI: Make sure VF's driver get attached after PF's
>>
>> Found kernel try to load mlx4 drivers for VFs before PF's is really loaded when
>> the drivers are built-in, and kernel command line include probe_vfs=63,
>> num_vfs=63.
>>
>> It turns that it also happen for hotadd path even drivers are compiled as
>> modules and if they loaded. Esp some VF share the same driver with PF.
>>
>> calling path:
>>       device driver probe
>>               ==> pci_enable_sriov
>>                       ==> virtfn_add
>>                               ==> pci_dev_add
>>                               ==> pci_bus_device_add
>> when pci_bus_device_add is called, the VF's driver will be attached.
>> and at that time PF's driver does not finish yet.
>>
>> Need to move out pci_bus_device_add from virtfn_add and call it later. Fix
>> the problem for two path, 1. hotadd path: use device_schedule_callback.
>> 2. for booting path, use initcall to call that for all VF's.

>> Index: linux-2.6/drivers/net/ethernet/mellanox/mlx4/main.c
>> =================================================================
>> ==
>> --- linux-2.6.orig/drivers/net/ethernet/mellanox/mlx4/main.c
>> +++ linux-2.6/drivers/net/ethernet/mellanox/mlx4/main.c
>> @@ -2308,6 +2308,8 @@ slave_start:
>>       priv->pci_dev_data = pci_dev_data;
>>       pci_set_drvdata(pdev, dev);
>>
>> +     pci_bus_add_device_vfs(pdev);
>> +
>
> This seems wrong, since pci_bus_add_device_vfs() is being called for VF's as well as for PF when SRIOV is not enabled.
> I can see that there are sanity checks in pci_bus_add_vf() that would prevent this code from doing damage,
> but why schedule a callback that will do nothing if we can prevent scheduling altogether?
> It would probably be better to do the following:
>
> +       if (dev->flags & MLX4_FLAG_SRIOV)
> +               pci_bus_add_device_vfs(pdev);
> +

Yes, we can add that check.

BTW, do you have any plan to make mlx4 support sriov_configure via sysfs?

Yinghai
