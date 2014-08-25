Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaHYOAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:00:21 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:47807 "EHLO
	mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbaHYOAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:00:16 -0400
Message-ID: <53FB4168.9070200@thorsten-knabe.de>
Date: Mon, 25 Aug 2014 16:00:08 +0200
From: Thorsten Knabe <linux@thorsten-knabe.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] UML: UBD: Fix for processes stuck in D state forever
 in UserModeLinux
References: <53F89B7A.1040406@thorsten-knabe.de> <53F8B48D.8060209@nod.at> <53F8D2A7.70204@thorsten-knabe.de> <53F9D661.8080100@nod.at> <53FA6EF3.3080902@thorsten-knabe.de> <53FB3941.3060504@nod.at>
In-Reply-To: <53FB3941.3060504@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Report: Content analysis details:   (-1.1 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.8 DKIM_ADSP_ALL          No valid author signature, domain signs all mail
  0.0 RP_MATCHES_RCVD        Envelope sender domain matches handover relay domain
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 03:25 PM, Richard Weinberger wrote:
> Am 25.08.2014 01:02, schrieb Thorsten Knabe:
>> On 08/24/2014 02:11 PM, Richard Weinberger wrote:
>>> Am 23.08.2014 19:43, schrieb Thorsten Knabe:
>>>> Hi Richard.
>>>>
>>>> On 08/23/2014 05:34 PM, Richard Weinberger wrote:
>>>>> Hi!
>>>>>
>>>>> Am 23.08.2014 15:47, schrieb Thorsten Knabe:
>>>>>> From: Thorsten Knabe <linux@thorsten-knabe.de>
>>>>>>
>>>>>> UML: UBD: Fix for processes stuck in D state forever in UserModeLinux.
>>>>>>
>>>>>> Starting with Linux 3.12 processes get stuck in D state forever in
>>>>>> UserModeLinux under sync heavy workloads. This bug was introduced by
>>>>>> commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
>>>>>> Fix bug by adding a check if FLUSH request was successfully submitted to
>>>>>> the I/O thread and keeping the FLUSH request on the request queue on
>>>>>> submission failures.
>>>>>>
>>>>>> Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
>>>>>> Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>
>>>>>
>>>>> Thanks a lot for hunting this issue down.
>>>>>
>>>>>> ---
>>>>>> Patch applies to 3.16.1.
>>>>>>
>>>>>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>>>>>> index 3716e69..b7d2840 100644
>>>>>> --- a/arch/um/drivers/ubd_kern.c
>>>>>> +++ b/arch/um/drivers/ubd_kern.c
>>>>>> @@ -1277,7 +1277,7 @@ static void do_ubd_request(struct request_queue *q)
>>>>>>
>>>>>>  	while(1){
>>>>>>  		struct ubd *dev = q->queuedata;
>>>>>> -		if(dev->end_sg == 0){
>>>>>> +		if(dev->request == NULL){
>>>>>
>>>>> Why do we need this specific change?
>>>>
>>>> This change is required, because for FLUSH requests dev->end_sg is
>>>> initialized to 0 by blk_rq_map_sg() a few lines above, as FLUSH requests
>>>> have no data blocks attached to themselves.
>>>
>>> You meant "below"? Looks like I really miss something here.
>>> At the bottom of the while(1) loop we have
>>>                 dev->end_sg = 0;
>>>                 dev->request = NULL;
>>
>> No. The problematic line is:
>>                         dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
>> and blk_rq_map_sg() returning 0 for REQ_FLUSH requests, because they
>> have no associated data blocks.
>>
>> Hence on the next iteration of the while(1) loop:
>>                 if(dev->end_sg == 0){
> 
> At the bottom of the while loop dev->end_sg will be set to 0 anyway, this is what puzzles
> me so hard.
> (And dev->request too)

Yes, but the statements:
                dev->end_sg = 0;
                dev->request = NULL;
at the end of the while loop will only be reached (for FLUSH requests
only with my patch applied) when submit_request() succeeds. Otherwise
the function do_ubd_request() returns early leaving dev->end_sg and
dev->request untouched.

> 
> Thanks,
> //richard
> 


-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
