Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaEAU4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:56:52 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:48036 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaEAU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140501203910.GB25829@thunk.org>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
 <20140501192618.GA25829@thunk.org> <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com>
 <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com> <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com>
 <20140501203910.GB25829@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 13:56:29 -0700
Message-ID: <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com>
Subject: Re: random: Providing a seed value to VM guests
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 1:39 PM,  <tytso@mit.edu> wrote:
> On Thu, May 01, 2014 at 01:32:55PM -0700, Andy Lutomirski wrote:
>> On Thu, May 1, 2014 at 1:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > RDSEED is not synchronous.  It is, however, nonblocking.
>>
>> What I mean is: IIUC it's reasonable to call RDSEED a few times in a
>> loop and hope it works.  It makes no sense to do that with
>> /dev/random.
>
> RDSEED is allowed to return an error if there is insufficient entropy.
> So long as the caller understands that this is an emulated
> instruction, I don't see a problem.

What's the point?

I think this is too caught up in x86 architectural stuff.  As I see
it, the goal is to give guests a way to ask their hosts to give them,
immediately and synchronously, some bytes suitable for seeding an RNG.
 These bytes need not contain true entropy, because the host may not
be able to provide entropy an a timely manner.  The mechanism should
be usable extremely early after boot, it should be usable after a
guest reboot, and it should be reliable.  I think there's an added
benefit if all architectures can implement a semantically equivalent
function, even if the interface is completely different.

There's no need for anything new to provide asynchronous and-or very
slow true random data -- virtio-rng already exists. *

Emulating RDRAND for this purpose is a little weird because it's
normally available to user code and it has the flag indicating
failure.  We're also not going to want the guest kernel to access it
through the arch_get_random interface.

Even if we could emulate RDSEED effectively**, I don't really
understand what the guest is expected to do with it.  And I generally
dislike defining an interface with no known sensible users, because it
means that there's a good chance that the interface won't end up
working.

* I still don't know why it doesn't work for me.  I'll fiddle with it,
but I think that the right solution is to fix it for this purpose, not
to replace it.
** Doing this sensibly in the host will be awkward.  Is the host
supposed to use non-blocking reads of /dev/random?  Getting anything
remotely fair may be difficult.

>
>                                                 - Ted



-- 
Andy Lutomirski
AMA Capital Management, LLC
