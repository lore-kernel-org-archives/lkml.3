Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3BMHXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:23:22 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:37120 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab3BMHXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:23:09 -0500
Message-ID: <511B3F5B.4050803@msgid.tls.msk.ru>
Date: Wed, 13 Feb 2013 11:23:07 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org
Subject: Re: [PATCH linux-next] autofs4: autofs4_catatonic_mode(): remove
 redundant null check on kfree()
References: <1360689138-59191-1-git-send-email-tim.gardner@canonical.com> <1360740008.2288.3.camel@perseus.themaw.net>
In-Reply-To: <1360740008.2288.3.camel@perseus.themaw.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13.02.2013 11:20, Ian Kent wrote:
> On Tue, 2013-02-12 at 10:12 -0700, Tim Gardner wrote:
>> smatch analysis:
>>
>> fs/autofs4/waitq.c:46 autofs4_catatonic_mode() info: redundant null
>>   check on wq->name.name calling kfree()
>
> I'm not sure about this change.
>
> autofs4_catatonic_mode() could be called when there are remaining
> entries in the wait queue, which is nulled, so autofs4_wait_release()
> won't see the the discarded waits if it is called.

Ian, this is about something else really.  The patch is about the
NULL check before calling kfree() -- it does the NULL check internally.
It is nothing about code flow or anything else, it is about calling
kfree() unconditionally regardless whenever the argument is actually
NULL or non-NULL.  It makes the code shorter and easier to read.

You can add my

Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>

if you want.

>> Cc: Ian Kent <raven@themaw.net>
>> Cc: autofs@vger.kernel.org
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> ---
>>   fs/autofs4/waitq.c |    6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
>> index 03bc1d3..3db70da 100644
>> --- a/fs/autofs4/waitq.c
>> +++ b/fs/autofs4/waitq.c
>> @@ -42,10 +42,8 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
>>   	while (wq) {
>>   		nwq = wq->next;
>>   		wq->status = -ENOENT; /* Magic is gone - report failure */
>> -		if (wq->name.name) {
>> -			kfree(wq->name.name);
>> -			wq->name.name = NULL;
>> -		}
>> +		kfree(wq->name.name);
>> +		wq->name.name = NULL;
>>   		wq->wait_ctr--;
>>   		wake_up_interruptible(&wq->queue);
>>   		wq = nwq;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe autofs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

