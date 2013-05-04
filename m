Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3EDJ0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 05:26:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30338 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3EDJ0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 05:26:06 -0400
From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Luonengjun <luonengjun@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Qinchuanyu <qinchuanyu@huawei.com>
Subject: Re: KVM VM(rhel-5.5) %si is too high when TX/RX packets
Thread-Topic: KVM VM(rhel-5.5) %si is too high when TX/RX packets
Thread-Index: Ac5Hs1wISEMZKpucRUKMj7M5PG0M3gApUvGAABPW0OA=
Date: Sat, 4 May 2013 09:25:50 +0000
Message-ID: <D3E216785288A145B7BC975F83A2ED103FE40085@szxeml556-mbx.china.huawei.com>
References: <D3E216785288A145B7BC975F83A2ED103FE3BBB3@szxeml556-mbx.china.huawei.com>
 <5184BD35.2000207@redhat.com>
In-Reply-To: <5184BD35.2000207@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: C9Ae GiKj HgCd IGkb S2wm US+K YSkB ZqUD aljr cqOB dXAR
 i8Zl m2R2 neaq np1w
 pF1+;4;awB2AG0AQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBwAGIAbwBuAHoAaQBuAGkAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAcQBlAG0AdQAtAGQAZQB2AGUAbABAAG4AbwBuAGcAbgB1AC4AbwByAGcA;Sosha1_v1;7;{7A54BAD0-C7B4-498D-AD17-1C870B9847D8};aABhAG8AeQB1AC4AegBoAGEAbgBnAEAAaAB1AGEAdwBlAGkALgBjAG8AbQA=;Sat,
 04 May 2013 09:25:41
 GMT;UgBlADoAIABLAFYATQAgAFYATQAoAHIAaABlAGwALQA1AC4ANQApACAAJQBzAGkAIABpAHMAIAB0AG8AbwAgAGgAaQBnAGgAIAB3AGgAZQBuACAAVABYAC8AUgBYACAAcABhAGMAawBlAHQAcwA=
x-cr-puzzleid: {7A54BAD0-C7B4-498D-AD17-1C870B9847D8}
x-originating-ip: [10.135.68.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I running a VM(RHEL-5.5) on KVM hypervisor(linux-3.8 + QEMU-1.4.1), 
>> and direct-assign intel 82576 VF to the VM. When TX/RX packets on VM to the other host via iperf tool, top tool result on VM shown that the %si is too high, approximately 95% ~ 100%, but from the view of host, the VM's total CPU usage is about 20% - 30%. And the throughput rate is approximately 200Mb/s, far from the line rate 1Gb/s, And, I found  the hardirq rate is lower than normal by running "watch -d -n 1 cat /proc/interrupts", I think it's caused by the too high %si, because the NIC's hardirq was disabled during the softirq process.
>> Then, I direct-assign the intel 82576 to the VM, the same case happened too. 
>> I found the intel 82576 and intel 82576 VF's interrupt mode are both PCI-MSI-X.
>> 
>> And,
>> I rmmod the igb driver, and, re-insmod the igb driver(igb-4.1.2) with the parameter IntMode=0/1(0:legacy, 1:MSI, 2:MSI-x), the problem then gone, the %si is approximately 20% -30%, and the throughput rate came to the line rate, about 940Mb/s.
>> I update the VM to RHEL-6.1, the problem disappeared too.
>> And, I found a very strange thing, the VM's 82576VF's irq routing is set one time on Vf's one interrupt received, so frequently.
>
>RHEL 5.5 is a very old update.  Can you try RHEL 5.9?
>
>In any case, this looks a lot like a bug in the version of the driver that was included in RHEL5.5; you should contact Red Hat support services if you can still reproduce it with the latest RHEL5 update.
>
>Paolo

One patch has been proposed to QEMU, shown as below,

[PATCH] [KVM] Needless to update msi route when only msi-x entry "control" section changed
With regard to old version linux guest(e.g., rhel-5.5), in ISR processing, mask and unmask msi-x vector every time, which result in VMEXIT, then QEMU will invoke kvm_irqchip_update_msi_route() to ask KVM hypervisor to update the VM irq routing table. In KVM hypervisor, synchronizing RCU needed after updating routing table, so much time consumed for waiting in wait_rcu_gp(). So CPU usage in VM is so high, while from the view of host, VM's total CPU usage is so low. 
Masking/unmasking msi-x vector only set msi-x entry "control" section, needless to update VM irq routing table.

hw/i386/kvm/pci-assign.c | 3 +++
1 files changed, 3 insertions(+)

--- a/hw/i386/kvm/pci-assign.c  2013-05-04 15:53:18.000000000 +0800
+++ b/hw/i386/kvm/pci-assign.c  2013-05-04 15:50:46.000000000 +0800
@@ -1576,6 +1576,8 @@ static void assigned_dev_msix_mmio_write
                 MSIMessage msg;
                 int ret;

+                /* Needless to update msi route when only msi-x entry "control" section changed */
+                if ((addr & (PCI_MSIX_ENTRY_SIZE - 1)) != PCI_MSIX_ENTRY_VECTOR_CTRL){
                 msg.address = entry->addr_lo |
                     ((uint64_t)entry->addr_hi << 32);
                 msg.data = entry->data; @@ -1585,6 +1587,7 @@ static void assigned_dev_msix_mmio_write
                 if (ret) {
                     error_report("Error updating irq routing entry (%d)", ret);
                 }
+                }
             }
         }
     }

Thanks,
Zhang Haoyu
