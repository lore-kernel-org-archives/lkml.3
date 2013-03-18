Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3CRLLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:11:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30405 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab3CRLLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:11:51 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355068800"; 
   d="scan'208";a="6893884"
Message-ID: <5146E521.1040708@cn.fujitsu.com>
Date: Mon, 18 Mar 2013 17:57:53 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Will Huck <will.huckk@gmail.com>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com, mgorman@suse.de,
        walken@google.com, riel@redhat.com, khlebnikov@openvz.org,
        tj@kernel.org, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linfeng@cn.fujitsu.com,
        jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 part1 0/9] Introduce movablemem_map boot option.
References: <1363430142-14563-1-git-send-email-tangchen@cn.fujitsu.com> <51450D93.1090303@gmail.com>
In-Reply-To: <51450D93.1090303@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 17:53:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 17:54:40,
	Serialize complete at 2013/03/18 17:54:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 03/17/2013 08:25 AM, Will Huck wrote:
>
> http://marc.info/?l=linux-mm&m=136014458829566&w=2
>
> It seems that Mel don't like this idea.
>

Thank you for reminding me this.

And yes, I have read that email. :)

And about this boot option, we have had a long discussion before.
Please refer to: https://lkml.org/lkml/2012/11/29/190

The situation is:

For now, Linux kernel cannot migrate kernel direct mapping memory. And
there is no way to ensure that ZONE_NORMAL has no kernel memory. So we
can only use ZONE_MOVABLE to ensure the memory device could be removed.

For now, I have the following reasons that movablemem_map boot option is
necessary. Some may be mentioned before, but here, I think I need to say
them again:

1) If we want to hot-remove a memory device, the device should only have
    memory of two types:
    - kernel memory whose life cycle is the same as the memory device.
      such as pagetables, vmemmap
    - user memory that could be migrated.

    For type1: we can allocate it on local node, just like Yinghai's work,
               and free it when hot-removing.
    For type2: we can migrate it at run time. But it must be in ZONE_MOVABLE
               because we cannot ensure ZONE_NORMAL has no kernel memory.

    So we need a way to limit hotpluggable memory in ZONE_MOVABLE.

2) We have the following ways to do it:
    a) use SRAT, which I have already implemented
    b) specify physical address ranges, which I have implemented too, but
       obviously very few guys like it.
    c) specify node id. But nid could be changed on some platform by 
firmware.

    Because of c), we chose to use physical address ranges. To satisfy all
    users, I also implemented a).

3) Even if we don't specify physical address in command line, we use SRAT,
    we still need the logic in this patch-set to achieve the same goal.

4) Since setting a whole node as movable will cause NUMA performance down,
    no matter which way we use, we always need an interface to open or close
    this functionality.
    The boot option itself is an interface. If users don't specify it in
    command line, the kernel will work as before.

So I do want to try again to push this boot option.  :)

With this boot option, memory hotplug will work now.


It's true that if we reimplement the whole mm in Linux to make kernel
memory migratable, but we need to handle a lot of problems. I agree with 
Mel.
But it is a long way to go in the future.

And the work in the near future:
1) Allocate pagetables and vmemmap on local node, as Yinghai said.
2) Do the proper modification for hot-add and hot-remove.
    - Reserve memory for pagetables and vmemmap when hot-add, maybe use
      memblock.
    - Free all pagetables and vmemmap before hot-remove.
3) And about Mel's advice, modify memory management in Linux to migrate
    kernel pages, it is a long way to go in the future. I think we can
    discuss more.

Thanks. :)


