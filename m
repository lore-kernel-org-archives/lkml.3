Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaAHHaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:30:03 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46544 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaAHH3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:29:55 -0500
MIME-Version: 1.0
In-Reply-To: <52CB1EB2.60705@wwwdotorg.org>
References: <CAGHPBZogJzOUTM=WooJmNd92=QCivWa9W+c9Co1NJd-sgRTB1A@mail.gmail.com>
	<52CB1EB2.60705@wwwdotorg.org>
Date: Wed, 8 Jan 2014 15:29:54 +0800
Message-ID: <CAGHPBZq7T_467p+8srLFL5Mj9zvdsK1HVXuJT1tFgKCyfK5hug@mail.gmail.com>
Subject: Re: Confusion about Pinctrl and GPIO
From: Rongrong Cao <caorr1980@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,
Thank you very much!
I understood now!

2014/1/7 Stephen Warren <swarren@wwwdotorg.org>:
> On 12/25/2013 10:18 PM, 曹荣荣 wrote:
>
>> I noticed that Stephen<swarren@nvidia.com> submitted a patch for pinctrl:
>> http://www.gossamer-threads.com/lists/linux/kernel/1500890?do=post_view_threaded
>>
>> In this patch, Stephen said, "When an SoC muxes pins in a group, it's
>> quite possible for the group to contain e.g. 6 pins, but only 4 of
>> them actually be needed by the HW module that's mux'd to them. In this
>> case, the other 2 pins could be used as GPIOs. However, pinctrl marks
>> all the pins within the group as in-use by the selected mux function.
>> To allow the expected gpiolib interaction, separate the concepts of
>> pin ownership into two parts: One for the mux function and one for
>> GPIO usage. Finally, allow those two ownerships to exist in parallel.
>> "
>>
>> I agree that gpiolib should be able to use the two idle pins as GPIO,
>> but after apply this patch, gpiolib can also request the 4 pins used
>> by HW module succesfully, and this will override the settings of the 4
>> pins for HW module.
>
> Yes, that's true.
>
> The solution is: don't do that.
>
>> Let me talk again about the example described by Stephen. If actually
>> only 4 pins of the group which contains 6 pins are needed by HW
>> module, then why does the group be defined to contain 6 pins? I think
>> the group should be defined only containing 4 pins rather than 6 pins,
>> then the other 2 idle pins can be used for any other purpose.
>
> It all depends on what you mean by group...
>
> A lot of HW has a mux setting per pin. In this case, it would make sense
> for the pinctrl driver to expose a separate group for each pin, and for
> the pinctrl mapping table (or DT content) to contain an entry for each
> individual pin setting that pin to whatever mux function was relevant.
>
> So in this case, yes, it'd make sense in most cases to disallow pins
> with a defined/selected mux setting from being used as a GPIO. However,
> even in this case, we can't ban dual mux/GPIO usage completely, since
> e.g. an I2C driver might want the I2C HW module to drive the pins most
> of the time, but still need to acquire the pins as GPIO to implement
> some kind of manual bit-banging e.g. to implement a "bus unstick" algorithm.
>
> Some other HW has mux settings that affect multiple pins at once. Tegra
> is an example. In this case, there's a single register bit that defines
> the mux functions for e.g. 6 pins. In this case, there *must* be a
> single pinctrl group definition that encompasses all those 6 pins, since
> that's how the HW works. However, the GPIO-vs-non-GPIO setting on Tegra
> at least is still per pin, hence the need for the patch of mine that you
> mentioned above.
>
> Finally, some people want to use pinctrl groups to represent something
> higher level than HW that has a mux bit for a group of pins rather than
> per-pin. In that case, you also may need GPIO/mux sharing of a pin, for
> similar reasons to the case where the HW muxing really does operate in
> groups.
