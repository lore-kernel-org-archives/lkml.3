Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbaHYOEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:04:32 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300AbaHYOEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:04:31 -0400
Message-ID: <53FB426B.90002@nod.at>
Date: Mon, 25 Aug 2014 16:04:27 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thorsten Knabe <linux@thorsten-knabe.de>
CC: linux-kernel@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] UML: UBD: Fix for processes stuck in D state forever
 in UserModeLinux
References: <53F89B7A.1040406@thorsten-knabe.de> <53F8B48D.8060209@nod.at> <53F8D2A7.70204@thorsten-knabe.de> <53F9D661.8080100@nod.at> <53FA6EF3.3080902@thorsten-knabe.de> <53FB3941.3060504@nod.at> <53FB4168.9070200@thorsten-knabe.de>
In-Reply-To: <53FB4168.9070200@thorsten-knabe.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.08.2014 16:00, schrieb Thorsten Knabe:
> On 08/25/2014 03:25 PM, Richard Weinberger wrote:
>> Am 25.08.2014 01:02, schrieb Thorsten Knabe:
>>> On 08/24/2014 02:11 PM, Richard Weinberger wrote:
>>>> Am 23.08.2014 19:43, schrieb Thorsten Knabe:
>>>>> Hi Richard.
>>>>>
>>>>> On 08/23/2014 05:34 PM, Richard Weinberger wrote:
>>>>>> Hi!
>>>>>>
>>>>>> Am 23.08.2014 15:47, schrieb Thorsten Knabe:
>>>>>>> From: Thorsten Knabe <linux@thorsten-knabe.de>
>>>>>>>
>>>>>>> UML: UBD: Fix for processes stuck in D state forever in UserModeLinux.
>>>>>>>
>>>>>>> Starting with Linux 3.12 processes get stuck in D state forever in
>>>>>>> UserModeLinux under sync heavy workloads. This bug was introduced by
>>>>>>> commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
>>>>>>> Fix bug by adding a check if FLUSH request was successfully submitted to
>>>>>>> the I/O thread and keeping the FLUSH request on the request queue on
>>>>>>> submission failures.
>>>>>>>
>>>>>>> Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
>>>>>>> Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>
>>>>>>
>>>>>> Thanks a lot for hunting this issue down.
>>>>>>
>>>>>>> ---
>>>>>>> Patch applies to 3.16.1.
>>>>>>>
>>>>>>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>>>>>>> index 3716e69..b7d2840 100644
>>>>>>> --- a/arch/um/drivers/ubd_kern.c
>>>>>>> +++ b/arch/um/drivers/ubd_kern.c
>>>>>>> @@ -1277,7 +1277,7 @@ static void do_ubd_request(struct request_queue *q)
>>>>>>>
>>>>>>>  	while(1){
>>>>>>>  		struct ubd *dev = q->queuedata;
>>>>>>> -		if(dev->end_sg == 0){
>>>>>>> +		if(dev->request == NULL){
>>>>>>
>>>>>> Why do we need this specific change?
>>>>>
>>>>> This change is required, because for FLUSH requests dev->end_sg is
>>>>> initialized to 0 by blk_rq_map_sg() a few lines above, as FLUSH requests
>>>>> have no data blocks attached to themselves.
>>>>
>>>> You meant "below"? Looks like I really miss something here.
>>>> At the bottom of the while(1) loop we have
>>>>                 dev->end_sg = 0;
>>>>                 dev->request = NULL;
>>>
>>> No. The problematic line is:
>>>                         dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
>>> and blk_rq_map_sg() returning 0 for REQ_FLUSH requests, because they
>>> have no associated data blocks.
>>>
>>> Hence on the next iteration of the while(1) loop:
>>>                 if(dev->end_sg == 0){
>>
>> At the bottom of the while loop dev->end_sg will be set to 0 anyway, this is what puzzles
>> me so hard.
>> (And dev->request too)
> 
> Yes, but the statements:
>                 dev->end_sg = 0;
>                 dev->request = NULL;
> at the end of the while loop will only be reached (for FLUSH requests
> only with my patch applied) when submit_request() succeeds. Otherwise
> the function do_ubd_request() returns early leaving dev->end_sg and
> dev->request untouched.

Can you please add this info into the commit message, I'm sure others get also
confused by that.^^
The logic in do_ubd_request() royal mess which needs fixing too. :-\

Thanks,
//richard
