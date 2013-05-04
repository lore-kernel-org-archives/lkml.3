Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3EDEHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 00:07:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21433 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3EDEG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 00:06:58 -0400
From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
To: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
CC: Qinchuanyu <qinchuanyu@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        Luonengjun <luonengjun@huawei.com>
Subject: Re: KVM VM(rhel-5.5) %si is too high when TX/RX packets
Thread-Topic: KVM VM(rhel-5.5) %si is too high when TX/RX packets
Thread-Index: Ac5Hs1wISEMZKpucRUKMj7M5PG0M3gAxJBQw
Date: Sat, 4 May 2013 04:06:39 +0000
Message-ID: <D3E216785288A145B7BC975F83A2ED103FE3FE28@szxeml556-mbx.china.huawei.com>
References: <D3E216785288A145B7BC975F83A2ED103FE3BBB3@szxeml556-mbx.china.huawei.com>
In-Reply-To: <D3E216785288A145B7BC975F83A2ED103FE3BBB3@szxeml556-mbx.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.135.68.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I running a VM(RHEL-5.5) on KVM hypervisor(linux-3.8 + QEMU-1.4.1), and direct-assign intel 82576 VF to the VM. When TX/RX packets on VM to the other host via iperf tool, top tool result on VM shown that the %si is too high, approximately 95% ~ 100%, but from the view of host, the VM's total CPU usage is about 20% - 30%. And the throughput rate is approximately 200Mb/s, far from the line rate 1Gb/s, And, I found  the hardirq rate is lower than normal by running "watch -d -n 1 cat /proc/interrupts", I think it's caused by the too high %si, because the NIC's hardirq was disabled during the softirq process.
> Then, I direct-assign the intel 82576 to the VM, the same case happened too. 
> I found the intel 82576 and intel 82576 VF's interrupt mode are both PCI-MSI-X.
> 
> And,
> I rmmod the igb driver, and, re-insmod the igb driver(igb-4.1.2) with the parameter IntMode=0/1(0:legacy, 1:MSI, 2:MSI-x), the problem then gone, the %si is approximately 20% -30%, and the throughput rate came to the line rate, about 940Mb/s.
> I update the VM to RHEL-6.1, the problem disappeared too.
> And, I found a very strange thing, the VM's 82576VF's irq routing is set one time on Vf's one interrupt received, so frequently.

With regard to rhel-5.5(linux-2.6.18), in ISR process, mask and unmask msi-x vector function msi_set_mask_bit() was invoked every time, which result in VMEXIT, then QEMU will invoke kvm_irqchip_update_msi_route() to ask KVM hypervisor to update the VM irq routing table. In KVM hypervisor, synchronizing process needed after updating routing table, so much time consumed for waiting in wait_rcu_gp(). 
So %si in VM is so high, while from the view of host, VM's total CPU usage is so low. 

Why in ISR process, masking and unmasking msi-x vector is needed every time? 

Thanks,
Zhang Haoyu
