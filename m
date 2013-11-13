Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab3KMO2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:28:32 -0500
Received: from mail-gg0-f177.google.com ([209.85.161.177]:41889 "EHLO
	mail-gg0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828Ab3KMO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:28:29 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2013 09:28:29 EST
Message-ID: <52838B30.6020804@gmail.com>
Date: Wed, 13 Nov 2013 09:22:40 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chang <changxiangzhong@gmail.com>, nhorman@tuxdriver.com,
        davem@davemloft.net
CC: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dreibh@simula.no
Subject: Re: [PATCH 1/1] net: sctp: bug fixing when sctp path recovers
References: <1384306486-31345-1-git-send-email-changxiangzhong@gmail.com> <5282E5F9.5000506@gmail.com> <5282E9EC.3090307@gmail.com>
In-Reply-To: <5282E9EC.3090307@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 09:54 PM, Chang wrote:
>
> On 11/13/2013 03:37 AM, Vlad Yasevich wrote:
>> On 11/12/2013 08:34 PM, Chang Xiangzhong wrote:
>>> Look for the __two__ most recently used path/transport and set to
>>> active_path
>>> and retran_path respectively
>>>
>>> Signed-off-by: changxiangzhong@gmail.com
>>> ---
>>>   net/sctp/associola.c |    4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
>>> index ab67efc..070011a 100644
>>> --- a/net/sctp/associola.c
>>> +++ b/net/sctp/associola.c
>>> @@ -913,11 +913,15 @@ void sctp_assoc_control_transport(struct
>>> sctp_association *asoc,
>>>           if (!first || t->last_time_heard > first->last_time_heard) {
>>>               second = first;
>>>               first = t;
>>> +            continue;
>>>           }
>>>           if (!second || t->last_time_heard > second->last_time_heard)
>>>               second = t;
>>
>> You might as well remove this bit and then you don't need a continue.
> I don't think we could remove this bit. My understanding of these
> algorithms are to find the 1st recently used path and the 2nd, assigning
> to active_path and retran_path respectively. If we remove the
> looking-for-second block, how are we suppose to find the 2nd?
> I think we can remove the continue and use else-if in the
> 2nd-assignment-block.

Yes, you are right.  An if...else block is what we need here.

-vlad

>>
>>>       }
>>>
>>> +    if (!second)
>>> +        second = first;
>>> +
>>
>> This needs to move down 1 more block.  Set the second transport after we
>> check to see if the primary is back up and we need to go back to using
>> it.
>>
>> -vlad
>>
> I agree with this change
>>>       /* RFC 2960 6.4 Multi-Homed SCTP Endpoints
>>>        *
>>>        * By default, an endpoint should always transmit to the
>>>
>>
>

