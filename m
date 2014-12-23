Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaLWH6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:58:33 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11677 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbaLWH6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:58:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 22 Dec 2014 23:56:47 -0800
Message-ID: <5499208C.6070708@nvidia.com>
Date: Tue, 23 Dec 2014 15:58:04 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: <hdoyu@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Olof Johansson" <olof@lixom.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory: Add NVIDIA SMMU suspend/resume support
References: <1418019656-6893-1-git-send-email-markz@nvidia.com> <CAAVeFu+1B44vxuQK8+uH2PzRJQgHAHAYGkTMT9vTi6TTrXf2RA@mail.gmail.com>
In-Reply-To: <CAAVeFu+1B44vxuQK8+uH2PzRJQgHAHAYGkTMT9vTi6TTrXf2RA@mail.gmail.com>
X-Originating-IP: [10.19.224.127]
X-ClientProxiedBy: HKMAIL101.nvidia.com (10.18.16.10) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 04:18 PM, Alexandre Courbot wrote:
> Hi Mark,
> 
> On Mon, Dec 8, 2014 at 3:20 PM, Mark Zhang <markz@nvidia.com> wrote:
>> This patch adds suspend/resume support for NVIDIA SMMU.
> 
> 
>> This patch is created on top of Thierry Reding's patch set:
>>
>> "[PATCH v7 00/12] NVIDIA Tegra memory controller and IOMMU support"
> 
> You should have this comment under the "---" as we don't need it to
> persist once this patch is merged.
> 

Yep, will do.

>>
>> Signed-off-by: Mark Zhang <markz@nvidia.com>
>> ---
>>  drivers/iommu/tegra-smmu.c | 79 +++++++++++++++++++++++++++++++++++++++++++++-
>>  drivers/memory/tegra/mc.c  | 21 ++++++++++++
>>  drivers/memory/tegra/mc.h  |  4 +++
>>  3 files changed, 103 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
>> index 0909e0bae9ec..ab38805055a4 100644
>> --- a/drivers/iommu/tegra-smmu.c
>> +++ b/drivers/iommu/tegra-smmu.c
>> @@ -17,6 +17,8 @@
>>  #include <soc/tegra/ahb.h>
>>  #include <soc/tegra/mc.h>
>>
>> +struct tegra_smmu_as;
>> +
>>  struct tegra_smmu {
>>         void __iomem *regs;
>>         struct device *dev;
>> @@ -25,9 +27,10 @@ struct tegra_smmu {
>>         const struct tegra_smmu_soc *soc;
>>
>>         unsigned long *asids;
>> +       struct tegra_smmu_as **as;
>>         struct mutex lock;
>>
>> -       struct list_head list;
>> +       struct list_head swgroup_asid_list;
>>  };
>>
>>  struct tegra_smmu_as {
>> @@ -40,6 +43,12 @@ struct tegra_smmu_as {
>>         u32 attr;
>>  };
>>
>> +struct tegra_smmu_swgroup_asid {
>> +       struct list_head list;
>> +       unsigned swgroup_id;
>> +       unsigned asid;
>> +};
>> +
>>  static inline void smmu_writel(struct tegra_smmu *smmu, u32 value,
>>                                unsigned long offset)
>>  {
>> @@ -376,6 +385,7 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
>>         as->smmu = smmu;
>>         as->use_count++;
>>
>> +       smmu->as[as->id] = as;
>>         return 0;
>>  }
>>
>> @@ -386,6 +396,7 @@ static void tegra_smmu_as_unprepare(struct tegra_smmu *smmu,
>>                 return;
>>
>>         tegra_smmu_free_asid(smmu, as->id);
>> +       smmu->as[as->id] = NULL;
>>         as->smmu = NULL;
>>  }
>>
>> @@ -398,6 +409,7 @@ static int tegra_smmu_attach_dev(struct iommu_domain *domain,
>>         struct of_phandle_args args;
>>         unsigned int index = 0;
>>         int err = 0;
>> +       struct tegra_smmu_swgroup_asid *sa = NULL;
> 
> This initialization is unneeded. Actually this declaration would
> probably be better placed in the while() loop below since its usage is
> local to it.
> 

Correct.

>>
>>         while (!of_parse_phandle_with_args(np, "iommus", "#iommu-cells", index,
>>                                            &args)) {
>> @@ -411,6 +423,14 @@ static int tegra_smmu_attach_dev(struct iommu_domain *domain,
>>                         return err;
>>
>>                 tegra_smmu_enable(smmu, swgroup, as->id);
>> +
>> +               sa = kzalloc(sizeof(struct tegra_smmu_swgroup_asid),
>> +                               GFP_KERNEL);
>> +               INIT_LIST_HEAD(&sa->list);
> 
> You don't need to call INIT_LIST_HEAD on this, list_add_tail() will
> effectively overwrite any initialization done by this macro (see
> include/linux/list.h).

Right. So why we still need "INIT_LIST_HEAD"? Given most of the list
functions will manipulate "list->prev" & "list->next", I can't imagine a
scenario that we create a list while not calling list functions.

> 
>> +               sa->swgroup_id = swgroup;
>> +               sa->asid = as->id;
>> +               list_add_tail(&sa->list, &smmu->swgroup_asid_list);
>> +
>>                 index++;
>>         }
>>
>> @@ -427,6 +447,7 @@ static void tegra_smmu_detach_dev(struct iommu_domain *domain, struct device *de
>>         struct tegra_smmu *smmu = as->smmu;
>>         struct of_phandle_args args;
>>         unsigned int index = 0;
>> +       struct tegra_smmu_swgroup_asid *sa = NULL;
> 
> Same here, move the declaration into the while() loop and remove the
> initialization.
> 

OK.

>>
>>         while (of_parse_phandle_with_args(np, "iommus", "#iommu-cells", index,
>>                                           &args)) {
>> @@ -435,6 +456,13 @@ static void tegra_smmu_detach_dev(struct iommu_domain *domain, struct device *de
>>                 if (args.np != smmu->dev->of_node)
>>                         continue;
>>
>> +               list_for_each_entry(sa, &smmu->swgroup_asid_list, list) {
>> +                       if (sa->asid == as->id && sa->swgroup_id == swgroup)
>> +                               break;
>> +               }
>> +               list_del(&sa->list);
>> +               kfree(sa);
>> +
>>                 tegra_smmu_disable(smmu, swgroup, as->id);
>>                 tegra_smmu_as_unprepare(smmu, as);
>>                 index++;
>> @@ -651,6 +679,48 @@ static void tegra_smmu_ahb_enable(void)
>>         }
>>  }
>>
>> +void tegra_smmu_resume(struct tegra_smmu *smmu)
>> +{
>> +       struct tegra_smmu_as *as = NULL;
>> +       unsigned int bit;
>> +       u32 value;
>> +       struct tegra_smmu_swgroup_asid *sa = NULL;
> 
> Again no need to initialize to NULL here.
> 

Yep. But it doesn't hurt, right? I don't know why the kernel developers
don't set NULL to pointers while relying on the compiler to do that.
Alex, do you know that?

>> +
>> +       for_each_set_bit(bit, smmu->asids, smmu->soc->num_asids) {
>> +               as = smmu->as[bit];
>> +               smmu->soc->ops->flush_dcache(as->pd, 0, SMMU_SIZE_PD);
>> +
>> +               smmu_writel(smmu, as->id & 0x7f, SMMU_PTB_ASID);
>> +               value = SMMU_PTB_DATA_VALUE(as->pd, as->attr);
>> +               smmu_writel(smmu, value, SMMU_PTB_DATA);
>> +       }
>> +
>> +       list_for_each_entry(sa, &smmu->swgroup_asid_list, list)
>> +               tegra_smmu_enable(smmu, sa->swgroup_id, sa->asid);
> 
> Actually I wonder if you could not do completely without the list
> here. How about the following:
> 
> 1) add a "unsigned swgroup_id" member to tegra_smmu_as, set it in
> tegra_smmu_attach_dev() instead of sa->asid
> 2) in the "for_each_bit" loop above, call tegra_smmu_enable(smmu,
> as->swgroup_id, as->id) after the last smmu_writel()
> 
> Would that work? It would allow you to get rid of the
> tegra_smmu_swgroup_asid struct as well as a few memory allocations. I
> don't know if that kind of 1:1 matching between as and and swgroup
> makes sense for the SMMU though, maybe Thierry or Hiroshi can confirm?
> 

It wouldn't work, yes, you already mentioned, swgroup & asid is not 1:1
matching. Multiple swgroup can belong to 1 asid, swgroup/asid is N:1
matching.

So we need to create a list in "tegra_smmu_as" to save swgroup ids, if
we wanna remove "tegra_smmu_swgroup_asid".

BTW, Olof mentioned that we don't need to save/restore swgroup/asid
usage infos, just save/restore all necessary smmu registers blindly.
Given currently the smmu driver has defined all registers in the driver,
so I think that's another good way.

Mark
