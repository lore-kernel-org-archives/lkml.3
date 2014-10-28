Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbaJ1FR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:17:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:50963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933731AbaJ1FRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,801,1406617200"; 
   d="scan'208";a="626690435"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Yang, Fei" <fei.yang@intel.com>
Subject: RE: [PATCH 0/6] ACPI/OSL: Rework of ACPICA memory OSLs to improve
 performance.
Thread-Topic: [PATCH 0/6] ACPI/OSL: Rework of ACPICA memory OSLs to improve
 performance.
Thread-Index: AQHP7ma/AcSnTFQvPU6SYqCtW9XFSpxE/zzA
Date: Tue, 28 Oct 2014 05:15:51 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026885AD@SHSMSX101.ccr.corp.intel.com>
References: <cover.1414029477.git.lv.zheng@intel.com>
In-Reply-To: <cover.1414029477.git.lv.zheng@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are reasons for why RCU is used here.
Using spinlock here will break specific acpi_os_read_memory()/acpi_os_write_memory() users.
So this patchset is not correct, please ignore.

Thanks
-Lv

> From: Zheng, Lv
> Sent: Thursday, October 23, 2014 10:12 AM
> 
> It is reported that there is a performance issue in the ACPICA OSL
> implementation around memory mappings.
> 
> On the reported platforms, there is a debugging facility implemented in the
> ACPI namespace using circular logging buffer:
>         Name (DPTR, 0x3AFEB000)
>         Name (EPTR, 0x3AFFB000)
>         Name (CPTR, 0x3AFEB010)
>         Mutex (MMUT, 0x00)
>         Method (MDBG, 1, Serialized)
>         {
>             Store (Acquire (MMUT, 0x03E8), Local0)
>             If (Local0 == Zero)
>             {
>                 OperationRegion (ABLK, SystemMemory, CPTR, 0x10)
>                 Field (ABLK, ByteAcc, NoLock, Preserve)
>                 {
>                     AAAA,   128
>                 }
>                 Store (Arg0, AAAA) /* \MDBG.AAAA */
>                 CPTR = (CPTR + 0x10) /* \CPTR */
>                 If (CPTR >= EPTR)
>                 {
>                     CPTR = (DPTR + 0x10) /* \CPTR */
>                 }
>                 Release (MMUT)
>             }
>             Return (Local0)
>         }
> This function is heavily invoked by other ACPI control methods.
> The reported platforms suffer from 2-5 minutes kernel stuck in the end of
> accessing the mapped circular buffer system memory region. By
> instrumentation, the 2-5 minutes time consumption overhead can be seen to
> happen on the synchronize_rcu() invoked in the acpi_os_unmap_memory().
> 
> This patchset removes the synchronize_rcu() from the hot path to improve
> the performance.
> 
> Lv Zheng (6):
>   ACPI/OSL: Split memory operation region implementations to a seperate
>     file.
>   ACPI/OSL: Rename system memory functions.
>   ACPI/OSL: Cleanup memory access functions by merging duplicate code.
>   ACPI/OSL: Add acpi_map2virt() to merge duplicate code.
>   ACPI/OSL: Cleanup branch logics.
>   ACPI/OSL: Fix performance issue in system memory lockings.
> 
>  drivers/acpi/Makefile |    2 +-
>  drivers/acpi/mem.c    |  414 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/osl.c    |  381 ---------------------------------------------
>  3 files changed, 415 insertions(+), 382 deletions(-)
>  create mode 100644 drivers/acpi/mem.c
> 
> --
> 1.7.10

