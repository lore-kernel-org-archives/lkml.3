Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3EJKGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:06:16 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39128 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3EJKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:06:14 -0400
MIME-Version: 1.0
In-Reply-To: <518C3CE9.1010603@ti.com>
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
	<1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org>
	<51847070.8040400@ti.com>
	<CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com>
	<518840A2.5000205@ti.com>
	<CAJe_ZhedTM_wU7NGH_QRrL=O3JSYjt9ENDLYpOEQNSX3f7OgBA@mail.gmail.com>
	<518976B9.2030605@ti.com>
	<CAJe_ZhfpLQzDBSx=2VbD3W-499-g1JOovGDuFwxkE-Cq=HQDww@mail.gmail.com>
	<518AFB1F.7010409@ti.com>
	<CAJe_ZheEZo7Akri40ixBhWzeefABxiJXG1Juc4zQOPNQqyahUw@mail.gmail.com>
	<518C3CE9.1010603@ti.com>
Date: Fri, 10 May 2013 15:36:14 +0530
Message-ID: <CAJe_ZhfFs5svKPABHWdKA83+LhxA5+Q3LKuJyqyRj_4SMMm_hg@mail.gmail.com>
Subject: Re: [RFC 2/3] mailbox: Introduce a new common API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Green <andy.green@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Suman,

On 10 May 2013 05:48, Suman Anna <s-anna@ti.com> wrote:

>> No, please. The controller driver should not implement any policy (of
>> allowing/disallowing requests). It should simply try to do as
>> directed. If the client screwed up even after getting info from
>> platform_data/DT, let it suffer.
>
> This would be the same as a client trying to misconfigure a link, you
> cannot blame on a client screw up.
>
One kernel code should not suspect other kernel code's intentions. The
safety/security is in allowing only well written and trusted code
inside the kernel space.
If a client misconfigures a link, the best we could do is call it
buggy. BTW such a hell-bent client would rather screw up with a BUG(),
what do we do then?
So no please, I am not convinced the controller driver should have
anything to do with allow/disallow policy, or any policy at all.

>>>>>
>>>> Already one call ipc_link_ops.startup() reaches the controller upon
>>>> ipc_request_channel.
>>>>
>>>> Do you mean ?
>>>>        ipc_con_ops.startup();
>>>>        ipc_link_ops.startup();
>>>
>>> Yes.
>>>
>> And let the controller startup()/shutdown() upon every
>> link_request/release?
>
> Yes, and the controller driver can take care of any ref-counting or
> whatever other logic it needs to maintain. You see this outside in the
> previous mailbox code, but that is not the responsibility of the core code.
>
The pm_runtime imbalance that you mentioned is the result of OMAP's
API trying to do just that.

>>
>> BTW, I have seen my 2 controllers, OMAP, PL320 and read the dbx500
>> driver. Unsurprisingly none of these have any use for what you call a
>> special ipc_con_ops.startup().  Lets say if the call were there, what
>> would the OMAP put in it?
>
> Enabling the clock for the device. The clock is for the entire IP, a
> link has no power/clock dependencies.
>
OMAP controller driver doesn't do clocks.
It does do rpm though, which does a better job of what OMAP needs.
Please see how pm_runtime_xxx calls are made without worry at each
ipc_link_ops.startup/shutdown.

For controllers that do do clocks, having contiguous
        ipc_con_ops.startup();
        ipc_link_ops.startup();
doesn't save them any complexity. They still have to keep track of
first ipc_link_ops.startup() call in ipc_con_ops.startup() and last
ipc_link_ops.shutdown() call in ipc_con_ops.shutdown()
Which they could very well do in link_ops, if not rpm.

>>
>>>>> Yeah, the pm_runtime_enable cannot be called twice when mailbox is
>>>>> invoked from multiple clients on separate links, so there has to a
>>>>> controller-level logic/ref-counting for that. The clocking for us is on
>>>>> the controller.
>>>>>
>>>> No.  You could call pm_runtime_enable/disable any number of times as
>>>> long as they are balanced. The core does refcounting.
>>>
>>> Exactly, as long as they are balanced. I have two clients dealing with
>>> two remotes (using two links) so pm_runtime_enable on the h/w block
>>> needs to be called only when the first one comes in.
>>>
>> Actually you just gave another reason why the API messing around with
>> controller's power state is a bad idea.
>
> Where do you expect to power up the device (obviously this depends on
> the SoC, and its functional purpose)?
>
Use RPM.  Just like OMAP controller driver already does -
unconditionally call pm_runtime_get upon each link request and
pm_runtime_put upon each link release. Neither the controller nor the
API would have to do refcounting.  If rpm isn't supported, only then
the controller should do refcounting within linp_ops.startup/shutdown
(anyways you want the con_ops and link_ops to be always contiguous).


>> See how mailbox_startup() tries to balance mbox->ops->startup() and
>> mailbox_fini() the mbox->ops->shutdown()  That's very fragile and the
>> cause of imbalance between rpm enable/disable, unless your clients are
>> buggy.
>
> Yeah, it is kinda messed up in the existing code, the startup defined
> there is really for the controller and not the link, and that's why you
> see all the ref-counting balancing logic. The rpm enable/disable being
> called is on the controller's dev, not the link's dev - maybe that's
> what confused you.
>
I wrote the driver for this api, so I do realize the rpm is on
controller. Links are not devices anyways.

cheers,
jassi
