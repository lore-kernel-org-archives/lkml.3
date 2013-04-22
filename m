Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3DVGvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 02:51:38 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:32858 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3DVGvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 02:51:37 -0400
MIME-Version: 1.0
In-Reply-To: <5174CB26.9060908@jp.fujitsu.com>
References: <1366441080-5937-1-git-send-email-wei@aristanetworks.com> <5174CB26.9060908@jp.fujitsu.com>
From: Wei Hu <wei@aristanetworks.com>
Date: Sun, 21 Apr 2013 23:50:56 -0700
Message-ID: <CANwcMEZF+ehPeFuucRqcKSiNNoXL6bDy+GTHBHYjr3DfoZY7vg@mail.gmail.com>
Subject: Re: [PATCH 1/1] intel-iommu: Disable DMA Remapping when intel_iommu=off
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 10:31 PM, Takao Indoh
<indou.takao@jp.fujitsu.com> wrote:
> (2013/04/20 15:58), Wei Hu wrote:
>> On a VT-d capable machine Linux will enable IOMMU by default. If it
>> then kexec's a second kernel with intel_iommu=off, this second kernel
>> will leave the DMA remapping engine on with no code handling it. The
>> symptom is at least USB and SATA drives stop working. This patch fixes
>> the problem by always disabling DMA remapping when intel_iommu=off.
>
> Even when second kernel boots up with intel_iommu=on, dma-remapping need
> to be disabled as well before it is initialized and enabled again in
> init_dmars(). So, how about something like this?
>
>         for_each_drhd_unit(drhd) {
>                 struct dmar_drhd_unit *drhd;
>                 if (drhd->ignored)
>                         continue;
>
>                 iommu = drhd->iommu;
>                 if (iommu->gcmd & DMA_GCMD_TE)
>                         iommu_disable_translation(iommu);
>         }
>
> Note, if you agree above code and fix your patch like this, you need
> additinal fix to set iommu->gcmd flag sinse gcmd is always zero here.
> See first hunk of this patch.
> https://lkml.org/lkml/2013/3/20/707

Thanks for your reply. I reviewed your patch. Are you suggesting
keeping your change to dmar.c, and moving your change to intel-iommu.c
(i.e. the code you just showed) up after the call to
dmar_table_init()?
