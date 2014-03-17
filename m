Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaCQXq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:46:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53946 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaCQXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:46:56 -0400
Message-ID: <53278950.5030905@ti.com>
Date: Mon, 17 Mar 2014 18:46:24 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 0/7] omap hwspinlock dt support
References: <1389658764-39199-1-git-send-email-s-anna@ti.com> <52F9282B.5000702@ti.com> <530B8C00.8020001@ti.com> <CAK=WgbZp_RQPCeZJyMRkNTQxaJsnGZ3DnjhSkYYR_-PAE_Kp4g@mail.gmail.com> <53239789.40600@ti.com> <CAK=WgbZCzA7JovSxnysHCQRZZWc3Z2j3AS8ekpM9fOZ160rmCA@mail.gmail.com> <532748B7.1080606@ti.com> <CAK=WgbYjtw+cxy5wX6pjK=Rpj6wOk6Cu+GrPuFN+sqtgDAY=_Q@mail.gmail.com>
In-Reply-To: <CAK=WgbYjtw+cxy5wX6pjK=Rpj6wOk6Cu+GrPuFN+sqtgDAY=_Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 03/17/2014 02:47 PM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Mon, Mar 17, 2014 at 9:10 PM, Suman Anna <s-anna@ti.com> wrote:
>> base_id would be a property (if added) of the hwspinlock controller node,
>> and from DT perspective, we will be using the phandle for the controller
>> anyway. So, using a base_id+specifier seems redundant, as the specifier is
>> already w.r.t a hwspinlock controller node.  It is best to leave the base_id
>> out, just use the specifier. This is pretty much the standard practice
>> (GPIOs, DMAs, etc all follow this).
> 
> Do you mean hwspin_lock_get_id() will return just the specifier
> instead of base_id+specifier? This is problematic, because Linux will
> not be able to communicate this lock id outside to a different core
> running a different OS: that OS will have no idea what hwlock
> controller this is relative to.

The behavior of hwspin_lock_get_id() is unchanged, so you will still get
the global lock id back. The hwspin_lock_request_specific() (note: not
the OF one) will also still be operating on the global lock id.

> 
>> Please see the comments from Mark regarding the same on an earlier version.
> 
> I think I understand and agree with Mark generally, but in this case,
> the hwlock id is not an implementation detail. Unlike GPIOs/DMAs, this
> id number is global and system-wide (Linux is just one component in
> the system, and must use the same predefined id numbers all other
> cores use, otherwise it will be impossible to use those hwlocks for
> multi-core synchronization).
> 
>> Yes, I agree this is an issue if we have to have the base_ids fixed per
>> controller.
> 
> Do you see any other way this could work if the base_ids were not
> predefined? Linux and some other core running a different OS must
> agree on the id numbers of the hardware locks we have in the system.

So far, we have not come across multiple controllers. I see your point,
and I think this also depends on the semantics of how you exchange the
lock id number. The agreement at the moment is on base_ids across
multiple SoC components. If the semantics involve exchanging the
controller instance, for example, then we might get away with it. But
that probably involves adding additional helpers to retrieve controller
instance in addition to lock number, or some other similar functions.
I can add back the hwlock-base-id binding to the controller node.

Mark, Kumar,
Do you have any issues adding back this element for registration purposes?

> 
>>> Before DT came along, early board code could have reserved specific
>>> hwspinlocks if needed. Now with DT, we should add the list of reserved
>>> locks to the controller node, in order to prevent them from being
>>> dynamically allocated by others.
>>
>>
>> But that strictly relied on the order of requests without any core changes
>> in the hwspinlock core, right.
> 
> I don't think so, you could request a specific lock by id number.

Sorry, I should have rephrased it better - by order, I meant the
inherent order between board early code and other drivers. With DT, we
cannot guarantee that right, as specific locks are requested from drivers.

> 
>> With DT, the early board code is much simplified. Looking at the same
>> scenario from DT case, it seems kinda redundant to specify a set of reserved
>> locks both in the controller node, as well as the respective client drivers,
>> as there is almost no platform data with DT. The only use case for DT client
>> nodes would be for requesting specific locks. I agree with the problem you
>> described, and I think it will require a different set of changes to the
>> core.
> 
> Exactly. The platform-specific hwspinlock driver will have to inform
> the core, upon registration, which of the locks are already reserved.
> In turn, the core will never provide them to clients that dynamically
> allocate an hwlock: they will be provided only to clients that ask for
> them specifically (using phandle+specifier).

Understood. And we may have to assign the client association with a lock
as well. These are core changes that were actually not needed in the
non-DT case due to the inherent order as stated above. So, are you
suggesting that we add one more property to the controller node to mark
which are reserved, or rely on constructing this through DT tree parsing?

regards
Suman
