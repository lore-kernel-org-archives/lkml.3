Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3G3COr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:14:47 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61712 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3G3COq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:14:46 -0400
Message-ID: <51F72171.9070901@huawei.com>
Date: Tue, 30 Jul 2013 10:14:09 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH] PCI: update NumVFs register properly during enable/disable
 sriov
References: <1374657972-2456-1-git-send-email-wangyijing@huawei.com> <CAErSpo4jww8mX61-tw8aTXtv5TR2fCg_+6pfwPKHdwB=iL=mBA@mail.gmail.com>
In-Reply-To: <CAErSpo4jww8mX61-tw8aTXtv5TR2fCg_+6pfwPKHdwB=iL=mBA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/29 22:31, Bjorn Helgaas wrote:
> [+cc Don]
> 
> On Wed, Jul 24, 2013 at 3:26 AM, Yijing Wang <wangyijing@huawei.com> wrote:
>> Currently, we only update NumVFs register during sriov_enable().
>> This register should also be updated properly during sriov_disable.
>> Otherwise, we will get the stale "Number of VFs" info from lspci.
> 
> Has this always been broken, or was it broken by a recent change?
> 
> Can you post a transcript demonstrating what's going wrong?  Doesn't
> have to be in the changelog unless it's short, but just something to
> help reproduce the problem.


Hi Bjorn,
   It seems to be not a regression. This is not a serious problem, only
make users get stale "NumVFs" info from lspci.

Following is my demonstrating info:

euler-linux:~ # lspci -tv
-+-[0000:ff]-+-00.0  Intel Corporation Xeon 5600 Series QuickPath Architecture Generic Non-core Registers
...............[snip]...................
 \-[0000:00]-+-00.0  Intel Corporation 5500 I/O Hub to ESI Port
             +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
             +-07.0-[0000:03]--+-00.0  Intel Corporation 82576 Gigabit Network Connection         ----------------->support sriov
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-09.0-[0000:04]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:05]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z9s/Z9m (XG21 core)
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
             +-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller
             \-1f.5  Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2
euler-linux:~ # lspci -vvv -s 03:00.0
03:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET Dual Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
...........[snip]................
	Capabilities: [140] Device Serial Number 0c-da-21-ff-ff-ba-e2-90
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy+
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00  --------------------->total is 8, current number is 0
		VF offset: 128, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		VF Migration: offset: 00000000, BIR: 1
	Kernel driver in use: igb
	Kernel modules: igb

euler-linux:~ # cd /sys/bus/pci/devices/0000\:03\:00.0/
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # cat sriov_numvfs
0
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # cat sriov_totalvfs
7
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # echo 7 > sriov_numvfs             -------------------------->enable the sriov
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # lspci -tv
-+-[0000:ff]-+-00.0  Intel Corporation Xeon 5600 Series QuickPath Architecture Generic Non-core Registers
................[snip].....................
 \-[0000:00]-+-00.0  Intel Corporation 5500 I/O Hub to ESI Port
             +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
             +-07.0-[0000:03]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 +-00.1  Intel Corporation 82576 Gigabit Network Connection
             |                 +-10.0  Intel Corporation 82576 Virtual Function    -------------------------->the new VFs
             |                 +-10.2  Intel Corporation 82576 Virtual Function
             |                 +-10.4  Intel Corporation 82576 Virtual Function
             |                 +-10.6  Intel Corporation 82576 Virtual Function
             |                 +-11.0  Intel Corporation 82576 Virtual Function
             |                 +-11.2  Intel Corporation 82576 Virtual Function
             |                 \-11.4  Intel Corporation 82576 Virtual Function
             +-09.0-[0000:04]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:05]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z9s/Z9m (XG21 core)
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
             +-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller
             \-1f.5  Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # lspci -vvv -s 03:00.0
03:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET Dual Port Server Adapter
................[snip]......................
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable+ Migration- Interrupt- MSE+ ARIHierarchy+
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 7, Function Dependency Link: 00   ---------------------> Number of VFs is ok, updated properly
		VF offset: 128, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		VF Migration: offset: 00000000, BIR: 1
	Kernel driver in use: igb
	Kernel modules: igb

euler-linux:/sys/bus/pci/devices/0000:03:00.0 # echo 0 > sriov_numvfs             ---------------------> disable sriov
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # lspci -tv
-+-[0000:ff]-+-00.0  Intel Corporation Xeon 5600 Series QuickPath Architecture Generic Non-core Registers
................[snip]....................
 \-[0000:00]-+-00.0  Intel Corporation 5500 I/O Hub to ESI Port
             +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
             +-07.0-[0000:03]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-09.0-[0000:04]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:05]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z9s/Z9m (XG21 core)
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
             +-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller
             \-1f.5  Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # cat sriov_numvfs
0
euler-linux:/sys/bus/pci/devices/0000:03:00.0 # lspci -vvv -s 03:00.0
03:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET Dual Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
....................[snip].......................
	Capabilities: [140] Device Serial Number 0c-da-21-ff-ff-ba-e2-90
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy+
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 7, Function Dependency Link: 00   --------------------->problem: still the old info, should be updated to 0
		VF offset: 128, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		VF Migration: offset: 00000000, BIR: 1
	Kernel driver in use: igb
	Kernel modules: igb

euler-linux:/sys/bus/pci/devices/0000:03:00.0 #

Changes in sriov_enable() just avoid device write nr_virtfn to NumVFs register while enable failed.
Changes in sriov_disable() just make sriov update NumVFs properly.


Thanks!
Yijing.


> 
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/pci/iov.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index de8ffac..6e4844b 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -286,7 +286,6 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>>             (!(iov->cap & PCI_SRIOV_CAP_VFM) && (nr_virtfn > initial)))
>>                 return -EINVAL;
>>
>> -       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
>>         pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_OFFSET, &offset);
>>         pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_STRIDE, &stride);
>>         if (!offset || (nr_virtfn > 1 && !stride))
>> @@ -334,6 +333,7 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>>                         return rc;
>>         }
>>
>> +       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
>>         iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
>>         pci_cfg_access_lock(dev);
>>         pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>> @@ -368,6 +368,7 @@ failed:
>>         iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
>>         pci_cfg_access_lock(dev);
>>         pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>> +       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, 0);
>>         ssleep(1);
>>         pci_cfg_access_unlock(dev);
>>
>> @@ -401,6 +402,7 @@ static void sriov_disable(struct pci_dev *dev)
>>                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
>>
>>         iov->num_VFs = 0;
>> +       pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, 0);
>>  }
>>
>>  static int sriov_init(struct pci_dev *dev, int pos)
>> --
>> 1.7.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
Thanks!
Yijing

