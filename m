Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3CPOjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 10:39:12 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56385 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755729Ab3CPOjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:39:10 -0400
Message-ID: <5144849A.8050907@metafoo.de>
Date: Sat, 16 Mar 2013 15:41:30 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [RFC: PATCH 2/2] iio: adc: exynos_adc: Handle timeout and race
 conditions
References: <1363364801-23684-1-git-send-email-ch.naveen@samsung.com>	<51439846.9090201@metafoo.de> <CAD=FV=V+-DwCjGoookySCazazBBYOoRO+=G5Q_WXAw+SrXNc-A@mail.gmail.com>
In-Reply-To: <CAD=FV=V+-DwCjGoookySCazazBBYOoRO+=G5Q_WXAw+SrXNc-A@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 01:37 AM, Doug Anderson wrote:
> On Fri, Mar 15, 2013 at 2:53 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> What exactly is the spinlock protecting against here? Concurrent runs of
>> exynos_adc_isr? This is probably not issue in the first place.
>>
>> What you want to protect against is that completion is completed between the
>> call to INIT_COMPLETION() and the start of a new conversion. So the sections
>> that need to be under the spinlock are the complete call here and the point
>> from INIT_COMPLETION until the transfer is started in exynos_read_raw(). Make
>> sure to use spin_lock_irq there.
> 
> ...and at that point I _think_ you won't also need the mutex.
> 
> A reasonable way to test to see if you've got this all correct would be to:
> 
> * Start two processes that are reading from different ADCs that will
> report very different values (maybe add a device tree node for adc1 or
> adc7 and use those since they're not really connected to
> thermistors?).
> 
> * Have your two processes read as fast as they can.  This could just
> be "while true; do cat /sys/class/hwmon/hwmon0/device/temp1_input;
> done"
> 
> * Decrease your timeout and maybe(?) sprinkle some random udelays in
> the irq handler so that the timeouts happen sometimes but not others.
> 
> * Periodically cancel one of the readers with Ctrl-C
> 
> If all is working well then you should always get back the right value
> from the right reader (and get no crashes).
> 


I think you still need the mutex for serialization, otherwise the requests
would just cancel each other out. Btw. what happens if you start a conversion
while another is still in progress? Is it possible to abort a conversion?

- Lars
