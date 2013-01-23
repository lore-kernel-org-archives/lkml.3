Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3AWOW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:22:28 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47666 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3AWOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:22:23 -0500
Message-ID: <50FFF218.1010204@gmail.com>
Date: Wed, 23 Jan 2013 09:22:16 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: xufengzhang.main@gmail.com, sri@us.ibm.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: set association state to established in dupcook_a
 handler
References: <1358926720-25557-1-git-send-email-xufengzhang.main@gmail.com> <20130123134650.GA3512@hmsreliant.think-freely.org>
In-Reply-To: <20130123134650.GA3512@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 08:46 AM, Neil Horman wrote:
> On Wed, Jan 23, 2013 at 03:38:40PM +0800, xufengzhang.main@gmail.com wrote:
>> From: Xufeng Zhang <xufeng.zhang@windriver.com>
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
>> Fix this problem by adding a SCTP_CMD_NEW_STATE cmd to the command
>> list so as to set the restart association to SCTP_STATE_ESTABLISHED
>> state properly.
>>
>> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
>> ---
>>   net/sctp/sm_statefuns.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
>> index 618ec7e..528f1c8 100644
>> --- a/net/sctp/sm_statefuns.c
>> +++ b/net/sctp/sm_statefuns.c
>> @@ -1779,6 +1779,8 @@ static sctp_disposition_t sctp_sf_do_dupcook_a(struct net *net,
>>
>>   	/* Update the content of current association. */
>>   	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
>> +	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
>> +			SCTP_STATE(SCTP_STATE_ESTABLISHED));
>>   	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
>>   	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
>>   	return SCTP_DISPOSITION_CONSUME;
>> --
>> 1.7.0.2
>>
>>
>
> Looks reasonable to me, thanks
>
> nit: The RFC indicate the association should enter the ESTABLISHED state after
> preforming all other actions, so it seems that the state change should occur
> after the ULP event is sent
>

I have a slight concern here that if we change state last, then any data 
that may have been bundled with COOKIE-ACK as part of CMD_REPLY will get 
the SACK_IMMEDIATE flag set since we are still in the SHUTDOWN_PENDING 
state.

I would be more correct (and would match sctp_sf_do_5_1D_ce) to
do it in this order:
   UPDATE_ASSOC  - resets all the congestion/association variables
   EVENT_UP  - send RESTART to USER
   NEW_STATE  - set ESTABLISHED state (as per spec)
   REPLY	- Send cookie-ack along with any pending data.

-vlad
> Neil
>

