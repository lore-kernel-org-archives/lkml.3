Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaDYSNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:13:20 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:45020 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaDYSNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:13:18 -0400
From: "Sumner, William" <bill.sumner@hp.com>
To: Don Dutile <ddutile@redhat.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        "bhe@redhat.com" <bhe@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Hatch, Douglas B (HPS Linux PM)" <doug.hatch@hp.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>,
        "Hoemann, Jerry" <jerry.hoemann@hp.com>
Subject: RE: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Thread-Topic: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Thread-Index: AQHPDlBjPwJavIH01UGK8YIeAgS3uJsHJ2WAgBwb2iA=
Date: Fri, 25 Apr 2014 18:11:47 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A066E3CF5B@G4W3299.americas.hpqcorp.net>
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
 <53430DE9.9080303@redhat.com>
In-Reply-To: <53430DE9.9080303@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

      1 Hi Don,
      2 It seems that we agree in the area of keeping the iommu active and using it to
      3 isolate the legacy DMA.  We also agree that the device's IO driver should be
      4 the software that deals with the device (e.g.: resets it, etc.)
      5
      6 It also seems that there are several differences in our two approaches to how
      7 the iommu is then used to accomplish this common goal.
      8
      9 More detailed replies are among your comments below.
     10
     11 On Monday 4/7/2014: Don Dutile wrote:
     12 >On 01/10/2014 05:07 PM, Bill Sumner wrote:
     13 >> v2->v3:
     14 >> 1. Commented-out "#define DEBUG 1" to eliminate debug messages
     15 >> 2. Updated the comments about changes in each version in all patches in the set        .
     16 >> 3. Fixed: one-line added to Copy-Translations" patch to initialize the iovad
     17 >>            struct as recommended by Baoquan He [bhe@redhat.com]
     18 >>            init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
     19 >>
     20 >> v1->v2:
     21 >> The following series implements a fix for:
     22 >> A kdump problem about DMA that has been discussed for a long time. That is,
     23 >> when a kernel panics and boots into the kdump kernel, DMA started by the
     24 >> panicked kernel is not stopped before the kdump kernel is booted and the
     25 >> kdump kernel disables the IOMMU while this DMA continues.  This causes the
     26 >> IOMMU to stop translating the DMA addresses as IOVAs and begin to treat them
     27 >> as physical memory addresses -- which causes the DMA to either:
     28 >> (1) generate DMAR errors or (2) generate PCI SERR errors or (3) transfer
     29 >> data to or from incorrect areas of memory. Often this causes the dump to fail.
     30 >>
     31 >> This patch set modifies the behavior of the iommu in the (new) crashdump kernel        :
     32 >> 1. to accept the iommu hardware in an active state,
     33 >> 2. to leave the current translations in-place so that legacy DMA will continue
     34 >>     using its current buffers until the device drivers in the crashdump kernel
     35 >>     initialize and initialize their devices,
     36 >> 3. to use different portions of the iova address ranges for the device drivers
     37 >>     in the crashdump kernel than the iova ranges that were in-use at the time
     38 >>     of the panic.
     39 >>
     40 >> Advantages of this approach:
     41 >> 1. All manipulation of the IO-device is done by the Linux device-driver
     42 >>     for that device.
     43 >> 2. This approach behaves in a manner very similar to operation without an
     44 >>     active iommu.
     45 >
     46 >Sorry to be late to the game.... finally getting out of a deep hole &
     47 >asked to look at this proposal...
     48 >
     49 >Along this concept -- similar to operation without an active iommu --
     50 >have you considered the following:
     51 >a) if (this is crash kernel), turn *off* DMAR faults;
     52 I did look at turning off DMAR faults and, although I chose not to disable
     53 them in my current patch submissions, I think that this is still an open area
     54 to explore -- especially for any cases where DMAR faults were already occurring
     55 in the panicked kernel. We may want to explore expanding the patches to cover the
     56 case where legacy DMAR faults are still occurring in the kdump kernel.
     57 I would recommend tackling this as a separate follow-on effort.
     58 In testing my patches, I have seen no new DMAR faults introduced by them.
     59 In fact, the transition is seamless, leaving no time window where (for
     60 instance) RMRR DMA would fail.
     61
     62 >b) if (this is crash kernel), isolate all device DMA in IOMMU
     63 I agree, the iommu is a great resource to isolate device DMA into safe memory
     64 areas -- we should leave it active and use it.
     65
     66 >b) as second kernel configures each device, have each device to use IOMMU hw-pass        through,
     67 >      i.e., the equivalent of having no IOMMU for the second, kexec'd kernel
     68 >   but, having the benefit of keeping all the other (potentially bad) devices
     69 >   sequestered / isolated, until they are initialized & re-configured in the seco        nd kernel,
     70 >    *if at all* -- note: kexec'd kernels may not enable/configure all devices tha        t
     71 >    existed in the first kernel (Bill: I'm sure you know this, but others may not        ).
     72 >
     73 >RMRR's that were previously setup could continue to work if they are skipped in s        tep (b),
     74 >unless the device has gone mad/bad.  In that case, re-parsing the RMRR may or may         not
     75 >clear up the issue.
     76 >
     77 >Additionally, a tidbit of information like "some servers force NMI's on DMAR faul        ts,
     78 >and cause a system reset, thereby, preventing a kdump to occur"
     79 >should have been included as one reason to stop DMAR faults from occurring on kex        ec-boot,
     80 >in addition to the fact that a flood of them can lock up a system.
     81 If a server will "force NMI's on DMAR faults, and cause a system reset, thereby,
     82 preventing a kdump to occur" then if the panicked kernel was already causing DMAR
     83 faults our dump is already doomed.  If the panicked kernel was *not* causing
     84 DMAR faults, then any kdump technique that does not introduce any new DMAR
     85 fault conditions should be ok.
     86 >
     87 >Again, just turning off DMAR fault reporting for the 'if (this is crash kernel)',
     88 >short-term workaround sounds a whole lot less expensive to implement, as well as
     89 >'if (this is crash kernel), force hw-passthrough'.
     90 Actually it may not be all that less expensive once the details of
     91 its implementation are explored.
     92
     93 1. Especially with the current patches already available and somewhat tested.
     94
     95 2. I think that implementing what you suggest will require some manipulation
     96 of the translation tables and their base register in the iommu -- code
     97 that seems likely to be similar to what is in the patches.  If this effort
     98 goes in the direction you suggest, perhaps some of the code in the patches
     99 could be of help.
    100 >
    101 >If the IO devices are borked to the point that they won't complete DMA properly,
    102 >with or without IOMMU, the system is dead anyhow, game over.
    103 True, and there is probably not much we can do about it.
    104 >
    105 >Finally, copying the previous IOMMU state to the second kernel, and hoping
    106 >that the cause of the kernel crash wasn't an errant DMA (e.g., due to a device going bad,
    107 >or it's DMA-state being corrupted & causing an improper IO), is omitting an important failure
    108 >case/space.
    109 I am not just "hoping":
    110 a. The iommu isolates all device DMA to buffers dictated by the translation
    111 tables -- whether those tables are the ones I copied or the ones that were
    112 created in kdump to isolate the DMA to new memory buffers.  By design,
    113 the iommu hardware very strongly limits what memory a device can access --
    114 even in the cited case where the device has a corrupted state and may be
    115 making all sorts of bad requests.
    116
    117 b. The iommu tables of course could be "hosed" which would cause problems; but
    118 in the normal case the translation tables are updated only by a small amount
    119 of software in the iommu driver and the dma software.  This fortunately
    120 provides a relatively solid foundation that ensures the integrity of the
    121 tables that the iommu hardware is using for translations.
    122
    123 c. Since the tables the patches copy come from a panicked kernel, they are
    124 vetted as well as we can before they are copied and used in the kdump kernel.
    125 This happens early in kdump __init before any of the copied tables are used
    126 by the kdump iommu driver software.  Currently if the patches find any bad
    127 tables, they simply bail-out of taking the dump -- another area where they
    128 might be expanded -- to do something different in this case.
    129
    130 d. The most vulnerable place I have noticed for bugs in the Linux kernel to
    131 generate bad translations in the iommu tables is the short path in the
    132 device drivers between obtaining the memory buffer from some allocator
    133 and then obtaining an IOVA for that buffer from the dma subsystem.
    134 If the device driver loses the buffer address and/or hands the dma subsystem
    135 a different buffer address when it requests the IOVA, then the iommu has
    136 no way of knowing that the buffer address is bad, creates the translation,
    137 and bad things happen.
    138
    139 >Keeping the first-kernel DMA isolated (IOMMU on, all translations off, all DMAR faults off),
    140 >and then allowing each device (driver) configuration to sanely reset the device &
    141 >start a new (hw-passthrough) domain seems simpler and cleaner, for this dump-and-run kernel
    142 >effort.
    143 As you explore the technique of turning-off translations, a few questions come to mind:
    144 1. How is the RMRR activity supported? Any time windows where the device cannot
    145 initiate a DMA transaction will need to be minimized.
    146
    147 2. How does the iommu code know when the device has been reset by its driver
    148 so that it is now safe to program new translations into the iommu tables?
    149 The first communication the iommu code gets from the driver is when the driver
    150 requests a translation via the dma services.  I see no ordering requirement
    151 on the driver that it must have already reset the device at this time.
    152 The driver may be accumulating buffers that it will later send to the device
    153 during the reset sequence for use as work queues, status inputs, or data
    154 buffers.
    155
    156 3.  What happens if hardware pass-through is enabled for a device before the
    157 driver resets it ?  This would seem to allow any legacy DMA to run rampant.
    158 >
    159 >- Don
    160 >
    161 >> 3. Any activity between the IO-device and its RMRR areas is handled by the
    162 >>     device-driver in the same manner as during a non-kdump boot.
    163 >> 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
    164 >>     This supports the practice of creating a special kdump kernel without
    165 >>     drivers for any devices that are not required for taking a crashdump.
    166 >>
    167 >> Changes since the RFC version of this patch:
    168 >> 1. Consolidated all of the operational code into the "copy..." functions.
    169 >>     The "process..." functions were primarily used for diagnostics and
    170 >>     exploration; however, there was a small amount of operational code that
    171 >>     used the "process..." functions.
    172 >>     This operational code has been moved into the "copy..." functions.
    173 >>
    174 >> 2. Removed the "Process ..." functions and the diagnostic code that ran
    175 >>     on that function set.  This removed about 1/4 of the code -- which this
    176 >>     operational patch set no longer needs.  These portions of the RFC patch
    177 >>     could be formatted as a separate patch and submitted independently
    178 >>     at a later date.
    179 >>
    180 >> 3. Re-formatted the code to the Linux Coding Standards.
    181 >>     The checkpatch script still finds some lines to complain about;
    182 >>     however most of these lines are either (1) lines that I did not change,
    183 >>     or (2) lines that only changed by adding a level of indent which pushed
    184 >>     them over 80-characters, or (3) new lines whose intent is far clearer when
    185 >>     longer than 80-characters.
    186 >>
    187 >> 4. Updated the remaining debug print to be significantly more flexible.
    188 >>     This allows control over the amount of debug print to the console --
    189 >>     which can vary widely.
    190 >>
    191 >> 5. Fixed a couple of minor bugs found by testing on a machine with a
    192 >>     very large IO configuration.
    193 >>
    194 >> At a high level, this code operates primarily during iommu initialization
    195 >> and device-driver initialization
    196 >>
    197 >> During intel-iommu hardware initialization:
    198 >> In intel_iommu_init(void)
    199 >> * If (This is the crash kernel)
    200 >>    .  Set flag: crashdump_accepting_active_iommu (all changes below check this)
    201 >>    .  Skip disabling the iommu hardware translations
    202 >>
    203 >> In init_dmars()
    204 >> * Duplicate the intel iommu translation tables from the old kernel
    205 >>    in the new kernel
    206 >>    . The root-entry table, all context-entry tables,
    207 >>      and all page-translation-entry tables
    208 >>    . The duplicate tables contain updated physical addresses to link them toget        her.
    209 >>    . The duplicate tables are mapped into kernel virtual addresses
    210 >>      in the new kernel which allows most of the existing iommu code
    211 >>      to operate without change.
    212 >>    . Do some minimal sanity-checks during the copy
    213 >>    . Place the address of the new root-entry structure into "struct intel_iommu        "
    214 >>
    215 >> * Skip setting-up new domains for 'si', 'rmrr', 'isa'
    216 >>    . Translations for 'rmrr' and 'isa' ranges have been copied from the old ker        nel
    217 >>    . This patch has not yet been tested with iommu pass-through enabled
    218 >>
    219 >> * Existing (unchanged) code near the end of dmar_init:
    220 >>    . Loads the address of the (now new) root-entry structure from
    221 >>      "struct intel_iommu" into the iommu hardware and does the hardware flushes        .
    222 >>      This changes the active translation tables from the ones in the old kernel
    223 >>      to the copies in the new kernel.
    224 >>    . This is legal because the translations in the two sets of tables are
    225 >>      currently identical:
    226 >>        Virtualization Technology for Directed I/O. Architecture Specification,
    227 >>        February 2011, Rev. 1.3  (section 11.2, paragraph 2)
    228 >>
    229 >> In iommu_init_domains()
    230 >> * Mark as in-use all domain-id's from the old kernel
    231 >>    . In case the new kernel contains a device that was not in the old kernel
    232 >>      and a new, unused domain-id is actually needed, the bitmap will give us on        e.
    233 >>
    234 >> When a new domain is created for a device:
    235 >> * If (this device has a context in the old kernel)
    236 >>    . Get domain-id, address-width, and IOVA ranges from the old kernel context;
    237 >>    . Get address(page-entry-tables) from the copy in the new kernel;
    238 >>    . And apply all of the above values to the new domain structure.
    239 >> * Else
    240 >>    . Create a new domain as normal
    241 >>
    242 >>
    243 >> Bill Sumner (6):
    244 >>    Crashdump-Accepting-Active-IOMMU-Flags-and-Prototype
    245 >>    Crashdump-Accepting-Active-IOMMU-Utility-functions
    246 >>    Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
    247 >>    Crashdump-Accepting-Active-IOMMU-Copy-Translations
    248 >>    Crashdump-Accepting-Active-IOMMU-Debug-Print-IOMMU
    249 >>    Crashdump-Accepting-Active-IOMMU-Call-From-Mainline
    250 >>
    251 >>   drivers/iommu/intel-iommu.c | 1293 ++++++++++++++++++++++++++++++++++++++++--        -
    252 >>   1 file changed, 1225 insertions(+), 68 deletions(-)
    253 >>
    254 >
    255 >
    256 In summary:
    257 1. We seem to agree that keeping the iommu active and using it is a good idea.
    258 And there are a few different ideas about how to use it.  It will be
    259 a good conversation to explore these and settle on a final solution.
    260
    261 2. Since the patches are currently available on a recent stable baseline,
    262 and the technique in them has already been somewhat tested by three companies
    263 and found to work, I would recommend completing the review, testing, and
    264 implementation of these patches into the Linux kernel. They appear to solve
    265 the majority of the currently observed problems.
    266
    267 3. After that, exploration of other methodologies or extensions of these
    268 patches could be pursued.
    269
    270 -- Bill
