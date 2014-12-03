Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaLCTZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:25:32 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:61182 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:25:31 -0500
MIME-Version: 1.0
In-Reply-To: <20141203190045.GB32005@redhat.com>
References: <547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141203190045.GB32005@redhat.com>
Date: Wed, 3 Dec 2014 11:25:29 -0800
X-Google-Sender-Auth: GoqMWJnJ9-umPFWbq-UEN7v1DlY
Message-ID: <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 11:00 AM, Dave Jones <davej@redhat.com> wrote:
>
> So right after sending my last mail, I rebooted, and restarted the run
> on the same kernel again.
>
> As I was writing this mail, this happened.
>
> [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]
>
> and that's all that made it over the console. I couldn't log in via ssh,
> and thought "ah-ha, so it IS bad".  I walked over to reboot it, and
> found I could actually log in on the console. check out this dmesg..
>
> [  503.683055] Clocksource tsc unstable (delta = -95946009388 ns)
> [  503.692038] Switched to clocksource hpet
> [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]

Interesting. That whole NMI watchdog thing happens pretty much 22s
after the "TSC unstable" message.

Have you ever seen that TSC issue before? The watchdog relies on
comparing get_timestamp() differences, so if the timestamp was
incorrect...

Maybe that whole "clocksource_watchdog()" is bogus. That delta is
about 96 seconds, sounds very odd. I'm not seeing how the TSC could
actually scew up that badly, so I'd almost be more likely to blame the
"watchdog" clock.

I don't know. This piece of code:

        delta = clocksource_delta(wdnow, cs->wd_last, watchdog->mask);

makes no sense to me. Shouldn't it be

        delta = clocksource_delta(wdnow, watchdog->wd_last, watchdog->mask);

Thomas? John?

                  Linus
