Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaHXXCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 19:02:24 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:40350 "EHLO
	mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHXXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 19:02:23 -0400
Message-ID: <53FA6EF3.3080902@thorsten-knabe.de>
Date: Mon, 25 Aug 2014 01:02:11 +0200
From: Thorsten Knabe <linux@thorsten-knabe.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] UML: UBD: Fix for processes stuck in D state forever
 in UserModeLinux
References: <53F89B7A.1040406@thorsten-knabe.de> <53F8B48D.8060209@nod.at> <53F8D2A7.70204@thorsten-knabe.de> <53F9D661.8080100@nod.at>
In-Reply-To: <53F9D661.8080100@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Report: Content analysis details:   (-1.1 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.8 DKIM_ADSP_ALL          No valid author signature, domain signs all mail
 -0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
                             domain
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2014 02:11 PM, Richard Weinberger wrote:
> Am 23.08.2014 19:43, schrieb Thorsten Knabe:
>> Hi Richard.
>>
>> On 08/23/2014 05:34 PM, Richard Weinberger wrote:
>>> Hi!
>>>
>>> Am 23.08.2014 15:47, schrieb Thorsten Knabe:
>>>> From: Thorsten Knabe <linux@thorsten-knabe.de>
>>>>
>>>> UML: UBD: Fix for processes stuck in D state forever in UserModeLinux.
>>>>
>>>> Starting with Linux 3.12 processes get stuck in D state forever in
>>>> UserModeLinux under sync heavy workloads. This bug was introduced by
>>>> commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
>>>> Fix bug by adding a check if FLUSH request was successfully submitted to
>>>> the I/O thread and keeping the FLUSH request on the request queue on
>>>> submission failures.
>>>>
>>>> Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
>>>> Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>
>>>
>>> Thanks a lot for hunting this issue down.
>>>
>>>> ---
>>>> Patch applies to 3.16.1.
>>>>
>>>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>>>> index 3716e69..b7d2840 100644
>>>> --- a/arch/um/drivers/ubd_kern.c
>>>> +++ b/arch/um/drivers/ubd_kern.c
>>>> @@ -1277,7 +1277,7 @@ static void do_ubd_request(struct request_queue *q)
>>>>
>>>>  	while(1){
>>>>  		struct ubd *dev = q->queuedata;
>>>> -		if(dev->end_sg == 0){
>>>> +		if(dev->request == NULL){
>>>
>>> Why do we need this specific change?
>>
>> This change is required, because for FLUSH requests dev->end_sg is
>> initialized to 0 by blk_rq_map_sg() a few lines above, as FLUSH requests
>> have no data blocks attached to themselves.
> 
> You meant "below"? Looks like I really miss something here.
> At the bottom of the while(1) loop we have
>                 dev->end_sg = 0;
>                 dev->request = NULL;

No. The problematic line is:
                        dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
and blk_rq_map_sg() returning 0 for REQ_FLUSH requests, because they
have no associated data blocks.

Hence on the next iteration of the while(1) loop:
                if(dev->end_sg == 0){
will be true, even if the request has not been successfully submitted to
the I/O thread in the previous iteration of the while(1) loop and a new
request will be fetched:
                        struct request *req = blk_fetch_request(q);
                        if(req == NULL)
                                return;

                        dev->request = req;
                        dev->rq_pos = blk_rq_pos(req);
                        dev->start_sg = 0;
                        dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
                }

Thus the REQ_FLUSH request got lost and will never get submitted to the
I/O thread, there will be no matching answer from the I/O thread and the
lost REQ_FLUSH request will never complete...

Regards
Thorsten

> 
> Thanks,
> //richard
> 


-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
