Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbaCUCFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:05:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24135 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933061AbaCUCFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:05:39 -0400
X-IronPort-AV: E=Sophos;i="4.97,699,1389715200"; 
   d="scan'208";a="9737834"
Message-ID: <532B9C54.80705@cn.fujitsu.com>
Date: Fri, 21 Mar 2014 09:56:36 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        jmoyer@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
        linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] aio: fix the confliction of read events and migrating
 ring page
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org>
In-Reply-To: <20140320163004.GE28970@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/21 10:02:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/21 10:02:39,
	Serialize complete at 2014/03/21 10:02:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
On 03/21/2014 12:30 AM, Benjamin LaHaise wrote:

> On Thu, Mar 20, 2014 at 10:32:07AM -0400, Dave Jones wrote:
>> On Thu, Mar 20, 2014 at 01:46:25PM +0800, Gu Zheng wrote:
>>
>>  > diff --git a/fs/aio.c b/fs/aio.c
>>  > index 88ad40c..e353085 100644
>>  > --- a/fs/aio.c
>>  > +++ b/fs/aio.c
>>  > @@ -319,6 +319,9 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
>>  >  	ctx->ring_pages[old->index] = new;
>>  >  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>>  >  
>>  > +	/* Ensure read event is completed before putting old page */
>>  > +	mutex_lock(&ctx->ring_lock);
>>  > +	mutex_unlock(&ctx->ring_lock);
>>  >  	put_page(old);
>>  >  
>>  >  	return rc;
>>
>> This looks a bit weird. Would using a completion work here ?
> 
> Nope.  This is actually the most elegant fix I've seen for this approach, 
> as everything else has relied on adding additional spin locks (which only 
> end up being needed in the migration case) around access to the ring_pages 
> on the reader side.  That said, this patch is not a complete solution to 
> the problem, as the update of the ring's head pointer could still get lost 
> with this patch.  I think the right thing is just taking the ring_lock 
> mutex over the entire page migration operation.  That should be safe, as 
> nowhere else is the ring_lock mutex nested with any other locks.

This one is based on linux-next which has merged the following patch:
commit 692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
Author: Tang Chen <tangchen@cn.fujitsu.com>
Date:   Mon Mar 10 16:15:33 2014 +0800
aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.

With this patch, the update of the ring's head pointer is safe because it is protected
by completion_lock, so we do not need to enlarge the ring_lock protection region.
And on the other side, if we take the ring_lock over the entire page migration
operation, reading events will be affected if the page migration is going.

Thanks,
Gu

> 
> 		-ben
> 
>> 	Dave
> 


