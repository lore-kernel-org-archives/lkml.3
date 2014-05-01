Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaEAVGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:06:36 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36957 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEAVGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:06:34 -0400
MIME-Version: 1.0
In-Reply-To: <5362B618.50602@zytor.com>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
 <20140501192618.GA25829@thunk.org> <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com>
 <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com> <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com>
 <20140501203910.GB25829@thunk.org> <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com>
 <5362B618.50602@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 14:06:13 -0700
Message-ID: <CALCETrXu_bFjemS3TZNDDes=cBgkUXtDH-6cA84JcNjD0AdZ7A@mail.gmail.com>
Subject: Re: random: Providing a seed value to VM guests
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 2:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/01/2014 01:56 PM, Andy Lutomirski wrote:
>>
>> Even if we could emulate RDSEED effectively**, I don't really
>> understand what the guest is expected to do with it.  And I generally
>> dislike defining an interface with no known sensible users, because it
>> means that there's a good chance that the interface won't end up
>> working.
>>
>> ** Doing this sensibly in the host will be awkward.  Is the host
>> supposed to use non-blocking reads of /dev/random?  Getting anything
>> remotely fair may be difficult.
>
> The host can use nonblocking reads of /dev/random.  Fairness would have
> to be implemented at the host level, but that is true for anything.
>

I still don't see the point.  What does this do better than virtio-rng?

The ASLR code doesn't even try to use RDSEED.  RDSEED is used in
add_interrupt_randomness, which should drain the host's /dev/random
even if it could, and it's used in init_std_data.  The logic there is:

                if (!arch_get_random_seed_long(&rv) &&
                    !arch_get_random_long(&rv))
                        rv = random_get_entropy();

I think this is better achieved by having the host try to supply the
highest quality data it can.

The third RDSEED use is arch_random_refill.  This purpose would be
much better served by the khwrng stuff and virtio-rng.

So I still claim that fancy emulated RDSEED support will have no users.

--Andy
