Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaJDJoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 05:44:08 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:56904 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaJDJoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 05:44:06 -0400
Message-ID: <542FC15D.3070503@kernel.org>
Date: Sat, 04 Oct 2014 10:43:57 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Michael Welling <mwelling@ieee.org>, Felipe Balbi <balbi@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org,
        pmeerw@pmeerw.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
References: <20140925221619.GA10644@saruman> <20140927041959.GA28445@saruman> <20140929140227.GD32403@saruman> <20140929183856.GA11871@sysresccd> <20140929185325.GA1939@saruman> <20140929223833.GA13111@sysresccd> <20140929224638.GA21681@saruman> <20140929234159.GB13111@sysresccd> <20140930212204.GC13806@saruman> <20141002180553.GI7933@saruman> <20141004031721.GA2846@deathray>
In-Reply-To: <20141004031721.GA2846@deathray>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/14 04:17, Michael Welling wrote:
> On Thu, Oct 02, 2014 at 01:05:53PM -0500, Felipe Balbi wrote:
>> Hi,
>>
>> On Tue, Sep 30, 2014 at 04:22:04PM -0500, Felipe Balbi wrote:
>>> On Mon, Sep 29, 2014 at 06:41:59PM -0500, Michael Welling wrote:
>>>> On Mon, Sep 29, 2014 at 05:46:38PM -0500, Felipe Balbi wrote:
>>>>> Hi,
>>>>>
>>>>> On Mon, Sep 29, 2014 at 05:38:33PM -0500, Michael Welling wrote:
>>>>>>>>> Alright, this is already ridiculous. Andrew, if I resend the patch can
>>>>>>>>> you apply it since maintainer has been ignoring this thread anyway ?
>>>>>>>>>
>>>>>>>>
>>>>>>>> Do you reall think this is the best way to approach this?
>>>>>>>
>>>>>>> when maintainer doesn't respond for weeks, yeah! Sure it is.
>>>>>>>
>>>>>>>> Perhaps it would be better to explain what each field of the
>>>>>>>> configuration register does and then we can move on.
>>>>>>>
>>>>>>> perhaps Jonathan could tell me exactly what he wants because I can't
>>>>>>> handle back-and-forth anymore. Specially when he complains about stuff
>>>>>>> he asked me to modify himself.
>>>>>>>
>>>>>>>> In particular the OPT3001_CONFIGURATION_L field needs to be explained
>>>>>>>> such that the ABI can be properly applied.
>>>>>>>>
>>>>>>>> Looking at the docs for the Windows demo program the field is associated
>>>>>>>> with a latch configuration. What does this bit field actually do?
>>>>>>
>>>>>> Still no technical information. Without all the facts how can you expect
>>>>>> him to tell you what he wants?
>>>>>
>>>>> yeah, because clearly he doesn't know himself, right ?
>>>>
>>>> Could you explain how it works to me then?
>>>
>>> checking how much of the docs I can expose now, gimme a couple days.
>>
>> alright, here's a snippet of what's on preliminary docs:
>>
Firstly, thanks Felipe for going through the process to get permission
to release the snippets.  I know this can be a real pain to do.
> 
> Firstly, there is logical error in the latest code.
> The hysteresis setting is 0 not 1.
> 
> +       if (opt->hysteresis)
> +               reg |= OPT3001_CONFIGURATION_L;
> +       else
> +               reg &= ~OPT3001_CONFIGURATION_L;
> 
> 
>> Latch field (read or write).
>> The latch field controls the functionality of the interrupt reporting
>> mechanisms: the INT pin, the flag high field (FH), and flag low field (FL).
>> This bit selects the reporting style between a latched window-style comparison
>> and a transparent hysteresis-style comparison.
>>
>> 0 = The device functions in transparent hysteresis-style comparison operation,
>> where the three interrupt reporting mechanisms directly reflect the comparison
>> of the result register with the high- and low-limit registers with no
>> user-controlled clearing event. See the Interrupt Operation, INT Pin, and
>> Interrupt Reporting Mechanisms section for further details.
>>
>> 1 = The device functions in latched window-style comparison operation, latching
>> the interrupt reporting mechanisms until a user-controlled clearing event.
>>
> 
> How is the interrupt cleared in mode 1 in the latest version of your
> code?
> 
>> [...]
>>
>> 7.4.2.2 Transparent Hysteresis-Style Comparison Mode
>> The transparent hysteresis-style comparison mode is typically used when a
>> single digital signal is desired that indicates whether the input light is
>> higher than or lower than a light level of interest. If the result register is
>> higher than the high-limit register for a consecutive number of events set by
>> the fault count field, the INT line is set to active, the flag high field is
>> set to 1, and the flag low field is set to 0. If the result register is lower
>> than the lowlimit register for a consecutive number of events set by the fault
>> count field, the INT line is set to inactive, the flag low field is set to 1,
>> and the flag high field is set to 0. The INT pin and flag high and flag low
>> fields do not change state with configuration reads and writes. The INT pin and
>> flag fields continually report the appropriate comparison of the light to the
>> low-limit and high-limit registers. The device does not respond to the SMBus
>> alert response protocol while in either of the two transparent comparison modes
>> (configuration register, latch field = 0).
>>
> 
> The ABI confusion starts here.
> 
> You are dealing with a mode enable and IIO_EV_INFO_HYSTERESIS is associated
> with a the hysteresis level of a threshold event.
> 
> http://lxr.free-electrons.com/source/Documentation/ABI/testing/sysfs-bus-iio#L605
> 
> You are going to have abstract the register access to conform to the ABI or add
> to the ABI as Jonathan suggests.

Hysteresis in IIO is the equivalent of the action of a Schmitt trigger
Clearly there are other more complex forms of hysteresis, though a
purely temporal one is an unusual use of the term.

As I read this description what we have here corresponds to
*_period though that ABI requires the units to be seconds rather
than samples hence a conversion will be necessary.

I guess that the OPT3001_CONFIGURATION_FC_MASK relates to this
fault count? Hence your *_period controls IIO_EV_INFO_PERIOD
will presumably write that.

Michael has noted the other complexity above.  In non hysteresis
mode we have a conventional interrupt that can be cleared one
the driver has dealt with it. That simple interrupt corresponds
to a period of 0 (though that might also be a valid value for your
fault count field).

For these others cases that 'interrupt' line has become a simple
indicator of state. What state is it in if the value is between the
two thresholds?

Anyhow, you handle this by triggering on either rising or falling edge,
thus catching any change of state but not causing an interrupt storm.
This works in most cases but would it not miss a change of state from
initially between the thresholds to then being outside of them?
Perhaps I'm missing something here.

Thanks,

Jonathan



> 
>> -- 
>> balbi
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
