Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3HTQnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:43:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52854 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3HTQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:43:41 -0400
Message-ID: <52139C92.6000203@redhat.com>
Date: Tue, 20 Aug 2013 18:42:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Christian Ehrhardt <lk@c--e.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Fix lapic time counter read for periodic mode
References: <20121111122528.GC19718@lisa.in-ulm.de> <20121112213237.GA31377@amt.cnet> <20121113075254.GA15071@lisa.in-ulm.de> <20121113204039.GA22112@amt.cnet>
In-Reply-To: <20121113204039.GA22112@amt.cnet>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/11/2012 21:40, Marcelo Tosatti ha scritto:
> On Tue, Nov 13, 2012 at 08:52:54AM +0100, Christian Ehrhardt wrote:
>> > 
>> > Hi,
>> > 
>> > thanks for your reply.
>> > 
>> > On Mon, Nov 12, 2012 at 07:32:37PM -0200, Marcelo Tosatti wrote:
>>>> > > > there is a bug in the emulation of the lapic time counter. In particular
>>>> > > > what we are seeing is that the time counter of a periodic lapic timer
>>>> > > > in the guest reads as zero 99% of the time. The patch below fixes that.
>>>> > > > 
>>>> > > > The emulation of the lapic timer is done with the help of a hires
>>>> > > > timer that expires with the same frequency as the lapic counter.
>>>> > > > New expiration times for a periodic timer are calculated incrementally
>>>> > > > based on the last scheduled expiration time. This ensures long term
>>>> > > > accuracy of the emulated timer close to that of the underlying clock.
>>>> > > > 
>>>> > > > The actual value of the lapic time counter is calculated from the
>>>> > > > real time difference between current time and scheduled expiration time
>>>> > > > of the hires timer. If this difference is negative, the hires timer
>>>> > > > expired. For oneshot mode this is correctly translated into a zero value
>>>> > > > for the time counter. However, in periodic mode we must use the negative
>>>> > > > difference unmodified.
>>>> > > > 
>>>> > > >      regards   Christian
>>>> > > > 
>>>> > > > Fix lapic time counter read for periodic mode.
>>> > > 
>>> > > In periodic mode the hrtimer is rearmed once expired, see
>>> > > apic_timer_fn. So _get_remaining should return proper value
>>> > > even if the guest is not able to process timer interrupts. 
>>> > > 
>>> > > Can you describe your specific scenario in more detail?
>> > 
>> > In my specific case, the host is admittedly somewhat special as it
>> > already is a rehosted version of linux, i.e. not running directly on
>> > native hardware. It is still unclear if the host has sufficiently accurate
>> > timer interrupts. This is most likely part of the problems we are seeing.
>> > 
>> > However, AFAICS apic_timer_fn is only called once per jiffy (at least in
>> > some configurations). In particular, it is not called by
>> > hrtimer_get_remaining. Thus depending on the frequency of the LAPIC timer
>> > in the guest there might _several_ iterations that are missed. This can
>> > probably be mitigated by a hires timer interrupts. However, I think
>> > the problem is still there even in that case.
>> > 
>> > Additionally, the behaviour that I want to establish matches that of the
>> > PIT timer (in a not completely obvious way, though).
>> > 
>> > Having said that the proposed patch in my first mail is incomplete, as
>> > the mod_64 does not work correctly for negative values. A fixed version
>> > is below.
>> > 
>> >      regards     Christian
>> > 
>> > Signed-off-by: Christian Ehrhardt <lk@c--e.de>
> Alright. Please add a comment from the LAPIC documentation describing
> this behaviour (and a nice changelog). Thanks.
> 

Christian, did you ever resubmit the patch?

Paolo
