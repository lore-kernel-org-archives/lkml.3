Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaDESYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 14:24:48 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55285 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaDESYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 14:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <1396587632.2499.5.camel@buesod1.americas.hpqcorp.net>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
 <20140331170546.3b3e72f0.akpm@linux-foundation.org> <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net>
 <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
 <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com>
 <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>
 <20140401142947.927642a408d84df27d581e36@linux-foundation.org>
 <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>
 <20140401144801.603c288674ab8f417b42a043@linux-foundation.org>
 <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.com>
 <1396394931.25314.34.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rH+vfFzRrh35TETxjFU2HM0xnDQFweQ+Bfw20Pm2nL3g@mail.gmail.com>
 <1396484447.2953.1.camel@buesod1.americas.hpqcorp.net> <533DB03D.7010308@colorfullife.com>
 <1396554637.2550.11.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rT7WswD0LOxVeDDpae-Ahaz4wEcpE8HLmDwOBw598z8g@mail.gmail.com>
 <1396587632.2499.5.camel@buesod1.americas.hpqcorp.net>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 5 Apr 2014 14:24:26 -0400
Message-ID: <CAHGf_=pvN96SgLYdR3jPn8VaEfAjq-LX=r=PQRvPGqi6xFJoxQ@mail.gmail.com>
Subject: Re: [PATCH] ipc,shm: disable shmmax and shmall by default
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg Thelen <gthelen@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 1:00 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Thu, 2014-04-03 at 19:39 -0400, KOSAKI Motohiro wrote:
>> On Thu, Apr 3, 2014 at 3:50 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> > On Thu, 2014-04-03 at 21:02 +0200, Manfred Spraul wrote:
>> >> Hi Davidlohr,
>> >>
>> >> On 04/03/2014 02:20 AM, Davidlohr Bueso wrote:
>> >> > The default size for shmmax is, and always has been, 32Mb.
>> >> > Today, in the XXI century, it seems that this value is rather small,
>> >> > making users have to increase it via sysctl, which can cause
>> >> > unnecessary work and userspace application workarounds[1].
>> >> >
>> >> > Instead of choosing yet another arbitrary value, larger than 32Mb,
>> >> > this patch disables the use of both shmmax and shmall by default,
>> >> > allowing users to create segments of unlimited sizes. Users and
>> >> > applications that already explicitly set these values through sysctl
>> >> > are left untouched, and thus does not change any of the behavior.
>> >> >
>> >> > So a value of 0 bytes or pages, for shmmax and shmall, respectively,
>> >> > implies unlimited memory, as opposed to disabling sysv shared memory.
>> >> > This is safe as 0 cannot possibly be used previously as SHMMIN is
>> >> > hardcoded to 1 and cannot be modified.
>> >
>> >> Are we sure that no user space apps uses shmctl(IPC_INFO) and prints a
>> >> pretty error message if shmall is too small?
>> >> We would break these apps.
>> >
>> > Good point. 0 bytes/pages would definitely trigger an unexpected error
>> > message if users did this. But on the other hand I'm not sure this
>> > actually is a _real_ scenario, since upon overflow the value can still
>> > end up being 0, which is totally bogus and would cause the same
>> > breakage.
>> >
>> > So I see two possible workarounds:
>> > (i) Use ULONG_MAX for the shmmax default instead. This would make shmall
>> > default to 1152921504606846720 and 268435456, for 64 and 32bit systems,
>> > respectively.
>> >
>> > (ii) Keep the 0 bytes, but add a new a "transition" tunable that, if set
>> > (default off), would allow 0 bytes to be unlimited. With time, users
>> > could hopefully update their applications and we could eventually get
>> > rid of it. This _seems_ to be the less aggressive way to go.
>>
>> Do you mean
>>
>> set 0: IPC_INFO return shmmax = 0.
>> set 1: IPC_INFO return shmmax = ULONG_MAX.
>>
>> ?
>>
>> That makes sense.
>
> Well I was mostly referring to:
>
> set 0: leave things as there are now.
> set 1: this patch.

I don't recommend this approach because many user never switch 1 and
finally getting API fragmentation.


> I don't think it makes much sense to set unlimited for both 0 and
> ULONG_MAX, that would probably just create even more confusion.
>
> But then again, we shouldn't even care about breaking things with shmmax
> or shmall with 0 value, it just makes no sense from a user PoV. shmmax
> cannot be 0 unless there's an overflow, which voids any valid cases, and
> thus shmall cannot be 0 either as it would go against any values set for
> shmmax. I think it's safe to ignore this.

Agreed.
IMHO, until you find out any incompatibility issue of this, we don't
need the switch
because we can't make good workaround for that. I'd suggest to merge your patch
and see what happen.
