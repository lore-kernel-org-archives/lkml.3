Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3AVXaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:30:03 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:25380
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093Ab3AVXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:30:00 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z21eIzbb2dI98dI9371I936eI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz177df4h17326ah8275eha1495iz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h1155h)
X-WSS-ID: 0MH1VXR-02-4DW-02
X-M-MSG: 
Message-ID: <50FF20F2.9090503@amd.com>
Date: Tue, 22 Jan 2013 17:29:54 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: Boris Ostrovsky <boris.ostrovsky@amd.com>, Jacob Shin <jacob.shin@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>  <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>  <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>  <20130120114828.GB16519@pd.tnic> <20130121160450 <50FE9E76.30702@xs4all.nl> <50FEA3F2.1070408@amd.com> <50FEAFEB.7020103@xs4all.nl> <50FEBA69.60106@amd.com> <50FEBE5D.7040905@xs4all.nl>
In-Reply-To: <50FEBE5D.7040905@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2013 10:29 AM, Udo van den Heuvel wrote:

> On 2013-01-22 17:12, Boris Ostrovsky wrote:
>> Your BIOS does not have the required erratum workaround. We will provide
>> a patch to close that hole but since the problem is not easily
>> reproducible (and the erratum is also not easy to trigger) it may be
>> difficult to say whether it really helped with your problem.

Udo,

I sent out a patch (http://marc.info/?l=linux-kernel&m=135889686523524&w=2) which should implement
the workaround for AMD processor family15h model 10-1Fh erratum 746 in the IOMMU driver.
In your case, the output from "setpci -s 00:00.02 F4.w" is "0050" which tells me that BIOS doesn't
implement the work around. After patching, you should see the following message in "dmesg".

"AMD-Vi: Applying erratum 746 for IOMMU at 0000:00:00.2"

> Can we think of certain loads/actions/etc that could help trigger the issue?
> Then if reproducing is easier we can better say if stuff is actually
> fixed after the workaround.
>
> Udo

Looking at the original kernel message, it seems that the the kernel timed out while waiting for the IOMMU
to finish executing the "COMPLETION_WAIT" command.   In this particular case, it is issued as part of
"__domain_flush_pages()" while trying to send the "INVALIDATE_IOMMU_PAGE" command to the IOMMU but the command
buffer is getting full and the kernel needed to wait for the command buffer to free up.  However, the kernel
message did not exactly telling us what caused IOMMU to locked up in the first place.

According to my observation, high disk traffic workload should trigger large amount of "INVALIDATE_IOMMU_PAGE".
However, this doesn't automatically issuing "COMPLETION_WAIT" command.  The following patch slightly modify
the code to always issue "COMPLETION_WAIT" after every command.  This should help increasing the chance of reproducing
the issue.


diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c1c74e0..d05b1f9 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1016,6 +1016,7 @@ static int iommu_queue_command_sync(struct amd_iommu *iommu,
                                     struct iommu_cmd *cmd,
                                     bool sync)
  {
+#if 0
         u32 left, tail, head, next_tail;
         unsigned long flags;
  
@@ -1052,6 +1053,40 @@ again:
  
         spin_unlock_irqrestore(&iommu->lock, flags);
  
+#else
+       u32 tail;
+       unsigned long flags;
+
+       WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
+       printk (KERN_DEBUG "AMD-Vi: iommu_queue_command_sync: iommu_queue_command_sync"
+               " data[0]:%#x data[1]:%#x data[2]:%#x data[3]:%#x\n",
+               cmd->data[0], cmd->data[1], cmd->data[2], cmd->data[3] );
+
+       spin_lock_irqsave(&iommu->lock, flags);
+
+       tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+       copy_cmd_to_buffer(iommu, cmd, tail);
+
+       spin_unlock_irqrestore(&iommu->lock, flags);
+
+       // Sending completion_wait command
+       {
+               struct iommu_cmd sync_cmd;
+               volatile u64 sem = 0;
+               int ret;
+
+               spin_lock_irqsave(&iommu->lock, flags);
+
+               tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+               build_completion_wait(&sync_cmd, (u64)&sem);
+               copy_cmd_to_buffer(iommu, &sync_cmd, tail);
+
+               spin_unlock_irqrestore(&iommu->lock, flags);
+
+               if ((ret = wait_on_sem(&sem)) != 0)
+                       return ret;
+       }
+#endif
         return 0;
  }







