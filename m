Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaFBVGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:06:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45079 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaFBVGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:06:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alex Elder <elder@linaro.org>, mporter@linaro.org, bcm@fixthebug.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <538950A6.6020300@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1401483188-5395-1-git-send-email-elder@linaro.org>
 <1401483188-5395-2-git-send-email-elder@linaro.org>
 <20140530232822.10062.26597@quantum> <538950A6.6020300@linaro.org>
Message-ID: <20140602210556.10062.18574@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v4 1/7] clk: kona: allow nested ccu_write_enable() requests
Date: Mon, 02 Jun 2014 14:05:56 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alex Elder (2014-05-30 20:46:46)
> On 05/30/2014 06:28 PM, Mike Turquette wrote:
> > Quoting Alex Elder (2014-05-30 13:53:02)
> >> Use a counter rather than a Boolean to track whether write access to
> >> a CCU has been enabled or not.  This will allow more than one of
> >> these requests to be nested.
> >>
> >> Note that __ccu_write_enable() and __ccu_write_disable() calls all
> >> come in pairs, and they are always surrounded immediately by calls
> >> to ccu_lock() and ccu_unlock().
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> >>  drivers/clk/bcm/clk-kona.c | 14 ++++----------
> >>  drivers/clk/bcm/clk-kona.h |  2 +-
> >>  2 files changed, 5 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
> >> index 95af2e6..ee8e988 100644
> >> --- a/drivers/clk/bcm/clk-kona.c
> >> +++ b/drivers/clk/bcm/clk-kona.c
> >> @@ -170,13 +170,8 @@ static inline void ccu_unlock(struct ccu_data *ccu, unsigned long flags)
> >>   */
> >>  static inline void __ccu_write_enable(struct ccu_data *ccu)
> > 
> > Per Documentation/CodingStyle, chapter 15, "the inline disease", it
> > might be best to not inline these functions.
> 
> This was not intentional.  I normally only inline things
> defined in header files, and maybe this is an artifact of
> having been in a header at one time.  I don't know, I'll get
> rid of the inline.
> 
> > 
> >>  {
> >> -       if (ccu->write_enabled) {
> >> -               pr_err("%s: access already enabled for %s\n", __func__,
> >> -                       ccu->name);
> >> -               return;
> >> -       }
> >> -       ccu->write_enabled = true;
> >> -       __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD | 1);
> >> +       if (!ccu->write_enabled++)
> >> +               __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD | 1);
> >>  }
> >>  
> >>  static inline void __ccu_write_disable(struct ccu_data *ccu)
> >> @@ -186,9 +181,8 @@ static inline void __ccu_write_disable(struct ccu_data *ccu)
> >>                         ccu->name);
> >>                 return;
> >>         }
> >> -
> >> -       __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
> >> -       ccu->write_enabled = false;
> >> +       if (!--ccu->write_enabled)
> >> +               __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
> > 
> > What happens if calls to __ccu_write_enable and __ccu_write_disable are
> > unbalanced? It would be better to catch that case and throw a WARN:
> 
> You can't see it in the diff, but that's what happens
> (well, it's a pr_err(), not a WARN()).   I think a WARN()
> is probably right in this case though.
> 
> >       if (WARN_ON(ccu->write_enabled == 0))
> >               return;
> > 
> >       if (--ccu->write_enabled > 0)
> >               return;
> > 
> >       __ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
> > 
> >>  }
> >>  
> >>  /*
> >> diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
> >> index 2537b30..e9a8466 100644
> >> --- a/drivers/clk/bcm/clk-kona.h
> >> +++ b/drivers/clk/bcm/clk-kona.h
> >> @@ -478,7 +478,7 @@ struct ccu_policy {
> >>  struct ccu_data {
> >>         void __iomem *base;     /* base of mapped address space */
> >>         spinlock_t lock;        /* serialization lock */
> >> -       bool write_enabled;     /* write access is currently enabled */
> >> +       u32 write_enabled;      /* write access enable count */
> > 
> > Why u32? An unsigned int will do just nicely here.
> 
> That's a preference of mine.  I almost always favor
> using u32, etc. because they are compact, and explicit
> about the size and signedness.  I "know" an int is 32
> bits, but I still prefer being explicit.
> 
> I'll interpret this as a preference on your part for
> unsigned int, and I have no problem making that change.

It's not a big deal, I was just curious why. Feel free to use whatever
solution you prefer here.

Regards,
Mike

> 
>                                         -Alex
> 
> > Regards,
> > Mike
> > 
> >>         struct ccu_policy policy;
> >>         struct list_head links; /* for ccu_list */
> >>         struct device_node *node;
> >> -- 
> >> 1.9.1
> >>
> 
