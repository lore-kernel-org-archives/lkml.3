Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3KOWEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:04:36 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:52011 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3KOWEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:04:30 -0500
Message-ID: <52869A6C.8060900@gmail.com>
Date: Fri, 15 Nov 2013 23:04:28 +0100
From: Chang <changxiangzhong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com
CC: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dreibh@simula.no, ernstgr@simula.no
Subject: Re: [PATCH] net: sctp: recover a tranport when an ack comes
References: <1384461624-17636-1-git-send-email-changxiangzhong@gmail.com> <5285884F.8030907@gmail.com>
In-Reply-To: <5285884F.8030907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/15/2013 03:34 AM, Vlad Yasevich wrote:
> I don't think this is right.  The spec states:
>  8.  ACKs for retransmissions do not transition a PF destination back
>        to Active state, since a sender cannot disambiguate whether the
>        ack was for the original transmission or the retransmission(s).
>
Could you please reconsider my proposal?

In the rule 8, it clearly specifies ACKs for *retransmission* do not 
transition ... But those chunks were not retransmitted!

Every transport maintains its own [transport->transmitted] queue, when 
retransmit happens (no matter time_out or fast_retransmit). The chunk 
would be removed from the queue and moved to the sctp_outq->retransmit.

static void sctp_check_transmitted(...) {
...
     if (transport) {  /*<=======This proves that its not the 
outq->retransmit (the retransmitted queue)*/
         if (bytes_acked) {
         ...
         if((transport->state in [INACTIVE, UNCONFIRMED, PF]...)
             sctp_assoc_control_transport(..., SCTP_TRANSPORT_UP).


In addition, if its not appropriate to transition PF->ACTIVE, why is it 
appropriate to transition INACTIVE->ACTIVE (the original implementation).
>
> Now, the proper way to this would would be modify 
> sctp_assoc_control_transport() to transition the transport state to
> ACTIVE if it was PF transport that was chosen to send data.
>
> -vlad
>
>> ---
>>   net/sctp/outqueue.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
>> index 94df758..2557fa5 100644
>> --- a/net/sctp/outqueue.c
>> +++ b/net/sctp/outqueue.c
>> @@ -1517,6 +1517,7 @@ static void sctp_check_transmitted(struct 
>> sctp_outq *q,
>>                * active if it is not so marked.
>>                */
>>               if ((transport->state == SCTP_INACTIVE ||
>> +                 transport->state == SCTP_PF ||
>>                    transport->state == SCTP_UNCONFIRMED) &&
>>                   sctp_cmp_addr_exact(&transport->ipaddr, saddr)) {
>>                   sctp_assoc_control_transport(
>>
>

