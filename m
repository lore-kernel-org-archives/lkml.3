Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaCBNfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 08:35:21 -0500
Received: from www.prifuk.cz ([31.31.77.241]:54875 "EHLO prifuk.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbaCBNfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 08:35:19 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: Felix Rueegg <felix.rueegg@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: ff-memless: don't schedule already playing effect to play again
Date: Sun, 02 Mar 2014 14:37:11 +0100
Message-ID: <1433818.6pzd5XvsiT@sigyn>
User-Agent: KMail/4.12.2 (Linux/3.13.5-1-ARCH; KDE/4.12.2; x86_64; ; )
In-Reply-To: <CADbOyBSMG_a=2qPmM0EU1LEd7y1ZxrpLuoz4MHroX6ri4-nJ3g@mail.gmail.com>
References: <1393760143-5986-1-git-send-email-felix.rueegg@gmail.com> <CADbOyBSMG_a=2qPmM0EU1LEd7y1ZxrpLuoz4MHroX6ri4-nJ3g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 of March 2014 14:17:58 you wrote:
> On Sun, Mar 2, 2014 at 12:35 PM, Felix Rueegg 
<felix.rueegg@gmail.com> wrote:
> > When an effect with zero replay length, zero replay delay
> > and zero envelope attack length is uploaded, it is played and then
> > scheduled to play again one timer tick later. This triggers a 
warning
> > (URB submitted while active) in combination with the xpad driver.
> > 
> > Skipping the rescheduling of this effect fixes the issue.
> > 
> > Signed-off-by: Felix Rueegg <felix.rueegg@gmail.com>
> > ---
> > 
> >  drivers/input/ff-memless.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
> > index 74c0d8c..2e06948 100644
> > --- a/drivers/input/ff-memless.c
> > +++ b/drivers/input/ff-memless.c
> > @@ -139,10 +139,13 @@ static void ml_schedule_timer(struct 
ml_device *ml)
> > 
> >                 if (!test_bit(FF_EFFECT_STARTED, &state->flags))
> >                 
> >                         continue;
> > 
> > -               if (test_bit(FF_EFFECT_PLAYING, &state->flags))
> > +               if (test_bit(FF_EFFECT_PLAYING, &state->flags)) {
> > 
> >                         next_at = calculate_next_time(state);
> > 
> > -               else
> > +                       if (next_at == now)
> > +                               continue;
> > +               } else {
> > 
> >                         next_at = state->play_at;
> > 
> > +               }
> > 
> >                 if (time_before_eq(now, next_at) &&
> >                 
> >                     (++events == 1 || time_before(next_at, earliest)))
> > 
> > --
> > 1.9.0
> > 
> > --
> 
> @Michal: Is ff-memless-next also affected by this problem?
> 
> Elias

I hope it's not, see mlnx_get_envelope_update_time(), this part in 
particular:

        /* Prevent the effect from being started twice */
        if (mlnxeff->begin_at == now && mlnx_is_playing(mlnxeff))
                return now - 1;

        return mlnxeff->begin_at;

Michal
