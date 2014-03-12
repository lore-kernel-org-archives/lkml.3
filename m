Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaCLFW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 01:22:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49231 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbaCLFW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 01:22:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,635,1389715200"; 
   d="scan'208";a="9682161"
Message-ID: <531FEFC6.50709@cn.fujitsu.com>
Date: Wed, 12 Mar 2014 13:25:26 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: viro@zeniv.linux.org.uk, jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        miaox@cn.fujitsu.com
Subject: Re: [RESEND v2 PATCH 1/2] aio, memory-hotplug: Fix confliction when
 migrating and accessing ring pages.
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com> <1394439334-28523-2-git-send-email-tangchen@cn.fujitsu.com> <20140311184656.GD16433@kvack.org>
In-Reply-To: <20140311184656.GD16433@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 13:19:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 13:20:04
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ben,

Sorry for the delay.

On 03/12/2014 02:46 AM, Benjamin LaHaise wrote:
> On Mon, Mar 10, 2014 at 04:15:33PM +0800, Tang Chen wrote:
>> IO ring page migration has been implemented by the following patch:
>>
>>          https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/aio.c?id=36bc08cc01709b4a9bb563b35aa530241ddc63e3
>>
>> In this patch, ctx->completion_lock is used to prevent other processes
>> from accessing the ring page being migrated.
>>
>> But in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring(),
>> when writing to the ring page, they didn't take ctx->completion_lock.
>
>> As a result, for example, we have the following problem:
> ...
>> As above, the new ring page will not be updated.
>>
>> The solution is taking ctx->completion_lock in thread 2, which means,
>> in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring() when
>> writing to ring pages.
>
> Upon review, there are still two accesses of ->ring_pages that are not
> protected by any spinlocks which could potentially race with migration.  One
> is in aio_setup_ring(), which can be easily resolved by moving the assignment
> of ->ring_pages above the unlock_page().

Yes， you are right. Followed, thanks.

>Another spot is in
> aio_read_events_ring() where head and tail are fetched from the ring without
> any locking.  I also fear we'll be introducing new performance issues with
> all the additonal spinlock bouncing, despite the fact that is only ever
> needed for migration.  I'm going to continue looking into this today and
> will try to send out a followup to this email later.

In the beginning of aio_read_events_ring(), it reads head and tail, not 
write.
So even if ring pages are migrated, the contents of the pages will not 
be changed.
So reading it is OK, from old page or from the new page, I think.


>
> 		-ben
