Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaE3MPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:15:15 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:33551 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaE3MPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:15:13 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: migueloliv@gmail.com
In-Reply-To: <20140530113418.GA9670@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
	<20140530113418.GA9670@amd.pavel.ucw.cz>
Date: Fri, 30 May 2014 13:15:12 +0100
X-Google-Sender-Auth: 4VaHZxQDdoNap9QLAaYblKA4n90
Message-ID: <CAMGgR5swX-cp4navRBu8CxYnL5fRSxkBVRcu-xKXkr0oyBXP+A@mail.gmail.com>
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
From: Miguel Oliveira <cmroliv@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@linuxfoundation.org, gulsah.1004@gmail.com, pali.rohar@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the /Documentation/timers/timers-howto.txt stats:

SLEEPING FOR ~USECS OR SMALL MSECS ( 10us - 20ms):
* Use usleep_range

- Why not msleep for (1ms - 20ms)?
Explained originally here:
http://lkml.org/lkml/2007/8/3/250
msleep(1~20) may not do what the caller intends, and
will often sleep longer (~20 ms actual sleep for any
value given in the 1~20ms range). In many cases this
is not the desired behavior.

- Why is there no "usleep" / What is a good range?
Since usleep_range is built on top of hrtimers, the
wakeup will be very precise (ish), thus a simple
usleep function would likely introduce a large number
of undesired interrupts.

With the introduction of a range, the scheduler is
free to coalesce your wakeup with any other wakeup
that may have happened for other reasons, or at the
worst case, fire an interrupt for your upper bound.

The larger a range you supply, the greater a chance
that you will not trigger an interrupt; this should
be balanced with what is an acceptable upper bound on
delay / performance for your specific code path. Exact
tolerances here are very situation specific, thus it
is left to the caller to determine a reasonable range.

Should the documentation should be ignored?

Regards

2014-05-30 12:34 GMT+01:00 Pavel Machek <pavel@ucw.cz>:
> On Fri 2014-05-30 11:27:13, Miguel Oliveira wrote:
>> Creating this patch for the Eudyptula Challenge.
>> Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
>> Also inserted a blank line after adeclaration.
>
> So you are changing timings without testing. Plus, burning CPU power
> instead of sleeping.
>
> Seems you'll need another patch for the challenge :-).
>                                                                         Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
