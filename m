Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaIHOZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:25:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42115 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaIHOZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:25:04 -0400
Message-ID: <540DBC36.3020107@oracle.com>
Date: Mon, 08 Sep 2014 10:24:54 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org
CC: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fsnotify: don't put user context if it was never assigned
References: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com> <540788A3.80101@oracle.com>
In-Reply-To: <540788A3.80101@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 09/03/2014 05:31 PM, Sasha Levin wrote:
> Ping? This is a NULL ptr deref that userspace can trigger.
> 
> On 07/29/2014 09:25 AM, Sasha Levin wrote:
>> On some failure paths we may attempt to free user context even
>> if it wasn't assigned yet. This will cause a NULL ptr deref
>> and a kernel BUG.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> ---
>>  fs/notify/inotify/inotify_fsnotify.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
>> index 43ab1e1..9c8187e 100644
>> --- a/fs/notify/inotify/inotify_fsnotify.c
>> +++ b/fs/notify/inotify/inotify_fsnotify.c
>> @@ -165,8 +165,10 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
>>  	/* ideally the idr is empty and we won't hit the BUG in the callback */
>>  	idr_for_each(&group->inotify_data.idr, idr_callback, group);
>>  	idr_destroy(&group->inotify_data.idr);
>> -	atomic_dec(&group->inotify_data.user->inotify_devs);
>> -	free_uid(group->inotify_data.user);
>> +	if (group->inotify_data.user) {
>> +		atomic_dec(&group->inotify_data.user->inotify_devs);
>> +		free_uid(group->inotify_data.user);
>> +	}
>>  }
>>  
>>  static void inotify_free_event(struct fsnotify_event *fsn_event)
>>
> 

