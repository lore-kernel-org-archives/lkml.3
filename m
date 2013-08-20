Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab3HTTAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:00:40 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52062 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3HTTAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130820185043.GA24040@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
 <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
 <20130819184355.GA25362@redhat.com> <CALCETrU4gTfzcpeEo-X7o-yZefKiw9BVNKdcN4fThUeiuZtOOg@mail.gmail.com>
 <20130820185043.GA24040@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Aug 2013 12:00:18 -0700
Message-ID: <CALCETrUjohT2D=jtVQ9mnbeUr2oJ9VoN812PtQhaB2ZZ89isNA@mail.gmail.com>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/20, Andy Lutomirski wrote:
>>
>> On Mon, Aug 19, 2013 at 11:43 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 08/19, Andy Lutomirski wrote:
>> >>
>> >> On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >> >
>> >> > So do you think this change is fine or not (ignoring the fact it needs
>> >> > cleanups) ?
>> >>
>> >> I think that removing the CLONE_VM check is fine (although there are
>> >> some other ones that should probably be removed as well), but I'm not
>> >> sure if that check needs replacing with something else.
>> >
>> > OK, thanks... but I still can't understand.
>> >
>> > The patch I sent is equivalent to the new one below. I just tried to
>> > unify it with another check in do_fork().
>>
>> I was confused.
>
> Andy, I do not know how much you were confused, but I bet I am confused
> much more ;)
>
>> Currently (with or without your patch), vfork() followed by
>> unshare(CLONE_NEWUSER) or unshare(CLONE_NEWPID) will unshare the VM.
>
> Could you spell please?
>
> We never unshare the VM. CLONE_VM in sys_unshare() paths just means
> "fail unless ->mm is not shared".
>

Argh.  In that case this is probably buggy, and I am just as confused
as you.  This stuff is serious spaghetti code.

sys_unshare will see CLONE_NEWPID or CLONE_NEWUSER and set
CLONE_THREAD.  Then it will see CLONE_THREAD and set CLONE_VM.  Then
check_unshare_flags will see CLONE_VM and fail if we just called
vfork.

Could this be made much more comprehensible by having a single list of
shareable things are allowed to be shared across namespaces and
enforcing the *same* list in clone and unshare?

--Andy



> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
