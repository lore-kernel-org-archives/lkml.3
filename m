Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3FGK0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:26:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:63210 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:26:13 -0400
Message-ID: <51B1B866.6080103@windriver.com>
Date: Fri, 7 Jun 2013 18:39:34 +0800
From: Xufeng Zhang <xufeng.zhang@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] sctp: set association state to established in dupcook_a
 handler
References: <1370245978-12884-1-git-send-email-xufeng.zhang@windriver.com> <51AEA8B6.9090609@windriver.com>
In-Reply-To: <51AEA8B6.9090609@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Is this fix fine to you for -stable?


Thanks,
Xufeng

On 06/05/2013 10:55 AM, Xufeng Zhang wrote:
> On 06/03/2013 03:52 PM, Xufeng Zhang wrote:
>> 3.4-stable review patch.  If anyone has any objections, please let me 
>> know.
> Sorry Greg, David -- I did not fully understand all the details
> of the stable kernel process earlier.
>
> I have since checked the networking stable queue here:
>
> http://patchwork.ozlabs.org/bundle/davem/stable/?state=*
>
> to confirm this upstream commit 9839ff0d has not yet been queued.
>
> It can be applied to kernel versions<3.0, 3.4>, and is
> present in mainline for 3.8+ kernels.
>
> I think it makes sense to queue for stable because it
> fixes the SCTP association can get stuck in SCTP_STATE_SHUTDOWN_PENDING
> state forever in the below test case:
> 1). Set SCTP parameters on A (slow detection of link failure):
> net.sctp.association_max_retrans = 5
> net.sctp.path_max_retrans = 5
> net.sctp.hb_interval = 30000
> 2). Set SCTP parameters on B (fast detection of link failure):
> net.sctp.association_max_retrans = 2
> net.sctp.path_max_retrans = 2
> net.sctp.hb_interval = 1000
> 3). Start sctp_darn on both sides:
> A(interactive):
> sctp_darn -H 192.168.100.10 -P 256 -h 192.168.100.100 -p 256 -I -s
> B:
> sctp_darn -H 192.168.100.100 -P 256 -h 192.168.100.10 -p 256 -l&
> 4). Send data on A to establish the SCTP association:
> snd=5
> 5). Block SCTP traffic on B (simulates a network failure):
> iptables -t filter -I INPUT 1 -p sctp --dport 256 -j DROP
> iptables -t filter -I OUTPUT 1 -p sctp --dport 256 -j DROP
> Then quickly send data on A and then shutdown (A goes into 
> SHUTDOWN_PENDING state):
> snd=5
> snd=5
> shutdown
> 6). Wait for link to drop on B (Recieved SCTP_COMM_LOST), and quickly 
> kill the listener,
> open the firewall for SCTP, then start an SCTP sender:
> kill $PID
> iptables -t filter -D INPUT 1
> iptables -t filter -D OUTPUT 1
> sctp_darn -H 192.168.100.100 -P 256 -h 192.168.100.10 -p 256 -s
> Press<Enter>  to send data to trigger sending INIT to A, the SHUTDOWN 
> on A will failed and
> the association on A remains in SHUTDOWN_PENDING (5) state indefinitely.
>
>
> However if David doesn't think it is worth bothering with for
> net stable, then that is of course fine too.
>
>
> Thanks,
> Xufeng
>
>
>
>> ------------------
>>
>>
>> From: Xufeng Zhang<xufeng.zhang@windriver.com>
>>
>> [ Upstream commit 9839ff0dead906e85e4d17490aeff87a5859a157 ]
>>
>> While sctp handling a duplicate COOKIE-ECHO and the action is
>> 'Association restart', sctp_sf_do_dupcook_a() will processing
>> the unexpected COOKIE-ECHO for peer restart, but it does not set
>> the association state to SCTP_STATE_ESTABLISHED, so the association
>> could stuck in SCTP_STATE_SHUTDOWN_PENDING state forever.
>> This violates the sctp specification:
>>    RFC 4960 5.2.4. Handle a COOKIE ECHO when a TCB Exists
>>    Action
>>    A) In this case, the peer may have restarted. .....
>>       After this, the endpoint shall enter the ESTABLISHED state.
>>
>> To resolve this problem, adding a SCTP_CMD_NEW_STATE cmd to the
>> command list before SCTP_CMD_REPLY cmd, this will set the restart
>> association to SCTP_STATE_ESTABLISHED state properly and also avoid
>> I-bit being set in the DATA chunk header when COOKIE_ACK is bundled
>> with DATA chunks.
>>
>> Signed-off-by: Xufeng Zhang<xufeng.zhang@windriver.com>
>> Acked-by: Neil Horman<nhorman@tuxdriver.com>
>> Acked-by: Vlad Yasevich<vyasevich@gmail.com>
>> Signed-off-by: David S. Miller<davem@davemloft.net>
>> ---
>>   net/sctp/sm_statefuns.c |    4 +++-
>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
>> index cb1c430..ab08f65 100644
>> --- a/net/sctp/sm_statefuns.c
>> +++ b/net/sctp/sm_statefuns.c
>> @@ -1747,8 +1747,10 @@ static sctp_disposition_t 
>> sctp_sf_do_dupcook_a(const struct sctp_endpoint *ep,
>>
>>       /* Update the content of current association. */
>>       sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, 
>> SCTP_ASOC(new_asoc));
>> -    sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
>>       sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
>> +    sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
>> +            SCTP_STATE(SCTP_STATE_ESTABLISHED));
>> +    sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
>>       return SCTP_DISPOSITION_CONSUME;
>>
>>   nomem_ev:
>
>

