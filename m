Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab3EXJQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:16:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46343 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab3EXJQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:16:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,734,1363104000"; 
   d="scan'208";a="7355014"
Message-ID: <519F2F65.4000400@cn.fujitsu.com>
Date: Fri, 24 May 2013 17:14:13 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Mell <sub.atomic.fusion@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc mount options out of pid_namespace
References: <3342521.NtikuogILA@pegasus> <2515335.Kvy7Q1OKc4@pegasus> <519ED883.9060903@cn.fujitsu.com> <24900395.sMN6olMGRM@pegasus>
In-Reply-To: <24900395.sMN6olMGRM@pegasus>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:15:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:15:16,
	Serialize complete at 2013/05/24 17:15:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 05/24/2013 12:29 PM, Stephen Mell wrote:

> Gu,
> 
> On Friday, May 24, 2013 11:03:31 Gu Zheng wrote:
>> Hi Stephen,
>>
>> On 05/24/2013 07:32 AM, Stephen Mell wrote:
>>
>>> On Thursday, May 23, 2013 18:20:57 Gu Zheng wrote:
>>>
>>>> Here it'll create a new proc sb instance which holds the same context as the old ones
>>>> each time we mount proc though in the same PID namespace, won't it?
>>> I believe so. But this is the point, right? 
> 
>> Yes, but I think it's also the problem.
>>
>>> They won't be identical if different mount options are used, I don't think.
>>
>> If different mount options are used, we'll create different super block instance, and they have
>> the same context, only the difference is each one holds different proc_sb_info.
>> But I think what we really want is only one proc sb instance and create different proc_sb_info
>> if different mount options are used.
> 
> Will having several different superblocks cause problems, or is it merely inefficient? 

Not only inefficient.

>I freely admit to not really knowing what I'm doing, and I thank you for your assistance.
> How is this situation distinct from that of ramfs? It appears to have a superblock for each mount.

They're different, each ramfs uses a split superblock to manage it's infos, e.g. the usage, and each ramfs mount instance should not affect others.
But proc is a common interface, each mount instance holds the same context, so there's no need to create a new superblock instance each time mount if we in
the same PID namespace. 

> It would seem to me as though one cannot have different sb_infos with the same superblock, making storing the mount options in sb_info effectively the same as storing them in the superblock itself, for the purposes of this discussion. Where would the mount options be stored, if not in the superblock?
> 

One fuzzy way in my mind, I'm not sure whether it's OK, but we can discuss it.
Split hide_pid, pid_gid, and proc_self from pid_namespace, and create struct proc_sb_info(maybe the name "proc_mount_info" is better). 
And create a new list domain in the pid_namespace to contain the proc_sb_info instances. Each time we mount proc in a new directory only
create a new proc_sb_info instance, and added it to the list in pid_namespace. 
But this leads to another problem, how to get the right proc_sb_info instance in proc permission checking routine, do you have any idea?
what do you think of this way?


Thanks,
Gu

>>>
>>>> Here the pre-check seems needless.
>>> Is that new with my patch, or has it always been needless?
>>
>> Yeah, it's always needless.
>>
>> Thanks,
>> Gu
>>
>>>
>>> Thanks,
>>> Stephen
> 
> Thanks again,
> Stephen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


