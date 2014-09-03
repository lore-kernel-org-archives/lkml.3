Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaICUVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:21:08 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:54173 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaICUVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <5405D2D8.1040700@mellanox.com>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>
	<5405D2D8.1040700@mellanox.com>
Date: Wed, 3 Sep 2014 23:21:03 +0300
Message-ID: <CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
From: Or Gerlitz <gerlitz.or@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagig@mellanox.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014, Or Gerlitz <ogerlitz@mellanox.com> wrote:
> On 7/3/2014 11:44 AM, Haggai Eran wrote:
>>
>> Hi Roland,
>>
>> I understand that you were reluctant to review these patches as long as
>> there was an ongoing debate on whether or not the i_mmap_mutex should be
>> changed into a spinlock.
>>
>> It seems that the debate concluded with the decision to change it into a
>> rwsem [1], as apparently this provides the optimal performance with the new
>> optimistic spinning patch [2].
>>
>> I believe this means that there will be no problem adding paging support
>> to the RDMA stack that depends on sleepable MMU notifiers.
>
>
> Hi Roland,
>
> The ODP patch set was initially posted whole six months ago (March 2nd,
> 2014). We did it prior to LSF so you can discuss that with Sagi while he's
> there. Well no comment from your side so far. It's really (really) hard to
> do proper kernel development when the sub-system maintainer doesn't provide
> you almost no concrete feedback over half a year.
>
> Can you please go ahead and tell us your position re this features/patches?

Hi Roland,

Bump. Can you comment here? these patches were worked out here for
long time by a dedicated group and implement a strategic feature for
the RDMA industry.
I don't see why the RDMA kernel maintainer can leave the development
team in the air without any comment on their work for half a year.

Or.


>> Changes from V0: http://marc.info/?l=linux-rdma&m=139375790322547&w=2
>>
>> - Rebased against latest upstream / for-next branch.
>> - Removed dependency on patches that were accepted upstream.
>> - Removed pre-patches that were accepted upstream [3].
>> - Add extended uverb call for querying device (patch 1) and use kernel
>> device
>>    attributes to report ODP capabilities through the new uverb entry
>> instead of
>>    having a special verb.
>> - Allow upgrading page access permissions during page faults.
>> - Minor fixes to issues that came up during regression testing of the
>> patches.
>>
>> The following set of patches implements on-demand paging (ODP) support
>> in the RDMA stack and in the mlx5_ib Infiniband driver.
>>
>> What is on-demand paging?
>>
>> Applications register memory with an RDMA adapter using system calls,
>> and subsequently post IO operations that refer to the corresponding
>> virtual addresses directly to HW. Until now, this was achieved by
>> pinning the memory during the registration calls. The goal of on demand
>> paging is to avoid pinning the pages of registered memory regions (MRs).
>> This will allow users the same flexibility they get when swapping any
>> other part of their processes address spaces. Instead of requiring the
>> entire MR to fit in physical memory, we can allow the MR to be larger,
>> and only fit the current working set in physical memory.
>>
>> This can make programming with RDMA much simpler. Today, developers that
>> are working with more data than their RAM can hold need either to
>> deregister and reregister memory regions throughout their process's
>> life, or keep a single memory region and copy the data to it. On demand
>> paging will allow these developers to register a single MR at the
>> beginning of their process's life, and let the operating system manage
>> which pages needs to be fetched at a given time. In the future, we might
>> be able to provide a single memory access key for each process that
>> would provide the entire process's address as one large memory region,
>> and the developers wouldn't need to register memory regions at all.
>>
>> How does page faults generally work?
>>
>> With pinned memory regions, the driver would map the virtual addresses
>> to bus addresses, and pass these addresses to the HCA to associate them
>> with the new MR. With ODP, the driver is now allowed to mark some of the
>> pages in the MR as not-present. When the HCA attempts to perform memory
>> access for a communication operation, it notices the page is not
>> present, and raises a page fault event to the driver. In addition, the
>> HCA performs whatever operation is required by the transport protocol to
>> suspend communication until the page fault is resolved.
>>
>> Upon receiving the page fault interrupt, the driver first needs to know
>> on which virtual address the page fault occurred, and on what memory
>> key. When handling send/receive operations, this information is inside
>> the work queue. The driver reads the needed work queue elements, and
>> parses them to gather the address and memory key. For other RDMA
>> operations, the event generated by the HCA only contains the virtual
>> address and rkey, as there are no work queue elements involved.
>>
>> Having the rkey, the driver can find the relevant memory region in its
>> data structures, and calculate the actual pages needed to complete the
>> operation. It then uses get_user_pages to retrieve the needed pages back
>> to the memory, obtains dma mapping, and passes the addresses to the HCA.
>> Finally, the driver notifies the HCA it can continue operation on the
>> queue pair that encountered the page fault. The pages that
>> get_user_pages returned are unpinned immediately by releasing their
>> reference.
>>
>> How are invalidations handled?
>>
>> The patches add infrastructure to subscribe the RDMA stack as an mmu
>> notifier client [4]. Each process that uses ODP register a notifier
>> client.
>> When receiving page invalidation notifications, they are passed to the
>> mlx5_ib driver, which updates the HCA with new, not-present mappings.
>> Only after flushing the HCA's page table caches the notifier returns,
>> allowing the kernel to release the pages.
>>
>> What operations are supported?
>>
>> Currently only send, receive and RDMA write operations are supported on
>> the
>> RC protocol, and also send operations on the UD protocol. We hope to
>> implement support for other transports and operations in the future.
>>
>> The structure of the patchset
>>
>> Patches 1-6:
>> The first set of patches adds page fault support to the IB core layer,
>> allowing MRs to be registered without their pages to be pinned. Patch 1
>> adds an extended verb to query device attributes, and patch 2
>> adds capability bits, configuration options, and a method for querying
>> whether the paging capabilities from user-space. The next two patches
>> (3-4)
>> make some necessary changes to the ib_umem type. Patches 5 and 6 add
>> paging support and invalidation support respectively.
>>
>> Patches 7-12:
>> This set of patches add small size new functionality to the mlx5 driver
>> and
>> builds toward paging support. Patch 7 make changes to UMR mechanism
>> (an internal mechanism used by mlx5 to update device page mappings).
>> Patch 8 adds infrastructure support for page fault handling to the
>> mlx5_core module. Patch 9 queries the device for paging capabilities, and
>> patch 11 adds a function to do partial device page table updates. Finally,
>> patch 12 adds a helper function to read information from user-space work
>> queues in the driver's context.
>>
>> Patches 13-16:
>> The final part of this patch set finally adds paging support to the mlx5
>> driver. Patch 13 adds in mlx5_ib the infrastructure to handle page faults
>> coming from mlx5_core. Patch 14 adds the code to handle UD send page
>> faults
>> and RC send and receive page faults. Patch 15 adds support for page faults
>> caused by RDMA write operations, and patch 16 adds invalidation support to
>> the mlx5 driver, allowing pages to be unmapped dynamically.
>>
>> [1] [PATCH 0/5] mm: i_mmap_mutex to rwsem
>>      https://lkml.org/lkml/2013/6/24/683
>>
>> [2] Re: Performance regression from switching lock to rw-sem for anon-vma
>> tree
>>      https://lkml.org/lkml/2013/6/17/452
>>
>> [3] pre-patches that were accepted upstream:
>>    a74d241 IB/mlx5: Refactor UMR to have its own context struct
>>    48fea83 IB/mlx5: Set QP offsets and parameters for user QPs and not
>> just for kernel QPs
>>    b475598 mlx5_core: Store MR attributes in mlx5_mr_core during creation
>> and after UMR
>>    8605933 IB/mlx5: Add MR to radix tree in reg_mr_callback
>>
>> [4] Integrating KVM with the Linux Memory Management (presentation),
>>      Andrea Archangeli
>>
>> http://www.linux-kvm.org/wiki/images/3/33/KvmForum2008%24kdf2008_15.pdf
>>
>>
>> Haggai Eran (11):
>>    IB/core: Add an extended user verb to query device attributes
>>    IB/core: Replace ib_umem's offset field with a full address
>>    IB/core: Add umem function to read data from user-space
>>    IB/mlx5: Enhance UMR support to allow partial page table update
>>    net/mlx5_core: Add support for page faults events and low level
>>      handling
>>    IB/mlx5: Implement the ODP capability query verb
>>    IB/mlx5: Changes in memory region creation to support on-demand
>>      paging
>>    IB/mlx5: Add mlx5_ib_update_mtt to update page tables after creation
>>    IB/mlx5: Add function to read WQE from user-space
>>    IB/mlx5: Page faults handling infrastructure
>>    IB/mlx5: Handle page faults
>>
>> Sagi Grimberg (1):
>>    IB/core: Add flags for on demand paging support
>>
>> Shachar Raindel (4):
>>    IB/core: Add support for on demand paging regions
>>    IB/core: Implement support for MMU notifiers regarding on demand
>>      paging regions
>>    IB/mlx5: Add support for RDMA write responder page faults
>>    IB/mlx5: Implement on demand paging by adding support for MMU
>>      notifiers
>>
>>   drivers/infiniband/Kconfig                     |  11 +
>>   drivers/infiniband/core/Makefile               |   1 +
>>   drivers/infiniband/core/umem.c                 |  63 +-
>>   drivers/infiniband/core/umem_odp.c             | 620
>> ++++++++++++++++++++
>>   drivers/infiniband/core/umem_rbtree.c          |  94 +++
>>   drivers/infiniband/core/uverbs.h               |   1 +
>>   drivers/infiniband/core/uverbs_cmd.c           | 170 ++++--
>>   drivers/infiniband/core/uverbs_main.c          |   5 +-
>>   drivers/infiniband/hw/amso1100/c2_provider.c   |   2 +-
>>   drivers/infiniband/hw/ehca/ehca_mrmw.c         |   2 +-
>>   drivers/infiniband/hw/ipath/ipath_mr.c         |   2 +-
>>   drivers/infiniband/hw/mlx5/Makefile            |   1 +
>>   drivers/infiniband/hw/mlx5/main.c              |  39 +-
>>   drivers/infiniband/hw/mlx5/mem.c               |  67 ++-
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h           | 114 +++-
>>   drivers/infiniband/hw/mlx5/mr.c                | 303 ++++++++--
>>   drivers/infiniband/hw/mlx5/odp.c               | 770
>> +++++++++++++++++++++++++
>>   drivers/infiniband/hw/mlx5/qp.c                | 198 +++++--
>>   drivers/infiniband/hw/nes/nes_verbs.c          |   4 +-
>>   drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |   2 +-
>>   drivers/infiniband/hw/qib/qib_mr.c             |   2 +-
>>   drivers/net/ethernet/mellanox/mlx5/core/eq.c   |  11 +-
>>   drivers/net/ethernet/mellanox/mlx5/core/fw.c   |  35 +-
>>   drivers/net/ethernet/mellanox/mlx5/core/main.c |   8 +-
>>   drivers/net/ethernet/mellanox/mlx5/core/qp.c   | 134 ++++-
>>   include/linux/mlx5/device.h                    |  73 ++-
>>   include/linux/mlx5/driver.h                    |  20 +-
>>   include/linux/mlx5/qp.h                        |  63 ++
>>   include/rdma/ib_umem.h                         |  29 +-
>>   include/rdma/ib_umem_odp.h                     | 156 +++++
>>   include/rdma/ib_verbs.h                        |  47 +-
>>   include/uapi/rdma/ib_user_verbs.h              |  25 +
>>   32 files changed, 2907 insertions(+), 165 deletions(-)
>>   create mode 100644 drivers/infiniband/core/umem_odp.c
>>   create mode 100644 drivers/infiniband/core/umem_rbtree.c
>>   create mode 100644 drivers/infiniband/hw/mlx5/odp.c
>>   create mode 100644 include/rdma/ib_umem_odp.h
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
