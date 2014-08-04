Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaHDOrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:47:00 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64309 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaHDOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:46:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Date: Mon, 4 Aug 2014 16:45:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Paul.Mundt@huawei.com, Marc Zyngier <marc.zyngier@arm.com>,
        linux-pci@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        virtualization@lists.linux-foundation.org,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <201408011516.26253.arnd@arndb.de> <53DEFECB.3030201@huawei.com>
In-Reply-To: <53DEFECB.3030201@huawei.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408041645.50566.arnd@arndb.de>
X-Provags-ID: V02:K0:WVmIIseUFfDPmrKgXtg3oVrQ4d994uFuQdJIKW6vExu
 Aonmf5hjUA3CBcaR3PiJwJYwBytdKPyrKByxsXTGYni2eNfp88
 OEtBqScZapd9b7TFui5PHeY9bCUlHlvZriY16xRJpUDCnMA9kp
 2VjhDGta75251NOcG5ROOiifihVaAUuVpY2Z9/f5ZEInw70ITE
 civ6Lh/ONrLZFk+25A4mDa/mZe20U8ndH1xrnVhWSbzeO7rz+T
 JV19sY98Cr3aKJApiLTZuI66tTx1FHdx6t/P1LCN6iNJ8scxcQ
 Fe74PXpUAJ3H3j4Wcc0F1CkRSZRQ5flDS7rVZJaSH9pR4IshHF
 Pbf+nWy1ouY6r5cqGE/LMA/P1A0XjcrUnY/HMprj1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2014, Yijing Wang wrote:
> I have another question is some drivers will request more than one
> MSI/MSI-X IRQ, and the driver will use them to process different things.
> Eg. network driver generally uses one of them to process trivial network thins,
> and others to transmit/receive data.
> 
> So, in this case, it seems to driver need to touch the IRQ numbers.
> 
> wr-linux:~ # cat /proc/interrupts
>             CPU0       CPU1       CPU2     ....      CPU17      CPU18      CPU19      CPU20      CPU21      CPU22      CPU23
>  ......
>  100:          0          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0
>  101:          2          0          0               0          0          0  302830488          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-0
>  102:        110          0          0               0          0  360675897          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-1
>  103:        109          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-2
>  104:        107          0          0         9678933          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-3
>  105:        107          0          0               0  357838258          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-4
>  106:        115          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-5
>  107:        114          0          0               0          0          0          0  337866096          0          0  IR-PCI-MSI-edge      eth0-TxRx-6
>  108:  373801199          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-7
> 

I think in this example, you just need to request eight interrupts, and pass a
different data pointer each time, pointing to the napi_struct of each of the
NIC queues. The driver has no need to deal with the IRQ number at all,
and I would be surprised if it cared today.

	Arnd
