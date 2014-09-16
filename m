Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaIPQuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:50:23 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:43611 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaIPQuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <53FB426B.90002@nod.at>
References: <53F89B7A.1040406@thorsten-knabe.de>
	<53F8B48D.8060209@nod.at>
	<53F8D2A7.70204@thorsten-knabe.de>
	<53F9D661.8080100@nod.at>
	<53FA6EF3.3080902@thorsten-knabe.de>
	<53FB3941.3060504@nod.at>
	<53FB4168.9070200@thorsten-knabe.de>
	<53FB426B.90002@nod.at>
Date: Tue, 16 Sep 2014 18:50:19 +0200
Message-ID: <CAFLxGvxySJ9WvNTOjww9OG5KB-q++72WT3QcrCGAFW1M=C9DhA@mail.gmail.com>
Subject: Re: [PATCH] UML: UBD: Fix for processes stuck in D state forever in UserModeLinux
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Thorsten Knabe <linux@thorsten-knabe.de>,
        LKML <linux-kernel@vger.kernel.org>, Thomas Meyer <thomas@m3y3r.de>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 4:04 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 25.08.2014 16:00, schrieb Thorsten Knabe:
>> On 08/25/2014 03:25 PM, Richard Weinberger wrote:
>>> Am 25.08.2014 01:02, schrieb Thorsten Knabe:
>>>> On 08/24/2014 02:11 PM, Richard Weinberger wrote:
>>>>> Am 23.08.2014 19:43, schrieb Thorsten Knabe:
>>>>>> Hi Richard.
>>>>>>
>>>>>> On 08/23/2014 05:34 PM, Richard Weinberger wrote:
>>>>>>> Hi!
>>>>>>>
>>>>>>> Am 23.08.2014 15:47, schrieb Thorsten Knabe:
>>>>>>>> From: Thorsten Knabe <linux@thorsten-knabe.de>
>>>>>>>>
>>>>>>>> UML: UBD: Fix for processes stuck in D state forever in UserModeLinux.
>>>>>>>>
>>>>>>>> Starting with Linux 3.12 processes get stuck in D state forever in
>>>>>>>> UserModeLinux under sync heavy workloads. This bug was introduced by
>>>>>>>> commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
>>>>>>>> Fix bug by adding a check if FLUSH request was successfully submitted to
>>>>>>>> the I/O thread and keeping the FLUSH request on the request queue on
>>>>>>>> submission failures.
>>>>>>>>
>>>>>>>> Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
>>>>>>>> Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>
>>>>>>>
>>>>>>> Thanks a lot for hunting this issue down.
>>>>>>>
>>>>>>>> ---
>>>>>>>> Patch applies to 3.16.1.
>>>>>>>>
>>>>>>>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>>>>>>>> index 3716e69..b7d2840 100644
>>>>>>>> --- a/arch/um/drivers/ubd_kern.c
>>>>>>>> +++ b/arch/um/drivers/ubd_kern.c
>>>>>>>> @@ -1277,7 +1277,7 @@ static void do_ubd_request(struct request_queue *q)
>>>>>>>>
>>>>>>>>         while(1){
>>>>>>>>                 struct ubd *dev = q->queuedata;
>>>>>>>> -               if(dev->end_sg == 0){
>>>>>>>> +               if(dev->request == NULL){
>>>>>>>
>>>>>>> Why do we need this specific change?
>>>>>>
>>>>>> This change is required, because for FLUSH requests dev->end_sg is
>>>>>> initialized to 0 by blk_rq_map_sg() a few lines above, as FLUSH requests
>>>>>> have no data blocks attached to themselves.
>>>>>
>>>>> You meant "below"? Looks like I really miss something here.
>>>>> At the bottom of the while(1) loop we have
>>>>>                 dev->end_sg = 0;
>>>>>                 dev->request = NULL;
>>>>
>>>> No. The problematic line is:
>>>>                         dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
>>>> and blk_rq_map_sg() returning 0 for REQ_FLUSH requests, because they
>>>> have no associated data blocks.
>>>>
>>>> Hence on the next iteration of the while(1) loop:
>>>>                 if(dev->end_sg == 0){
>>>
>>> At the bottom of the while loop dev->end_sg will be set to 0 anyway, this is what puzzles
>>> me so hard.
>>> (And dev->request too)
>>
>> Yes, but the statements:
>>                 dev->end_sg = 0;
>>                 dev->request = NULL;
>> at the end of the while loop will only be reached (for FLUSH requests
>> only with my patch applied) when submit_request() succeeds. Otherwise
>> the function do_ubd_request() returns early leaving dev->end_sg and
>> dev->request untouched.
>
> Can you please add this info into the commit message, I'm sure others get also
> confused by that.^^
> The logic in do_ubd_request() royal mess which needs fixing too. :-\

Hmm, you didn't resend the patch.
I'll amend the commit message myself and push it to Linus this week.

-- 
Thanks,
//richard
