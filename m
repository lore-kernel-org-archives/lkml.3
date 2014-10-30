Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbaJ3CDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:03:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:42989 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757991AbaJ3CDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:03:47 -0400
X-IronPort-AV: E=Sophos;i="5.04,814,1406563200"; 
   d="scan'208";a="42575558"
Message-ID: <54519D35.3060708@cn.fujitsu.com>
Date: Thu, 30 Oct 2014 10:06:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <pang.xunlei@zte.com.cn>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] idr: optimize ida_init() to avoid an extra memset
References: <OF73B80F6F.959BED11-ON48257D80.00327936-48257D80.00341CEF@zte.com.cn> <20141029143838.GC25226@htj.dyndns.org>
In-Reply-To: <20141029143838.GC25226@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 10:38 PM, Tejun Heo wrote:
> On Wed, Oct 29, 2014 at 05:26:34PM +0800, pang.xunlei@zte.com.cn wrote:
>> The memset in ida_init() already handles idr, so there's some
>> redundancy in the following idr_init().
>>
>> This patch removes the memset, and clears ida->free_bitmap instead.
>>
>> Signed-off-by: pang.xunlei <pang.xunlei@zte.com.cn>
>> ---
>>  lib/idr.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/lib/idr.c b/lib/idr.c
>> index e654aeb..bbe5779 100644
>> --- a/lib/idr.c
>> +++ b/lib/idr.c
>> @@ -1141,8 +1141,7 @@ EXPORT_SYMBOL(ida_simple_remove);
>>   */
>>  void ida_init(struct ida *ida)
>>  {
>> -   memset(ida, 0, sizeof(struct ida));
>>     idr_init(&ida->idr);
>> -
>> +   ida->free_bitmap = NULL;
> 
> I don't know.  Does this matter?  If this *really* matters, I'd much
> rather have memset(&ida->FIRST_FIELD, 0, sizeof(struct ida) - offset
> of FIRST_FIELD) to ensure that all fields get reset or implement an
> internal function like __idr_init_without_zeroing(); however, given
> the size of an idr and the low frequency of the operation, I'd prefer
> to just leave it as-is.
> 

memset(ptr, 0, sizeof()) or kzalloc() is convenient and good for buffers
but bad for structures, objects...

general way for object initialization is:

xxx_init()
{
	explicitly init every field...

	/* maybe complicated, over elaborate */
}

