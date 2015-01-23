Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbbAWTHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:07:44 -0500
Received: from mail-n.franken.de ([193.175.24.27]:43799 "EHLO
	mail-n.franken.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbAWTHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:07:41 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: Question on SCTP ABORT chunk is generated when the association_max_retrans is reached
From: Michael Tuexen <tuexen@fh-muenster.de>
In-Reply-To: <54C2807E.8080607@redhat.com>
Date: Fri, 23 Jan 2015 19:36:18 +0100
Cc: Vlad Yasevich <vyasevich@gmail.com>, Sun Paul <paulrbk@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8BBFBEE6-FA34-4190-BFCB-AB6BEC093774@fh-muenster.de>
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com> <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com> <54C23581.9060809@redhat.com> <54C27137.5010405@gmail.com> <54C2807E.8080607@redhat.com>
To: Daniel Borkmann <dborkman@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 23 Jan 2015, at 18:10, Daniel Borkmann <dborkman@redhat.com> wrote:
> 
> On 01/23/2015 05:05 PM, Vlad Yasevich wrote:
>> On 01/23/2015 06:50 AM, Daniel Borkmann wrote:
>>> On 01/23/2015 11:25 AM, Sun Paul wrote:
>>> ...
>>>> I would like to check the behave in LKSCTP.
>>>> 
>>>> we are running DIAMETER message over SCTP, and we have set the
>>>> parameter "net.sctp.association_max_retrans = 4" in the LinuxOS.
>>>> 
>>>> We noticed that when remote peer have retry to send the same request
>>>> for 4 times, the LKSCTP will initiate an ABORT chunk with reason
>>>> "association exceeded its max_retrans count".
>>>> 
>>>> We would like to know whether this is the correct behavior? is there
>>>> any other option that we can alter in order to avoid the ABORT chunk
>>>> being sent?
>>> 
>>> I don't recall the RFC saying to send an ABORT, but let me double
>>> check in the mean time.
>> 
>> The RFC is silent on the matter.  The abort got added in 3.8 so
>> it's been there for a while.
> 
> I see, commit de4594a51c90 ("sctp: send abort chunk when max_retrans
> exceeded") added the behaviour.
> 
>>> Hmm, untested, but could you try something like that?
>>> 
>>> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
>>> index fef2acd..5ce198d 100644
>>> --- a/net/sctp/sm_sideeffect.c
>>> +++ b/net/sctp/sm_sideeffect.c
>>> @@ -584,7 +584,8 @@ static void sctp_cmd_assoc_failed(sctp_cmd_seq_t *commands,
>>>          sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
>>>                  SCTP_ULPEVENT(event));
>>> 
>>> -    if (asoc->overall_error_count >= asoc->max_retrans) {
>>> +    if (asoc->overall_error_count >= asoc->max_retrans &&
>>> +        error != SCTP_ERROR_NO_ERROR) {
>>>          abort = sctp_make_violation_max_retrans(asoc, chunk);
>>>          if (abort)
>>>              sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
>> 
>> This would pretty much stop all ABORTs due to excessive rtx.  Might
>> as well take the code out :).
>> 
>> I was a bit concerned about this ABORT when it went in.
> 
> So effectively, if I understand the argument from the commit, the
> assumption is that the ABORT would never reach the peer anyway, but
> is a way for tcpdump users to see on the wire that rtx limit has
> been exceeded and since there's not mentioned anything in the RFC
> about this, it doesn't break it. Hm.
Yepp. It might not reach the peer or it might. If it does it helps
to keep the states in sync. If it doesn't it sometimes helps in
analysing tracefiles. In BSD, we also send it. It is not required,
doesn't harm and is useful in some cases...

Best regards
Michael
> 
> Sun Paul, what exactly broke in your scenario? Can you be more explicit?
> 
> Thanks,
> Daniel
> 

