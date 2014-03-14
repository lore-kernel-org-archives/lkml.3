Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaCNX6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:58:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53425 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770AbaCNX6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:58:31 -0400
Message-ID: <53239789.40600@ti.com>
Date: Fri, 14 Mar 2014 18:58:01 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 0/7] omap hwspinlock dt support
References: <1389658764-39199-1-git-send-email-s-anna@ti.com> <52F9282B.5000702@ti.com> <530B8C00.8020001@ti.com> <CAK=WgbZp_RQPCeZJyMRkNTQxaJsnGZ3DnjhSkYYR_-PAE_Kp4g@mail.gmail.com>
In-Reply-To: <CAK=WgbZp_RQPCeZJyMRkNTQxaJsnGZ3DnjhSkYYR_-PAE_Kp4g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 03/14/2014 03:10 PM, Ohad Ben-Cohen wrote:
> Hi Suman, Mark,
>
> On Mon, Feb 24, 2014 at 8:14 PM, Suman Anna <s-anna@ti.com> wrote:
>> Mark, Ohad,
> ...
>> Gentle reminder, can you provide your acks/comments?
>
> Sorry for the late jump in.
>
> I have a few comments:

Thanks for the comments. It probably covers few topics that are slightly 
beyond the scope of the series, but nevertheless are good discussion 
points for finalizing the series.

> - Hardware spinlocks must have global and system-wide id numbers;
> these numbers cannot be maintained internally by the Linux Kernel.
> Think of an SoC with several asynchronous heterogeneous processors,
> each of which is running a different OS, and they all need to use a
> specific hardware spinlock in order to share some resource. For that
> to happen, every hwlock must have a predefined and deterministic id
> number which is global in the system. We can't have those id numbers
> be relative to an hwlock "controller", and we can't have two hwlock
> "controllers" share the same id numbers.

The series doesn't change the semantics of hwspinlock registration or 
adds a new OF controller registration function. Implementations would 
still need to register a controller using a base_id and number of locks. 
The series rather adds a DT-friendly function _ONLY_ for requesting a 
specific hwlock, and there are no restrictions on the args specifier 
being relative id numbers. Though this is what the simple default xlate 
helper does (most common usage), the added xlate ops and #hwlock-cells 
should allow individual implementation drivers to adjust any variations, 
and return a relative lock w.r.t its registered base_id, as this is how 
a lock gets registered in the first place.

>
> - I suspect the simplest and most straight forward way to achieve this
> is by (a) bringing back the concept of the base_id property, and

I actually started out this series with the base_id property, and 
dropped it in v3 based on comments looking at it from the 
request-specific-lock semantics with DT. That said, the drivers still 
need to manage a 'base_id' needed for registration when they get probed 
for multiple controllers. Getting the base_id from DT _may_ be useful 
just for registration purposes, but for requesting a hwlock, a 
controller phandle and an implementation defined args-specifier should 
suffice IMHO.


(b)
> letting the global hwlock id be the DT identifier (plus the base_id)
> and then providing it directly to the drivers when needed.The latter
> is required in order to support dynamically allocation of hwlocks, in
> which case Linux must know the global system-wide id number, and then
> share it with the other asynchronous OSes via some IPC.

Each lock still retains a global lock id value, and you can retrieve it 
using the existing hwspin_lock_get_id(). Why is the latter required for 
dynamic allocation, isn't it the other way around, allocate a lock, and 
you will be able to get the lock id. If wanting to request a specific 
lock received across, the regular hwspin_lock_request_specific should be 
used.

>
> - If we feel there's no way any system is going to have more than a
> single hwlock controller, then we can live without a base_id property,
> but then this needs to be clearly documented and prohibited. Today
> both the hwlock DT representation, and the coupled kernel code,
> implicitly allow this anomaly to exist.

I haven't removed the concept of base_id, it is just not defined in the 
DT-bindings, and am currently expecting the drivers to manage it and use 
it for registration.

>
> - Hwlock controller nodes should have a list of reserved locks (those
> locks for which other nodes have a phandle+identifier pointing at) to
> prevent those locks from being dynamically allocated by eager drivers.

The exact notion of informing the hwspinlock core about a list of 
reserved locks is missing at the moment (even in the non-DT case). I am 
not sure if this got lost during the conversion of the registration from 
per lock to registering a bank of locks together, or if it is implied by 
the base_id + num_locks combination. The core today supports requesting 
only those locks that were actually registered, whether allocating a 
free one dynamically or giving a specific one.

There were some slightly similar comments from Kumar earlier on the v2 
series, please see the thread in [1].

>
> Most of these issues were discussed Arnd, Benoit and myself back then,
> please see below:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-September/064265.html

Thanks for the pointer to the previous discussion, I wasn't aware of an 
earlier attempt. The primary approach on requesting locks is actually no 
different from what Arnd suggested originally.

regards
Suman

[1] http://marc.info/?l=linux-omap&m=138031002012191&w=2

