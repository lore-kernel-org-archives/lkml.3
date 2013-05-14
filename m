Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3ENJEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:04:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3ENJED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:04:03 -0400
X-IronPort-AV: E=Sophos;i="4.87,669,1363104000"; 
   d="scan'208";a="7265234"
Message-ID: <5191FEA7.7060606@cn.fujitsu.com>
Date: Tue, 14 May 2013 17:06:47 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v4 00/22] x86, ACPI, numa: Parse numa info early
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org> <517F7110.6000705@cn.fujitsu.com> <518B645C.10408@cn.fujitsu.com> <CAE9FiQWPFL0qagAmkcyj_XfjWQtONtomwQPAimKUm+nJi5dHTw@mail.gmail.com> <5190570C.9010707@cn.fujitsu.com>
In-Reply-To: <5190570C.9010707@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 17:02:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 17:02:50,
	Serialize complete at 2013/05/14 17:02:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

How do you think of the following problem and solutions ?

And can we not allocate pagetable to local node when MEMORY_HOTREMOVE
is enabled for now, and do it again when the problem in hot-remove
path is fixed ?

Thanks. :)

On 05/13/2013 10:59 AM, Tang Chen wrote:
> Hi Yinghai,
>
> On 05/10/2013 02:24 AM, Yinghai Lu wrote:
>>>> So I suggest to separate the job into 2 parts:
>>>> 1. Push Yinghai's patch1 ~ patch20, without putting pagetable in local
>>>> node.
>>>> And push my work to use SRAT to arrange ZONE_MOVABLE.
>>>> In this case, we can enable memory hotplug in the kernel first.
>>>> 2. Merge patch21 and patch22 into the fixing work I am doing now,
>>>> and push
>>>> them
>>>> together when finished.
>>>>
>>
>> no, no, no, please do not half-done work.
>>
>> Do it right, and Do it clean.
>>
>
> I'm not saying I want to do it half-way. Putting pagetable in local node
> will make memory hot-remove patch unable to work.
>
> Before removing pages, the kernel first offlines pages. If the offline
> logic
> fails, the hot-remove cannot work. Since your patches have put node
> pagetable
> in local node at boot time, this memory cannot be offlined, furthermore,
> it cannot be hot-removed.
>
> The minimum unit of memory online/offline is block. And by default,
> one block contains one section, which by default is 128MB. So if parts
> of a block are pagetable, and the rest parts are movable memory, this
> block cannot be offlined. And as a result, it cannot be removed.
>
> In order to fix it, we have three solutions:
>
> 1. Reserve the whole block (128MB), making no user can use the rest
> parts of the block. And skip them when offlining memory.
> When all the other blocks are offlined, free the pagetable, and remove
> all the memory.
>
> But we may lose some memory for this purpose. 128MB is a little big
> to waste.
>
>
> 2. Migrate movable pages and keep this block online. Although the offline
> operation fails, it is OK to remove memory.
>
> But the offline operation will always fail. And generally speaking,
> there are a lot of reasons of offline failing, it is difficult to
> detect if it is OK to remove memory.
>
>
> 3. Migrate user pages and make this block offline, but the kernel can
> still use the pagetable in it.
>
> But this will change the semantics of "offline". I'm not sure if we
> can do it in this way.
>
>
> 4. Do not allocate pagetable to local node when CONFIG_MEMORY_HOTREMOVE
> is enabled. (I do suggest not to put pagetable in local node in
> memory hot-remove situation.)
>
>
> How do you think about these 4 solutions above ?
>
> I think I need some advices for this problem in community. Do you have
> any idea to fix this problem if we put pagetable in local node ?
>
> The memory hot-plug guys do want to use memory hot-remove. And I think
> for now, we use solution 4 above. When CONFIG_MEMORY_HOTREMOVE is enabled,
> do not allocate pagetable to local node.
>
> I'm not trying to do it half-way. When we fix this problem, we can allocate
> pagetable to local node again with CONFIG_MEMORY_HOTREMOVE enabled.
>
> Please do give some advices or feedback.
>
>
>>>
>>> If you have any thinking of this patch-set, please let me know.
>>
>> Talked to HPA, and he will put my patchset into tip/x86/mm after
>> v3.10-rc1.
>>
>> after that we can work on put pagetable on local node for hotadd path.
>>
>
> hot-add path is another problem. But I think the hot-remove path is more
> urgent now.
>
>
> Thanks. :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
