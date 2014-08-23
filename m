Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaHWRnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:43:14 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:51714 "EHLO
	mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaHWRnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:43:13 -0400
Message-ID: <53F8D2A7.70204@thorsten-knabe.de>
Date: Sat, 23 Aug 2014 19:43:03 +0200
From: Thorsten Knabe <linux@thorsten-knabe.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] UML: UBD: Fix for processes stuck in D state forever
 in UserModeLinux
References: <53F89B7A.1040406@thorsten-knabe.de> <53F8B48D.8060209@nod.at>
In-Reply-To: <53F8B48D.8060209@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Report: Content analysis details:   (-1.8 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.8 DKIM_ADSP_ALL          No valid author signature, domain signs all mail
 -0.7 RP_MATCHES_RCVD        Envelope sender domain matches handover relay domain
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard.

On 08/23/2014 05:34 PM, Richard Weinberger wrote:
> Hi!
> 
> Am 23.08.2014 15:47, schrieb Thorsten Knabe:
>> From: Thorsten Knabe <linux@thorsten-knabe.de>
>>
>> UML: UBD: Fix for processes stuck in D state forever in UserModeLinux.
>>
>> Starting with Linux 3.12 processes get stuck in D state forever in
>> UserModeLinux under sync heavy workloads. This bug was introduced by
>> commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
>> Fix bug by adding a check if FLUSH request was successfully submitted to
>> the I/O thread and keeping the FLUSH request on the request queue on
>> submission failures.
>>
>> Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
>> Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>
> 
> Thanks a lot for hunting this issue down.
> 
>> ---
>> Patch applies to 3.16.1.
>>
>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>> index 3716e69..b7d2840 100644
>> --- a/arch/um/drivers/ubd_kern.c
>> +++ b/arch/um/drivers/ubd_kern.c
>> @@ -1277,7 +1277,7 @@ static void do_ubd_request(struct request_queue *q)
>>
>>  	while(1){
>>  		struct ubd *dev = q->queuedata;
>> -		if(dev->end_sg == 0){
>> +		if(dev->request == NULL){
> 
> Why do we need this specific change?

This change is required, because for FLUSH requests dev->end_sg is
initialized to 0 by blk_rq_map_sg() a few lines above, as FLUSH requests
have no data blocks attached to themselves.

Checking for dev->end_sg == 0 would then replace a not yet submitted
FLUSH request by the next request on the next iteration of the while
loop, also the FLUSH request was scheduled for resubmission to the I/O
thread.

Kind regards
Thorsten

> 
> Thanks,
> //richard
> 


-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
