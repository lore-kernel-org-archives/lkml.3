Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAMTcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:32:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19251 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbaAMTcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:32:47 -0500
Message-ID: <52D43F26.4040007@fb.com>
Date: Mon, 13 Jan 2014 14:31:50 -0500
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Chris Mason <clm@fb.com>
CC: <linux-kernel@vger.kernel.org>, <peterz@infradead.org>
Subject: Re: [PATCH 1/2] rwsem: add rwsem_is_contended
References: <1389633531-1921-1-git-send-email-jbacik@fb.com> <20140113190221.GA9667@gmail.com>
In-Reply-To: <20140113190221.GA9667@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-13_03:2014-01-13,2014-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.64183245069339e-08 kscore.compositescore=0
 circleOfTrustscore=71.2056966559817 compositescore=0.9989857498195
 urlsuspect_oldscore=0.9989857498195 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.9989857498195 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401130128
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 02:02 PM, Ingo Molnar wrote:
> * Josef Bacik <jbacik@fb.com> wrote:
>
>> From: Josef Bacik <jbacik@fusionio.com>
>>
>> Btrfs needs a simple way to know if it needs to let go of it's read lock on a
>> rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
>> this rwsem currently.  This is just a hueristic, it is meant to be light and not
>> 100% accurate and called by somebody already holding on to the rwsem in either
>> read or write.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>> ---
>>   include/linux/rwsem.h | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
>> index 0616ffe..03f3b05 100644
>> --- a/include/linux/rwsem.h
>> +++ b/include/linux/rwsem.h
>> @@ -75,6 +75,17 @@ do {								\
>>   } while (0)
>>   
>>   /*
>> + * This is the same regardless of which rwsem implementation that is being used.
>> + * It is just a heuristic meant to be called by somebody alreadying holding the
>> + * rwsem to see if somebody from an incompatible type is wanting access to the
>> + * lock.
>> + */
>> +static inline int rwsem_is_contended(struct rw_semaphore *sem)
>> +{
>> +	return !list_empty(&sem->wait_list);
>> +}
>> +
>> +/*
>>    * lock for reading
>>    */
>>   extern void down_read(struct rw_semaphore *sem);
> Looks good to me. To make it easier to merge 2/2 feel free to add this
> to the BTRFS tree, with my Acked-by:
>
>    Acked-by: Ingo Molnar <mingo@kernel.org>
Great thanks Ingo,

Josef
