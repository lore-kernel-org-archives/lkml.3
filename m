Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaCPCPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 22:15:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaCPCPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 22:15:03 -0400
X-IronPort-AV: E=Sophos;i="4.97,662,1389715200"; 
   d="scan'208";a="9703685"
Message-ID: <5325070D.308@cn.fujitsu.com>
Date: Sun, 16 Mar 2014 10:06:05 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, viro@zeniv.linux.org.uk,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, miaox@cn.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND v2 PATCH 1/2] aio, memory-hotplug: Fix confliction when
 migrating and accessing ring pages.
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com> <1394439334-28523-2-git-send-email-tangchen@cn.fujitsu.com> <20140311184656.GD16433@kvack.org> <531FEFC6.50709@cn.fujitsu.com> <20140312221735.GF32444@kvack.org> <5322D90C.5050207@cn.fujitsu.com> <20140314151446.GE29206@kvack.org>
In-Reply-To: <20140314151446.GE29206@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/16 10:12:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/16 10:12:09,
	Serialize complete at 2014/03/16 10:12:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
Sorry for late.
On 03/14/2014 11:14 PM, Benjamin LaHaise wrote:

> Hi Gu,
> 
> On Fri, Mar 14, 2014 at 06:25:16PM +0800, Gu Zheng wrote:
>> Hi Ben,
>> On 03/13/2014 06:17 AM, Benjamin LaHaise wrote:
>>
>>> Hello Tang,
>>>
>>> On Wed, Mar 12, 2014 at 01:25:26PM +0800, Tang Chen wrote:
>>> ... <snip> ...
>>>
>>>>> Another spot is in
>>>>> aio_read_events_ring() where head and tail are fetched from the ring 
>>>>> without
>>>>> any locking.  I also fear we'll be introducing new performance issues with
>>>>> all the additonal spinlock bouncing, despite the fact that is only ever
>>>>> needed for migration.  I'm going to continue looking into this today and
>>>>> will try to send out a followup to this email later.
>>>>
>>>> In the beginning of aio_read_events_ring(), it reads head and tail, not 
>>>> write.
>>>> So even if ring pages are migrated, the contents of the pages will not 
>>>> be changed.
>>>> So reading it is OK, from old page or from the new page, I think.
>>>
>>> Your assumption that reading it is okay is incorrect.  Since we do not have 
>>> a reference on the page at that point, it is possible that the read of the 
>>> page takes place after the page has been freed and allocated to another part 
>>> of the kernel.  This would result in the read returning invalid information.
>>
>> What about the following patch? It adds additional reference to protect the page
>> avoid being freed when we reading it.
>> ps.It is applied on linux-next(3-13).
> 
> I think that's even worse than the spinlock approach since we'll end up 
> bouncing around the struct page's cacheline in addition to spinlock we're 
> going to end up taking anyways.

But we can not use spinlock approach to avoid this issue in aio_read_events_ring(),
because we need to copy events to user space. And on the other side, it will break
the concurrency of aio_read_events_ring() and aio_complete().
Besides, IMHO, the problem you mentioned above is almost insignificant when reading
events.
Any better solution? Other guys?

Regards,
Gu 

> 
> 		-ben


