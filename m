Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaHAJwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:52:34 -0400
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:49238
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaHAJwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:52:33 -0400
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org> <20140731143538.GI11610@cbox> <87mwbpimgz.fsf@linaro.org> <20140731163805.GK11610@cbox> <CAFEAcA91efUg3MVpLScNBkxZSEgDP0zNnmxxr055fAz5=vDCoA@mail.gmail.com> <20140731165006.GL11610@cbox>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo regs
Date: Fri, 01 Aug 2014 10:48:36 +0100
In-reply-to: <20140731165006.GL11610@cbox>
Message-ID: <87egx0ilkg.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoffer Dall writes:

> On Thu, Jul 31, 2014 at 05:45:28PM +0100, Peter Maydell wrote:
>> On 31 July 2014 17:38, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> >> > If we are not complaining when setting the pause value to false if it
>> >> > was true before, then we probably also need to wake up the thread in
>> >> > case this is called from another thread, right?
>> >> >
>> >> > or perhaps we should just return an error if you're trying to un-pause a
>> >> > CPU through this interface, hmmmm.
>> >>
>> >> Wouldn't it be an error to mess with any register when the system is not
>> >> in a quiescent state? I was assuming that the wake state is dealt with
>> >> when the run loop finally restarts.
>> >>
>> >
>> > The ABI doesn't really define it as an error (the ABI doesn't enforce
>> > anything right now) so the question is, does it ever make sense to clear
>> > the pause flag through this ioctl?  If not, I think we should just err
>> > on the side of caution and specify in the docs that this is not
>> > supported and return an error.
>> 
>> Consider the case where the reset state of the system is
>> "CPU 0 running, CPUs 1..N stopped", and we're doing an
>> incoming migration to a state where all CPUs are running.
>> In that case we'll be using this ioctl to clear the pause flag,
>> right? (We'll also obviously need to set the PC and other
>> register state correctly before resuming the guest.)
>> 
> Doh, you're right, I somehow had it in my mind that when you send the
> thread a signal, the pause flag would be cleared, but that goes against
> the whole idea of a CPU being turned off for KVM.
>
> But wouldn't we then have to also wake up the thread when clearing the
> pause flag?  It feels strange that the ioctl can clear the pause flag,
> but keep the thread on a wake-queue, and then userspace has to send the
> thread a signal of some sort to wake it up?
<snip>

Isn't the vCPU off the wait-queue by definition if the ioctl exits and
you go through the KVM_SET_ONE_REG stuff?

Once you re-enter the KVM_RUN ioctl it sees the pause_flag as cleared
and falls straight through into kvm_guest_enter() otherwise it will
again wait on wait_event_interruptible(*wq, !vcpu->arch.pause).

-- 
Alex Bennée
