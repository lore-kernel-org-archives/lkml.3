Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaIDEvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:51:14 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33265 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaIDEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+B8BG5Hf8=ki0JDeRR13Mo7QRFDmsDuEpW8ozepvCp5KsY8ZA@mail.gmail.com>
References: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
	<CAOh2x==TSbtOKBn6KOL9Z_M-nkzQOiO+EqSTmEtQeRLXROC1rw@mail.gmail.com>
	<CAOh2x=kNtcse_2sExDPCpRnCmxvmqq1++mkSW6HKY+Vn-SJ9QA@mail.gmail.com>
	<CA+B8BG5Hf8=ki0JDeRR13Mo7QRFDmsDuEpW8ozepvCp5KsY8ZA@mail.gmail.com>
Date: Thu, 4 Sep 2014 10:21:09 +0530
Message-ID: <CAKohpon7Uxndqg+0JSaJEhfousitDcCvpVLx1jtNtBFHh0WatQ@mail.gmail.com>
Subject: Re: [RFC PATCH] pm: prevent suspend until power supply events are processed
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Zoran Markovic <zrn.markovic@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Arve Hjonnevag <arve@android.com>, Todd Poynor <toddpoynor@google.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your quick reply :)

On 4 September 2014 00:43, Zoran Markovic <zrn.markovic@gmail.com> wrote:
> Note that power_supply_changed_work() could race with
> power_supply_changed(), as well as with itself. You could theoretically run
> power_supply_changed() several times and queue several
> power_supply_changed_work() calls. The first run of
> power_supply_changed_work() would cancel all previous power_supply_changed()
> and the remaining runs would just encounter psy->changed == FALSE and fall
> through.

That's not completely true. You can't queue the same work multiple times. And
the work is queued only if its not pending. The pending bit is just
cleared before calling
the work-handler.

The worst corner case is that the work-handler, i.e. power_supply_changed_work()
is called and just before taking the lock, another work is enqueued. Now for the
first iteration of power_supply_changed_work() we will surely get
changes as TRUE,
but for second one it may be FALSE.

So, yes my theory was incorrect.

>> >> +               psy->changed = false;
>> >> +               spin_unlock_irqrestore(&psy->changed_lock, flags);
>> >> +               class_for_each_device(power_supply_class, NULL, psy,
>> >> +                                     __power_supply_changed_work);
>> >> +               power_supply_update_leds(psy);
>> >> +               kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
>> >> +               spin_lock_irqsave(&psy->changed_lock, flags);
>> >> +       }
>> >> +       /* dependent power supplies (e.g. battery) may have changed
>> >> +        * state as a result of this event, so poll again and hold
>> >> +        * the wakeup_source until all events are processed.
>> >> +        */
>> >> +       if (!psy->changed)
>> >> +               pm_relax(psy->dev);
>> >
>> > I got a bit confused here. Does the above comment say this:
>> >
>> > The supplies dependent on 'psy' may change states and that *may*
>> > change the state of 'psy' again? And so psy->changed is set to true
>> > again?
>
> This is where power_supply_changed_work() could race with another
> power_supply_changed(). By the time you hit the check for !psy->changed,
> another work may have been already queued. Calling pm_relax() without this
> check could defer that work until next resume.

Hmm.. Correct here as well.

Thanks for your explanation.
