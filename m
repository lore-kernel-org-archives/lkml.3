Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3LBBst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:48:49 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:25925 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3LBBss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:48:48 -0500
Message-ID: <529BE696.6070206@huawei.com>
Date: Mon, 2 Dec 2013 09:47:02 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>
CC: <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part1 V2 12/17] iommu/vt-d: fix invalid memory access
 when freeing DMAR irq
References: <1385715030-20553-1-git-send-email-jiang.liu@linux.intel.com> <1385715030-20553-14-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1385715030-20553-14-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Yijing Wang <wangyijing@huawei.com>

On 2013/11/29 16:50, Jiang Liu wrote:
> In function free_dmar_iommu(), it sets IRQ handler data to NULL
> before calling free_irq(), which will cause invalid memory access
> because free_irq() will access IRQ handler data when calling
> function dmar_msi_mask(). So only set IRQ handler data to NULL
> after calling free_irq().
> 
> Sample stack dump:
> [   13.094010] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> [   13.103215] IP: [<ffffffff810a97cd>] __lock_acquire+0x4d/0x12a0
> [   13.110104] PGD 0
> [   13.112614] Oops: 0000 [#1] SMP
> [   13.116585] Modules linked in:
> [   13.120260] CPU: 60 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-rc1-gerry+ #9
> [   13.129367] Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.99.99.x059.091020121352 09/10/2012
> [   13.142555] task: ffff88042dd38010 ti: ffff88042dd32000 task.ti: ffff88042dd32000
> [   13.151179] RIP: 0010:[<ffffffff810a97cd>]  [<ffffffff810a97cd>] __lock_acquire+0x4d/0x12a0
> [   13.160867] RSP: 0000:ffff88042dd33b78  EFLAGS: 00010046
> [   13.166969] RAX: 0000000000000046 RBX: 0000000000000002 RCX: 0000000000000000
> [   13.175122] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000048
> [   13.183274] RBP: ffff88042dd33bd8 R08: 0000000000000002 R09: 0000000000000001
> [   13.191417] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88042dd38010
> [   13.199571] R13: 0000000000000000 R14: 0000000000000048 R15: 0000000000000000
> [   13.207725] FS:  0000000000000000(0000) GS:ffff88103f200000(0000) knlGS:0000000000000000
> [   13.217014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   13.223596] CR2: 0000000000000048 CR3: 0000000001a0b000 CR4: 00000000000407e0
> [   13.231747] Stack:
> [   13.234160]  0000000000000004 0000000000000046 ffff88042dd33b98 ffffffff810a567d
> [   13.243059]  ffff88042dd33c08 ffffffff810bb14c ffffffff828995a0 0000000000000046
> [   13.251969]  0000000000000000 0000000000000000 0000000000000002 0000000000000000
> [   13.260862] Call Trace:
> [   13.263775]  [<ffffffff810a567d>] ? trace_hardirqs_off+0xd/0x10
> [   13.270571]  [<ffffffff810bb14c>] ? vprintk_emit+0x23c/0x570
> [   13.277058]  [<ffffffff810ab1e3>] lock_acquire+0x93/0x120
> [   13.283269]  [<ffffffff814623f7>] ? dmar_msi_mask+0x47/0x70
> [   13.289677]  [<ffffffff8156b449>] _raw_spin_lock_irqsave+0x49/0x90
> [   13.296748]  [<ffffffff814623f7>] ? dmar_msi_mask+0x47/0x70
> [   13.303153]  [<ffffffff814623f7>] dmar_msi_mask+0x47/0x70
> [   13.309354]  [<ffffffff810c0d93>] irq_shutdown+0x53/0x60
> [   13.315467]  [<ffffffff810bdd9d>] __free_irq+0x26d/0x280
> [   13.321580]  [<ffffffff810be920>] free_irq+0xf0/0x180
> [   13.327395]  [<ffffffff81466591>] free_dmar_iommu+0x271/0x2b0
> [   13.333996]  [<ffffffff810a947d>] ? trace_hardirqs_on+0xd/0x10
> [   13.340696]  [<ffffffff81461a17>] free_iommu+0x17/0x50
> [   13.346597]  [<ffffffff81dc75a5>] init_dmars+0x691/0x77a
> [   13.352711]  [<ffffffff81dc7afd>] intel_iommu_init+0x351/0x438
> [   13.359400]  [<ffffffff81d8a711>] ? iommu_setup+0x27d/0x27d
> [   13.365806]  [<ffffffff81d8a739>] pci_iommu_init+0x28/0x52
> [   13.372114]  [<ffffffff81000342>] do_one_initcall+0x122/0x180
> [   13.378707]  [<ffffffff81077738>] ? parse_args+0x1e8/0x320
> [   13.385016]  [<ffffffff81d850e8>] kernel_init_freeable+0x1e1/0x26c
> [   13.392100]  [<ffffffff81d84833>] ? do_early_param+0x88/0x88
> [   13.398596]  [<ffffffff8154f8b0>] ? rest_init+0xd0/0xd0
> [   13.404614]  [<ffffffff8154f8be>] kernel_init+0xe/0x130
> [   13.410626]  [<ffffffff81574d6c>] ret_from_fork+0x7c/0xb0
> [   13.416829]  [<ffffffff8154f8b0>] ? rest_init+0xd0/0xd0
> [   13.422842] Code: ec 99 00 85 c0 8b 05 53 05 a5 00 41 0f 45 d8 85 c0 0f 84 ff 00 00 00 8b 05 99 f9 7e 01 49 89 fe 41 89 f7 85 c0 0f 84 03 01 00 00 <49> 8b 06 be 01 00 00 00 48 3d c0 0e 01 82 0f 44 de 41 83 ff 01
> [   13.450191] RIP  [<ffffffff810a97cd>] __lock_acquire+0x4d/0x12a0
> [   13.458598]  RSP <ffff88042dd33b78>
> [   13.462671] CR2: 0000000000000048
> [   13.466551] ---[ end trace c5bd26a37c81d760 ]---
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/intel-iommu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0ec49da..426095e 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1289,9 +1289,9 @@ void free_dmar_iommu(struct intel_iommu *iommu)
>  		iommu_disable_translation(iommu);
>  
>  	if (iommu->irq) {
> -		irq_set_handler_data(iommu->irq, NULL);
>  		/* This will mask the irq */
>  		free_irq(iommu->irq, iommu);
> +		irq_set_handler_data(iommu->irq, NULL);
>  		destroy_irq(iommu->irq);
>  	}
>  
> 


-- 
Thanks!
Yijing

