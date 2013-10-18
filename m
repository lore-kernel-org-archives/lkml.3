Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3JRCZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 22:25:59 -0400
Received: from smtp105.biz.mail.ne1.yahoo.com ([98.138.207.12]:28343 "HELO
	smtp105.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755130Ab3JRCZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 22:25:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: j7DKxLEVM1li6byDowzn5i3quTUw4EQnKJvy9zqZhysgCrT
 KfRYRfa1IlMBCqAOGkzc8PRzu1QA_x4YkZPOgw4RYKf.bFKZp9HS8YGxfKwu
 XDe8HtSsDLrc4Lvc9x8JIDRpCqsIgoFEQW7udAi0nADUfUwB0bNyba6FBkbX
 bzlUtcx48wzZ4x_Wwun60FeEhfLuXuoPVA5nT6v3nt9GpU4C5qk0IqwnFaV4
 B.XkYC3DDvBSpQbEc.MdlTGkq14xMTS5ZXA2YxRNX9FV8qLA5Gd64r_isy6j
 o6sK57kpz_eMLzy00KWeVdjhRpd5INXhJYRB8R_KumYreGVqhoUBPCtZjuqp
 BovAq0jpCxTd9H1OuQs9m0ZdrBQqXwcdmLYBZwlEfhSyjUE9UZSQGdrSnqc1
 fav.GBRmUwI1B5TlmVjcoIsdQJHg47tLTSsQn932eardC7qSZXccRxe2vnHd
 kScv5KYCpysPoAsA9dnFhXNNx6buQvkkiLEuILvS8_RoN4X6zX3mJhlcD.5O
 g0efR8.pA5._XHDAuBSlZsen1kCXXIoch0iP.CErgWuY7wmzm
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.168.21.102 with )
        by smtp105.biz.mail.ne1.yahoo.com with SMTP; 17 Oct 2013 19:25:56 -0700 PDT
Message-ID: <52609C36.2040809@schaufler-ca.com>
Date: Thu, 17 Oct 2013 19:25:58 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        James Morris <james.l.morris@oracle.com>,
        James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
References: <20130920203556.GA8726@www.outflux.net>	<alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>	<alpine.LRH.2.02.1309241128430.3782@tundra.namei.org>	<CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>	<20131016151831.GE5186@outflux.net>	<201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp>	<525F083D.8060502@schaufler-ca.com> <CAGXu5jLSDynZ_XRZGZ+0uZTgtygO1n8+3rOnR+WonH5-tkui6A@mail.gmail.com>
In-Reply-To: <CAGXu5jLSDynZ_XRZGZ+0uZTgtygO1n8+3rOnR+WonH5-tkui6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 3:43 PM, Kees Cook wrote:
> On Wed, Oct 16, 2013 at 2:42 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 10/16/2013 1:47 PM, Tetsuo Handa wrote:
>>> Kees Cook wrote:
>>>> Any update on this? It'd be nice to have it in linux-next.
>>> What was the conclusion at LSS about multiple concurrent LSM support?
>>> If we agreed to merge multiple concurrent LSM support, there will be nothing to
>>> prevent this module from merging.
>>>
>> Yeah.
> The discussion at LSS basically centered around the catch-22 of not
> being able to stack, and not having anything to stack (since Yama got
> an hard-coded exception). So I sent this LSM as one I'd been waiting
> for stacking on. Essentially, I'm breaking the catch-22 by sending
> this. I'd like it to get into the tree so we don't have a catch-22
> about stacking any more. :)
>
>> The conclusion was that it needs to be staged because it's
>> too much to swallow all at once. I can see that. It's going
>> to be a lot of work to rearrange and rebase. That's a chunk
>> of time I don't expect to have for a while. It looks good
>> to happen, but don't hold supper for me.
> Do you want me to take a stab at it? It sounds like it was desirable
> to cut the current series into two halves? The core changes first, and
> the userspace interface changes next?

My read on it was a three phased approach:

First, move the cap "module" checks out of the other modules
and directly into security.c. There would be no "default" module.
If another module is loaded, call the hook it defines if the cap
check passes. Add /sys/kernel/security/lsm to make it easy to
find out what module (if any) is active.

Second, allow more than one LSM to get called if so requested.
Call them all, and return the error code of the last failure.
Refuse to load more than one module that uses an exclusive feature;
netlabel, secmark or XFRM.

Finally, put in all the gimmicks to decide who gets which of the
networking facilities.

Yes, If you've got the cycles to work with it I'd be happy for the help.


>
> -Kees
>

