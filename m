Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbbAWQFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:05:17 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62487 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbbAWQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:05:14 -0500
Message-ID: <54C27137.5010405@gmail.com>
Date: Fri, 23 Jan 2015 11:05:11 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>, Sun Paul <paulrbk@gmail.com>
CC: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Fwd: Question on SCTP ABORT chunk is generated when the association_max_retrans
 is reached
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com> <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com> <54C23581.9060809@redhat.com>
In-Reply-To: <54C23581.9060809@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 06:50 AM, Daniel Borkmann wrote:
> Hi,
> 
> On 01/23/2015 11:25 AM, Sun Paul wrote:
> ...
>> I would like to check the behave in LKSCTP.
>>
>> we are running DIAMETER message over SCTP, and we have set the
>> parameter "net.sctp.association_max_retrans = 4" in the LinuxOS.
>>
>> We noticed that when remote peer have retry to send the same request
>> for 4 times, the LKSCTP will initiate an ABORT chunk with reason
>> "association exceeded its max_retrans count".
>>
>> We would like to know whether this is the correct behavior? is there
>> any other option that we can alter in order to avoid the ABORT chunk
>> being sent?
> 
> I don't recall the RFC saying to send an ABORT, but let me double
> check in the mean time.

The RFC is silent on the matter.  The abort got added in 3.8 so
it's been there for a while.


> 
> Hmm, untested, but could you try something like that?
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index fef2acd..5ce198d 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -584,7 +584,8 @@ static void sctp_cmd_assoc_failed(sctp_cmd_seq_t *commands,
>          sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
>                  SCTP_ULPEVENT(event));
> 
> -    if (asoc->overall_error_count >= asoc->max_retrans) {
> +    if (asoc->overall_error_count >= asoc->max_retrans &&
> +        error != SCTP_ERROR_NO_ERROR) {
>          abort = sctp_make_violation_max_retrans(asoc, chunk);
>          if (abort)
>              sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,


This would pretty much stop all ABORTs due to excessive rtx.  Might
as well take the code out :).

I was a bit concerned about this ABORT when it went in.

-vlad
