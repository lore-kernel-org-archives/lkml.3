Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaCYRsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:48:01 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30849 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaCYRr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:47:57 -0400
Message-ID: <5331C13C.8030507@oracle.com>
Date: Tue, 25 Mar 2014 13:47:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Gu Zheng <guz.fnst@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        jmoyer@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        miaox@cn.fujitsu.com, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] aio: ensure access to ctx->ring_pages is correctly serialised
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org> <532B9C54.80705@cn.fujitsu.com> <20140321183509.GC23173@kvack.org> <533077CE.6010204@oracle.com> <20140324190743.GJ4173@kvack.org>
In-Reply-To: <20140324190743.GJ4173@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 03:07 PM, Benjamin LaHaise wrote:
> On Mon, Mar 24, 2014 at 02:22:06PM -0400, Sasha Levin wrote:
>> On 03/21/2014 02:35 PM, Benjamin LaHaise wrote:
>>> Hi all,
>>>
>>> Based on the issues reported by Tang and Gu, I've come up with the an
>>> alternative fix that avoids adding additional locking in the event read
>>> code path.  The fix is to take the ring_lock mutex during page migration,
>>> which is already used to syncronize event readers and thus does not add
>>> any new locking requirements in aio_read_events_ring().  I've dropped
>>> the patches from Tang and Gu as a result.  This patch is now in my
>>> git://git.kvack.org/~bcrl/aio-next.git tree and will be sent to Linus
>>> once a few other people chime in with their reviews of this change.
>>> Please review Tang, Gu.  Thanks!
>>
>> Hi Benjamin,
>>
>> This patch seems to trigger:
>>
>> [  433.476216] ======================================================
>> [  433.478468] [ INFO: possible circular locking dependency detected ]
> ...
>
> Yeah, that's a problem -- thanks for the report.  The ring_lock mutex can't
> be nested inside of mmap_sem, as aio_read_events_ring() can take a page
> fault while holding ring_mutex.  That makes the following change required.
> I'll fold this change into the patch that caused this issue.

Yup, that does the trick.

Could you please add something to document why this is a trylock instead of a lock? If
I were reading the code there's no way I'd understand what's the reason behind it
without knowing of this bug report.


Thanks,
Sasha

