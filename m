Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3FNPXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:23:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37475 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3FNPXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:23:47 -0400
Message-ID: <51BB357F.80406@wwwdotorg.org>
Date: Fri, 14 Jun 2013 09:23:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com> <51B75148.5080701@wwwdotorg.org> <CACRpkdYQSO0+9tQkS=df-kpL=XL+DpnY1ijp6_Zeg0MvmFujyw@mail.gmail.com> <20130612183345.GU8164@atomide.com> <51BA1E06.6020705@wwwdotorg.org> <20130614084644.GD20992@atomide.com>
In-Reply-To: <20130614084644.GD20992@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 02:46 AM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [130613 12:37]:
>> On 06/12/2013 12:33 PM, Tony Lindgren wrote:
>>> * Linus Walleij <linus.walleij@linaro.org> [130611 12:59]:
>>>> On Tue, Jun 11, 2013 at 6:33 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>>> On 06/11/2013 02:16 AM, Linus Walleij wrote:
>>>>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>>>>
>>>>>> In addition to the recently introduced pinctrl core
>>>>>> control, the PM runtime pin control for the OMAP platforms
>>>>>> require a fourth state in addtition to the default, idle and
>>>>>> sleep states already handled by the core: an explicit "active"
>>>>>> state. Let's introduce this to the core in addition to the
>>>>>> other states already defined.
>>>>>
>>>>> Surely "default" /is/ "active"? That's what it's meant so far.
>>>>
>>>> I thought so too, until Tony informed us that in the OMAP world
>>>> this state is not always the active one.
>>>>
>>>> But I don't know the exact reasons for.
>>>>
>>>> I guess that some "default" states on the OMAP may mean these
>>>> are configured as decoupled, inactive, until explicitly activated
>>>> or something like that.
>>>
>>> The main reason is that remuxing all the pins for a device for
>>> PM runtime suspend and resume is not necessary. Most pins are
>>> static and configured once during the consumer driver probe.
>>> And in most cases, remuxing only one pin for the rx line is
>>> needed. This is performance critical as it may need to be done
>>> constantly while entering and exiting idle, and remuxing all the
>>> pins is just a waste of cycles.
>>
>> Then isn't the correct solution to optimize the code that switches
>> between states, so that it only reprograms the pins/groups necessary?
>> Inventing extra states just to work around that issue seems quite wrong.
> 
> Hmm how would the pinctrl subsystem know which pins to reprogram and
> which ones are static?

Each state should list the desired configuration of all pins used by the
HW module. Any configuration that's identical between the old an new
state when pinctrl_select_state() executes is static, anything else is not.

>> So, I think you're relying on:
>>
>> default: Set up everything static.
>> active: flip just a few pins to active state.
>> idle: flip just a few pins to idle state.
>>
>> ... and assuming that the default->active or default->idle transitions
>> will not affect any pins that are used in default, but not used in
>> active/idle.
> 
> Yes except the default pins are not touched after probe at all.

>> However, that very specifically isn't the case; pinctrl drivers are
>> allowed to force unused pins back to some default unused state when the
>> pinctrl state that's being switched to doesn't mention them, and hence
>> this concept won't work in general.
> 
> We don't have any default state for pins for omaps at least and pinctrl
> single does not not set them to anything when disable is called unless
> function-off is specified.

But that's OMAP-specific. If the set of pinctrl states that the core PM
code operates on is documented as general policy, it has to work the
same everywhere.

> But even if the pinctrl driver does something to the pins in disable,
> that should work too. It's just an extra step between toggling between
> two named pin states.

If the "default" state says e.g. "set pin X to function A", and the
"idle" state doesn't say anything about pin X, when a switch from
default -> idle will simply program pin X back to its default state (if
the driver does that) and then not program it to anything else, since
the idle state doesn't say what to program it to.

As I said, this might work fine if the pinctrl driver doesn't do
anything in struct pinmux_ops .disable, but given that it's legal for
the driver to do so, relying on that won't work for all drivers, so some
alternative scheme of handling static pinmux configuration is needed.

>> Also, if default uses more pins that active, when you switch to active,
>> those pins won't be marked as owned any more, I think, so something else
>> could in theory grab them. At least, debugfs wouldn't be entirely
>> accurate any more.
> 
> I think you're misunderstanding. The default pins are held for as long
> as the device is loaded. We're not touching the default pins at all
> after probe. Active and idle pins are not subsets of default.

OK, then please provide an example of how this is represented.
