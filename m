Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3KHKCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:02:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8001 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab3KHKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:02:41 -0500
X-IronPort-AV: E=Sophos;i="4.93,658,1378828800"; 
   d="scan'208";a="8980322"
Message-ID: <527CB54B.4040704@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 17:56:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@zeniv.linux.org.uk>, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] fs/buffer.c: exit if already confirmed page has
 dirty and writeback buffers
References: <5278C21B.7010204@cn.fujitsu.com> <20131107114459.GB31798@quack.suse.cz>
In-Reply-To: <20131107114459.GB31798@quack.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/08 18:00:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/08 18:00:42,
	Serialize complete at 2013/11/08 18:00:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On 11/07/2013 07:44 PM, Jan Kara wrote:

> On Tue 05-11-13 18:02:03, Gu Zheng wrote:
>> Stop the loop of iterating bh if we have confirmed page
>> has dirty and writeback buffers.
>   Thanks for the patch. What I'm somewhat missing here is a motivation of
> the patch. For the common case where blocksize == pagesize this is a noop
> (only adds some code). 

Yes, you're right.

> For the case where blocksize < pagesize we can
> possibly save checking some buffers but how common is that going be?

It's really hard to say.:( But many file systems support small blocksize.

> Does that minimal speed up outweight the cost of additional check / code
> complication?

In fact, without complete test. But I think the speed up can outweigh the cost
if blocksize small enough. For example, blocksize: 1k, pagesize: 4k, we can
reduce 6 bh check(3 dirty, 3 writeback) in the best case.

Best regards,
Gu

> 
> 								Honza
> 
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/buffer.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 6024877..519cc5c 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -112,7 +112,7 @@ void buffer_check_dirty_writeback(struct page *page,
>>  			*dirty = true;
>>  
>>  		bh = bh->b_this_page;
>> -	} while (bh != head);
>> +	} while ((bh != head) && !(*writeback && *dirty));
>>  }
>>  EXPORT_SYMBOL(buffer_check_dirty_writeback);
>>  
>> -- 
>> 1.7.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


