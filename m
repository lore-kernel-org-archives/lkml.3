Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3EQOJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:09:47 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51163 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3EQOJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:09:45 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Scott Wood <scottwood@freescale.com>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list\:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for !CONFIG_KVM
References: <20130321072955.GO3889@redhat.com> <87ppyshlq5.fsf@linaro.org>
	<1363891354.31522.17@snotra> <20130321191600.GG9382@redhat.com>
	<1363894393.31522.20@snotra> <20130321211736.GI9382@redhat.com>
	<CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com>
	<20130324140114.GV3889@redhat.com> <87txnz9o7n.fsf@linaro.org>
	<20130515225201.GA2341@somewhere> <20130517010442.GB12928@somewhere>
Date: Fri, 17 May 2013 07:09:42 -0700
In-Reply-To: <20130517010442.GB12928@somewhere> (Frederic Weisbecker's message
	of "Fri, 17 May 2013 03:04:43 +0200")
Message-ID: <871u95u28p.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Thu, May 16, 2013 at 12:52:03AM +0200, Frederic Weisbecker wrote:
>> On Mon, Mar 25, 2013 at 02:14:20PM -0700, Kevin Hilman wrote:
>> > Gleb Natapov <gleb@redhat.com> writes:
>> > 
>> > > On Sun, Mar 24, 2013 at 02:44:26PM +0100, Frederic Weisbecker wrote:
>> > >> 2013/3/21 Gleb Natapov <gleb@redhat.com>:
>> > >> > Isn't is simpler for kernel/context_tracking.c to define empty
>> > >> > __guest_enter()/__guest_exit() if !CONFIG_KVM.
>> > >> 
>> > >> That doesn't look right. Off-cases are usually handled from the
>> > >> headers, right? So that we avoid iffdeffery ugliness in core code.
>> > > Lets put it in linux/context_tracking.h header then.
>> > 
>> > Here's a version to do that.
>> > 
>> > Kevin
>> > 
>> > From d9d909394479dd7ff90b7bddb95a564945406719 Mon Sep 17 00:00:00 2001
>> > From: Kevin Hilman <khilman@linaro.org>
>> > Date: Mon, 25 Mar 2013 14:12:41 -0700
>> > Subject: [PATCH v2] ontext_tracking: fix !CONFIG_KVM compile: add stub guest
>> >  enter/exit
>> 
>> Sorry for my very delayed response...
>> 
>> > 
>> > When KVM is not enabled, or not available on a platform, the KVM
>> > headers should not be included.  Instead, just define stub
>> > __guest_[enter|exit] functions.
>> 
>> May be it would be cleaner to move guest_enter/exit definitions altogether
>> in linux/context_tracking.h
>> 
>> After all that's where the implementation mostly belong to.
>> 
>> Let me see if I can get that in shape.
>
> Does the following work for you?

Nope. 

Since it still includs kvm_host.h on non-KVM builds, there is potential
for problems.  For example, on ARM (v3.10-rc1 + this patch) has this
build error:

  CC      kernel/context_tracking.o
In file included from /work/kernel/linaro/nohz/arch/arm/include/asm/kvm_host.h:41:0,
                 from /work/kernel/linaro/nohz/include/linux/kvm_host.h:34,
                 from /work/kernel/linaro/nohz/kernel/context_tracking.c:18:
/work/kernel/linaro/nohz/arch/arm/include/asm/kvm_vgic.h:38:6: warning: "CONFIG_KVM_ARM_MAX_VCPUS" is not defined [-Wundef]
In file included from /work/kernel/linaro/nohz/arch/arm/include/asm/kvm_host.h:41:0,
                 from /work/kernel/linaro/nohz/include/linux/kvm_host.h:34,
                 from /work/kernel/linaro/nohz/kernel/context_tracking.c:18:
/work/kernel/linaro/nohz/arch/arm/include/asm/kvm_vgic.h:59:11: error: 'CONFIG_KVM_ARM_MAX_VCPUS' undeclared here (not in a function)

Kevin
