Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbbAHBBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:01:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34336 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbAHBBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:01:18 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <54ADD6A2.5020807@jp.fujitsu.com>
Date: Thu, 8 Jan 2015 10:00:18 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <zhen-hual@hp.com>, <bhe@redhat.com>
CC: <dwmw2@infradead.org>, <joro@8bytes.org>, <vgoyal@redhat.com>,
        <dyoung@redhat.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <kexec@lists.infradead.org>, <alex.williamson@redhat.com>,
        <ddutile@redhat.com>, <ishii.hironobu@jp.fujitsu.com>,
        <bhelgaas@google.com>, <doug.hatch@hp.com>, <jerry.hoemann@hp.com>,
        <tom.vaden@hp.com>, <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        <billsumnerlinux@gmail.com>, <rwright@hp.com>
Subject: Re: [PATCH v7 0/10] iommu/vt-d: Fix intel vt-d faults in kdump kernel
References: <1420603474-4235-1-git-send-email-zhen-hual@hp.com> <54ACB1E9.9070904@hp.com> <20150107050247.GA16050@dhcp-16-116.nay.redhat.com> <54ACC35F.1070007@hp.com> <20150107082813.GB16050@dhcp-16-116.nay.redhat.com> <54ACF3CC.7090004@hp.com>
In-Reply-To: <54ACF3CC.7090004@hp.com>
Content-Type: multipart/mixed;
	boundary="------------080107040006090300080703"
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080107040006090300080703
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit

On 2015/01/07 17:52, Li, ZhenHua wrote:
> Well, that's quite good news.
> Looking forward Takao's testing on his system.

Unfortunately DMAR fault still occurs with this patch...
I attach console log.

Thanks,
Takao Indoh

> 
> Regards
> Zhenhua
> On 01/07/2015 04:28 PM, Baoquan He wrote:
>> On 01/07/15 at 01:25pm, Li, ZhenHua wrote:
>>> It is same as the last one I send to you yesterday.
>>>
>>> The continuous memory that needed for data in this patchset:
>>> RE: PAGE_SIZE, 4096 Bytes;
>>> IRTE: 65536 * 16 ; 1M Bytes;
>>>
>>> It should use same memory as the old versions of this patchset. The
>>> changes for the last version do not need more memory.
>>
>> Hi Zhenhua,
>>
>> It was my mistake because I didn't strip the debug info of modules, then
>> initramfs is bloated very big. Just now I tested the latest version, it
>> works well and dump is successful. No dmar fault and intr-remap fault
>> seen any more, good job!
>>
>> Thanks
>> Baoquan
>>
>>
>>>
>>> Regards
>>> Zhenhua
>>>
>>> On 01/07/2015 01:02 PM, Baoquan He wrote:
>>>> On 01/07/15 at 12:11pm, Li, ZhenHua wrote:
>>>>> Many thanks to Takao Indoh and Baoquan He, for your testing on more
>>>>> different systems.
>>>>>
>>>>> The calling of flush functions are added to this version.
>>>>>
>>>>> The usage of __iommu_flush_cache function :
>>>>> 1. Fixes a dump on Takao's system.
>>>>> 2. Reduces the count of faults on Baoquan's system.
>>>>
>>>> I am testing the version you sent to me yesterday afternoon. Is that
>>>> different with this patchset? I found your patchset man reserve a big
>>>> contiguous memory region under 896M, this will cause the crashkernel
>>>> reservation failed when I set crashkernel=320M. The reason I increase
>>>> the crashkerenl reservation to 320M is 256M is not enough and cause OOM
>>>> when that patchset is tested.
>>>>
>>>> I am checking what happened.
>>>>
>>>>
>>>> Thanks
>>>> Baoquan
>>>>
>>>>>
>>>>> Regards
>>>>> Zhenhua
>>>>>
>>>>> On 01/07/2015 12:04 PM, Li, Zhen-Hua wrote:
>>>>>> This patchset is an update of Bill Sumner's patchset, implements a fix for:
>>>>>> If a kernel boots with intel_iommu=on on a system that supports intel vt-d,
>>>>>> when a panic happens, the kdump kernel will boot with these faults:
>>>>>>
>>>>>>      dmar: DRHD: handling fault status reg 102
>>>>>>      dmar: DMAR:[DMA Read] Request device [01:00.0] fault addr fff80000
>>>>>>      DMAR:[fault reason 01] Present bit in root entry is clear
>>>>>>
>>>>>>      dmar: DRHD: handling fault status reg 2
>>>>>>      dmar: INTR-REMAP: Request device [[61:00.0] fault index 42
>>>>>>      INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
>>>>>>
>>>>>> On some system, the interrupt remapping fault will also happen even if the
>>>>>> intel_iommu is not set to on, because the interrupt remapping will be enabled
>>>>>> when x2apic is needed by the system.
>>>>>>
>>>>>> The cause of the DMA fault is described in Bill's original version, and the
>>>>>> INTR-Remap fault is caused by a similar reason. In short, the initialization
>>>>>> of vt-d drivers causes the in-flight DMA and interrupt requests get wrong
>>>>>> response.
>>>>>>
>>>>>> To fix this problem, we modifies the behaviors of the intel vt-d in the
>>>>>> crashdump kernel:
>>>>>>
>>>>>> For DMA Remapping:
>>>>>> 1. To accept the vt-d hardware in an active state,
>>>>>> 2. Do not disable and re-enable the translation, keep it enabled.
>>>>>> 3. Use the old root entry table, do not rewrite the RTA register.
>>>>>> 4. Malloc and use new context entry table and page table, copy data from the
>>>>>>     old ones that used by the old kernel.
>>>>>> 5. to use different portions of the iova address ranges for the device drivers
>>>>>>     in the crashdump kernel than the iova ranges that were in-use at the time
>>>>>>     of the panic.
>>>>>> 6. After device driver is loaded, when it issues the first dma_map command,
>>>>>>     free the dmar_domain structure for this device, and generate a new one, so
>>>>>>     that the device can be assigned a new and empty page table.
>>>>>> 7. When a new context entry table is generated, we also save its address to
>>>>>>     the old root entry table.
>>>>>>
>>>>>> For Interrupt Remapping:
>>>>>> 1. To accept the vt-d hardware in an active state,
>>>>>> 2. Do not disable and re-enable the interrupt remapping, keep it enabled.
>>>>>> 3. Use the old interrupt remapping table, do not rewrite the IRTA register.
>>>>>> 4. When ioapic entry is setup, the interrupt remapping table is changed, and
>>>>>>     the updated data will be stored to the old interrupt remapping table.
>>>>>>
>>>>>> Advantages of this approach:
>>>>>> 1. All manipulation of the IO-device is done by the Linux device-driver
>>>>>>     for that device.
>>>>>> 2. This approach behaves in a manner very similar to operation without an
>>>>>>     active iommu.
>>>>>> 3. Any activity between the IO-device and its RMRR areas is handled by the
>>>>>>     device-driver in the same manner as during a non-kdump boot.
>>>>>> 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
>>>>>>     This supports the practice of creating a special kdump kernel without
>>>>>>     drivers for any devices that are not required for taking a crashdump.
>>>>>> 5. Minimal code-changes among the existing mainline intel vt-d code.
>>>>>>
>>>>>> Summary of changes in this patch set:
>>>>>> 1. Added some useful function for root entry table in code intel-iommu.c
>>>>>> 2. Added new members to struct root_entry and struct irte;
>>>>>> 3. Functions to load old root entry table to iommu->root_entry from the memory
>>>>>>     of old kernel.
>>>>>> 4. Functions to malloc new context entry table and page table and copy the data
>>>>>>     from the old ones to the malloced new ones.
>>>>>> 5. Functions to enable support for DMA remapping in kdump kernel.
>>>>>> 6. Functions to load old irte data from the old kernel to the kdump kernel.
>>>>>> 7. Some code changes that support other behaviours that have been listed.
>>>>>> 8. In the new functions, use physical address as "unsigned long" type, not
>>>>>>     pointers.
>>>>>>
>>>>>> Original version by Bill Sumner:
>>>>>>      https://lkml.org/lkml/2014/1/10/518
>>>>>>      https://lkml.org/lkml/2014/4/15/716
>>>>>>      https://lkml.org/lkml/2014/4/24/836
>>>>>>
>>>>>> Zhenhua's updates:
>>>>>>      https://lkml.org/lkml/2014/10/21/134
>>>>>>      https://lkml.org/lkml/2014/12/15/121
>>>>>>      https://lkml.org/lkml/2014/12/22/53
>>>>>>
>>>>>> Changelog[v7]:
>>>>>>      1. Use __iommu_flush_cache to flush the data to hardware.
>>>>>>
>>>>>> Changelog[v6]:
>>>>>>      1. Use "unsigned long" as type of physical address.
>>>>>>      2. Use new function unmap_device_dma to unmap the old dma.
>>>>>>      3. Some small incorrect bits order for aw shift.
>>>>>>
>>>>>> Changelog[v5]:
>>>>>>      1. Do not disable and re-enable traslation and interrupt remapping.
>>>>>>      2. Use old root entry table.
>>>>>>      3. Use old interrupt remapping table.
>>>>>>      4. New functions to copy data from old kernel, and save to old kernel mem.
>>>>>>      5. New functions to save updated root entry table and irte table.
>>>>>>      6. Use intel_unmap to unmap the old dma;
>>>>>>      7. Allocate new pages while driver is being loaded.
>>>>>>
>>>>>> Changelog[v4]:
>>>>>>      1. Cut off the patches that move some defines and functions to new files.
>>>>>>      2. Reduce the numbers of patches to five, make it more easier to read.
>>>>>>      3. Changed the name of functions, make them consistent with current context
>>>>>>         get/set functions.
>>>>>>      4. Add change to function __iommu_attach_domain.
>>>>>>
>>>>>> Changelog[v3]:
>>>>>>      1. Commented-out "#define DEBUG 1" to eliminate debug messages.
>>>>>>      2. Updated the comments about changes in each version.
>>>>>>      3. Fixed: one-line added to Copy-Translations patch to initialize the iovad
>>>>>>            struct as recommended by Baoquan He [bhe@redhat.com]
>>>>>>            init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
>>>>>>
>>>>>> Changelog[v2]:
>>>>>>      The following series implements a fix for:
>>>>>>      A kdump problem about DMA that has been discussed for a long time. That is,
>>>>>>      when a kernel panics and boots into the kdump kernel, DMA started by the
>>>>>>      panicked kernel is not stopped before the kdump kernel is booted and the
>>>>>>      kdump kernel disables the IOMMU while this DMA continues.  This causes the
>>>>>>      IOMMU to stop translating the DMA addresses as IOVAs and begin to treat
>>>>>>      them as physical memory addresses -- which causes the DMA to either:
>>>>>>          (1) generate DMAR errors or
>>>>>>          (2) generate PCI SERR errors or
>>>>>>          (3) transfer data to or from incorrect areas of memory. Often this
>>>>>>              causes the dump to fail.
>>>>>>
>>>>>> Changelog[v1]:
>>>>>>      The original version.
>>>>>>
>>>>>> Changed in this version:
>>>>>> 1. Do not disable and re-enable traslation and interrupt remapping.
>>>>>> 2. Use old root entry table.
>>>>>> 3. Use old interrupt remapping table.
>>>>>> 4. Use "unsigned long" as physical address.
>>>>>> 5. Use intel_unmap to unmap the old dma;
>>>>>>
>>>>>> Baoquan He <bhe@redhat.com> helps testing this patchset.
>>>>>>
>>>>>>    iommu/vt-d: Update iommu_attach_domain() and its callers
>>>>>>    iommu/vt-d: Items required for kdump
>>>>>>    iommu/vt-d: Add domain-id functions
>>>>>>    iommu/vt-d: functions to copy data from old mem
>>>>>>    iommu/vt-d: Add functions to load and save old re
>>>>>>    iommu/vt-d: datatypes and functions used for kdump
>>>>>>    iommu/vt-d: enable kdump support in iommu module
>>>>>>    iommu/vt-d: assign new page table for dma_map
>>>>>>    iommu/vt-d: Copy functions for irte
>>>>>>    iommu/vt-d: Use old irte in kdump kernel
>>>>>>
>>>>>> Signed-off-by: Bill Sumner <billsumnerlinux@gmail.com>
>>>>>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>>>>>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>>>>>> Tested-by: Baoquan He <bhe@redhat.com>
>>>>>> ---
>>>>>>   drivers/iommu/intel-iommu.c         | 1050 +++++++++++++++++++++++++++++++++--
>>>>>>   drivers/iommu/intel_irq_remapping.c |  104 +++-
>>>>>>   include/linux/intel-iommu.h         |   18 +
>>>>>>   3 files changed, 1130 insertions(+), 42 deletions(-)
>>>>>>
>>>>>
>>>
> 
> 
> 


--------------080107040006090300080703
Content-Type: text/plain; charset="Shift_JIS"; name="log3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="log3.txt"

U3lzUnEgOiBUcmlnZ2VyIGEgY3Jhc2gNCkJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAg
ICAobnVsbCkNCklQOiBbPGZmZmZmZmZmODEzNWVkNzY+XSBzeXNycV9oYW5k
bGVfY3Jhc2grMHgxNi8weDIwDQpQR0QgMjM5ZDk1MDY3IFBVRCAyMzliMGEw
NjcgUE1EIDAgDQpPb3BzOiAwMDAyIFsjMV0gU01QIA0KTW9kdWxlcyBsaW5r
ZWQgaW46IGVidGFibGVfbmF0IGVidGFibGVzIHh0X0NIRUNLU1VNIGlwdGFi
bGVfbWFuZ2xlIGJyaWRnZSBhdXRvZnM0IDgwMjFxIGdhcnAgc3RwIGxsYyBj
cHVmcmVxX29uZGVtYW5kIGlwdF9SRUpFQ1QgbmZfcmVqZWN0X2lwdjQgbmZf
Y29ubnRyYWNrX2lwdjQgbmZfZGVmcmFnX2lwdjQgaXB0YWJsZV9maWx0ZXIg
aXBfdGFibGVzIGlwNnRfUkVKRUNUIG5mX3JlamVjdF9pcHY2IG5mX2Nvbm50
cmFja19pcHY2IG5mX2RlZnJhZ19pcHY2IHh0X3N0YXRlIG5mX2Nvbm50cmFj
ayBpcDZ0YWJsZV9maWx0ZXIgaXA2X3RhYmxlcyBpcHY2IHZob3N0X25ldCBt
YWN2dGFwIG1hY3ZsYW4gdmhvc3QgdHVuIGt2bV9pbnRlbCBrdm0gdWlucHV0
IGlUQ09fd2R0IGlUQ09fdmVuZG9yX3N1cHBvcnQgbWljcm9jb2RlIHNlcmlv
X3JhdyBwY3Nwa3IgdHBtX2luZmluZW9uIGlwbWlfc2kgaXBtaV9tc2doYW5k
bGVyIGkyY19pODAxIGxwY19pY2ggbWZkX2NvcmUgaW9hdGRtYSBpN2NvcmVf
ZWRhYyBlZGFjX2NvcmUgc2cgaWdiIGRjYSBpMmNfYWxnb19iaXQgcHRwIHBw
c19jb3JlIGFjcGlfY3B1ZnJlcSBleHQ0IGpiZDIgbWJjYWNoZSBtcHRzYXMg
bXB0c2NzaWggbXB0YmFzZSBzY3NpX3RyYW5zcG9ydF9zYXMgbHBmYyBzY3Np
X3RyYW5zcG9ydF9mYyBtZWdhcmFpZF9zYXMgZG1fbWlycm9yIGRtX3JlZ2lv
bl9oYXNoIGRtX2xvZyBkbV9tb2QNCkNQVTogNCBQSUQ6IDMwMDAgQ29tbTog
YmFzaCBOb3QgdGFpbnRlZCAzLjE5LjAtcmMzICMzNg0KSGFyZHdhcmUgbmFt
ZTogRlVKSVRTVS1TViBQUklNRVJHWSBCWDkyMCBTMi9EMzAzMCwgQklPUyAw
ODAwMTUgUmV2LjNEODEuMzAzMCAwMi8xMC8yMDEyDQp0YXNrOiBmZmZmODgw
MjM5MzFlMjUwIHRpOiBmZmZmODgwMjM5YjY0MDAwIHRhc2sudGk6IGZmZmY4
ODAyMzliNjQwMDANClJJUDogMDAxMDpbPGZmZmZmZmZmODEzNWVkNzY+XSAg
WzxmZmZmZmZmZjgxMzVlZDc2Pl0gc3lzcnFfaGFuZGxlX2NyYXNoKzB4MTYv
MHgyMA0KUlNQOiAwMDE4OmZmZmY4ODAyMzliNjdlODggIEVGTEFHUzogMDAw
MTAyOTYNClJBWDogMDAwMDAwMDAwMDAwMDAwZiBSQlg6IDAwMDAwMDAwMDAw
MDAwNjMgUkNYOiAwMDAwMDAwMDAwMDAwMDAwDQpSRFg6IGZmZmY4ODAyM2Zj
MGVhMzggUlNJOiBmZmZmODgwMjNmYzBkMjM4IFJESTogMDAwMDAwMDAwMDAw
MDA2Mw0KUkJQOiBmZmZmODgwMjM5YjY3ZTg4IFIwODogMDAwMDAwMDAwMDAx
OWNkOCBSMDk6IDAwMDAwMDAwMDAwMDA0YzQNClIxMDogMDAwMDAwMDAwMDAw
MDAwMyBSMTE6IDAwMDAwMDAwMDAwMDA0YzMgUjEyOiBmZmZmZmZmZjgxYWM0
YzAwDQpSMTM6IDAwMDAwMDAwMDAwMDAwMDggUjE0OiAwMDAwMDAwMDAwMDAw
MDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMQ0KRlM6ICAwMDAwN2YwMTIzNGYz
NzAwKDAwMDApIEdTOmZmZmY4ODAyM2ZjMDAwMDAoMDAwMCkga25sR1M6MDAw
MDAwMDAwMDAwMDAwMA0KQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzMw0KQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENS
MzogMDAwMDAwMDIzNTZlNjAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA3ZTANClN0
YWNrOg0KIGZmZmY4ODAyMzliNjdlYjggZmZmZmZmZmY4MTM1ZjZmMSAwMDAw
MDAwMDAwMDAwMDAyIGZmZmZmZmZmZmZmZmZmZmINCiAwMDAwN2YwMTIzNTA0
MDAwIGZmZmY4ODAyMzliNjdmNTAgZmZmZjg4MDIzOWI2N2VkOCBmZmZmZmZm
ZjgxMzVmNzhkDQogZmZmZjg4MDIzOWI2N2VmOCBmZmZmODgwMjM5NjBkZGMw
IGZmZmY4ODAyMzliNjdlZjggZmZmZmZmZmY4MTIwMTQwMw0KQ2FsbCBUcmFj
ZToNCiBbPGZmZmZmZmZmODEzNWY2ZjE+XSBfX2hhbmRsZV9zeXNycSsweDEy
MS8weDE4MA0KIFs8ZmZmZmZmZmY4MTM1Zjc4ZD5dIHdyaXRlX3N5c3JxX3Ry
aWdnZXIrMHgzZC8weDQwDQogWzxmZmZmZmZmZjgxMjAxNDAzPl0gcHJvY19y
ZWdfd3JpdGUrMHg0My8weDcwDQogWzxmZmZmZmZmZjgxMTlkYmJlPl0gdmZz
X3dyaXRlKzB4Y2UvMHgxODANCiBbPGZmZmZmZmZmODExOWUzMjY+XSBTeVNf
d3JpdGUrMHg1Ni8weGQwDQogWzxmZmZmZmZmZjgxMGVjYTNjPl0gPyBfX2F1
ZGl0X3N5c2NhbGxfZW50cnkrMHhhYy8weDExMA0KIFs8ZmZmZmZmZmY4MTVi
NjE1Mj5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTIvMHgxNw0KQ29kZTog
ZjEgNmIgMjUgMDAgMzEgYzAgZWIgYWUgOTAgOTAgOTAgOTAgOTAgOTAgOTAg
OTAgOTAgOTAgOTAgOTAgOTAgNTUgNDggODkgZTUgNjYgNjYgNjYgNjYgOTAg
YzcgMDUgZWQgMTcgYTAgMDAgMDEgMDAgMDAgMDAgMGYgYWUgZjggPGM2PiAw
NCAyNSAwMCAwMCAwMCAwMCAwMSBjOSBjMyA1NSA0OCA4OSBlNSA2NiA2NiA2
NiA2NiA5MCA4ZCA0NyANClJJUCAgWzxmZmZmZmZmZjgxMzVlZDc2Pl0gc3lz
cnFfaGFuZGxlX2NyYXNoKzB4MTYvMHgyMA0KIFJTUCA8ZmZmZjg4MDIzOWI2
N2U4OD4NCkNSMjogMDAwMDAwMDAwMDAwMDAwMA0KSW5pdGlhbGl6aW5nIGNn
cm91cCBzdWJzeXMgY3B1c2V0DQpJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5
cyBjcHUNCkluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIGNwdWFjY3QNCkxp
bnV4IHZlcnNpb24gMy4xOS4wLXJjMyAocm9vdEBpbmRvd3NYUCkgKGdjYyB2
ZXJzaW9uIDQuNC43IDIwMTIwMzEzIChSZWQgSGF0IDQuNC43LTQpIChHQ0Mp
ICkgIzM2IFNNUCBXZWQgSmFuIDcgMTg6MzM6MjQgSlNUIDIwMTUNCkNvbW1h
bmQgbGluZTogcm8gcm9vdD1VVUlEPWJmYzg4ZjYyLWYwODAtNDkyZi1hOWY1
LTE3ZjBjN2M2MjE1YSByZF9OT19MVUtTIGNvbnNvbGU9dHR5UzAsMTE1MjAw
bjggcmRfTk9fTUQgS0VZQk9BUkRUWVBFPXBjIEtFWVRBQkxFPWpwMTA2IExB
Tkc9amFfSlAuVVRGLTggcmRfTk9fTFZNIHJkX05PX0RNIGludGVsX2lvbW11
PW9uIGlycXBvbGwgbnJfY3B1cz0xIHJlc2V0X2RldmljZXMgY2dyb3VwX2Rp
c2FibGU9bWVtb3J5IG1jZT1vZmYgIG1lbW1hcD1leGFjdG1hcCBtZW1tYXA9
NjI3S0A0SyBtZW1tYXA9MTMwNDI1S0A3NzA2NzVLIGVsZmNvcmVoZHI9OTAx
MTAwSyBtZW1tYXA9NEskMEsgbWVtbWFwPTlLJDYzMUsgbWVtbWFwPTEwMEsk
OTI0SyBtZW1tYXA9OEskMzEzNzA4MEsgbWVtbWFwPTUySyMzMTM3MDg4SyBt
ZW1tYXA9MjA0SyMzMTM3MTQwSyBtZW1tYXA9NjRLJDMxMzczNDRLIG1lbW1h
cD04MjY4SyQzMTM3NDYwSyBtZW1tYXA9MjYyMTQ0SyQzNjcwMDE2SyBtZW1t
YXA9NEskNDE3NTg3MksgbWVtbWFwPTIwNDhLJDQxOTIyNTZLDQplODIwOiBC
SU9TLXByb3ZpZGVkIHBoeXNpY2FsIFJBTSBtYXA6DQpCSU9TLWU4MjA6IFtt
ZW0gMHgwMDAwMDAwMDAwMDAwMTAwLTB4MDAwMDAwMDAwMDA5ZGJmZl0gdXNh
YmxlDQpCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDAwMDlkYzAwLTB4MDAw
MDAwMDAwMDA5ZmZmZl0gcmVzZXJ2ZWQNCkJJT1MtZTgyMDogW21lbSAweDAw
MDAwMDAwMDAwZTcwMDAtMHgwMDAwMDAwMDAwMGZmZmZmXSByZXNlcnZlZA0K
QklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDAwMDEwMDAwMC0weDAwMDAwMDAw
YmY3N2ZmZmZdIHVzYWJsZQ0KQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBi
Zjc4ZTAwMC0weDAwMDAwMDAwYmY3OGZmZmZdIHJlc2VydmVkDQpCSU9TLWU4
MjA6IFttZW0gMHgwMDAwMDAwMGJmNzkwMDAwLTB4MDAwMDAwMDBiZjc5Y2Zm
Zl0gQUNQSSBkYXRhDQpCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGJmNzlk
MDAwLTB4MDAwMDAwMDBiZjdjZmZmZl0gQUNQSSBOVlMNCkJJT1MtZTgyMDog
W21lbSAweDAwMDAwMDAwYmY3ZDAwMDAtMHgwMDAwMDAwMGJmN2RmZmZmXSBy
ZXNlcnZlZA0KQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBiZjdlZDAwMC0w
eDAwMDAwMDAwYmZmZmZmZmZdIHJlc2VydmVkDQpCSU9TLWU4MjA6IFttZW0g
MHgwMDAwMDAwMGUwMDAwMDAwLTB4MDAwMDAwMDBlZmZmZmZmZl0gcmVzZXJ2
ZWQNCkJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwZmVlMDAwMDAtMHgwMDAw
MDAwMGZlZTAwZmZmXSByZXNlcnZlZA0KQklPUy1lODIwOiBbbWVtIDB4MDAw
MDAwMDBmZmUwMDAwMC0weDAwMDAwMDAwZmZmZmZmZmZdIHJlc2VydmVkDQpC
SU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMTAwMDAwMDAwLTB4MDAwMDAwMDIz
ZmZmZmZmZl0gdXNhYmxlDQplODIwOiBsYXN0X3BmbiA9IDB4MjQwMDAwIG1h
eF9hcmNoX3BmbiA9IDB4NDAwMDAwMDAwDQpOWCAoRXhlY3V0ZSBEaXNhYmxl
KSBwcm90ZWN0aW9uOiBhY3RpdmUNCmU4MjA6IHVzZXItZGVmaW5lZCBwaHlz
aWNhbCBSQU0gbWFwOg0KdXNlcjogW21lbSAweDAwMDAwMDAwMDAwMDAwMDAt
MHgwMDAwMDAwMDAwMDAwZmZmXSByZXNlcnZlZA0KdXNlcjogW21lbSAweDAw
MDAwMDAwMDAwMDEwMDAtMHgwMDAwMDAwMDAwMDlkYmZmXSB1c2FibGUNCnVz
ZXI6IFttZW0gMHgwMDAwMDAwMDAwMDlkYzAwLTB4MDAwMDAwMDAwMDA5ZmZm
Zl0gcmVzZXJ2ZWQNCnVzZXI6IFttZW0gMHgwMDAwMDAwMDAwMGU3MDAwLTB4
MDAwMDAwMDAwMDBmZmZmZl0gcmVzZXJ2ZWQNCnVzZXI6IFttZW0gMHgwMDAw
MDAwMDJmMDljYzAwLTB4MDAwMDAwMDAzNmZmYWZmZl0gdXNhYmxlDQp1c2Vy
OiBbbWVtIDB4MDAwMDAwMDBiZjc4ZTAwMC0weDAwMDAwMDAwYmY3OGZmZmZd
IHJlc2VydmVkDQp1c2VyOiBbbWVtIDB4MDAwMDAwMDBiZjc5MDAwMC0weDAw
MDAwMDAwYmY3Y2ZmZmZdIEFDUEkgZGF0YQ0KdXNlcjogW21lbSAweDAwMDAw
MDAwYmY3ZDAwMDAtMHgwMDAwMDAwMGJmN2RmZmZmXSByZXNlcnZlZA0KdXNl
cjogW21lbSAweDAwMDAwMDAwYmY3ZWQwMDAtMHgwMDAwMDAwMGJmZmZmZmZm
XSByZXNlcnZlZA0KdXNlcjogW21lbSAweDAwMDAwMDAwZTAwMDAwMDAtMHgw
MDAwMDAwMGVmZmZmZmZmXSByZXNlcnZlZA0KdXNlcjogW21lbSAweDAwMDAw
MDAwZmVlMDAwMDAtMHgwMDAwMDAwMGZlZTAwZmZmXSByZXNlcnZlZA0KdXNl
cjogW21lbSAweDAwMDAwMDAwZmZlMDAwMDAtMHgwMDAwMDAwMGZmZmZmZmZm
XSByZXNlcnZlZA0KU01CSU9TIDIuNSBwcmVzZW50Lg0KQUdQOiBObyBBR1Ag
YnJpZGdlIGZvdW5kDQplODIwOiBsYXN0X3BmbiA9IDB4MzZmZmIgbWF4X2Fy
Y2hfcGZuID0gMHg0MDAwMDAwMDANClBBVCBjb25maWd1cmF0aW9uIFswLTdd
OiBXQiAgV0MgIFVDLSBVQyAgV0IgIFdDICBVQy0gVUMgIA0KdG90YWwgUkFN
IGNvdmVyZWQ6IDgxODRNDQpGb3VuZCBvcHRpbWFsIHNldHRpbmcgZm9yIG10
cnIgY2xlYW4gdXANCiBncmFuX3NpemU6IDY0SyAJY2h1bmtfc2l6ZTogMTZN
IAludW1fcmVnOiA1ICAJbG9zZSBjb3ZlciBSQU06IDBHDQpmb3VuZCBTTVAg
TVAtdGFibGUgYXQgW21lbSAweDAwMGZmNzgwLTB4MDAwZmY3OGZdIG1hcHBl
ZCBhdCBbZmZmZjg4MDAwMDBmZjc4MF0NClVzaW5nIEdCIHBhZ2VzIGZvciBk
aXJlY3QgbWFwcGluZw0KaW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAweDAw
MDAwMDAwLTB4MDAwZmZmZmZdDQppbml0X21lbW9yeV9tYXBwaW5nOiBbbWVt
IDB4MzY4MDAwMDAtMHgzNjlmZmZmZl0NCmluaXRfbWVtb3J5X21hcHBpbmc6
IFttZW0gMHgzNDAwMDAwMC0weDM2N2ZmZmZmXQ0KaW5pdF9tZW1vcnlfbWFw
cGluZzogW21lbSAweDJmMDlkMDAwLTB4MzNmZmZmZmZdDQppbml0X21lbW9y
eV9tYXBwaW5nOiBbbWVtIDB4MzZhMDAwMDAtMHgzNmZmYWZmZl0NClJBTURJ
U0s6IFttZW0gMHgzNmFiNTAwMC0weDM2ZmVlZmZmXQ0KQUNQSTogRWFybHkg
dGFibGUgY2hlY2tzdW0gdmVyaWZpY2F0aW9uIGRpc2FibGVkDQpBQ1BJOiBS
U0RQIDB4MDAwMDAwMDAwMDBGQUE1MCAwMDAwMjQgKHYwMiBBQ1BJQU0pDQpB
Q1BJOiBYU0RUIDB4MDAwMDAwMDBCRjc5MDEwMCAwMDAwOTQgKHYwMSBBQUEg
ICAgICAgICAgICAgMjAxMjAyMTAgTVNGVCAwMDAwMDA5NykNCkFDUEk6IEZB
Q1AgMHgwMDAwMDAwMEJGNzkwMjkwIDAwMDBGNCAodjA0IDAyMTAxMiBGQUNQ
MTcxNyAyMDEyMDIxMCBNU0ZUIDAwMDAwMDk3KQ0KQUNQSSBCSU9TIFdhcm5p
bmcgKGJ1Zyk6IDMyLzY0WCBsZW5ndGggbWlzbWF0Y2ggaW4gRkFEVC9HcGUw
QmxvY2s6IDEyOC82NCAoMjAxNDExMDcvdGJmYWR0LTYxOCkNCkFDUEk6IERT
RFQgMHgwMDAwMDAwMEJGNzkwNkYwIDAwNzEyQiAodjAyIFRVMU8gICBUVTFP
M0Q4MSAwMDAwM0Q4MSBJTlRMIDIwMDUxMTE3KQ0KQUNQSTogRkFDUyAweDAw
MDAwMDAwQkY3OUQwMDAgMDAwMDQwDQpBQ1BJOiBBUElDIDB4MDAwMDAwMDBC
Rjc5MDM5MCAwMDAxMUUgKHYwMiAwMjEwMTIgQVBJQzE3MTcgMjAxMjAyMTAg
TVNGVCAwMDAwMDA5NykNCkFDUEk6IFNQQ1IgMHgwMDAwMDAwMEJGNzkwNEIw
IDAwMDA1MCAodjAxIDAyMTAxMiBTUENSMTcxNyAyMDEyMDIxMCBNU0ZUIDAw
MDAwMDk3KQ0KQUNQSTogTUNGRyAweDAwMDAwMDAwQkY3OTA1MDAgMDAwMDND
ICh2MDEgMDIxMDEyIE9FTU1DRkcgIDIwMTIwMjEwIE1TRlQgMDAwMDAwOTcp
DQpBQ1BJOiBTTElUIDB4MDAwMDAwMDBCRjc5MDU0MCAwMDAwMzAgKHYwMSAw
MjEwMTIgT0VNU0xJVCAgMjAxMjAyMTAgTVNGVCAwMDAwMDA5NykNCkFDUEk6
IFNMSUMgMHgwMDAwMDAwMEJGNzkwNTcwIDAwMDE3NiAodjAxIEFBQSAgICAg
ICAgICAgICAyMDEyMDIxMCBNU0ZUIDAwMDAwMDk3KQ0KQUNQSTogU1JBVCAw
eDAwMDAwMDAwQkY3OUE2RjAgMDAwMUQwICh2MDIgMDIxMDEyIE9FTVNSQVQg
IDAwMDAwMDAxIElOVEwgMDAwMDAwMDEpDQpBQ1BJOiBIUEVUIDB4MDAwMDAw
MDBCRjc5QThDMCAwMDAwMzggKHYwMSAwMjEwMTIgT0VNSFBFVCAgMjAxMjAy
MTAgTVNGVCAwMDAwMDA5NykNCkFDUEk6IERNQVIgMHgwMDAwMDAwMEJGNzlE
MEUwIDAwMDE0MCAodjAxIEFNSSAgICBPRU1ETUFSICAwMDAwMDAwMSBNU0ZU
IDAwMDAwMDk3KQ0KQUNQSTogU1NEVCAweDAwMDAwMDAwQkY3OUY5QTAgMDAw
MzYzICh2MDEgRHBnUG1tIENwdVBtICAgIDAwMDAwMDEyIElOVEwgMjAwNTEx
MTcpDQpBQ1BJOiBFSU5KIDB4MDAwMDAwMDBCRjc5QTkwMCAwMDAxMzAgKHYw
MSBBTUlFUiAgQU1JX0VJTkogMjAxMjAyMTAgTVNGVCAwMDAwMDA5NykNCkFD
UEk6IEJFUlQgMHgwMDAwMDAwMEJGNzlBQTkwIDAwMDAzMCAodjAxIEFNSUVS
ICBBTUlfQkVSVCAyMDEyMDIxMCBNU0ZUIDAwMDAwMDk3KQ0KQUNQSTogRVJT
VCAweDAwMDAwMDAwQkY3OUFBQzAgMDAwMUIwICh2MDEgQU1JRVIgIEFNSV9F
UlNUIDIwMTIwMjEwIE1TRlQgMDAwMDAwOTcpDQpBQ1BJOiBIRVNUIDB4MDAw
MDAwMDBCRjc5QUM3MCAwMDAwQTggKHYwMSBBTUlFUiAgQUJDX0hFU1QgMjAx
MjAyMTAgTVNGVCAwMDAwMDA5NykNClNSQVQ6IFBYTSAwIC0+IEFQSUMgMHgw
MCAtPiBOb2RlIDANClNSQVQ6IFBYTSAwIC0+IEFQSUMgMHgwMiAtPiBOb2Rl
IDANClNSQVQ6IFBYTSAwIC0+IEFQSUMgMHgxMiAtPiBOb2RlIDANClNSQVQ6
IFBYTSAwIC0+IEFQSUMgMHgxNCAtPiBOb2RlIDANClNSQVQ6IFBYTSAwIC0+
IEFQSUMgMHgwMSAtPiBOb2RlIDANClNSQVQ6IFBYTSAwIC0+IEFQSUMgMHgw
MyAtPiBOb2RlIDANClNSQVQ6IFBYTSAwIC0+IEFQSUMgMHgxMyAtPiBOb2Rl
IDANClNSQVQ6IFBYTSAwIC0+IEFQSUMgMHgxNSAtPiBOb2RlIDANClNSQVQ6
IFBYTSAxIC0+IEFQSUMgMHgyMCAtPiBOb2RlIDENClNSQVQ6IFBYTSAxIC0+
IEFQSUMgMHgyMiAtPiBOb2RlIDENClNSQVQ6IFBYTSAxIC0+IEFQSUMgMHgz
MiAtPiBOb2RlIDENClNSQVQ6IFBYTSAxIC0+IEFQSUMgMHgzNCAtPiBOb2Rl
IDENClNSQVQ6IFBYTSAxIC0+IEFQSUMgMHgyMSAtPiBOb2RlIDENClNSQVQ6
IFBYTSAxIC0+IEFQSUMgMHgyMyAtPiBOb2RlIDENClNSQVQ6IFBYTSAxIC0+
IEFQSUMgMHgzMyAtPiBOb2RlIDENClNSQVQ6IFBYTSAxIC0+IEFQSUMgMHgz
NSAtPiBOb2RlIDENClNSQVQ6IE5vZGUgMCBQWE0gMCBbbWVtIDB4MDAwMDAw
MDAtMHgwMDA5ZmZmZl0NClNSQVQ6IE5vZGUgMCBQWE0gMCBbbWVtIDB4MDAx
MDAwMDAtMHhiZmZmZmZmZl0NClNSQVQ6IE5vZGUgMCBQWE0gMCBbbWVtIDB4
MTAwMDAwMDAwLTB4MTNmZmZmZmZmXQ0KU1JBVDogTm9kZSAxIFBYTSAxIFtt
ZW0gMHgxNDAwMDAwMDAtMHgyM2ZmZmZmZmZdDQpOVU1BOiBOb2RlIDAgW21l
bSAweDAwMDAwMDAwLTB4MDAwOWZmZmZdICsgW21lbSAweDAwMTAwMDAwLTB4
MzZmZmFmZmZdIC0+IFttZW0gMHgwMDAwMDAwMC0weDM2ZmZhZmZmXQ0KTk9E
RV9EQVRBKDApIGFsbG9jYXRlZCBbbWVtIDB4MzZhOGYwMDAtMHgzNmFiNGZm
Zl0NClpvbmUgcmFuZ2VzOg0KICBETUEgICAgICBbbWVtIDB4MDAwMDEwMDAt
MHgwMGZmZmZmZl0NCiAgRE1BMzIgICAgW21lbSAweDAxMDAwMDAwLTB4MzZm
ZmFmZmZdDQogIE5vcm1hbCAgIGVtcHR5DQpNb3ZhYmxlIHpvbmUgc3RhcnQg
Zm9yIGVhY2ggbm9kZQ0KRWFybHkgbWVtb3J5IG5vZGUgcmFuZ2VzDQogIG5v
ZGUgICAwOiBbbWVtIDB4MDAwMDEwMDAtMHgwMDA5Y2ZmZl0NCiAgbm9kZSAg
IDA6IFttZW0gMHgyZjA5ZDAwMC0weDM2ZmZhZmZmXQ0KSW5pdG1lbSBzZXR1
cCBub2RlIDAgW21lbSAweDAwMDAxMDAwLTB4MzZmZmFmZmZdDQpBQ1BJOiBQ
TS1UaW1lciBJTyBQb3J0OiAweDgwOA0KQUNQSTogTEFQSUMgKGFjcGlfaWRb
MHgwMV0gbGFwaWNfaWRbMHgwMF0gZW5hYmxlZCkNCkFDUEk6IE5SX0NQVVMv
cG9zc2libGVfY3B1cyBsaW1pdCBvZiAxIGFsbW9zdCByZWFjaGVkLiBLZWVw
aW5nIG9uZSBzbG90IGZvciBib290IGNwdS4gIFByb2Nlc3NvciAwLzB4MCBp
Z25vcmVkLg0KQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwMl0gbGFwaWNfaWRb
MHgwMl0gZW5hYmxlZCkNCkFDUEk6IE5SX0NQVVMvcG9zc2libGVfY3B1cyBs
aW1pdCBvZiAxIGFsbW9zdCByZWFjaGVkLiBLZWVwaW5nIG9uZSBzbG90IGZv
ciBib290IGNwdS4gIFByb2Nlc3NvciAxLzB4MiBpZ25vcmVkLg0KQUNQSTog
TEFQSUMgKGFjcGlfaWRbMHgwM10gbGFwaWNfaWRbMHgxMl0gZW5hYmxlZCkN
CkFDUEk6IE5SX0NQVVMvcG9zc2libGVfY3B1cyBsaW1pdCBvZiAxIGFsbW9z
dCByZWFjaGVkLiBLZWVwaW5nIG9uZSBzbG90IGZvciBib290IGNwdS4gIFBy
b2Nlc3NvciAyLzB4MTIgaWdub3JlZC4NCkFDUEk6IExBUElDIChhY3BpX2lk
WzB4MDRdIGxhcGljX2lkWzB4MTRdIGVuYWJsZWQpDQpBQ1BJOiBOUl9DUFVT
L3Bvc3NpYmxlX2NwdXMgbGltaXQgb2YgMSBhbG1vc3QgcmVhY2hlZC4gS2Vl
cGluZyBvbmUgc2xvdCBmb3IgYm9vdCBjcHUuICBQcm9jZXNzb3IgMy8weDE0
IGlnbm9yZWQuDQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDA1XSBsYXBpY19p
ZFsweDIwXSBlbmFibGVkKQ0KQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwNl0g
bGFwaWNfaWRbMHgyMl0gZW5hYmxlZCkNCkFDUEk6IE5SX0NQVVMvcG9zc2li
bGVfY3B1cyBsaW1pdCBvZiAxIHJlYWNoZWQuICBQcm9jZXNzb3IgNS8weDIy
IGlnbm9yZWQuDQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDA3XSBsYXBpY19p
ZFsweDMyXSBlbmFibGVkKQ0KQUNQSTogTlJfQ1BVUy9wb3NzaWJsZV9jcHVz
IGxpbWl0IG9mIDEgcmVhY2hlZC4gIFByb2Nlc3NvciA2LzB4MzIgaWdub3Jl
ZC4NCkFDUEk6IExBUElDIChhY3BpX2lkWzB4MDhdIGxhcGljX2lkWzB4MzRd
IGVuYWJsZWQpDQpBQ1BJOiBOUl9DUFVTL3Bvc3NpYmxlX2NwdXMgbGltaXQg
b2YgMSByZWFjaGVkLiAgUHJvY2Vzc29yIDcvMHgzNCBpZ25vcmVkLg0KQUNQ
STogTEFQSUMgKGFjcGlfaWRbMHgwOV0gbGFwaWNfaWRbMHgwMV0gZW5hYmxl
ZCkNCkFDUEk6IE5SX0NQVVMvcG9zc2libGVfY3B1cyBsaW1pdCBvZiAxIHJl
YWNoZWQuICBQcm9jZXNzb3IgOC8weDEgaWdub3JlZC4NCkFDUEk6IExBUElD
IChhY3BpX2lkWzB4MGFdIGxhcGljX2lkWzB4MDNdIGVuYWJsZWQpDQpBQ1BJ
OiBOUl9DUFVTL3Bvc3NpYmxlX2NwdXMgbGltaXQgb2YgMSByZWFjaGVkLiAg
UHJvY2Vzc29yIDkvMHgzIGlnbm9yZWQuDQpBQ1BJOiBMQVBJQyAoYWNwaV9p
ZFsweDBiXSBsYXBpY19pZFsweDEzXSBlbmFibGVkKQ0KQUNQSTogTlJfQ1BV
Uy9wb3NzaWJsZV9jcHVzIGxpbWl0IG9mIDEgcmVhY2hlZC4gIFByb2Nlc3Nv
ciAxMC8weDEzIGlnbm9yZWQuDQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDBj
XSBsYXBpY19pZFsweDE1XSBlbmFibGVkKQ0KQUNQSTogTlJfQ1BVUy9wb3Nz
aWJsZV9jcHVzIGxpbWl0IG9mIDEgcmVhY2hlZC4gIFByb2Nlc3NvciAxMS8w
eDE1IGlnbm9yZWQuDQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDBkXSBsYXBp
Y19pZFsweDIxXSBlbmFibGVkKQ0KQUNQSTogTlJfQ1BVUy9wb3NzaWJsZV9j
cHVzIGxpbWl0IG9mIDEgcmVhY2hlZC4gIFByb2Nlc3NvciAxMi8weDIxIGln
bm9yZWQuDQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDBlXSBsYXBpY19pZFsw
eDIzXSBlbmFibGVkKQ0KQUNQSTogTlJfQ1BVUy9wb3NzaWJsZV9jcHVzIGxp
bWl0IG9mIDEgcmVhY2hlZC4gIFByb2Nlc3NvciAxMy8weDIzIGlnbm9yZWQu
DQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDBmXSBsYXBpY19pZFsweDMzXSBl
bmFibGVkKQ0KQUNQSTogTlJfQ1BVUy9wb3NzaWJsZV9jcHVzIGxpbWl0IG9m
IDEgcmVhY2hlZC4gIFByb2Nlc3NvciAxNC8weDMzIGlnbm9yZWQuDQpBQ1BJ
OiBMQVBJQyAoYWNwaV9pZFsweDEwXSBsYXBpY19pZFsweDM1XSBlbmFibGVk
KQ0KQUNQSTogTlJfQ1BVUy9wb3NzaWJsZV9jcHVzIGxpbWl0IG9mIDEgcmVh
Y2hlZC4gIFByb2Nlc3NvciAxNS8weDM1IGlnbm9yZWQuDQpBQ1BJOiBMQVBJ
QyAoYWNwaV9pZFsweDExXSBsYXBpY19pZFsweDkwXSBkaXNhYmxlZCkNCkFD
UEk6IExBUElDIChhY3BpX2lkWzB4MTJdIGxhcGljX2lkWzB4OTFdIGRpc2Fi
bGVkKQ0KQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgxM10gbGFwaWNfaWRbMHg5
Ml0gZGlzYWJsZWQpDQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDE0XSBsYXBp
Y19pZFsweDkzXSBkaXNhYmxlZCkNCkFDUEk6IExBUElDIChhY3BpX2lkWzB4
MTVdIGxhcGljX2lkWzB4OTRdIGRpc2FibGVkKQ0KQUNQSTogTEFQSUMgKGFj
cGlfaWRbMHgxNl0gbGFwaWNfaWRbMHg5NV0gZGlzYWJsZWQpDQpBQ1BJOiBM
QVBJQyAoYWNwaV9pZFsweDE3XSBsYXBpY19pZFsweDk2XSBkaXNhYmxlZCkN
CkFDUEk6IExBUElDIChhY3BpX2lkWzB4MThdIGxhcGljX2lkWzB4OTddIGRp
c2FibGVkKQ0KQUNQSTogTEFQSUNfTk1JIChhY3BpX2lkWzB4ZmZdIGhpZ2gg
ZGZsIGxpbnRbMHgxXSkNCkFDUEk6IElPQVBJQyAoaWRbMHgwNl0gYWRkcmVz
c1sweGZlYzAwMDAwXSBnc2lfYmFzZVswXSkNCklPQVBJQ1swXTogYXBpY19p
ZCA2LCB2ZXJzaW9uIDMyLCBhZGRyZXNzIDB4ZmVjMDAwMDAsIEdTSSAwLTIz
DQpBQ1BJOiBJT0FQSUMgKGlkWzB4MDddIGFkZHJlc3NbMHhmZWM4YTAwMF0g
Z3NpX2Jhc2VbMjRdKQ0KSU9BUElDWzFdOiBhcGljX2lkIDcsIHZlcnNpb24g
MzIsIGFkZHJlc3MgMHhmZWM4YTAwMCwgR1NJIDI0LTQ3DQpBQ1BJOiBJTlRf
U1JDX09WUiAoYnVzIDAgYnVzX2lycSAwIGdsb2JhbF9pcnEgMiBkZmwgZGZs
KQ0KQUNQSTogSU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgOSBnbG9iYWxf
aXJxIDkgaGlnaCBsZXZlbCkNClVzaW5nIEFDUEkgKE1BRFQpIGZvciBTTVAg
Y29uZmlndXJhdGlvbiBpbmZvcm1hdGlvbg0KQUNQSTogSFBFVCBpZDogMHg4
MDg2YTMwMSBiYXNlOiAweGZlZDAwMDAwDQpzbXBib290OiAyNCBQcm9jZXNz
b3JzIGV4Y2VlZHMgTlJfQ1BVUyBsaW1pdCBvZiAxDQpzbXBib290OiBBbGxv
d2luZyAxIENQVXMsIDAgaG90cGx1ZyBDUFVzDQpQTTogUmVnaXN0ZXJlZCBu
b3NhdmUgbWVtb3J5OiBbbWVtIDB4MDAwMDAwMDAtMHgwMDAwMGZmZl0NClBN
OiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IFttZW0gMHgwMDA5ZDAwMC0w
eDAwMDlkZmZmXQ0KUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogW21l
bSAweDAwMDllMDAwLTB4MDAwOWZmZmZdDQpQTTogUmVnaXN0ZXJlZCBub3Nh
dmUgbWVtb3J5OiBbbWVtIDB4MDAwYTAwMDAtMHgwMDBlNmZmZl0NClBNOiBS
ZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IFttZW0gMHgwMDBlNzAwMC0weDAw
MGZmZmZmXQ0KUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogW21lbSAw
eDAwMTAwMDAwLTB4MmYwOWNmZmZdDQplODIwOiBbbWVtIDB4MzZmZmIwMDAt
MHhiZjc4ZGZmZl0gYXZhaWxhYmxlIGZvciBQQ0kgZGV2aWNlcw0Kc2V0dXBf
cGVyY3B1OiBOUl9DUFVTOjgxOTIgbnJfY3B1bWFza19iaXRzOjEgbnJfY3B1
X2lkczoxIG5yX25vZGVfaWRzOjINClBFUkNQVTogRW1iZWRkZWQgMjkgcGFn
ZXMvY3B1IEBmZmZmODgwMDM2NjAwMDAwIHM4MDY0MCByODE5MiBkMjk5NTIg
dTIwOTcxNTINCkJ1aWx0IDEgem9uZWxpc3RzIGluIE5vZGUgb3JkZXIsIG1v
YmlsaXR5IGdyb3VwaW5nIG9uLiAgVG90YWwgcGFnZXM6IDMyMjkxDQpQb2xp
Y3kgem9uZTogRE1BMzINCktlcm5lbCBjb21tYW5kIGxpbmU6IHJvIHJvb3Q9
VVVJRD1iZmM4OGY2Mi1mMDgwLTQ5MmYtYTlmNS0xN2YwYzdjNjIxNWEgcmRf
Tk9fTFVLUyBjb25zb2xlPXR0eVMwLDExNTIwMG44IHJkX05PX01EIEtFWUJP
QVJEVFlQRT1wYyBLRVlUQUJMRT1qcDEwNiBMQU5HPWphX0pQLlVURi04IHJk
X05PX0xWTSByZF9OT19ETSBpbnRlbF9pb21tdT1vbiBpcnFwb2xsIG5yX2Nw
dXM9MSByZXNldF9kZXZpY2VzIGNncm91cF9kaXNhYmxlPW1lbW9yeSBtY2U9
b2ZmICBtZW1tYXA9ZXhhY3RtYXAgbWVtbWFwPTYyN0tANEsgbWVtbWFwPTEz
MDQyNUtANzcwNjc1SyBlbGZjb3JlaGRyPTkwMTEwMEsgbWVtbWFwPTRLJDBL
IG1lbW1hcD05SyQ2MzFLIG1lbW1hcD0xMDBLJDkyNEsgbWVtbWFwPThLJDMx
MzcwODBLIG1lbW1hcD01MksjMzEzNzA4OEsgbWVtbWFwPTIwNEsjMzEzNzE0
MEsgbWVtbWFwPTY0SyQzMTM3MzQ0SyBtZW1tYXA9ODI2OEskMzEzNzQ2MEsg
bWVtbWFwPTI2MjE0NEskMzY3MDAxNksgbWVtbWFwPTRLJDQxNzU4NzJLIG1l
bW1hcD0yMDQ4SyQ0MTkyMjU2Sw0KSW50ZWwtSU9NTVU6IGVuYWJsZWQNCk1p
c3JvdXRlZCBJUlEgZml4dXAgYW5kIHBvbGxpbmcgc3VwcG9ydCBlbmFibGVk
DQpUaGlzIG1heSBzaWduaWZpY2FudGx5IGltcGFjdCBzeXN0ZW0gcGVyZm9y
bWFuY2UNClBJRCBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMiAob3JkZXI6IDAs
IDQwOTYgYnl0ZXMpDQpBR1A6IENoZWNraW5nIGFwZXJ0dXJlLi4uDQpBR1A6
IE5vIEFHUCBicmlkZ2UgZm91bmQNCk1lbW9yeTogMTAxNTY4Sy8xMzEwNDhL
IGF2YWlsYWJsZSAoNTg2N0sga2VybmVsIGNvZGUsIDExOTlLIHJ3ZGF0YSwg
Mjg0OEsgcm9kYXRhLCAxNzQ4SyBpbml0LCAyMTA0SyBic3MsIDI5NDgwSyBy
ZXNlcnZlZCwgMEsgY21hLXJlc2VydmVkKQ0KSGllcmFyY2hpY2FsIFJDVSBp
bXBsZW1lbnRhdGlvbi4NCglSQ1UgcmVzdHJpY3RpbmcgQ1BVcyBmcm9tIE5S
X0NQVVM9ODE5MiB0byBucl9jcHVfaWRzPTEuDQpSQ1U6IEFkanVzdGluZyBn
ZW9tZXRyeSBmb3IgcmN1X2Zhbm91dF9sZWFmPTE2LCBucl9jcHVfaWRzPTEN
Ck5SX0lSUVM6NTI0NTQ0IG5yX2lycXM6MjU2IDE2DQpTcHVyaW91cyBMQVBJ
QyB0aW1lciBpbnRlcnJ1cHQgb24gY3B1IDANCkNvbnNvbGU6IGNvbG91ciBk
dW1teSBkZXZpY2UgODB4MjUNCmNvbnNvbGUgW3R0eVMwXSBlbmFibGVkDQp0
c2M6IEZhc3QgVFNDIGNhbGlicmF0aW9uIHVzaW5nIFBJVA0KdHNjOiBEZXRl
Y3RlZCAyMTMzLjQxNCBNSHogcHJvY2Vzc29yDQpDYWxpYnJhdGluZyBkZWxh
eSBsb29wIChza2lwcGVkKSwgdmFsdWUgY2FsY3VsYXRlZCB1c2luZyB0aW1l
ciBmcmVxdWVuY3kuLiA0MjY2LjgyIEJvZ29NSVBTIChscGo9MjEzMzQxNCkN
CnBpZF9tYXg6IGRlZmF1bHQ6IDMyNzY4IG1pbmltdW06IDMwMQ0KQUNQSTog
Q29yZSByZXZpc2lvbiAyMDE0MTEwNw0KQUNQSTogQWxsIEFDUEkgVGFibGVz
IHN1Y2Nlc3NmdWxseSBhY3F1aXJlZA0KU2VjdXJpdHkgRnJhbWV3b3JrIGlu
aXRpYWxpemVkDQpTRUxpbnV4OiAgSW5pdGlhbGl6aW5nLg0KRGVudHJ5IGNh
Y2hlIGhhc2ggdGFibGUgZW50cmllczogMTYzODQgKG9yZGVyOiA1LCAxMzEw
NzIgYnl0ZXMpDQpJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDgx
OTIgKG9yZGVyOiA0LCA2NTUzNiBieXRlcykNCk1vdW50LWNhY2hlIGhhc2gg
dGFibGUgZW50cmllczogNTEyIChvcmRlcjogMCwgNDA5NiBieXRlcykNCk1v
dW50cG9pbnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA1MTIgKG9yZGVy
OiAwLCA0MDk2IGJ5dGVzKQ0KSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMg
ZGV2aWNlcw0KSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgZnJlZXplcg0K
SW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgbmV0X2Nscw0KSW5pdGlhbGl6
aW5nIGNncm91cCBzdWJzeXMgYmxraW8NCkluaXRpYWxpemluZyBjZ3JvdXAg
c3Vic3lzIHBlcmZfZXZlbnQNCkNQVTogUGh5c2ljYWwgUHJvY2Vzc29yIElE
OiAxDQpDUFU6IFByb2Nlc3NvciBDb3JlIElEOiAwDQpMYXN0IGxldmVsIGlU
TEIgZW50cmllczogNEtCIDUxMiwgMk1CIDcsIDRNQiA3DQpMYXN0IGxldmVs
IGRUTEIgZW50cmllczogNEtCIDUxMiwgMk1CIDMyLCA0TUIgMzIsIDFHQiAw
DQpGcmVlaW5nIFNNUCBhbHRlcm5hdGl2ZXMgbWVtb3J5OiAyMEsgKGZmZmZm
ZmZmODFjZTIwMDAgLSBmZmZmZmZmZjgxY2U3MDAwKQ0KZnRyYWNlOiBhbGxv
Y2F0aW5nIDIzOTA2IGVudHJpZXMgaW4gOTQgcGFnZXMNCmRtYXI6IEhvc3Qg
YWRkcmVzcyB3aWR0aCA0MA0KZG1hcjogRFJIRCBiYXNlOiAweDAwMDAwMGZi
ZmZlMDAwIGZsYWdzOiAweDENCmRtYXI6IElPTU1VIDA6IHJlZ19iYXNlX2Fk
ZHIgZmJmZmUwMDAgdmVyIDE6MCBjYXAgYzkwNzgwMTA2ZjA0NjIgZWNhcCBm
MDIwN2UNCmRtYXI6IFJNUlIgYmFzZTogMHgwMDAwMDAwMDBlNzAwMCBlbmQ6
IDB4MDAwMDAwMDAwZTlmZmYNCmRtYXI6IFJNUlIgYmFzZTogMHgwMDAwMDBi
ZjdlZDAwMCBlbmQ6IDB4MDAwMDAwYmY3ZmZmZmYNCmRtYXI6IEFUU1IgZmxh
Z3M6IDB4MA0KSU9BUElDIGlkIDYgdW5kZXIgRFJIRCBiYXNlICAweGZiZmZl
MDAwIElPTU1VIDANCklPQVBJQyBpZCA3IHVuZGVyIERSSEQgYmFzZSAgMHhm
YmZmZTAwMCBJT01NVSAwDQpFbmFibGVkIElSUSByZW1hcHBpbmcgaW4geGFw
aWMgbW9kZQ0KLi5USU1FUjogdmVjdG9yPTB4MzAgYXBpYzE9MCBwaW4xPTIg
YXBpYzI9LTEgcGluMj0tMQ0Kc21wYm9vdDogQ1BVMDogSW50ZWwoUikgWGVv
bihSKSBDUFUgICAgICAgICAgIEw1NjMwICBAIDIuMTNHSHogKGZhbTogMDYs
IG1vZGVsOiAyYywgc3RlcHBpbmc6IDAyKQ0KUGVyZm9ybWFuY2UgRXZlbnRz
OiBQRUJTIGZtdDErLCAxNi1kZWVwIExCUiwgV2VzdG1lcmUgZXZlbnRzLCBC
cm9rZW4gQklPUyBkZXRlY3RlZCwgY29tcGxhaW4gdG8geW91ciBoYXJkd2Fy
ZSB2ZW5kb3IuDQpbRmlybXdhcmUgQnVnXTogdGhlIEJJT1MgaGFzIGNvcnJ1
cHRlZCBody1QTVUgcmVzb3VyY2VzIChNU1IgMzhkIGlzIGIwKQ0KSW50ZWwg
UE1VIGRyaXZlci4NCnBlcmZfZXZlbnRfaW50ZWw6IENQVUlEIG1hcmtlZCBl
dmVudDogJ2J1cyBjeWNsZXMnIHVuYXZhaWxhYmxlDQouLi4gdmVyc2lvbjog
ICAgICAgICAgICAgICAgMw0KLi4uIGJpdCB3aWR0aDogICAgICAgICAgICAg
IDQ4DQouLi4gZ2VuZXJpYyByZWdpc3RlcnM6ICAgICAgNA0KLi4uIHZhbHVl
IG1hc2s6ICAgICAgICAgICAgIDAwMDBmZmZmZmZmZmZmZmYNCi4uLiBtYXgg
cGVyaW9kOiAgICAgICAgICAgICAwMDAwMDAwMDdmZmZmZmZmDQouLi4gZml4
ZWQtcHVycG9zZSBldmVudHM6ICAgMw0KLi4uIGV2ZW50IG1hc2s6ICAgICAg
ICAgICAgIDAwMDAwMDA3MDAwMDAwMGYNCng4NjogQm9vdGVkIHVwIDEgbm9k
ZSwgMSBDUFVzDQpzbXBib290OiBUb3RhbCBvZiAxIHByb2Nlc3NvcnMgYWN0
aXZhdGVkICg0MjY2LjgyIEJvZ29NSVBTKQ0KTk1JIHdhdGNoZG9nOiBlbmFi
bGVkIG9uIGFsbCBDUFVzLCBwZXJtYW5lbnRseSBjb25zdW1lcyBvbmUgaHct
UE1VIGNvdW50ZXIuDQpkZXZ0bXBmczogaW5pdGlhbGl6ZWQNCk5FVDogUmVn
aXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTYNCmNwdWlkbGU6IHVzaW5nIGdv
dmVybm9yIGxhZGRlcg0KY3B1aWRsZTogdXNpbmcgZ292ZXJub3IgbWVudQ0K
QUNQSSBGQURUIGRlY2xhcmVzIHRoZSBzeXN0ZW0gZG9lc24ndCBzdXBwb3J0
IFBDSWUgQVNQTSwgc28gZGlzYWJsZSBpdA0KQUNQSTogYnVzIHR5cGUgUENJ
IHJlZ2lzdGVyZWQNCmFjcGlwaHA6IEFDUEkgSG90IFBsdWcgUENJIENvbnRy
b2xsZXIgRHJpdmVyIHZlcnNpb246IDAuNQ0KUENJOiBNTUNPTkZJRyBmb3Ig
ZG9tYWluIDAwMDAgW2J1cyAwMC1mZl0gYXQgW21lbSAweGUwMDAwMDAwLTB4
ZWZmZmZmZmZdIChiYXNlIDB4ZTAwMDAwMDApDQpQQ0k6IE1NQ09ORklHIGF0
IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmXSByZXNlcnZlZCBpbiBFODIw
DQpQQ0k6IFVzaW5nIGNvbmZpZ3VyYXRpb24gdHlwZSAxIGZvciBiYXNlIGFj
Y2Vzcw0KQUNQSTogQWRkZWQgX09TSShNb2R1bGUgRGV2aWNlKQ0KQUNQSTog
QWRkZWQgX09TSShQcm9jZXNzb3IgRGV2aWNlKQ0KQUNQSTogQWRkZWQgX09T
SSgzLjAgX1NDUCBFeHRlbnNpb25zKQ0KQUNQSTogQWRkZWQgX09TSShQcm9j
ZXNzb3IgQWdncmVnYXRvciBEZXZpY2UpDQpBQ1BJOiBFeGVjdXRlZCAxIGJs
b2NrcyBvZiBtb2R1bGUtbGV2ZWwgZXhlY3V0YWJsZSBBTUwgY29kZQ0KQUNQ
STogSW50ZXJwcmV0ZXIgZW5hYmxlZA0KQUNQSSBFeGNlcHRpb246IEFFX05P
VF9GT1VORCwgV2hpbGUgZXZhbHVhdGluZyBTbGVlcCBTdGF0ZSBbXF9TMl9d
ICgyMDE0MTEwNy9od3hmYWNlLTU4MCkNCkFDUEkgRXhjZXB0aW9uOiBBRV9O
T1RfRk9VTkQsIFdoaWxlIGV2YWx1YXRpbmcgU2xlZXAgU3RhdGUgW1xfUzNf
XSAoMjAxNDExMDcvaHd4ZmFjZS01ODApDQpBQ1BJOiAoc3VwcG9ydHMgUzAg
UzEgUzQgUzUpDQpBQ1BJOiBVc2luZyBJT0FQSUMgZm9yIGludGVycnVwdCBy
b3V0aW5nDQpIRVNUOiBUYWJsZSBwYXJzaW5nIGhhcyBiZWVuIGluaXRpYWxp
emVkLg0KUENJOiBVc2luZyBob3N0IGJyaWRnZSB3aW5kb3dzIGZyb20gQUNQ
STsgaWYgbmVjZXNzYXJ5LCB1c2UgInBjaT1ub2NycyIgYW5kIHJlcG9ydCBh
IGJ1Zw0KQUNQSTogUENJIFJvb3QgQnJpZGdlIFtQQ0kwXSAoZG9tYWluIDAw
MDAgW2J1cyAwMC1mZl0pDQphY3BpIFBOUDBBMDg6MDA6IF9PU0M6IE9TIHN1
cHBvcnRzIFtFeHRlbmRlZENvbmZpZyBBU1BNIENsb2NrUE0gU2VnbWVudHMg
TVNJXQ0KYWNwaSBQTlAwQTA4OjAwOiBfT1NDIGZhaWxlZCAoQUVfTk9UX0ZP
VU5EKTsgZGlzYWJsaW5nIEFTUE0NCmFjcGkgUE5QMEEwODowMDogaWdub3Jp
bmcgaG9zdCBicmlkZ2Ugd2luZG93IFttZW0gMHgwMDBkMDAwMC0weDAwMGRm
ZmZmXSAoY29uZmxpY3RzIHdpdGggQWRhcHRlciBST00gW21lbSAweDAwMGNl
ODAwLTB4MDAwZDRmZmZdKQ0KUENJIGhvc3QgYnJpZGdlIHRvIGJ1cyAwMDAw
OjAwDQpwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFtidXMg
MDAtZmZdDQpwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFtp
byAgMHgwMDAwLTB4MGNmN10NCnBjaV9idXMgMDAwMDowMDogcm9vdCBidXMg
cmVzb3VyY2UgW2lvICAweDBkMDAtMHhmZmZmXQ0KcGNpX2J1cyAwMDAwOjAw
OiByb290IGJ1cyByZXNvdXJjZSBbbWVtIDB4MDAwYTAwMDAtMHgwMDBiZmZm
Zl0NCnBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAw
eGMwMDAwMDAwLTB4ZGZmZmZmZmZdDQpwY2lfYnVzIDAwMDA6MDA6IHJvb3Qg
YnVzIHJlc291cmNlIFttZW0gMHhmMDAwMDAwMC0weGZlZDhmZmZmXQ0KcGNp
IDAwMDA6MDA6MDEuMDogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJ
DQpwY2kgMDAwMDowMDowMi4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5
IEFDUEkNCnBjaSAwMDAwOjAwOjAzLjA6IFN5c3RlbSB3YWtldXAgZGlzYWJs
ZWQgYnkgQUNQSQ0KcGNpIDAwMDA6MDA6MDcuMDogU3lzdGVtIHdha2V1cCBk
aXNhYmxlZCBieSBBQ1BJDQpwY2kgMDAwMDowMDowOC4wOiBTeXN0ZW0gd2Fr
ZXVwIGRpc2FibGVkIGJ5IEFDUEkNCnBjaSAwMDAwOjAwOjA5LjA6IFN5c3Rl
bSB3YWtldXAgZGlzYWJsZWQgYnkgQUNQSQ0KcGNpIDAwMDA6MDA6MGEuMDog
U3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJDQpwY2kgMDAwMDowMDox
YS4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkNCnBjaSAwMDAw
OjAwOjFhLjE6IFN5c3RlbSB3YWtldXAgZGlzYWJsZWQgYnkgQUNQSQ0KcGNp
IDAwMDA6MDA6MWEuMjogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJ
DQpwY2kgMDAwMDowMDoxYS43OiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5
IEFDUEkNCnBjaSAwMDAwOjAwOjFjLjA6IFN5c3RlbSB3YWtldXAgZGlzYWJs
ZWQgYnkgQUNQSQ0KcGNpIDAwMDA6MDA6MWQuMDogU3lzdGVtIHdha2V1cCBk
aXNhYmxlZCBieSBBQ1BJDQpwY2kgMDAwMDowMDoxZC4xOiBTeXN0ZW0gd2Fr
ZXVwIGRpc2FibGVkIGJ5IEFDUEkNCnBjaSAwMDAwOjAwOjFkLjI6IFN5c3Rl
bSB3YWtldXAgZGlzYWJsZWQgYnkgQUNQSQ0KcGNpIDAwMDA6MDA6MWQuNzog
U3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJDQpwY2kgMDAwMDowMDox
ZS4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkNCnBjaSAwMDAw
OjAxOjAwLjA6IFN5c3RlbSB3YWtldXAgZGlzYWJsZWQgYnkgQUNQSQ0KcGNp
IDAwMDA6MDE6MDAuMTogU3lzdGVtIHdha2V1cCBkaXNhYmxlZCBieSBBQ1BJ
DQpwY2kgMDAwMDowMDowMS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDFdDQpw
Y2kgMDAwMDowMjowMC4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFD
UEkNCnBjaSAwMDAwOjAyOjAwLjE6IFN5c3RlbSB3YWtldXAgZGlzYWJsZWQg
YnkgQUNQSQ0KcGNpIDAwMDA6MDA6MDIuMDogUENJIGJyaWRnZSB0byBbYnVz
IDAyXQ0KcGNpIDAwMDA6MDA6MDMuMDogUENJIGJyaWRnZSB0byBbYnVzIDAz
XQ0KcGNpIDAwMDA6MDA6MDcuMDogUENJIGJyaWRnZSB0byBbYnVzIDEwXQ0K
cGNpIDAwMDA6MDA6MDguMDogUENJIGJyaWRnZSB0byBbYnVzIDIwXQ0KcGNp
IDAwMDA6MDA6MDkuMDogUENJIGJyaWRnZSB0byBbYnVzIDMwXQ0KcGNpIDAw
MDA6MDA6MGEuMDogUENJIGJyaWRnZSB0byBbYnVzIDQwXQ0KcGNpIDAwMDA6
MDA6MWMuMDogUENJIGJyaWRnZSB0byBbYnVzIDUwXQ0KcGNpIDAwMDA6MDA6
MWMuNDogUENJIGJyaWRnZSB0byBbYnVzIDYwXQ0KcGNpIDAwMDA6MDA6MWUu
MDogUENJIGJyaWRnZSB0byBbYnVzIDYxXSAoc3VidHJhY3RpdmUgZGVjb2Rl
KQ0KQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktBXSAoSVJRcyAzIDQg
NiA3ICoxMCAxMSAxMiAxNCAxNSksIGRpc2FibGVkLg0KQUNQSTogUENJIElu
dGVycnVwdCBMaW5rIFtMTktCXSAoSVJRcyAqNSksIGRpc2FibGVkLg0KQUNQ
STogUENJIEludGVycnVwdCBMaW5rIFtMTktDXSAoSVJRcyAzIDQgNiA3IDEw
ICoxMSAxMiAxNCAxNSksIGRpc2FibGVkLg0KQUNQSTogUENJIEludGVycnVw
dCBMaW5rIFtMTktEXSAoSVJRcyAzIDQgNiA3IDEwIDExIDEyIDE0ICoxNSks
IGRpc2FibGVkLg0KQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktFXSAo
SVJRcyAzIDQgNiA3IDEwIDExIDEyIDE0IDE1KSAqMCwgZGlzYWJsZWQuDQpB
Q1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0ZdIChJUlFzIDMgNCA2IDcg
MTAgMTEgMTIgKjE0IDE1KSwgZGlzYWJsZWQuDQpBQ1BJOiBQQ0kgSW50ZXJy
dXB0IExpbmsgW0xOS0ddIChJUlFzIDMgNCA2IDcgMTAgMTEgMTIgMTQgMTUp
ICowLCBkaXNhYmxlZC4NCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5L
SF0gKElSUXMgKjMgNCA2IDcgMTAgMTEgMTIgMTQgMTUpLCBkaXNhYmxlZC4N
CkFDUEk6IEVuYWJsZWQgMiBHUEVzIGluIGJsb2NrIDAwIHRvIDNGDQp2Z2Fh
cmI6IHNldHRpbmcgYXMgYm9vdCBkZXZpY2U6IFBDSTowMDAwOjYwOjAwLjAN
CnZnYWFyYjogZGV2aWNlIGFkZGVkOiBQQ0k6MDAwMDo2MDowMC4wLGRlY29k
ZXM9aW8rbWVtLG93bnM9aW8rbWVtLGxvY2tzPW5vbmUNCnZnYWFyYjogbG9h
ZGVkDQp2Z2FhcmI6IGJyaWRnZSBjb250cm9sIHBvc3NpYmxlIDAwMDA6NjA6
MDAuMA0KU0NTSSBzdWJzeXN0ZW0gaW5pdGlhbGl6ZWQNCkFDUEk6IGJ1cyB0
eXBlIFVTQiByZWdpc3RlcmVkDQp1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBp
bnRlcmZhY2UgZHJpdmVyIHVzYmZzDQp1c2Jjb3JlOiByZWdpc3RlcmVkIG5l
dyBpbnRlcmZhY2UgZHJpdmVyIGh1Yg0KdXNiY29yZTogcmVnaXN0ZXJlZCBu
ZXcgZGV2aWNlIGRyaXZlciB1c2INClBDSTogVXNpbmcgQUNQSSBmb3IgSVJR
IHJvdXRpbmcNClBDSTogRGlzY292ZXJlZCBwZWVyIGJ1cyBmZQ0KUENJIGhv
c3QgYnJpZGdlIHRvIGJ1cyAwMDAwOmZlDQpwY2lfYnVzIDAwMDA6ZmU6IHJv
b3QgYnVzIHJlc291cmNlIFtpbyAgMHgwMDAwLTB4ZmZmZl0NCnBjaV9idXMg
MDAwMDpmZTogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweDAwMDAwMDAwLTB4
ZmZmZmZmZmZmZl0NCnBjaV9idXMgMDAwMDpmZTogTm8gYnVzbiByZXNvdXJj
ZSBmb3VuZCBmb3Igcm9vdCBidXMsIHdpbGwgdXNlIFtidXMgZmUtZmZdDQpQ
Q0k6IERpc2NvdmVyZWQgcGVlciBidXMgZmYNClBDSSBob3N0IGJyaWRnZSB0
byBidXMgMDAwMDpmZg0KcGNpX2J1cyAwMDAwOmZmOiByb290IGJ1cyByZXNv
dXJjZSBbaW8gIDB4MDAwMC0weGZmZmZdDQpwY2lfYnVzIDAwMDA6ZmY6IHJv
b3QgYnVzIHJlc291cmNlIFttZW0gMHgwMDAwMDAwMC0weGZmZmZmZmZmZmZd
DQpwY2lfYnVzIDAwMDA6ZmY6IE5vIGJ1c24gcmVzb3VyY2UgZm91bmQgZm9y
IHJvb3QgYnVzLCB3aWxsIHVzZSBbYnVzIGZmLWZmXQ0KTmV0TGFiZWw6IElu
aXRpYWxpemluZw0KTmV0TGFiZWw6ICBkb21haW4gaGFzaCBzaXplID0gMTI4
DQpOZXRMYWJlbDogIHByb3RvY29scyA9IFVOTEFCRUxFRCBDSVBTT3Y0DQpO
ZXRMYWJlbDogIHVubGFiZWxlZCB0cmFmZmljIGFsbG93ZWQgYnkgZGVmYXVs
dA0KaHBldDA6IGF0IE1NSU8gMHhmZWQwMDAwMCwgSVJRcyAyLCA4LCAwLCAw
DQpocGV0MDogNCBjb21wYXJhdG9ycywgNjQtYml0IDE0LjMxODE4MCBNSHog
Y291bnRlcg0KU3dpdGNoZWQgdG8gY2xvY2tzb3VyY2UgaHBldA0KcG5wOiBQ
blAgQUNQSSBpbml0DQpzeXN0ZW0gMDA6MDA6IFttZW0gMHhmYmYwMDAwMC0w
eGZiZmZmZmZmXSBjb3VsZCBub3QgYmUgcmVzZXJ2ZWQNCnN5c3RlbSAwMDow
MDogW21lbSAweGZjMDAwMDAwLTB4ZmNmZmZmZmZdIGhhcyBiZWVuIHJlc2Vy
dmVkDQpzeXN0ZW0gMDA6MDA6IFttZW0gMHhmZDAwMDAwMC0weGZkZmZmZmZm
XSBoYXMgYmVlbiByZXNlcnZlZA0Kc3lzdGVtIDAwOjAwOiBbbWVtIDB4ZmUw
MDAwMDAtMHhmZWJmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQNCnN5c3RlbSAw
MDowMDogW21lbSAweGZlYzhhMDAwLTB4ZmVjOGFmZmZdIGNvdWxkIG5vdCBi
ZSByZXNlcnZlZA0Kc3lzdGVtIDAwOjAwOiBbbWVtIDB4ZmVkMTAwMDAtMHhm
ZWQxMGZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQNCnN5c3RlbSAwMDowNDogW2lv
ICAweDBjYTAtMHgwY2ExXSBoYXMgYmVlbiByZXNlcnZlZA0Kc3lzdGVtIDAw
OjA0OiBbaW8gIDB4MGNhNC0weDBjYTddIGhhcyBiZWVuIHJlc2VydmVkDQpz
eXN0ZW0gMDA6MDQ6IFtpbyAgMHgwY2FhLTB4MGNhZl0gaGFzIGJlZW4gcmVz
ZXJ2ZWQNCnN5c3RlbSAwMDowNDogW2lvICAweDA0ZDAtMHgwNGQxXSBoYXMg
YmVlbiByZXNlcnZlZA0Kc3lzdGVtIDAwOjA0OiBbaW8gIDB4MDgwMC0weDA4
N2ZdIGhhcyBiZWVuIHJlc2VydmVkDQpzeXN0ZW0gMDA6MDQ6IFtpbyAgMHgw
NTAwLTB4MDU3Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQNCnN5c3RlbSAwMDowNDog
W21lbSAweGZlZDFjMDAwLTB4ZmVkMWZmZmZdIGhhcyBiZWVuIHJlc2VydmVk
DQpzeXN0ZW0gMDA6MDQ6IFttZW0gMHhmZWQyMDAwMC0weGZlZDNmZmZmXSBo
YXMgYmVlbiByZXNlcnZlZA0Kc3lzdGVtIDAwOjA0OiBbbWVtIDB4ZmVkNDAw
MDAtMHhmZWQ4ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQNCnN5c3RlbSAwMDow
NTogW21lbSAweGZlYzAwMDAwLTB4ZmVjMDBmZmZdIGNvdWxkIG5vdCBiZSBy
ZXNlcnZlZA0Kc3lzdGVtIDAwOjA1OiBbbWVtIDB4ZmVlMDAwMDAtMHhmZWUw
MGZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQNCnN5c3RlbSAwMDowNzogW21lbSAw
eGUwMDAwMDAwLTB4ZWZmZmZmZmZdIGhhcyBiZWVuIHJlc2VydmVkDQpzeXN0
ZW0gMDA6MDg6IFttZW0gMHgwMDAwMDAwMC0weDAwMDlmZmZmXSBjb3VsZCBu
b3QgYmUgcmVzZXJ2ZWQNCnN5c3RlbSAwMDowODogW21lbSAweDAwMGUwMDAw
LTB4MDAwZmZmZmZdIGNvdWxkIG5vdCBiZSByZXNlcnZlZA0Kc3lzdGVtIDAw
OjA4OiBbbWVtIDB4MDAxMDAwMDAtMHhiZmZmZmZmZl0gY291bGQgbm90IGJl
IHJlc2VydmVkDQpzeXN0ZW0gMDA6MDg6IFttZW0gMHhmZWQ5MDAwMC0weGZm
ZmZmZmZmXSBjb3VsZCBub3QgYmUgcmVzZXJ2ZWQNCnBucDogUG5QIEFDUEk6
IGZvdW5kIDkgZGV2aWNlcw0KcGNpIDAwMDA6MDA6MDEuMDogUENJIGJyaWRn
ZSB0byBbYnVzIDAxXQ0KcGNpIDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2lu
ZG93IFtpbyAgMHhhMDAwLTB4YWZmZl0NCnBjaSAwMDAwOjAwOjAxLjA6ICAg
YnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmE4MDAwMDAtMHhmYThmZmZmZl0NCnBj
aSAwMDAwOjAwOjAyLjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwMl0NCnBjaSAw
MDAwOjAwOjAyLjA6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4YjAwMC0weGJm
ZmZdDQpwY2kgMDAwMDowMDowMi4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAw
eGZhOTAwMDAwLTB4ZmE5ZmZmZmZdDQpwY2kgMDAwMDowMDowMy4wOiBQQ0kg
YnJpZGdlIHRvIFtidXMgMDNdDQpwY2kgMDAwMDowMDowMy4wOiAgIGJyaWRn
ZSB3aW5kb3cgW2lvICAweGMwMDAtMHhjZmZmXQ0KcGNpIDAwMDA6MDA6MDMu
MDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYWEwMDAwMC0weGZhYWZmZmZm
XQ0KcGNpIDAwMDA6MDA6MDMuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhj
MDAwMDAwMC0weGMwMWZmZmZmIDY0Yml0IHByZWZdDQpwY2kgMDAwMDowMDow
Ny4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMTBdDQpwY2kgMDAwMDowMDowOC4w
OiBQQ0kgYnJpZGdlIHRvIFtidXMgMjBdDQpwY2kgMDAwMDowMDowOS4wOiBQ
Q0kgYnJpZGdlIHRvIFtidXMgMzBdDQpwY2kgMDAwMDowMDowOS4wOiAgIGJy
aWRnZSB3aW5kb3cgW2lvICAweGQwMDAtMHhkZmZmXQ0KcGNpIDAwMDA6MDA6
MDkuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYWIwMDAwMC0weGZhYmZm
ZmZmXQ0KcGNpIDAwMDA6MDA6MGEuMDogUENJIGJyaWRnZSB0byBbYnVzIDQw
XQ0KcGNpIDAwMDA6MDA6MWMuMDogUENJIGJyaWRnZSB0byBbYnVzIDUwXQ0K
cGNpIDAwMDA6MDA6MWMuMDogICBicmlkZ2Ugd2luZG93IFtpbyAgMHhlMDAw
LTB4ZWZmZl0NCnBjaSAwMDAwOjAwOjFjLjA6ICAgYnJpZGdlIHdpbmRvdyBb
bWVtIDB4ZmFjMDAwMDAtMHhmYWZmZmZmZl0NCnBjaSAwMDAwOjAwOjFjLjA6
ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4YzAyMDAwMDAtMHhjMDNmZmZmZiA2
NGJpdCBwcmVmXQ0KcGNpIDAwMDA6NjA6MDAuMDogQkFSIDY6IGFzc2lnbmVk
IFttZW0gMHhmYjgwMDAwMC0weGZiODBmZmZmIHByZWZdDQpwY2kgMDAwMDow
MDoxYy40OiBQQ0kgYnJpZGdlIHRvIFtidXMgNjBdDQpwY2kgMDAwMDowMDox
Yy40OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDEwMDAtMHgxZmZmXQ0KcGNp
IDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYjAwMDAw
MC0weGZiZWZmZmZmXQ0KcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2lu
ZG93IFttZW0gMHhmOTAwMDAwMC0weGY5ZmZmZmZmIDY0Yml0IHByZWZdDQpw
Y2kgMDAwMDowMDoxZS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgNjFdDQpORVQ6
IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDINClRDUCBlc3RhYmxpc2hl
ZCBoYXNoIHRhYmxlIGVudHJpZXM6IDEwMjQgKG9yZGVyOiAxLCA4MTkyIGJ5
dGVzKQ0KVENQIGJpbmQgaGFzaCB0YWJsZSBlbnRyaWVzOiAxMDI0IChvcmRl
cjogMiwgMTYzODQgYnl0ZXMpDQpUQ1A6IEhhc2ggdGFibGVzIGNvbmZpZ3Vy
ZWQgKGVzdGFibGlzaGVkIDEwMjQgYmluZCAxMDI0KQ0KVENQOiByZW5vIHJl
Z2lzdGVyZWQNClVEUCBoYXNoIHRhYmxlIGVudHJpZXM6IDI1NiAob3JkZXI6
IDEsIDgxOTIgYnl0ZXMpDQpVRFAtTGl0ZSBoYXNoIHRhYmxlIGVudHJpZXM6
IDI1NiAob3JkZXI6IDEsIDgxOTIgYnl0ZXMpDQpORVQ6IFJlZ2lzdGVyZWQg
cHJvdG9jb2wgZmFtaWx5IDENCnBjaSAwMDAwOjAxOjAwLjA6IERpc2FibGlu
ZyBMMHMNCnBjaSAwMDAwOjAxOjAwLjA6IGNhbid0IGRpc2FibGUgQVNQTTsg
T1MgZG9lc24ndCBoYXZlIEFTUE0gY29udHJvbA0KcGNpIDAwMDA6MDE6MDAu
MTogRGlzYWJsaW5nIEwwcw0KcGNpIDAwMDA6MDE6MDAuMTogY2FuJ3QgZGlz
YWJsZSBBU1BNOyBPUyBkb2Vzbid0IGhhdmUgQVNQTSBjb250cm9sDQpwY2kg
MDAwMDowMjowMC4wOiBEaXNhYmxpbmcgTDBzDQpwY2kgMDAwMDowMjowMC4w
OiBjYW4ndCBkaXNhYmxlIEFTUE07IE9TIGRvZXNuJ3QgaGF2ZSBBU1BNIGNv
bnRyb2wNCnBjaSAwMDAwOjAyOjAwLjE6IERpc2FibGluZyBMMHMNCnBjaSAw
MDAwOjAyOjAwLjE6IGNhbid0IGRpc2FibGUgQVNQTTsgT1MgZG9lc24ndCBo
YXZlIEFTUE0gY29udHJvbA0KVHJ5aW5nIHRvIHVucGFjayByb290ZnMgaW1h
Z2UgYXMgaW5pdHJhbWZzLi4uDQpGcmVlaW5nIGluaXRyZCBtZW1vcnk6IDUz
NTJLIChmZmZmODgwMDM2YWI1MDAwIC0gZmZmZjg4MDAzNmZlZjAwMCkNCklP
TU1VIFNraXAgZGlzYWJsaW5nIGlvbW11IGhhcmR3YXJlIHRyYW5zbGF0aW9u
cw0KSU9NTVUgQ29weWluZyB0cmFuc2xhdGUgdGFibGVzIGZyb20gcGFuaWNr
ZWQga2VybmVsDQpJT01NVTogcm9vdF9jYWNoZToweGZmZmY4ODAwMzNlZDgw
MDAgcGh5czoweDAwMDBiYWMyZjAwMA0KSU9NTVU6MCBEb21haW4gaWRzIGZy
b20gcGFuaWNrZWQga2VybmVsOg0KRElEIGRpZDoxMigweDAwMGMpDQpESUQg
ZGlkOjExKDB4MDAwYikNCkRJRCBkaWQ6MTAoMHgwMDBhKQ0KRElEIGRpZDo5
KDB4MDAwOSkNCkRJRCBkaWQ6MjQoMHgwMDE4KQ0KRElEIGRpZDoyMygweDAw
MTcpDQpESUQgZGlkOjIyKDB4MDAxNikNCkRJRCBkaWQ6MjEoMHgwMDE1KQ0K
RElEIGRpZDo4KDB4MDAwOCkNCkRJRCBkaWQ6NygweDAwMDcpDQpESUQgZGlk
OjYoMHgwMDA2KQ0KRElEIGRpZDo1KDB4MDAwNSkNCkRJRCBkaWQ6NCgweDAw
MDQpDQpESUQgZGlkOjMoMHgwMDAzKQ0KRElEIGRpZDoyKDB4MDAwMikNCkRJ
RCBkaWQ6MSgweDAwMDEpDQpESUQgZGlkOjAoMHgwMDAwKQ0KRElEIGRpZDoy
MCgweDAwMTQpDQpESUQgZGlkOjE5KDB4MDAxMykNCkRJRCBkaWQ6MTgoMHgw
MDEyKQ0KRElEIGRpZDoxNygweDAwMTEpDQpESUQgZGlkOjE2KDB4MDAxMCkN
CkRJRCBkaWQ6MTUoMHgwMDBmKQ0KRElEIGRpZDoxNCgweDAwMGUpDQpESUQg
ZGlkOjEzKDB4MDAwZCkNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCklPTU1VOiBkbWFyMCB1c2luZyBRdWV1ZWQgaW52YWxp
ZGF0aW9uDQpQQ0ktRE1BOiBJbnRlbChSKSBWaXJ0dWFsaXphdGlvbiBUZWNo
bm9sb2d5IGZvciBEaXJlY3RlZCBJL08NCmZ1dGV4IGhhc2ggdGFibGUgZW50
cmllczogMjU2IChvcmRlcjogMiwgMTYzODQgYnl0ZXMpDQphdWRpdDogaW5p
dGlhbGl6aW5nIG5ldGxpbmsgc3Vic3lzIChkaXNhYmxlZCkNCmF1ZGl0OiB0
eXBlPTIwMDAgYXVkaXQoMTQyMDYyNDIxMi40ODA6MSk6IGluaXRpYWxpemVk
DQpIdWdlVExCIHJlZ2lzdGVyZWQgMiBNQiBwYWdlIHNpemUsIHByZS1hbGxv
Y2F0ZWQgMCBwYWdlcw0KVkZTOiBEaXNrIHF1b3RhcyBkcXVvdF82LjUuMg0K
VkZTOiBEcXVvdC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMiAob3Jk
ZXIgMCwgNDA5NiBieXRlcykNCmJvdW5jZTogcG9vbCBzaXplOiA2NCBwYWdl
cw0KQmxvY2sgbGF5ZXIgU0NTSSBnZW5lcmljIChic2cpIGRyaXZlciB2ZXJz
aW9uIDAuNCBsb2FkZWQgKG1ham9yIDI1MikNCmRtYXI6IERSSEQ6IGhhbmRs
aW5nIGZhdWx0IHN0YXR1cyByZWcgMg0KZG1hcjogRE1BUjpbRE1BIFdyaXRl
XSBSZXF1ZXN0IGRldmljZSBbMDE6MDAuMF0gZmF1bHQgYWRkciBmZmRmMjAw
MCANCkRNQVI6W2ZhdWx0IHJlYXNvbiAwNV0gUFRFIFdyaXRlIGFjY2VzcyBp
cyBub3Qgc2V0DQppbyBzY2hlZHVsZXIgbm9vcCByZWdpc3RlcmVkDQppbyBz
Y2hlZHVsZXIgZGVhZGxpbmUgcmVnaXN0ZXJlZA0KaW8gc2NoZWR1bGVyIGNm
cSByZWdpc3RlcmVkIChkZWZhdWx0KQ0KcGNpX2hvdHBsdWc6IFBDSSBIb3Qg
UGx1ZyBQQ0kgQ29yZSB2ZXJzaW9uOiAwLjUNCnBjaWVocDogUENJIEV4cHJl
c3MgSG90IFBsdWcgQ29udHJvbGxlciBEcml2ZXIgdmVyc2lvbjogMC40DQpp
bnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZpY2VzL0xOWFNZU1RNOjAwL0xO
WFNZQlVTOjAwL1BOUDBDMEM6MDAvaW5wdXQvaW5wdXQwDQpBQ1BJOiBQb3dl
ciBCdXR0b24gW1BXUkJdDQppbnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZp
Y2VzL0xOWFNZU1RNOjAwL0xOWFBXUkJOOjAwL2lucHV0L2lucHV0MQ0KQUNQ
STogUG93ZXIgQnV0dG9uIFtQV1JGXQ0KQVBFSTogQ2FuIG5vdCByZXF1ZXN0
IFttZW0gMHhiZjdiM2QzYS0weGJmN2IzZDNiXSBmb3IgQVBFSSBFUlNUIHJl
Z2lzdGVycw0KW0Zpcm13YXJlIFdhcm5dOiBHSEVTOiBQb2xsIGludGVydmFs
IGlzIDAgZm9yIGdlbmVyaWMgaGFyZHdhcmUgZXJyb3Igc291cmNlOiAxLCBk
aXNhYmxlZC4NCkdIRVM6IEFQRUkgZmlybXdhcmUgZmlyc3QgbW9kZSBpcyBl
bmFibGVkIGJ5IFdIRUEgX09TQy4NClNlcmlhbDogODI1MC8xNjU1MCBkcml2
ZXIsIDQgcG9ydHMsIElSUSBzaGFyaW5nIGVuYWJsZWQNCnNlcmlhbCAwMDow
MjogdHR5UzAgYXQgSS9PIDB4M2Y4IChpcnEgPSA0LCBiYXNlX2JhdWQgPSAx
MTUyMDApIGlzIGEgMTY1NTBBDQpOb24tdm9sYXRpbGUgbWVtb3J5IGRyaXZl
ciB2MS4zDQpMaW51eCBhZ3BnYXJ0IGludGVyZmFjZSB2MC4xMDMNCmJyZDog
bW9kdWxlIGxvYWRlZA0KbG9vcDogbW9kdWxlIGxvYWRlZA0KbGlicGh5OiBG
aXhlZCBNRElPIEJ1czogcHJvYmVkDQplaGNpX2hjZDogVVNCIDIuMCAnRW5o
YW5jZWQnIEhvc3QgQ29udHJvbGxlciAoRUhDSSkgRHJpdmVyDQplaGNpLXBj
aTogRUhDSSBQQ0kgcGxhdGZvcm0gZHJpdmVyDQplaGNpLXBjaSAwMDAwOjAw
OjFhLjc6IEVIQ0kgSG9zdCBDb250cm9sbGVyDQplaGNpLXBjaSAwMDAwOjAw
OjFhLjc6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBu
dW1iZXIgMQ0KZWhjaS1wY2kgMDAwMDowMDoxYS43OiBkZWJ1ZyBwb3J0IDEN
CmVoY2ktcGNpIDAwMDA6MDA6MWEuNzogaXJxIDE4LCBpbyBtZW0gMHhmYTdk
ZTAwMA0KZWhjaS1wY2kgMDAwMDowMDoxYS43OiBVU0IgMi4wIHN0YXJ0ZWQs
IEVIQ0kgMS4wMA0KdXNiIHVzYjE6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBp
ZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMg0KdXNiIHVzYjE6IE5ldyBV
U0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51
bWJlcj0xDQp1c2IgdXNiMTogUHJvZHVjdDogRUhDSSBIb3N0IENvbnRyb2xs
ZXINCmRtYXI6IERSSEQ6IGhhbmRsaW5nIGZhdWx0IHN0YXR1cyByZWcgMTAy
DQpkbWFyOiBETUFSOltETUEgV3JpdGVdIFJlcXVlc3QgZGV2aWNlIFswMTow
MC4wXSBmYXVsdCBhZGRyIGZmY2U4MDAwIA0KRE1BUjpbZmF1bHQgcmVhc29u
IDA1XSBQVEUgV3JpdGUgYWNjZXNzIGlzIG5vdCBzZXQNCnVzYiB1c2IxOiBN
YW51ZmFjdHVyZXI6IExpbnV4IDMuMTkuMC1yYzMgZWhjaV9oY2QNCnVzYiB1
c2IxOiBTZXJpYWxOdW1iZXI6IDAwMDA6MDA6MWEuNw0KaHViIDEtMDoxLjA6
IFVTQiBodWIgZm91bmQNCmh1YiAxLTA6MS4wOiA2IHBvcnRzIGRldGVjdGVk
DQplaGNpLXBjaSAwMDAwOjAwOjFkLjc6IEVIQ0kgSG9zdCBDb250cm9sbGVy
DQplaGNpLXBjaSAwMDAwOjAwOjFkLjc6IG5ldyBVU0IgYnVzIHJlZ2lzdGVy
ZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgMg0KZWhjaS1wY2kgMDAwMDowMDox
ZC43OiBkZWJ1ZyBwb3J0IDENCmVoY2ktcGNpIDAwMDA6MDA6MWQuNzogaXJx
IDIzLCBpbyBtZW0gMHhmYTdkYzAwMA0KZWhjaS1wY2kgMDAwMDowMDoxZC43
OiBVU0IgMi4wIHN0YXJ0ZWQsIEVIQ0kgMS4wMA0KdXNiIHVzYjI6IE5ldyBV
U0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAw
Mg0KdXNiIHVzYjI6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQ
cm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xDQp1c2IgdXNiMjogUHJvZHVjdDog
RUhDSSBIb3N0IENvbnRyb2xsZXINCnVzYiB1c2IyOiBNYW51ZmFjdHVyZXI6
IExpbnV4IDMuMTkuMC1yYzMgZWhjaV9oY2QNCnVzYiB1c2IyOiBTZXJpYWxO
dW1iZXI6IDAwMDA6MDA6MWQuNw0KaHViIDItMDoxLjA6IFVTQiBodWIgZm91
bmQNCmh1YiAyLTA6MS4wOiA2IHBvcnRzIGRldGVjdGVkDQpvaGNpX2hjZDog
VVNCIDEuMSAnT3BlbicgSG9zdCBDb250cm9sbGVyIChPSENJKSBEcml2ZXIN
Cm9oY2ktcGNpOiBPSENJIFBDSSBwbGF0Zm9ybSBkcml2ZXINCnVoY2lfaGNk
OiBVU0IgVW5pdmVyc2FsIEhvc3QgQ29udHJvbGxlciBJbnRlcmZhY2UgZHJp
dmVyDQp1aGNpX2hjZCAwMDAwOjAwOjFhLjA6IFVIQ0kgSG9zdCBDb250cm9s
bGVyDQp1aGNpX2hjZCAwMDAwOjAwOjFhLjA6IG5ldyBVU0IgYnVzIHJlZ2lz
dGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgMw0KdWhjaV9oY2QgMDAwMDow
MDoxYS4wOiBkZXRlY3RlZCAyIHBvcnRzDQp1aGNpX2hjZCAwMDAwOjAwOjFh
LjA6IGlycSAxNiwgaW8gYmFzZSAweDAwMDA5YzAwDQp1c2IgdXNiMzogTmV3
IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTFkNmIsIGlkUHJvZHVjdD0w
MDAxDQp1c2IgdXNiMzogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMs
IFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTENCnVzYiB1c2IzOiBQcm9kdWN0
OiBVSENJIEhvc3QgQ29udHJvbGxlcg0KdXNiIHVzYjM6IE1hbnVmYWN0dXJl
cjogTGludXggMy4xOS4wLXJjMyB1aGNpX2hjZA0KdXNiIHVzYjM6IFNlcmlh
bE51bWJlcjogMDAwMDowMDoxYS4wDQpodWIgMy0wOjEuMDogVVNCIGh1YiBm
b3VuZA0KaHViIDMtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQNCnVoY2lfaGNk
IDAwMDA6MDA6MWEuMTogVUhDSSBIb3N0IENvbnRyb2xsZXINCnVoY2lfaGNk
IDAwMDA6MDA6MWEuMTogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWdu
ZWQgYnVzIG51bWJlciA0DQp1aGNpX2hjZCAwMDAwOjAwOjFhLjE6IGRldGVj
dGVkIDIgcG9ydHMNCnVoY2lfaGNkIDAwMDA6MDA6MWEuMTogaXJxIDIxLCBp
byBiYXNlIDB4MDAwMDk4ODANCnVzYiB1c2I0OiBOZXcgVVNCIGRldmljZSBm
b3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0PTAwMDENCnVzYiB1c2I0
OiBOZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9MywgUHJvZHVjdD0yLCBT
ZXJpYWxOdW1iZXI9MQ0KdXNiIHVzYjQ6IFByb2R1Y3Q6IFVIQ0kgSG9zdCBD
b250cm9sbGVyDQp1c2IgdXNiNDogTWFudWZhY3R1cmVyOiBMaW51eCAzLjE5
LjAtcmMzIHVoY2lfaGNkDQp1c2IgdXNiNDogU2VyaWFsTnVtYmVyOiAwMDAw
OjAwOjFhLjENCmh1YiA0LTA6MS4wOiBVU0IgaHViIGZvdW5kDQpodWIgNC0w
OjEuMDogMiBwb3J0cyBkZXRlY3RlZA0KdWhjaV9oY2QgMDAwMDowMDoxYS4y
OiBVSENJIEhvc3QgQ29udHJvbGxlcg0KdWhjaV9oY2QgMDAwMDowMDoxYS4y
OiBuZXcgVVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVy
IDUNCnVoY2lfaGNkIDAwMDA6MDA6MWEuMjogZGV0ZWN0ZWQgMiBwb3J0cw0K
dWhjaV9oY2QgMDAwMDowMDoxYS4yOiBpcnEgMTksIGlvIGJhc2UgMHgwMDAw
OTgwMA0KdXNiIHVzYjU6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRv
cj0xZDZiLCBpZFByb2R1Y3Q9MDAwMQ0KdXNiIHVzYjU6IE5ldyBVU0IgZGV2
aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0x
DQp1c2IgdXNiNTogUHJvZHVjdDogVUhDSSBIb3N0IENvbnRyb2xsZXINCnVz
YiB1c2I1OiBNYW51ZmFjdHVyZXI6IExpbnV4IDMuMTkuMC1yYzMgdWhjaV9o
Y2QNCnVzYiB1c2I1OiBTZXJpYWxOdW1iZXI6IDAwMDA6MDA6MWEuMg0KaHVi
IDUtMDoxLjA6IFVTQiBodWIgZm91bmQNCmh1YiA1LTA6MS4wOiAyIHBvcnRz
IGRldGVjdGVkDQp1aGNpX2hjZCAwMDAwOjAwOjFkLjA6IFVIQ0kgSG9zdCBD
b250cm9sbGVyDQp1aGNpX2hjZCAwMDAwOjAwOjFkLjA6IG5ldyBVU0IgYnVz
IHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNg0KdWhjaV9oY2Qg
MDAwMDowMDoxZC4wOiBkZXRlY3RlZCAyIHBvcnRzDQp1aGNpX2hjZCAwMDAw
OjAwOjFkLjA6IGlycSAyMywgaW8gYmFzZSAweDAwMDA5NDgwDQp1c2IgdXNi
NjogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTFkNmIsIGlkUHJv
ZHVjdD0wMDAxDQpkbWFyOiBEUkhEOiBoYW5kbGluZyBmYXVsdCBzdGF0dXMg
cmVnIDIwMg0KZG1hcjogRE1BUjpbRE1BIFdyaXRlXSBSZXF1ZXN0IGRldmlj
ZSBbMDE6MDAuMF0gZmF1bHQgYWRkciBmZmVmMzAwMCANCkRNQVI6W2ZhdWx0
IHJlYXNvbiAwNV0gUFRFIFdyaXRlIGFjY2VzcyBpcyBub3Qgc2V0DQp1c2Ig
dXNiNjogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFByb2R1Y3Q9
MiwgU2VyaWFsTnVtYmVyPTENCnVzYiB1c2I2OiBQcm9kdWN0OiBVSENJIEhv
c3QgQ29udHJvbGxlcg0KdXNiIHVzYjY6IE1hbnVmYWN0dXJlcjogTGludXgg
My4xOS4wLXJjMyB1aGNpX2hjZA0KdXNiIHVzYjY6IFNlcmlhbE51bWJlcjog
MDAwMDowMDoxZC4wDQpodWIgNi0wOjEuMDogVVNCIGh1YiBmb3VuZA0KaHVi
IDYtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQNCnVoY2lfaGNkIDAwMDA6MDA6
MWQuMTogVUhDSSBIb3N0IENvbnRyb2xsZXINCnVzYiAxLTI6IG5ldyBoaWdo
LXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDIgdXNpbmcgZWhjaS1wY2kNCnVo
Y2lfaGNkIDAwMDA6MDA6MWQuMTogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwg
YXNzaWduZWQgYnVzIG51bWJlciA3DQp1aGNpX2hjZCAwMDAwOjAwOjFkLjE6
IGRldGVjdGVkIDIgcG9ydHMNCnVoY2lfaGNkIDAwMDA6MDA6MWQuMTogaXJx
IDE5LCBpbyBiYXNlIDB4MDAwMDk0MDANCnVzYiB1c2I3OiBOZXcgVVNCIGRl
dmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0PTAwMDENCnVz
YiB1c2I3OiBOZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9MywgUHJvZHVj
dD0yLCBTZXJpYWxOdW1iZXI9MQ0KdXNiIHVzYjc6IFByb2R1Y3Q6IFVIQ0kg
SG9zdCBDb250cm9sbGVyDQp1c2IgdXNiNzogTWFudWZhY3R1cmVyOiBMaW51
eCAzLjE5LjAtcmMzIHVoY2lfaGNkDQp1c2IgdXNiNzogU2VyaWFsTnVtYmVy
OiAwMDAwOjAwOjFkLjENCmh1YiA3LTA6MS4wOiBVU0IgaHViIGZvdW5kDQpo
dWIgNy0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZA0KdWhjaV9oY2QgMDAwMDow
MDoxZC4yOiBVSENJIEhvc3QgQ29udHJvbGxlcg0KdWhjaV9oY2QgMDAwMDow
MDoxZC4yOiBuZXcgVVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMg
bnVtYmVyIDgNCnVoY2lfaGNkIDAwMDA6MDA6MWQuMjogZGV0ZWN0ZWQgMiBw
b3J0cw0KdWhjaV9oY2QgMDAwMDowMDoxZC4yOiBpcnEgMTgsIGlvIGJhc2Ug
MHgwMDAwOTA4MA0KdXNiIHVzYjg6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBp
ZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMQ0KdXNiIHVzYjg6IE5ldyBV
U0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51
bWJlcj0xDQp1c2IgdXNiODogUHJvZHVjdDogVUhDSSBIb3N0IENvbnRyb2xs
ZXINCnVzYiB1c2I4OiBNYW51ZmFjdHVyZXI6IExpbnV4IDMuMTkuMC1yYzMg
dWhjaV9oY2QNCnVzYiB1c2I4OiBTZXJpYWxOdW1iZXI6IDAwMDA6MDA6MWQu
Mg0KaHViIDgtMDoxLjA6IFVTQiBodWIgZm91bmQNCmh1YiA4LTA6MS4wOiAy
IHBvcnRzIGRldGVjdGVkDQppODA0MjogUE5QOiBObyBQUy8yIGNvbnRyb2xs
ZXIgZm91bmQuIFByb2JpbmcgcG9ydHMgZGlyZWN0bHkuDQpkbWFyOiBEUkhE
OiBoYW5kbGluZyBmYXVsdCBzdGF0dXMgcmVnIDMwMg0KZG1hcjogRE1BUjpb
RE1BIFdyaXRlXSBSZXF1ZXN0IGRldmljZSBbMDE6MDAuMF0gZmF1bHQgYWRk
ciBmZmNlNzAwMCANCkRNQVI6W2ZhdWx0IHJlYXNvbiAwNV0gUFRFIFdyaXRl
IGFjY2VzcyBpcyBub3Qgc2V0DQppODA0MjogRmFpbGVkIHRvIGRpc2FibGUg
QVVYIHBvcnQsIGJ1dCBjb250aW51aW5nIGFueXdheS4uLiBJcyB0aGlzIGEg
U2lTPw0KaTgwNDI6IElmIEFVWCBwb3J0IGlzIHJlYWxseSBhYnNlbnQgcGxl
YXNlIHVzZSB0aGUgJ2k4MDQyLm5vYXV4JyBvcHRpb24NCmRtYXI6IERSSEQ6
IGhhbmRsaW5nIGZhdWx0IHN0YXR1cyByZWcgNDAyDQpkbWFyOiBETUFSOltE
TUEgV3JpdGVdIFJlcXVlc3QgZGV2aWNlIFswMTowMC4wXSBmYXVsdCBhZGRy
IGZmY2U1MDAwIA0KRE1BUjpbZmF1bHQgcmVhc29uIDA1XSBQVEUgV3JpdGUg
YWNjZXNzIGlzIG5vdCBzZXQNCnNjaGVkOiBSVCB0aHJvdHRsaW5nIGFjdGl2
YXRlZA0Kc2VyaW86IGk4MDQyIEtCRCBwb3J0IGF0IDB4NjAsMHg2NCBpcnEg
MQ0KbW91c2VkZXY6IFBTLzIgbW91c2UgZGV2aWNlIGNvbW1vbiBmb3IgYWxs
IG1pY2UNCnJ0Y19jbW9zIDAwOjAxOiBSVEMgY2FuIHdha2UgZnJvbSBTNA0K
cnRjX2Ntb3MgMDA6MDE6IHJ0YyBjb3JlOiByZWdpc3RlcmVkIHJ0Y19jbW9z
IGFzIHJ0YzANCnJ0Y19jbW9zIDAwOjAxOiBhbGFybXMgdXAgdG8gb25lIG1v
bnRoLCB5M2ssIDExNCBieXRlcyBudnJhbSwgaHBldCBpcnFzDQpoaWRyYXc6
IHJhdyBISUQgZXZlbnRzIGRyaXZlciAoQykgSmlyaSBLb3NpbmENCnVzYiAx
LTI6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0wNGI0LCBpZFBy
b2R1Y3Q9NjU2MA0KdXNiIDEtMjogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczog
TWZyPTAsIFByb2R1Y3Q9MCwgU2VyaWFsTnVtYmVyPTANCnVzYmNvcmU6IHJl
Z2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkDQp1c2JoaWQ6
IFVTQiBISUQgY29yZSBkcml2ZXINCmRyb3BfbW9uaXRvcjogSW5pdGlhbGl6
aW5nIG5ldHdvcmsgZHJvcCBtb25pdG9yIHNlcnZpY2UNCmh1YiAxLTI6MS4w
OiBVU0IgaHViIGZvdW5kDQpUQ1A6IGN1YmljIHJlZ2lzdGVyZWQNCmh1YiAx
LTI6MS4wOiA0IHBvcnRzIGRldGVjdGVkDQpJbml0aWFsaXppbmcgWEZSTSBu
ZXRsaW5rIHNvY2tldA0KTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWls
eSAxNw0KbWNlOiBVbmFibGUgdG8gaW5pdCBkZXZpY2UgL2Rldi9tY2Vsb2cg
KHJjOiAtNSkNCnJlZ2lzdGVyZWQgdGFza3N0YXRzIHZlcnNpb24gMQ0KaW1h
OiBObyBUUE0gY2hpcCBmb3VuZCwgYWN0aXZhdGluZyBUUE0tYnlwYXNzIQ0K
cnRjX2Ntb3MgMDA6MDE6IHNldHRpbmcgc3lzdGVtIGNsb2NrIHRvIDIwMTUt
MDEtMDcgMDk6NTA6MjAgVVRDICgxNDIwNjI0MjIwKQ0KRnJlZWluZyB1bnVz
ZWQga2VybmVsIG1lbW9yeTogMTc0OEsgKGZmZmZmZmZmODFiMmQwMDAgLSBm
ZmZmZmZmZjgxY2UyMDAwKQ0KV3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVs
IHJlYWQtb25seSBkYXRhOiAxMDI0MGsNCkZyZWVpbmcgdW51c2VkIGtlcm5l
bCBtZW1vcnk6IDI2NEsgKGZmZmY4ODAwMzA1YmUwMDAgLSBmZmZmODgwMDMw
NjAwMDAwKQ0KRnJlZWluZyB1bnVzZWQga2VybmVsIG1lbW9yeTogMTI0OEsg
KGZmZmY4ODAwMzA4YzgwMDAgLSBmZmZmODgwMDMwYTAwMDAwKQ0KTW91bnRp
bmcgcHJvYyBmaWxlc3lzdGVtDQpNb3VudGluZyBzeXNmcyBmaWxlc3lzdGVt
DQpDcmVhdGluZyAvZGV2DQpDcmVhdGluZyBpbml0aWFsIGRldmljZSBub2Rl
cw0Kc2V0Zm9udDogS0RGT05UT1A6IEluYXBwcm9wcmlhdGUgaW9jdGwgZm9y
IGRlZGV2aWNlLW1hcHBlcjogdWV2ZW50OiB2ZXJzaW9uIDEuMC4zDQp2aWNl
DQpGcmVlIG1lbW9yZGV2aWNlLW1hcHBlcjogaW9jdGw6IDQuMjkuMC1pb2N0
bCAoMjAxNC0xMC0yOCkgaW5pdGlhbGlzZWQ6IGRtLWRldmVsQHJlZGhhdC5j
b20NCnkvVG90YWwgbWVtb3J5IChmcmVlICUpOiA3NjkyMCAvIDExMDIwMCAo
IDY5LjgwMDQgKQ0KTG9hZGluZyBkbS1tb2Qua28gbW9kdWxlDQpMb2FkaW5n
IGRtLWxvZy5rb2lwX3RhYmxlczogKEMpIDIwMDAtMjAwNiBOZXRmaWx0ZXIg
Q29yZSBUZWFtDQogbW9kdWxlDQpMb2FkaW5nIGRtLXJlZ2lvbi1oYXNoLm5m
X2Nvbm50cmFjayB2ZXJzaW9uIDAuNS4wICg4NjAgYnVja2V0cywgMzQ0MCBt
YXgpDQprbyBtb2R1bGUNCkxvYWRpaXA2X3RhYmxlczogKEMpIDIwMDAtMjAw
NiBOZXRmaWx0ZXIgQ29yZSBUZWFtDQpuZyBkbS1taXJyb3Iua28gbW9kdWxl
DQpMb2FkaW5nIGRtLXplcm8ua28gbW9kdWxlDQpMb2FkaW5nIGRtLWJ1TkVU
OiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxMA0KZmlvLmtvIG1vZHVs
ZQ0KTG9hZGluZyBkbS1zbmFwc2hvdC5rbyBtb2R1bGUNCkxvdHVuOiBVbml2
ZXJzYWwgVFVOL1RBUCBkZXZpY2UgZHJpdmVyLCAxLjYNCmFkaW5nIGNwdWZy
ZXFfb250dW46IChDKSAxOTk5LTIwMDQgTWF4IEtyYXNueWFuc2t5IDxtYXhr
QHF1YWxjb21tLmNvbT4NCmRlbWFuZC5rbyBtb2R1bGUNCkxvYWRpbmcgbmZf
cmVqZWN0X2lwdjQua28gbW9kdWxlDQpMb2FkaW5nIG5mX2RlZnJhZ19pcHY0
LmtvIG1vaVRDT192ZW5kb3Jfc3VwcG9ydDogdmVuZG9yLXN1cHBvcnQ9MA0K
ZHVsZQ0KTG9hZGluZyBpcF90YWJsZXMua28gbW9kdWxpbnB1dDogUEMgU3Bl
YWtlciBhcyAvZGV2aWNlcy9wbGF0Zm9ybS9wY3Nwa3IvaW5wdXQvaW5wdXQz
DQplDQpMb2FkaW5nIG5mX2Nvbm50cmFjay5rbyBtb2R1bGlwbWkgbWVzc2Fn
ZSBoYW5kbGVyIHZlcnNpb24gMzkuMg0KZQ0KTG9hZGluZyBpcDZfdGFibGVz
LmtvIG1vZHVsZQ1nZW5pcnE6IEZsYWdzIG1pc21hdGNoIGlycSAwLiAwMDAw
MDA4MCAoaTgwMV9zbWJ1cykgdnMuIDAwMDE1YTAwICh0aW1lcikNCkNQVTog
MCBQSUQ6IDE0NSBDb21tOiBpbnNtb2QgTm90IHRhaW50ZWQgMy4xOS4wLXJj
MyAjMzYNCkhhcmR3YXJlIG5hbWU6IEZVSklUU1UtU1YgUFJJTUVSR1kgQlg5
MjAgUzIvRDMwMzAsIEJJT1MgMDgwMDE1IFJldi4zRDgxLjMwMzAgMDIvMTAv
MjAxMg0KIGZmZmY4ODAwMzM1ZDc5NDAgZmZmZjg4MDAzMzUwM2E0OCBmZmZm
ZmZmZjgxNWIyMDBhIDAwMDAwMDAwMDAwMTVhMDANCiBmZmZmODgwMDM2MDNk
NjAwIGZmZmY4ODAwMzM1MDNhYTggZmZmZmZmZmY4MTBhOGNjYyBmZmZmODgw
MDMzNTAzYTk4DQogMDAwMDAwMDAwMDAwMDI0NiBmZmZmODgwMDMzNTAzYWE4
IGZmZmY4ODAwMzNiYTVjMDAgZmZmZjg4MDAzNjAzZDYwMA0KQ2FsbCBUcmFj
ZToNCiBbPGZmZmZmZmZmODE1YjIwMGE+XSBkdW1wX3N0YWNrKzB4NDgvMHg1
ZQ0KIFs8ZmZmZmZmZmY4MTBhOGNjYz5dIF9fc2V0dXBfaXJxKzB4MzljLzB4
NGYwDQogWzxmZmZmZmZmZjgxMGE5NjQwPl0gcmVxdWVzdF90aHJlYWRlZF9p
cnErMHgxMDAvMHgxNzANCiBbPGZmZmZmZmZmYTAxOTVjMzA+XSA/IGRtaV9j
aGVja19vbmJvYXJkX2RldmljZXMrMHgxYTAvMHgxYTAgW2kyY19pODAxXQ0K
IFs8ZmZmZmZmZmZhMDE5NTk2ND5dIGk4MDFfcHJvYmUrMHg0YjQvMHg1ZTAg
W2kyY19pODAxXQ0KIFs8ZmZmZmZmZmY4MTViNDI5Nj5dID8gbXV0ZXhfbG9j
aysweDE2LzB4NDANCiBbPGZmZmZmZmZmODEyZDE2YmM+XSBsb2NhbF9wY2lf
cHJvYmUrMHg0Yy8weGIwDQogWzxmZmZmZmZmZjgxMmQxN2E5Pl0gcGNpX2Nh
bGxfcHJvYmUrMHg4OS8weGIwDQogWzxmZmZmZmZmZjgxMmQxNWZlPl0gPyBw
Y2lfbWF0Y2hfZGV2aWNlKzB4ZGUvMHgxMTANCiBbPGZmZmZmZmZmODEyZDFh
ODk+XSBwY2lfZGV2aWNlX3Byb2JlKzB4NzkvMHhhMA0KIFs8ZmZmZmZmZmY4
MTM5YWYwMj5dID8gZHJpdmVyX3N5c2ZzX2FkZCsweDgyLzB4YjANCiBbPGZm
ZmZmZmZmODEzOWIxODE+XSByZWFsbHlfcHJvYmUrMHg4MS8weDM1MA0KIFs8
ZmZmZmZmZmY4MTM5YjQ5Nz5dIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHg0Ny8w
eGEwDQogWzxmZmZmZmZmZjgxMzliNTliPl0gX19kcml2ZXJfYXR0YWNoKzB4
YWIvMHhiMA0KIFs8ZmZmZmZmZmY4MTM5YjRmMD5dID8gZHJpdmVyX3Byb2Jl
X2RldmljZSsweGEwLzB4YTANCiBbPGZmZmZmZmZmODEzOWI0ZjA+XSA/IGRy
aXZlcl9wcm9iZV9kZXZpY2UrMHhhMC8weGEwDQogWzxmZmZmZmZmZjgxMzk5
Mzc0Pl0gYnVzX2Zvcl9lYWNoX2RldisweDk0LzB4YjANCiBbPGZmZmZmZmZm
ODEzOWFlMmU+XSBkcml2ZXJfYXR0YWNoKzB4MWUvMHgyMA0KIFs8ZmZmZmZm
ZmY4MTM5YTg5MD5dIGJ1c19hZGRfZHJpdmVyKzB4MWIwLzB4MjUwDQogWzxm
ZmZmZmZmZjgxMzliYzM0Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4NjQvMHhmMA0K
IFs8ZmZmZmZmZmY4MTJkMWI3Yz5dIF9fcGNpX3JlZ2lzdGVyX2RyaXZlcisw
eDRjLzB4NTANCiBbPGZmZmZmZmZmYTAxOWEwYTU+XSBpMmNfaTgwMV9pbml0
KzB4YTUvMHgxMDAwIFtpMmNfaTgwMV0NCiBbPGZmZmZmZmZmYTAxOWEwMDA+
XSA/IDB4ZmZmZmZmZmZhMDE5YTAwMA0KIFs8ZmZmZmZmZmY4MTAwMDI4Nz5d
IGRvX29uZV9pbml0Y2FsbCsweGI3LzB4MWQwDQogWzxmZmZmZmZmZjgxMTc1
MzUyPl0gPyBfX3Z1bm1hcCsweGMyLzB4MTEwDQogWzxmZmZmZmZmZjgxMGNm
NjAwPl0gZG9faW5pdF9tb2R1bGUrMHgzMC8weDFhMA0KIFs8ZmZmZmZmZmY4
MTBkMWRlZT5dIGxvYWRfbW9kdWxlKzB4NGVlLzB4NjIwDQogWzxmZmZmZmZm
ZjgxMGNlZWIwPl0gPyBtb2Rfc3lzZnNfdGVhcmRvd24rMHgxNTAvMHgxNTAN
CiBbPGZmZmZmZmZmODExNzViZjU+XSA/IF9fdm1hbGxvY19ub2RlKzB4MzUv
MHg0MA0KIFs8ZmZmZmZmZmY4MTBjZTdmMD5dID8gbW9kdWxlX3NlY3Rfc2hv
dysweDMwLzB4MzANCiBbPGZmZmZmZmZmODEwZDIwYTQ+XSBTeVNfaW5pdF9t
b2R1bGUrMHg5NC8weGMwDQogWzxmZmZmZmZmZjgxNWI2MTUyPl0gc3lzdGVt
X2NhbGxfZmFzdHBhdGgrMHgxMi8weDE3DQoKTG9hZGluZyBpcHY2LmtvaTgw
MV9zbWJ1cyAwMDAwOjAwOjFmLjM6IEZhaWxlZCB0byBhbGxvY2F0ZSBpcnEg
MDogLTE2DQogbW9kdWxlDQpMb2FkaW5naTgwMV9zbWJ1cyAwMDAwOjAwOjFm
LjM6IFNNQnVzIHVzaW5nIHBvbGxpbmcNCiBtYWN2bGFuLmtvIG1vZHVsZQ0K
TG9hZGluZyB2aG9zRURBQyBNQzogVmVyOiAzLjAuMA0KdC5rbyBtb2R1bGUN
CkxvYWRpbmcgdHVuLmtvIG1vZHVkY2Egc2VydmljZSBzdGFydGVkLCB2ZXJz
aW9uIDEuMTIuMQ0KbGUNCkxvYWRpbmcga3ZtLmtvIG1vZHVsZQ0KTG9hZGlw
cHNfY29yZTogTGludXhQUFMgQVBJIHZlci4gMSByZWdpc3RlcmVkDQpuZyB1
aW5wdXQua28gbW9kcHBzX2NvcmU6IFNvZnR3YXJlIHZlci4gNS4zLjYgLSBD
b3B5cmlnaHQgMjAwNS0yMDA3IFJvZG9sZm8gR2lvbWV0dGkgPGdpb21ldHRp
QGxpbnV4Lml0Pg0KdWxlDQpMb2FkaW5nIGlUQ09fdmVuZG9yX3N1cHBvcnQu
a28gbW9kdWxlDQpMb2FkaW5nIHNlcmlvX3Jhdy5rb0Z1c2lvbiBNUFQgYmFz
ZSBkcml2ZXIgMy4wNC4yMA0KIG1vZHVsZQ0KTG9hZGluZ0NvcHlyaWdodCAo
YykgMTk5OS0yMDA4IExTSSBDb3Jwb3JhdGlvbg0KIHBjc3Brci5rbyBtb2R1
bGUNCkxvYWRpbmcgaXBtaV9tc2doYW5kbGVyLmtvIG1vZHVsZQ0KTG9hZGlu
ZyB0cG1faW5maW5lb24ua28gbW9tZWdhc2FzOiAwNi44MDUuMDYuMDEtcmMx
DQpkdWxlDQpMb2FkaW5nIGkybWVnYXNhczogMHgxMDAwOjB4MDA3OToweDE3
MzQ6MHgxMTc2OiBjLWk4MDEua28gbW9kdWxlYnVzIDM6c2xvdCAwOmZ1bmMg
MA0KDQpMb2FkaW5nIG1mZC1jb21lZ2FyYWlkX3NhcyAwMDAwOjAzOjAwLjA6
IENhbid0IGFsbG9jYXRlIEZpcm13YXJlIGNyYXNoIGR1bXAgRE1BIGJ1ZmZl
cg0KcmUua28gbW9kdWxlDQpMb21lZ2FzYXM6IFdhaXRpbmcgZm9yIEZXIHRv
IGNvbWUgdG8gcmVhZHkgc3RhdGUNCmFkaW5nIGVkYWNfY29yZS5rbyBtb2R1
bGUNCkxvYWRpbmcgc2cua28gbW9kdWxlDQpMb2FkaW5nIGRjYS5rbyBtb2R1
bGUNCkxvYWRpbmcgaTJjLWFsZ28tYml0LmtvIG1vZHVsZQ0KTG9hZGluZyBw
cHNfY29yZS5rbyBtb2R1ZG1hcjogRFJIRDogaGFuZGxpbmcgZmF1bHQgc3Rh
dHVzIHJlZyA1MDINCmRtYXI6IERNQVI6W0RNQSBXcml0ZV0gUmVxdWVzdCBk
ZXZpY2UgWzAzOjAwLjBdIGZhdWx0IGFkZHIgZmZkZmUwMDAgDQpETUFSOltm
YXVsdCByZWFzb24gMDVdIFBURSBXcml0ZSBhY2Nlc3MgaXMgbm90IHNldA0K
bGUNCkxvYWRpbmcgYWNwaXVzYiA1LTE6IG5ldyBmdWxsLXNwZWVkIFVTQiBk
ZXZpY2UgbnVtYmVyIDIgdXNpbmcgdWhjaV9oY2QNCi1jcHVmcmVxLmtvIG1v
ZHVtZWdhc2FzOiBGVyBub3cgaW4gUmVhZHkgc3RhdGUNCmxlDQppbnNtb2Q6
IGNhbidtZWdhcmFpZF9zYXMgMDAwMDowMzowMC4wOiBbc2NzaTBdOiBGVyBz
dXBwb3J0czwwPiBNU0lYIHZlY3RvcixPbmxpbmUgQ1BVczogPDE+LEN1cnJl
bnQgTVNJWCA8MT4NCnQgaW5zZXJ0ICcvbGliL21vZHVsZXMvMy4xOS4wLXJj
My9hY3BpLWNwdWZyZXEua28nOiBObyBzdWNoIGRldmljZQ0KTG9hZGluZyBq
YmQyLmtvIG1vZHVsZQ0KTG9hZGluZyBtYmNhY2hlLmtvIG1vZHVsZQ0KTG9h
ZGluZyBtcHRiYXNlLmtvIG1vZHVsZQ0KTG9hZGluZyBzY3NpX3RyYW5zcG9y
dF9zYXMua28gbW9kdWxlDQpMb2FkaW5nIHNjc2lfdHJhbnNwb3J0X2ZjLmtv
IG1vZHVsZQ0KTG9hZGluZyBtZWdhcmFpZF9zYXMua28gbW9kdWxlDQptZWdh
c2FzX2luaXRfbWZpOiBmd19zdXBwb3J0X2llZWU9MA0KbWVnYXNhczogSU5J
VCBhZGFwdGVyIGRvbmUNCm1lZ2FyYWlkX3NhcyAwMDAwOjAzOjAwLjA6IENv
bnRyb2xsZXIgdHlwZTogTVIsTWVtb3J5IHNpemUgaXM6IDUxMk1CDQpzY3Np
IGhvc3QwOiBMU0kgU0FTIGJhc2VkIE1lZ2FSQUlEIGRyaXZlcg0KdXNiIDUt
MTogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTAwMDAsIGlkUHJv
ZHVjdD0wMDAwDQp1c2IgNS0xOiBOZXcgVVNCIGRldmljZSBzdHJpbmdzOiBN
ZnI9MSwgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9Mw0KdXNiIDUtMTogUHJv
ZHVjdDogaVJNQyBVU0IgRGV2aWNlDQp1c2IgNS0xOiBNYW51ZmFjdHVyZXI6
IEZ1aml0c3UNCnVzYiA1LTE6IFNlcmlhbE51bWJlcjogNDAxQjc5NDc3MEUx
Q0MNCnNjc2kgMDoyOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgTFNJICAgICAg
UkFJRCA1LzYgU0FTIDZHICAyLjEzIFBROiAwIEFOU0k6IDUNCnNjc2kgMDoy
OjE6MDogRGlyZWN0LUFjY2VzcyAgICAgTFNJICAgICAgUkFJRCA1LzYgU0FT
IDZHICAyLjEzIFBROiAwIEFOU0k6IDUNCnNjc2kgMDoyOjI6MDogRGlyZWN0
LUFjY2VzcyAgICAgTFNJICAgICAgUkFJRCA1LzYgU0FTIDZHICAyLjEzIFBR
OiAwIEFOU0k6IDUNCnNjc2kgMDoyOjM6MDogRGlyZWN0LUFjY2VzcyAgICAg
TFNJICAgICAgUkFJRCA1LzYgU0FTIDZHICAyLjEzIFBROiAwIEFOU0k6IDUN
CnNjc2kgMDoyOjQ6MDogRGlyZWN0LUFjY2VzcyAgICAgTFNJICAgICAgUkFJ
RCA1LzYgU0FTIDZHICAyLjEzIFBROiAwIEFOU0k6IDUNCnNjc2kgMDoyOjU6
MDogRGlyZWN0LUFjY2VzcyAgICAgTFNJICAgICAgUkFJRCA1LzYgU0FTIDZH
ICAyLjEzIFBROiAwIEFOU0k6IDUNCnNjc2kgMDoyOjY6MDogRGlyZWN0LUFj
Y2VzcyAgICAgTFNJICAgICAgUkFJRCA1LzYgU0FTIDZHICAyLjEzIFBROiAw
IEFOU0k6IDUNCmlucHV0OiBGdWppdHN1IGlSTUMgVVNCIERldmljZSBhcyAv
ZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWEuMi91c2I1LzUtMS81LTE6
MS4wLzAwMDM6MDAwMDowMDAwLjAwMDEvaW5wdXQvaW5wdXQ0DQpzY3NpIDA6
Mjo3OjA6IERpcmVjdC1BY2Nlc3MgICAgIExTSSAgICAgIFJBSUQgNS82IFNB
UyA2RyAgMi4xMyBQUTogMCBBTlNJOiA1DQpzZCAwOjI6MDowOiBbc2RhXSAy
ODU2NzE0MjQgNTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6ICgxNDYgR0IvMTM2
IEdpQikNCnNkIDA6MjowOjA6IFtzZGFdIDQwOTYtYnl0ZSBwaHlzaWNhbCBi
bG9ja3MNCnNkIDA6MjowOjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzAg
dHlwZSAwDQpzZCAwOjI6MDowOiBbc2RhXSBXcml0ZSBQcm90ZWN0IGlzIG9m
Zg0Kc2QgMDoyOjE6MDogW3NkYl0gMjg1NjcxNDI0IDUxMi1ieXRlIGxvZ2lj
YWwgYmxvY2tzOiAoMTQ2IEdCLzEzNiBHaUIpDQpzZCAwOjI6MTowOiBbc2Ri
XSA0MDk2LWJ5dGUgcGh5c2ljYWwgYmxvY2tzDQpzZCAwOjI6MTowOiBBdHRh
Y2hlZCBzY3NpIGdlbmVyaWMgc2cxIHR5cGUgMA0Kc2QgMDoyOjA6MDogW3Nk
YV0gV3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGRpc2FibGVk
LCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQ0KaGlkLWdlbmVyaWMgMDAw
MzowMDAwOjAwMDAuMDAwMTogaW5wdXQsaGlkcmF3MDogVVNCIEhJRCB2MS4x
MSBLZXlib2FyZCBbRnVqaXRzdSBpUk1DIFVTQiBEZXZpY2VdIG9uIHVzYi0w
MDAwOjAwOjFhLjItMS9pbnB1dDANCnNkIDA6MjoxOjA6IFtzZGJdIFdyaXRl
IFByb3RlY3QgaXMgb2ZmDQpzZCAwOjI6MjowOiBbc2RjXSAyODU2NzE0MjQg
NTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6ICgxNDYgR0IvMTM2IEdpQikNCnNk
IDA6MjoyOjA6IFtzZGNdIDQwOTYtYnl0ZSBwaHlzaWNhbCBibG9ja3MNCnNk
IDA6MjoyOjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzIgdHlwZSAwDQpz
ZCAwOjI6MTowOiBbc2RiXSBXcml0ZSBjYWNoZTogZW5hYmxlZCwgcmVhZCBj
YWNoZTogZGlzYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBDQpz
ZCAwOjI6MjowOiBbc2RjXSBXcml0ZSBQcm90ZWN0IGlzIG9mZg0Kc2QgMDoy
OjM6MDogW3NkZF0gMjg1NjcxNDI0IDUxMi1ieXRlIGxvZ2ljYWwgYmxvY2tz
OiAoMTQ2IEdCLzEzNiBHaUIpDQpzZCAwOjI6MzowOiBbc2RkXSA0MDk2LWJ5
dGUgcGh5c2ljYWwgYmxvY2tzDQpzZCAwOjI6MzowOiBBdHRhY2hlZCBzY3Np
IGdlbmVyaWMgc2czIHR5cGUgMA0Kc2QgMDoyOjI6MDogW3NkY10gV3JpdGUg
Y2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGRpc2FibGVkLCBkb2Vzbid0
IHN1cHBvcnQgRFBPIG9yIEZVQQ0Kc2QgMDoyOjM6MDogW3NkZF0gV3JpdGUg
UHJvdGVjdCBpcyBvZmYNCiBzZGE6IHNkYTENCnNkIDA6Mjo0OjA6IFtzZGVd
IDI4NTY3MTQyNCA1MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDE0NiBHQi8x
MzYgR2lCKQ0Kc2QgMDoyOjQ6MDogW3NkZV0gNDA5Ni1ieXRlIHBoeXNpY2Fs
IGJsb2Nrcw0Kc2QgMDoyOjQ6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNn
NCB0eXBlIDANCnNkIDA6MjowOjA6IFtzZGFdIEF0dGFjaGVkIFNDU0kgZGlz
aw0KU3dpdGNoZWQgdG8gY2xvY2tzb3VyY2UgdHNjDQppbnB1dDogRnVqaXRz
dSBpUk1DIFVTQiBEZXZpY2UgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAw
OjAwOjFhLjIvdXNiNS81LTEvNS0xOjEuMS8wMDAzOjAwMDA6MDAwMC4wMDAy
L2lucHV0L2lucHV0NQ0Kc2QgMDoyOjM6MDogW3NkZF0gV3JpdGUgY2FjaGU6
IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGRpc2FibGVkLCBkb2Vzbid0IHN1cHBv
cnQgRFBPIG9yIEZVQQ0Kc2QgMDoyOjQ6MDogW3NkZV0gV3JpdGUgUHJvdGVj
dCBpcyBvZmYNCnNkIDA6Mjo1OjA6IFtzZGZdIDI4NTY3MTQyNCA1MTItYnl0
ZSBsb2dpY2FsIGJsb2NrczogKDE0NiBHQi8xMzYgR2lCKQ0Kc2QgMDoyOjU6
MDogW3NkZl0gNDA5Ni1ieXRlIHBoeXNpY2FsIGJsb2Nrcw0KIHNkYjogc2Ri
MQ0Kc2QgMDoyOjU6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnNSB0eXBl
IDANCnNkIDA6MjoxOjA6IFtzZGJdIEF0dGFjaGVkIFNDU0kgZGlzaw0Kc2Qg
MDoyOjQ6MDogW3NkZV0gV3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2Fj
aGU6IGRpc2FibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQ0KIHNk
Yzogc2RjMSBzZGMyDQpzZCAwOjI6NjowOiBbc2RnXSAyODU2NzE0MjQgNTEy
LWJ5dGUgbG9naWNhbCBibG9ja3M6ICgxNDYgR0IvMTM2IEdpQikNCnNkIDA6
Mjo2OjA6IFtzZGddIDQwOTYtYnl0ZSBwaHlzaWNhbCBibG9ja3MNCnNkIDA6
Mjo2OjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzYgdHlwZSAwDQpzZCAw
OjI6MjowOiBbc2RjXSBBdHRhY2hlZCBTQ1NJIGRpc2sNCnNkIDA6Mjo1OjA6
IFtzZGZdIFdyaXRlIFByb3RlY3QgaXMgb2ZmDQpoaWQtZ2VuZXJpYyAwMDAz
OjAwMDA6MDAwMC4wMDAyOiBpbnB1dCxoaWRyYXcxOiBVU0IgSElEIHYxLjEx
IE1vdXNlIFtGdWppdHN1IGlSTUMgVVNCIERldmljZV0gb24gdXNiLTAwMDA6
MDA6MWEuMi0xL2lucHV0MQ0Kc2QgMDoyOjc6MDogW3NkaF0gMjg1NjcxNDI0
IDUxMi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoMTQ2IEdCLzEzNiBHaUIpDQpz
ZCAwOjI6NzowOiBbc2RoXSA0MDk2LWJ5dGUgcGh5c2ljYWwgYmxvY2tzDQog
c2RkOiBzZGQxIHNkZDINCnNkIDA6Mjo3OjA6IEF0dGFjaGVkIHNjc2kgZ2Vu
ZXJpYyBzZzcgdHlwZSAwDQpzZCAwOjI6NTowOiBbc2RmXSBXcml0ZSBjYWNo
ZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZGlzYWJsZWQsIGRvZXNuJ3Qgc3Vw
cG9ydCBEUE8gb3IgRlVBDQpzZCAwOjI6MzowOiBbc2RkXSBBdHRhY2hlZCBT
Q1NJIGRpc2sNCnNkIDA6Mjo2OjA6IFtzZGddIFdyaXRlIFByb3RlY3QgaXMg
b2ZmDQpzZCAwOjI6NzowOiBbc2RoXSBXcml0ZSBQcm90ZWN0IGlzIG9mZg0K
c2QgMDoyOjY6MDogW3NkZ10gV3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQg
Y2FjaGU6IGRpc2FibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQ0K
c2QgMDoyOjc6MDogW3NkaF0gV3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQg
Y2FjaGU6IGRpc2FibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQ0K
IHNkZTogc2RlMSBzZGUyIHNkZTMgc2RlNCA8IHNkZTUgc2RlNiBzZGU3IHNk
ZTggPg0KIHNkZjogc2RmMSBzZGYyDQpzZCAwOjI6NTowOiBbc2RmXSBBdHRh
Y2hlZCBTQ1NJIGRpc2sNCnNkIDA6Mjo0OjA6IFtzZGVdIEF0dGFjaGVkIFND
U0kgZGlzaw0KIHNkZzogdW5rbm93biBwYXJ0aXRpb24gdGFibGUNCiBzZGg6
IHVua25vd24gcGFydGl0aW9uIHRhYmxlDQpzZCAwOjI6NjowOiBbc2RnXSBB
dHRhY2hlZCBTQ1NJIGRpc2sNCnNkIDA6Mjo3OjA6IFtzZGhdIEF0dGFjaGVk
IFNDU0kgZGlzaw0KTG9hZGluZyBpcHRfUkVKRUNULmtvIG1vZHVsZQ0KTG9h
ZGluZyBuZl9jb25udHJhY2tfaXB2NC5rbyBtb2R1bGUNCkxvYWRpbmcgaXB0
YWJsZV9maWx0ZXIua28gbW9ka3ZtOiBWTV9FWElUX0xPQURfSUEzMl9QRVJG
X0dMT0JBTF9DVFJMIGRvZXMgbm90IHdvcmsgcHJvcGVybHkuIFVzaW5nIHdv
cmthcm91bmQNCnVsZQ0KTG9hZGluZyBuZl9pVENPX3dkdDogSW50ZWwgVENP
IFdhdGNoRG9nIFRpbWVyIERyaXZlciB2MS4xMQ0KcmVqZWN0X2lwdjYua28g
bUlQTUkgU3lzdGVtIEludGVyZmFjZSBkcml2ZXIuDQpvZHVsZQ0KTG9hZGlu
ZyBuaXBtaV9zaTogcHJvYmluZyB2aWEgQUNQSQ0KZl9kZWZyYWdfaXB2Ni5r
b2lwbWlfc2kgMDA6MDY6IFtpbyAgMHgwY2EyLTB4MGNhM10gcmVnc2l6ZSAx
IHNwYWNpbmcgMSBpcnEgMA0KIG1vZHVsZQ0KTG9hZGluZ2lwbWlfc2k6IEFk
ZGluZyBBQ1BJLXNwZWNpZmllZCBrY3Mgc3RhdGUgbWFjaGluZSB4dF9zdGF0
ZS5rbyBtb2QNCnVsZQ0KTG9hZGluZyBpcDZpcG1pX3NpOiBwcm9iaW5nIHZp
YSBTTUJJT1MNCnRhYmxlX2ZpbHRlci5rbyBpcG1pX3NpOiBTTUJJT1M6IGlv
IDB4Y2EyIHJlZ3NpemUgMSBzcGFjaW5nIDEgaXJxIDANCmlwbWlfc2k6IEFk
ZGluZyBTTUJJT1Mtc3BlY2lmaWVkIGtjcyBzdGF0ZSBtYWNoaW5lbW9kdWxl
DQpMb2FkaW5nICBkdXBsaWNhdGUgaW50ZXJmYWNlDQptYWN2dGFwLmtvIG1v
ZHVsaXBtaV9zaTogVHJ5aW5nIEFDUEktc3BlY2lmaWVkIGtjcyBzdGF0ZSBt
YWNoaW5lIGF0IGkvbyBhZGRyZXNzIDB4Y2EyLCBzbGF2ZSBhZGRyZXNzIDB4
MCwgaXJxIDANCmUNCkxvYWRpbmcga3ZtLWludGVsLmtvIG1vZHVsZQ0KTG9h
ZGluZyBpVENPX3dkdC5rbyBtb2R1bGUNCkxvYWRpbmcgaXBtaV9zaS5rbyBt
b2R1bGUNCmlwbWlfc2kgMDA6MDY6IEZvdW5kIG5ldyBCTUMgKG1hbl9pZDog
MHgwMDI4ODAsIHByb2RfaWQ6IDB4MDI3NiwgZGV2X2lkOiAweDMyKQ0KaXBt
aV9zaSAwMDowNjogSVBNSSBrY3MgaW50ZXJmYWNlIGluaXRpYWxpemVkDQpM
b2FkaW5nIGxwY19pY2guaVRDT193ZHQ6IEZvdW5kIGEgSUNIMTAgVENPIGRl
dmljZSAoVmVyc2lvbj0yLCBUQ09CQVNFPTB4MDg2MCkNCmtvIG1vZHVsZQ0K
aVRDT193ZHQ6IGluaXRpYWxpemVkLiBoZWFydGJlYXQ9MzAgc2VjIChub3dh
eW91dD0wKQ0KQUNQSSBXYXJuaW5nOiBTeXN0ZW1JTyByYW5nZSAweDAwMDAw
MDAwMDAwMDA4MjgtMHgwMDAwMDAwMDAwMDAwODJmIGNvbmZsaWN0cyB3aXRo
IE9wUmVnaW9uIDB4MDAwMDAwMDAwMDAwMDgwMC0weDAwMDAwMDAwMDAwMDA4
NGYgKFxQTVJHKSAoMjAxNDExMDcvdXRhZGRyZXNzLTI1OCkNCkFDUEk6IElm
IGFuIEFDUEkgZHJpdmVyIGlzIGF2YWlsYWJsZSBmb3IgdGhpcyBkZXZpY2Us
IHlvdSBzaG91bGQgdXNlIGl0IGluc3RlYWQgb2YgdGhlIG5hdGl2ZSBkcml2
ZXINCkFDUEkgV2FybmluZzogU3lzdGVtSU8gcmFuZ2UgMHgwMDAwMDAwMDAw
MDAwNTAwLTB4MDAwMDAwMDAwMDAwMDUyZiBjb25mbGljdHMgd2l0aCBPcFJl
Z2lvbiAweDAwMDAwMDAwMDAwMDA1MDAtMHgwMDAwMDAwMDAwMDAwNTFiIChc
X1NJXy5CTE5LKSAoMjAxNDExMDcvdXRhZGRyZXNzLTI1OCkNCkFDUEk6IElm
IGFuIEFDUEkgZHJpdmVyIGlzIGF2YWlsYWJsZSBmb3IgdGhpcyBkZXZpY2Us
IHlvdSBzaG91bGQgdXNlIGl0IGluc3RlYWQgb2YgdGhlIG5hdGl2ZSBkcml2
ZXINCmxwY19pY2g6IFJlc291cmNlIGNvbmZsaWN0KHMpIGZvdW5kIGFmZmVj
dGluZyBncGlvX2ljaA0KTG9hZGluZyBpb2F0ZG1hLmlvYXRkbWE6IEludGVs
KFIpIFF1aWNrRGF0YSBUZWNobm9sb2d5IERyaXZlciA0LjAwDQprbyBtb2R1
bGUNCkxvYWRpbmcgaTdjb3JlX2VkYWMua28gbW9kdWxlDQpFREFDIE1DMTog
R2l2aW5nIG91dCBkZXZpY2UgdG8gbW9kdWxlIGk3Y29yZV9lZGFjLmMgY29u
dHJvbGxlciBpNyBjb3JlICMxOiBERVYgMDAwMDpmZTowMy4wIChQT0xMRUQp
DQpFREFDIFBDSTA6IEdpdmluZyBvdXQgZGV2aWNlIHRvIG1vZHVsZSBpN2Nv
cmVfZWRhYyBjb250cm9sbGVyIEVEQUMgUENJIGNvbnRyb2xsZXI6IERFViAw
MDAwOmZlOjAzLjAgKFBPTExFRCkNCkVEQUMgTUMwOiBHaXZpbmcgb3V0IGRl
dmljZSB0byBtb2R1bGUgaTdjb3JlX2VkYWMuYyBjb250cm9sbGVyIGk3IGNv
cmUgIzA6IERFViAwMDAwOmZmOjAzLjAgKFBPTExFRCkNCkVEQUMgUENJMTog
R2l2aW5nIG91dCBkZXZpY2UgdG8gbW9kdWxlIGk3Y29yZV9lZGFjIGNvbnRy
b2xsZXIgRURBQyBQQ0kgY29udHJvbGxlcjogREVWIDAwMDA6ZmY6MDMuMCAo
UE9MTEVEKQ0KRURBQyBpN2NvcmU6IERyaXZlciBsb2FkZWQsIDIgbWVtb3J5
IGNvbnRyb2xsZXIocykgZm91bmQuDQpMb2FkaW5nIHB0cC5rbyBtUFRQIGNs
b2NrIHN1cHBvcnQgcmVnaXN0ZXJlZA0Kb2R1bGUNCkxvYWRpbmcgZXh0NC5r
byBtb2R1bGUNCkxvYWRpbmcgbXB0c2NzaWgua28gbW9kdWxlDQpMb2FkaW5n
IGxwZmMua28gbW9kdWxlDQpFbXVsZXggTGlnaHRQdWxzZSBGaWJyZSBDaGFu
bmVsIFNDU0kgZHJpdmVyIDEwLjQuODAwMC4wLg0KQ29weXJpZ2h0KGMpIDIw
MDQtMjAxNCBFbXVsZXguICBBbGwgcmlnaHRzIHJlc2VydmVkLg0Kc2NzaSBo
b3N0MTogRW11bGV4IExQZTEyMDAwIFBDSWUgRmlicmUgQ2hhbm5lbCBBZGFw
dGVyICBvbiBQQ0kgYnVzIDMwIGRldmljZSAwMCBpcnEgNDANCnNjc2kgaG9z
dDI6IEVtdWxleCBMUGUxMjAwMCBQQ0llIEZpYnJlIENoYW5uZWwgQWRhcHRl
ciAgb24gUENJIGJ1cyAzMCBkZXZpY2UgMDEgaXJxIDQzDQpMb2FkaW5nIGlw
NnRfUkVKRUNULmtvIG1vZHVsZQ0KTG9hZGluZyBuZl9jb25udHJhY2tfaXB2
Ni5rbyBtb2R1aWdiOiBJbnRlbChSKSBHaWdhYml0IEV0aGVybmV0IE5ldHdv
cmsgRHJpdmVyIC0gdmVyc2lvbiA1LjIuMTUtaw0KbGUNCkxvYWRpbmcgdmhv
c2lnYjogQ29weXJpZ2h0IChjKSAyMDA3LTIwMTQgSW50ZWwgQ29ycG9yYXRp
b24uDQp0X25ldC5rbyBtb2R1bGUNCkxvYWRpbmcgaWdiLmtvIG1vZHVsZQ0K
aWdiIDAwMDA6MDE6MDAuMDogRENBIGVuYWJsZWQNCmlnYiAwMDAwOjAxOjAw
LjA6IEludGVsKFIpIEdpZ2FiaXQgRXRoZXJuZXQgTmV0d29yayBDb25uZWN0
aW9uDQppZ2IgMDAwMDowMTowMC4wOiBldGgwOiAoUENJZToyLjVHYi9zOldp
ZHRoIHgyKSBjODowYTphOTo5ZDpmYTo1Mg0KaWdiIDAwMDA6MDE6MDAuMDog
ZXRoMDogUEJBIE5vOiBVbmtub3duDQppZ2IgMDAwMDowMTowMC4wOiBVc2lu
ZyBNU0ktWCBpbnRlcnJ1cHRzLiAxIHJ4IHF1ZXVlKHMpLCAxIHR4IHF1ZXVl
KHMpDQppZ2IgMDAwMDowMTowMC4xOiBEQ0EgZW5hYmxlZA0KaWdiIDAwMDA6
MDE6MDAuMTogSW50ZWwoUikgR2lnYWJpdCBFdGhlcm5ldCBOZXR3b3JrIENv
bm5lY3Rpb24NCmlnYiAwMDAwOjAxOjAwLjE6IGV0aDE6IChQQ0llOjIuNUdi
L3M6V2lkdGggeDIpIGM4OjBhOmE5OjlkOmZhOjUzDQppZ2IgMDAwMDowMTow
MC4xOiBldGgxOiBQQkEgTm86IFVua25vd24NCmlnYiAwMDAwOjAxOjAwLjE6
IFVzaW5nIE1TSS1YIGludGVycnVwdHMuIDEgcnggcXVldWUocyksIDEgdHgg
cXVldWUocykNCmlnYiAwMDAwOjAyOjAwLjA6IERDQSBlbmFibGVkDQppZ2Ig
MDAwMDowMjowMC4wOiBJbnRlbChSKSBHaWdhYml0IEV0aGVybmV0IE5ldHdv
cmsgQ29ubmVjdGlvbg0KaWdiIDAwMDA6MDI6MDAuMDogZXRoMjogKFBDSWU6
Mi41R2IvczpXaWR0aCB4MikgYzg6MGE6YTk6OWQ6ZmE6NTQNCmlnYiAwMDAw
OjAyOjAwLjA6IGV0aDI6IFBCQSBObzogVW5rbm93bg0KaWdiIDAwMDA6MDI6
MDAuMDogVXNpbmcgTVNJLVggaW50ZXJydXB0cy4gMSByeCBxdWV1ZShzKSwg
MSB0eCBxdWV1ZShzKQ0KaWdiIDAwMDA6MDI6MDAuMTogRENBIGVuYWJsZWQN
CmlnYiAwMDAwOjAyOjAwLjE6IEludGVsKFIpIEdpZ2FiaXQgRXRoZXJuZXQg
TmV0d29yayBDb25uZWN0aW9uDQppZ2IgMDAwMDowMjowMC4xOiBldGgzOiAo
UENJZToyLjVHYi9zOldpZHRoIHgyKSBjODowYTphOTo5ZDpmYTo1NQ0KaWdi
IDAwMDA6MDI6MDAuMTogZXRoMzogUEJBIE5vOiBVbmtub3duDQppZ2IgMDAw
MDowMjowMC4xOiBVc2luZyBNU0ktWCBpbnRlcnJ1cHRzLiAxIHJ4IHF1ZXVl
KHMpLCAxIHR4IHF1ZXVlKHMpDQpMb2FkaW5nIG1wdHNhcy5rRnVzaW9uIE1Q
VCBTQVMgSG9zdCBkcml2ZXIgMy4wNC4yMA0KbyBtb2R1bGUNCm1wdGJhc2U6
IGlvYzA6IEluaXRpYXRpbmcgYnJpbmd1cA0KaW9jMDogTFNJU0FTMTA2NEUg
QjM6IENhcGFiaWxpdGllcz17SW5pdGlhdG9yfQ0Kc2NzaSBob3N0MzogaW9j
MDogTFNJU0FTMTA2NEUgQjMsIEZ3UmV2PTAxMWUwMDAwaCwgUG9ydHM9MSwg
TWF4UT0yNzcsIElSUT0xNg0KbXB0c2FzOiBpb2MwOiBhdHRhY2hpbmcgc2F0
YSBkZXZpY2U6IGZ3X2NoYW5uZWwgMCwgZndfaWQgMCwgcGh5IDAsIHNhc19h
ZGRyIDB4MTIyMTAwMDAwMDAwMDAwMA0Kc2NzaSAzOjA6MDowOiBEaXJlY3Qt
QWNjZXNzICAgICBBVEEgICAgICBTVDkxNjA1MTFOUyAgICAgIEZURDQgUFE6
IDAgQU5TSTogNQ0Kc2QgMzowOjA6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmlj
IHNnOCB0eXBlIDANCnNkIDM6MDowOjA6IFtzZGldIDMxMjU4MTgwOCA1MTIt
Ynl0ZSBsb2dpY2FsIGJsb2NrczogKDE2MCBHQi8xNDkgR2lCKQ0KbXB0c2Fz
OiBpb2MwOiBhdHRhY2hpbmcgc2F0YSBkZXZpY2U6IGZ3X2NoYW5uZWwgMCwg
ZndfaWQgMSwgcGh5IDEsIHNhc19hZGRyIDB4MTIyMTAwMDAwMTAwMDAwMA0K
c2NzaSAzOjA6MTowOiBEaXJlY3QtQWNjZXNzICAgICBBVEEgICAgICBTVDkx
NjA1MTFOUyAgICAgIEZURDQgUFE6IDAgQU5TSTogNQ0Kc2QgMzowOjE6MDog
QXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnOSB0eXBlIDANCnNkIDM6MDoxOjA6
IFtzZGpdIDMxMjU4MTgwOCA1MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDE2
MCBHQi8xNDkgR2lCKQ0Kc2QgMzowOjA6MDogW3NkaV0gV3JpdGUgUHJvdGVj
dCBpcyBvZmYNCnNkIDM6MDowOjA6IFtzZGldIFdyaXRlIGNhY2hlOiBlbmFi
bGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBP
IG9yIEZVQQ0Kc2QgMzowOjE6MDogW3Nkal0gV3JpdGUgUHJvdGVjdCBpcyBv
ZmYNCnNkIDM6MDoxOjA6IFtzZGpdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCBy
ZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZV
QQ0KIHNkaTogc2RpMSBzZGkyIHNkaTMNCnJhbmRvbTogbm9uYmxvY2tpbmcg
cG9vbCBpcyBpbml0aWFsaXplZA0KIHNkajogc2RqMSBzZGoyIHNkajMgc2Rq
NCA8IHNkajUgc2RqNiA+DQpzZCAzOjA6MDowOiBbc2RpXSBBdHRhY2hlZCBT
Q1NJIGRpc2sNCnNkIDM6MDoxOjA6IFtzZGpdIEF0dGFjaGVkIFNDU0kgZGlz
aw0KV2FpdGluZyBmb3IgcmVxdWlyZWQgYmxvY2sgZGV2aWNlIGRpc2NvdmVy
eQ0KV2FpdGluZyBmb3IgZGV2aWNlIHdpdGggc2NzaV9pZHM6IDM2MDAzMDA1
NzAxNGFhMzMwMTgyZjg2MzUyMDI3ZTExNCAuLi4NCkNyZWF0aW5nIGJsb2Nr
IGRldmljZSBsb29wMA0KQ3JlYXRpbmcgYmxvY2sgZGV2aWNlIGxvb3AxDQpD
cmVhdGluZyBibG9jayBkZXZpY2UgbG9vcDINCkNyZWF0aW5nIGJsb2NrIGRl
dmljZSBsb29wMw0KQ3JlYXRpbmcgYmxvY2sgZGV2aWNlIGxvb3A0DQpDcmVh
dGluZyBibG9jayBkZXZpY2UgbG9vcDUNCkNyZWF0aW5nIGJsb2NrIGRldmlj
ZSBsb29wNg0KQ3JlYXRpbmcgYmxvY2sgZGV2aWNlIGxvb3A3DQpDcmVhdGlu
ZyBibG9jayBkZXZpY2UgcmFtMA0KQ3JlYXRpbmcgYmxvY2sgZGV2aWNlIHJh
bTENCkNyZWF0aW5nIGJsb2NrIGRldmljZSByYW0xMA0KQ3JlYXRpbmcgYmxv
Y2sgZGV2aWNlIHJhbTExDQpDcmVhdGluZyBibG9jayBkZXZpY2UgcmFtMTIN
CkNyZWF0aW5nIGJsb2NrIGRldmljZSByYW0xMw0KQ3JlYXRpbmcgYmxvY2sg
ZGV2aWNlIHJhbTE0DQpDcmVhdGluZyBibG9jayBkZXZpY2UgcmFtMTUNCkNy
ZWF0aW5nIGJsb2NrIGRldmljZSByYW0yDQpDcmVhdGluZyBibG9jayBkZXZp
Y2UgcmFtMw0KQ3JlYXRpbmcgYmxvY2sgZGV2aWNlIHJhbTQNCkNyZWF0aW5n
IGJsb2NrIGRldmljZSByYW01DQpDcmVhdGluZyBibG9jayBkZXZpY2UgcmFt
Ng0KQ3JlYXRpbmcgYmxvY2sgZGV2aWNlIHJhbTcNCkNyZWF0aW5nIGJsb2Nr
IGRldmljZSByYW04DQpDcmVhdGluZyBibG9jayBkZXZpY2UgcmFtOQ0KQ3Jl
YXRpbmcgYmxvY2sgZCBzZGE6IHNkYTENCmV2aWNlIHNkYQ0KQ3JlYXRpbmcg
YmxvY2sgZGV2aWNlIHNkYg0KIHNkYjogc2RiMQ0KQ3JlYXRpbmcgYmxvY2sg
ZCBzZGM6IHNkYzEgc2RjMg0KZXZpY2Ugc2RjDQpDcmVhdGluZyBibG9jayBk
IHNkZDogc2RkMSBzZGQyDQpldmljZSBzZGQNCkNyZWF0aW5nIGJsb2NrIGRl
dmljZSBzZGUNCiBzZGU6IHNkZTEgc2RlMiBzZGUzIHNkZTQgPCBzZGU1IHNk
ZTYgc2RlNyBzZGU4ID4NCkNyZWF0aW5nIGJsb2NrIGQgc2RmOiBzZGYxIHNk
ZjINCmV2aWNlIHNkZg0KQ3JlYXRpbmcgYmxvY2sgZCBzZGc6IHVua25vd24g
cGFydGl0aW9uIHRhYmxlDQpldmljZSBzZGcNCkNyZWF0aW5nIGJsb2NrIGQg
c2RoOiB1bmtub3duIHBhcnRpdGlvbiB0YWJsZQ0KZXZpY2Ugc2RoDQpDcmVh
dGluZyBibG9jayBkZXZpY2Ugc2RpDQogc2RpOiBzZGkxIHNkaTIgc2RpMw0K
Q3JlYXRpbmcgYmxvY2sgZGV2aWNlIHNkag0KIHNkajogc2RqMSBzZGoyIHNk
ajMgc2RqNCA8IHNkajUgc2RqNiA+DQpGb3VuZCBkZXZpY2Ugd2l0aCBzY3Np
X2lkczogMzYwMDMwMDU3MDE0YWEzMzAxODJmODYzNTIwMjdlMTE0DQpDcmVh
dGluZyBSZW1haW4gQmxvY2sgRGV2aWNlcw0KU2F2aW5nIHRvIHRoZSBsb2Nh
bCBmaWxlc3lzdGVtIExBQkVMPS9kdW1wMg0KZTJmc2NrIDEuNDEuMTIgKDE3
LU1heS0yMDEwKQ0KL2R1bXAyOiBjbGVhbiwgMzUvODkyOTI4MCBmaWxlcywg
OTI5NTE4LzM1NzA4NjcyIGJsb2Nrcw0KRVhUNC1mcyAoc2RhMSk6IG1vdW50
ZWQgZmlsZXN5c3RlbSB3aXRoIG9yZGVyZWQgZGF0YSBtb2RlLiBPcHRzOiAN
CkZyZWUgbWVtb3J5L1RvdGFsIG1lbW9yeSAoZnJlZSAlKTogNjE4MTIgLyAx
MTAyMDAgKCA1Ni4wOTA3ICkNClNhdmluZyB2bWNvcmUtZG1lc2cudHh0DQpN
aXNzaW5nIHRoZSBzdHJ1Y3QgbG9nIHNpemUgZXhwb3J0DQpTYXZpbmcgdm1j
b3JlLWRtZXNnLnR4dCBmYWlsZWQNCg1FeGNsdWRpbmcgdW5uZWNlc3Nhcnkg
cGFnZXMgICAgICAgIDogWyAgMCAlXSANRXhjbHVkaW5nIHVubmVjZXNzYXJ5
IHBhZ2VzICAgICAgICA6IFsxMDAgJV0gDUV4Y2x1ZGluZyB1bm5lY2Vzc2Fy
eSBwYWdlcyAgICAgICAgOiBbIDEyICVdIA1FeGNsdWRpbmcgdW5uZWNlc3Nh
cnkgcGFnZXMgICAgICAgIDogWzEwMCAlXSANQ29weWluZyBkYXRhICAgICAg
ICAgICAgICAgICAgICAgICA6IFsgIDIgJV0gDUNvcHlpbmcgZGF0YSAgICAg
ICAgICAgICAgICAgICAgICAgOiBbIDEyICVdIA1Db3B5aW5nIGRhdGEgICAg
ICAgICAgICAgICAgICAgICAgIDogWyAxOSAlXSANQ29weWluZyBkYXRhICAg
ICAgICAgICAgICAgICAgICAgICA6IFsgMjYgJV0gDUNvcHlpbmcgZGF0YSAg
ICAgICAgICAgICAgICAgICAgICAgOiBbIDM2ICVdIA1Db3B5aW5nIGRhdGEg
ICAgICAgICAgICAgICAgICAgICAgIDogWyA0NyAlXSANQ29weWluZyBkYXRh
ICAgICAgICAgICAgICAgICAgICAgICA6IFsgNTcgJV0gDUNvcHlpbmcgZGF0
YSAgICAgICAgICAgICAgICAgICAgICAgOiBbIDY4ICVdIA1Db3B5aW5nIGRh
dGEgICAgICAgICAgICAgICAgICAgICAgIDogWyA3NSAlXSANQ29weWluZyBk
YXRhICAgICAgICAgICAgICAgICAgICAgICA6IFsgODYgJV0gDUNvcHlpbmcg
ZGF0YSAgICAgICAgICAgICAgICAgICAgICAgOiBbIDk1ICVdIA1Db3B5aW5n
IGRhdGEgICAgICAgICAgICAgICAgICAgICAgIDogWzEwMCAlXSANChtbMEpT
YXZpbmcgY29yZSBjb21wbGV0ZQ0Ka3ZtOiBleGl0aW5nIGhhcmR3YXJlIHZp
cnR1YWxpemF0aW9uDQpzZCAzOjA6MTowOiBbc2RqXSBTeW5jaHJvbml6aW5n
IFNDU0kgY2FjaGUNCnNkIDM6MDowOjA6IFtzZGldIFN5bmNocm9uaXppbmcg
U0NTSSBjYWNoZQ0Kc2QgMDoyOjc6MDogW3NkaF0gU3luY2hyb25pemluZyBT
Q1NJIGNhY2hlDQpzZCAwOjI6NjowOiBbc2RnXSBTeW5jaHJvbml6aW5nIFND
U0kgY2FjaGUNCnNkIDA6Mjo1OjA6IFtzZGZdIFN5bmNocm9uaXppbmcgU0NT
SSBjYWNoZQ0Kc2QgMDoyOjQ6MDogW3NkZV0gU3luY2hyb25pemluZyBTQ1NJ
IGNhY2hlDQpzZCAwOjI6MzowOiBbc2RkXSBTeW5jaHJvbml6aW5nIFNDU0kg
Y2FjaGUNCnNkIDA6MjoyOjA6IFtzZGNdIFN5bmNocm9uaXppbmcgU0NTSSBj
YWNoZQ0Kc2QgMDoyOjE6MDogW3NkYl0gU3luY2hyb25pemluZyBTQ1NJIGNh
Y2hlDQpzZCAwOjI6MDowOiBbc2RhXSBTeW5jaHJvbml6aW5nIFNDU0kgY2Fj
aGUNCnJlYm9vdDogUmVzdGFydGluZyBzeXN0ZW0NCnJlYm9vdDogbWFjaGlu
ZSByZXN0YXJ0

--------------080107040006090300080703--
