Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaEAOeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:34:00 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56157 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaEAOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:33:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140501141156.GV3245@sirena.org.uk>
References: <1398854171-5187-1-git-send-email-ricardo.ribalda@gmail.com>
	<20140501013402.GL3245@sirena.org.uk>
	<CAPybu_3g=VBW+gGhveBJoc7=tCiPurP_r_+hqOU78bvsg8QJWw@mail.gmail.com>
	<20140501141156.GV3245@sirena.org.uk>
Date: Thu, 1 May 2014 16:33:58 +0200
X-Google-Sender-Auth: 3Pod47x3ChRQ2Tz4TNmnUvEr0e8
Message-ID: <CAMuHMdUeFJDq8TMQn=D+y_nWVy-puZDYekV3cPhHTnDF+ebKJA@mail.gmail.com>
Subject: Re: [PATCH] spi: Fix hung task timeout when initialization fails
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 4:11 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, May 01, 2014 at 07:53:58AM +0200, Ricardo Ribalda Delgado wrote:
>
>> Thanks for your comments. This fix does not avoid the task being
>> killed (which is not an error). What it does is that IF the task is
>> killed or we are out of memory we will exit with all the resources
>> properly released and no locks helds, giving the user a chance to
>> reload/rebind the module instead of getting and unstable system that
>> cannot even reboot without a powercycle.
>
> How does it ensure that?  What's to stop the task being killed after we
> check to see if the task was killed.

master->kworker_task is set like this:

    master->kworker_task = kthread_run(...)

so it just contains the status of the creation of the kthread, not if it was
killed, right? Hence we don't check if it was killed.

So Ricardo's patch prevents the stopping and destruction of the thread
if it failed to be _created_.

What if it is killed? I suppose the kthread API handles that internally, as it
could happen to any thread (e.g. OOM)?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
