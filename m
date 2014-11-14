Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161507AbaKNRJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:09:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51761 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934233AbaKNRJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:09:48 -0500
Message-ID: <5466373B.2070808@ti.com>
Date: Fri, 14 Nov 2014 11:09:15 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv6 4/5] hwspinlock/core: add common OF helpers
References: <1410553499-55951-1-git-send-email-s-anna@ti.com> <1410553499-55951-5-git-send-email-s-anna@ti.com> <CAK=WgbamdqAufjC4Xb5moERRBSB-cO6c1RPTE=f+dp75F+Eh7A@mail.gmail.com> <5463B5B6.8040709@ti.com> <CAK=WgbbatPTiz3efDWHVEcuug_UQfkCViMoK0zcfUg3JwB2oTA@mail.gmail.com> <5464EC7A.7050603@ti.com> <CAK=WgbbodS8GsUxQbkyCp6hAG+Ko4LMirx+pUa8_fUdxWFasvw@mail.gmail.com> <54651C48.90809@ti.com> <CAK=WgbYMM19-rWLOBjix+TA3fF_Pb25ia1rutDxYSUg9SV0efg@mail.gmail.com>
In-Reply-To: <CAK=WgbYMM19-rWLOBjix+TA3fF_Pb25ia1rutDxYSUg9SV0efg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 11/14/2014 01:11 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Thu, Nov 13, 2014 at 11:02 PM, Suman Anna <s-anna@ti.com> wrote:
>> OK, lets take an example. I have say 2 device instances, say
>>         hwlock1: hwlock@0 {
>>                 hwlock-num-locks = <32>
>>                 hwlock-base-id = <0>;
>>                 #hwlock-cells = <1>;
>>         };
>>         hwlock2: hwlock@0 {
>>                 hwlock-num-locks = <32>
>>                 hwlock-base-id = <32>;
>>                 #hwlock-cells = <1>;
>>         };
>>
>>         some-client {
>>                 hwlocks = <&hwlock1 32>, <&hwlock2 0>;
>>         };
>>
>> The first args value is incorrect, and I expect the API to return an
>> error. I don't think the API can make assumptions that all passed in
>> values will be correct. What do you suggest that the API do here?
> 
> I think this is just one example of many potential mistakes the DT
> developer can have, and that there's nothing really special about it.
> 
> What if the '5' digit below is a typo, and the actual hardware
> assignment was supposed to be '4' ?
> 
>          some-client {
>                  hwlocks = <&hwlock1 5>, <&hwlock2 5>;
>          };
> 
> I don't see how much different this mistake is from the one you
> mentioned above. There's a limit to how much we can really catch DT
> mistakes in the code, just like we couldn't really catch past mistakes
> in the platform data structures.
> 
> If we can easily add some validations then great, but if we have to go
> to great lengths just to gain very limited validations, then I'd vote
> against doing so.

OK, personally, I am not too comfortable to not perform any validation
on an API.

> 
>> One solution to handle #1 is to also make the hwlock-num-locks property
>> also mandatory (even though it could have been read from a register
> 
> Yeah, this is awkward. We shouldn't impose this on implementations
> like OMAP which don't need it.
> 
> Again I think for the very limited validation this buys us - it's not worth it.
> 
>> And, how do you propose we solve the problem of deferred probing?
> 
> It seems to me that hwspin_lock_request_specific failures should be
> used by clients to defer their probing. Why wouldn't such a simple
> solution work?

Because the API always returns NULL on failures and there is no way for
the clients to figure out if the lock id passed is invalid or the bank
containing the lock is not registered. This was an old discussion on v4
[1], and you insisted that we don't change the return code convention on
the API. I had couple of patches on v5 that dealt with this, but even
that requires the list of registered devices.

regards
Suman

[1] https://patchwork.kernel.org/patch/3481331/
