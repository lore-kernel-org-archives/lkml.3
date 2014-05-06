Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170AbaEFGj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:39:59 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:48866 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933953AbaEFGj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405052238230.980@knanqh.ubzr>
References: <CAPz6YkXsig6XornqoMyn5DtRd9NECyc+qgQo39RQK0sDeat34Q@mail.gmail.com>
 <alpine.LFD.2.11.1405052238230.980@knanqh.ubzr>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Mon, 5 May 2014 23:39:36 -0700
X-Google-Sender-Auth: wzCupQwkz4fmCmy-80h5IszxB6I
Message-ID: <CAPz6YkXFeoj5HyrpD3tETj+9mhesmvADNcxeQtMRhouWf3sXGg@mail.gmail.com>
Subject: Re: CPU performance counters not working on big.LITTLE switcher
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>, Olof <olofj@chromium.org>,
        Stephane Eranian <eranian@google.com>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 7:52 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Mon, 5 May 2014, Sonny Rao wrote:
>
>> Hi, we have the problem today that cpu based performance counters don't
>> work when we're using the big.LITTLE switcher on Exynos 5420, and it
>> doesn't look like code exists to deal with this in the switcher.
>>
>> As it stands right now, if you put an A-15 or A-7 PMU node into your
>> device-tree on an bl_switcher system it's very broken.  At the minimum, I
>> think it should disable performance counters until there's some kind of
>> proper implementation.
>>
>> I looked into trying to make this work, but it turned out to not be as
>> simple as just context switching counters from A-15 to A-7.  The biggest
>> problem is that the PMUs are not architecturally compatible.  There are
>> different events and differing numbers of counters on these two cores.
>>  There's also the tangential issue of representing this in the device tree,
>> but that's far less important.
>>
>> My guess as to how to fix this is to create an "architectural" PMU which
>> contains the intersection of the two performance monitor units with the
>> minimum number of counters supported by either core (which in this case
>> looks to be 4 on the A7).  However, I don't really have the bandwidth to
>> work on this at  the moment.  I was mostly wondering, have other people run
>> into this limitation and is there any sort of plan to work on it?
>
> The Linaro kernel release from a year ago or so contained a hack to make
> PMUs available and cope with the switcher.

Ok, any pointers?  Like I mentioned, if one enables the A15 Counters
with an upstream kernel that's using the switcher, I think things are
very broken, and since the switcher code is upstream, it seems like at
a minimum it would be good to deal with that somehow.  The big hammer
would be just to make hardware PMU support incompatible with the
switcher support, but maybe there are better solutions.

> However, the ultimate solution is to add multi-PMU support in a generic
> way to the kernel and let user space see both A15 and A7 counters.  It
> is then up to the analysis tools to consolidate (some of) them if
> wanted.  And this would work whether the switcher is used, or even when
> the scheduler has learned to do proper task placement for b.L systems
> where tasks may migrate across clusters.

How is that meant to work?  I think you'd need the generic perf-event
subsystem to properly support multiple CPU-type PMUs, which it
currently does not.  In the case of a system using the switcher, would
the events on a particular logical "cpu" just get inter-mingled from
the different cores?  I think it would be difficult to make sense of
data like that without extra information about when the logical cpu
switched from one type to the other.

> Someone at ARM indicated they'd be working on the multi-PMU support if I
> remember correctly.  For that reason, Linaro stopped maintaining the
> initial hack since it was a lot of work to keep it working on top of
> later kernels and a better solution was coming anyway.  I don't know
> what the status of that work is though.
>
>
> Nicolas
