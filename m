Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaLBCLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 21:11:08 -0500
Received: from mout.gmx.net ([212.227.15.18]:58223 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbaLBCLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 21:11:07 -0500
Message-ID: <547D1FB5.80809@gmx.de>
Date: Tue, 02 Dec 2014 03:11:01 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] fanotify: only destroy mark when both mask and ignored_mask
 are cleared
References: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de> <20141201090450.GB16185@quack.suse.cz>
In-Reply-To: <20141201090450.GB16185@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Eu3/C0YcYMiAIL/adCu8UDI4DLvVB5MW7RSspZLACkWMrT0ZRX+
 N91sKAnTCLVcVVPmCdu8IHWBciAc9i1aLzpHdFG0P8yM29ECEU8BC2DiU/D5VsOjbavS0gK
 1k6T98oQmmIcTlmuCx9EXEqv888m0LEy0jXy/HgdUWGVzg3JkAyBXMvrYexjeRA1EG3zv9s
 A1xWau0SrSZMMXqA7LRIw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01.12.2014 10:04, Jan Kara wrote:
> On Sun 30-11-14 00:37:36, Lino Sanfilippo wrote:
>> In fanotify_mark_remove_from_mask() a mark is destroyed if only one of both
>> bitmasks (mask or ignored_mask) of a mark is cleared. However the other mask
>> may still be set and contain information that should not be lost. Thus only
>> destroy a mark if both masks are cleared.
>> 
>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>> ---
>>  fs/notify/fanotify/fanotify_user.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
>> index c991616..03a0dd1 100644
>> --- a/fs/notify/fanotify/fanotify_user.c
>> +++ b/fs/notify/fanotify/fanotify_user.c
>> @@ -488,6 +488,8 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>>  					    int *destroy)
>>  {
>>  	__u32 oldmask;
>> +	__u32 new_mask;
>> +	__u32 new_ignored;
>>  
>>  	spin_lock(&fsn_mark->lock);
>>  	if (!(flags & FAN_MARK_IGNORED_MASK)) {
>> @@ -497,9 +499,11 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>>  		oldmask = fsn_mark->ignored_mask;
>>  		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
>>  	}
>> +	new_mask = fsn_mark->mask;
>> +	new_ignored = fsn_mark->ignored_mask;
>>  	spin_unlock(&fsn_mark->lock);
>>  
>> -	*destroy = !(oldmask & ~mask);
>> +	*destroy = !(new_mask | new_ignored);
>   There's no need for new variables, is there? You can just set *destroy
> under the spinlock...
> 

youre right, these variables are totally unneeded. I cant remember the
reason why i introduced them (maybe leftovers from an earlier attempt).
I will resend a cleaned up version of that patch.

Regards,
Lino

