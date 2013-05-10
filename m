Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3EJAY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:24:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35159 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab3EJAYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:24:25 -0400
Message-ID: <518C3CE9.1010603@ti.com>
Date: Thu, 9 May 2013 19:18:49 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Green <andy.green@linaro.org>
Subject: Re: [RFC 2/3] mailbox: Introduce a new common API
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com> <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org> <51847070.8040400@ti.com> <CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com> <518840A2.5000205@ti.com> <CAJe_ZhedTM_wU7NGH_QRrL=O3JSYjt9ENDLYpOEQNSX3f7OgBA@mail.gmail.com> <518976B9.2030605@ti.com> <CAJe_ZhfpLQzDBSx=2VbD3W-499-g1JOovGDuFwxkE-Cq=HQDww@mail.gmail.com> <518AFB1F.7010409@ti.com> <CAJe_ZheEZo7Akri40ixBhWzeefABxiJXG1Juc4zQOPNQqyahUw@mail.gmail.com>
In-Reply-To: <CAJe_ZheEZo7Akri40ixBhWzeefABxiJXG1Juc4zQOPNQqyahUw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,
>
> On 9 May 2013 06:55, Suman Anna <s-anna@ti.com> wrote:
> 
>>> so it can't be driven by the controller. We could make it a Kconfig option.
>>> What do you suggest?
>>
>> I am saying controller/link because they are the ones that knows how the
>> physical transport is, and it may vary from one to another. I would
>> think that the client dependencies would become a subset of this.
>> Kconfig option is fine, but we have to think about the best way of
>> representing it from a multi-platform kernel support perspective.
>>
> Actually it has more to do with clients and less with multiplatform.
> Even on single platform the client that needs biggest buffer will
> rule. Ditto on multi-platform.
> Anyways I get your idea. I'll put a note there to revisit once number
> of active clients increase on the platform.

OK thanks.

>>>> IMHO. It's calling ipc_links_register twice on the same controller. Idea
>>>> was that the API would distinguish different controllers, not the same
>>>> one. Also, see the above example if you were to treat a link as Rx or Tx
>>>> only (functional behavior differences even though the link is exactly
>>>> the same type).
>>>>
>>> Why is calling ipc_links_register() twice, for a controller with 2
>>> classes of links, a problem ?
>>
>> It will be inelegant, once you start maintaining the list of
>> ipc_controllers in the core code. You would have to search all the
>> controllers in the list with the matching name, and their links. You
>> will need to define multiple controller specific controller structures
>> and copy most of the elements from the actual h/w device into the
>> containing ipc_controller definition. As you said, the clients deal with
>> the links themselves, so making the ops part of the ipc_link definition
>> makes it easier on the controller implementations. You are anyway
>> caching the ops in ipc_chan (per link) and that is what you are using in
>> the core code. Majority of the time, you would be using the same ops for
>> all the links, but this gives the flexibility to links. You can avoid
>> having multiple controller instance denoting the h/w block, just because
>> of the difference in links behavior.
>>
> I don't see it as an issue, it's just how the code is designed on the
> principle that the API works only on links, not controllers. Let us
> wait for the driver of such a controller to show up. It should be easy
> to change if we see the need.

OK fine, I brought it up since we are defining the API, and defining it
the first time with flexibility eliminates the need later on.

> 
>>>
>>> And, No, the API need not know if the link is "RX" or "TX", which is
>>> purely a logical function.
>>>
>>> Please do tell me which controller physically limits its links to do
>>> only "RX" or only "TX"?  It's just the platform's firmware that
>>> dictates who sends and who receives on which link, thereby giving the
>>> illusion of a link being a "RX" or "TX" capable only.
>>> Even if some h/w limits do exist on links of some controller, still
>>> the API shouldn't try to discern a "RX" from a "TX" link. When a
>>> client knows which link to open, it will also know if it should read
>>> or write to it - this assumption already holds true. If the client
>>> writes on a link that it's supposed to listen to remote on, no amount
>>> of policing by the API could help.
>>>
>>> Even if the API tries to differentiate "RX" and "TX" links, the
>>> knowledge must come from a client (it's driven by the protocol on the
>>> platform), and not the controller because each of its links are
>>> physically equally capable to do RX or TX on each end.
>>
>> The API never differentiates, but the controller implementation has to.
>> From a controller driver implementation perspective, you still have to
>> make sure that no client is calling an op on which it is not supposed
>> to. When you have a mixture like this, a common code would include some
>> dead paths for certain links.
>>
> No, please. The controller driver should not implement any policy (of
> allowing/disallowing requests). It should simply try to do as
> directed. If the client screwed up even after getting info from
> platform_data/DT, let it suffer.

This would be the same as a client trying to misconfigure a link, you
cannot blame on a client screw up. The controller driver has to take
care of what it ought to check for in the startup.

> 
>>>>> Yes, I have 2 types of controllers and I already thought about
>>>>> multiple controllers in a platform.
>>>>>  What do you expect to do in controller startup/shutdown? Since the
>>>>> API works on individual links, not the controllers, when would it call
>>>>> controller_start() and controller_shutdown()?  The ipc_link's
>>>>> startup/shutdown are already non-atomic, if the controller needs any
>>>>> setup it could do it in the first link's startup and teardown in the
>>>>> last link's shutdown. Not to forget the resources lke IRQ are usually
>>>>> per Link which should be acquired/released upon link's use/idle.
>>>>>  While writing the OMAP2 controller driver, did I miss any controller
>>>>> startup/shutdown ?
>>>>
>>>> It just delineates the code better, and has flexibility later on to
>>>> extend any controller ops or exposing new controller-specific API. The
>>>> controller start and stop will be called in the same function as
>>>> ipc_request_channel.
>>>>
>>> Already one call ipc_link_ops.startup() reaches the controller upon
>>> ipc_request_channel.
>>>
>>> Do you mean ?
>>>        ipc_con_ops.startup();
>>>        ipc_link_ops.startup();
>>
>> Yes.
>>
> And let the controller startup()/shutdown() upon every
> link_request/release? 

Yes, and the controller driver can take care of any ref-counting or
whatever other logic it needs to maintain. You see this outside in the
previous mailbox code, but that is not the responsibility of the core code.

> 
> BTW, I have seen my 2 controllers, OMAP, PL320 and read the dbx500
> driver. Unsurprisingly none of these have any use for what you call a
> special ipc_con_ops.startup().  Lets say if the call were there, what
> would the OMAP put in it?

Enabling the clock for the device. The clock is for the entire IP, a
link has no power/clock dependencies.

> 
>>>> Yeah, the pm_runtime_enable cannot be called twice when mailbox is
>>>> invoked from multiple clients on separate links, so there has to a
>>>> controller-level logic/ref-counting for that. The clocking for us is on
>>>> the controller.
>>>>
>>> No.  You could call pm_runtime_enable/disable any number of times as
>>> long as they are balanced. The core does refcounting.
>>
>> Exactly, as long as they are balanced. I have two clients dealing with
>> two remotes (using two links) so pm_runtime_enable on the h/w block
>> needs to be called only when the first one comes in.
>>
> Actually you just gave another reason why the API messing around with
> controller's power state is a bad idea.

Where do you expect to power up the device (obviously this depends on
the SoC, and its functional purpose)?

> See how mailbox_startup() tries to balance mbox->ops->startup() and
> mailbox_fini() the mbox->ops->shutdown()  That's very fragile and the
> cause of imbalance between rpm enable/disable, unless your clients are
> buggy.

Yeah, it is kinda messed up in the existing code, the startup defined
there is really for the controller and not the link, and that's why you
see all the ref-counting balancing logic. The rpm enable/disable being
called is on the controller's dev, not the link's dev - maybe that's
what confused you.

regards
Suman

