Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaFRQqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:46:31 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:40629 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaFRQq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:46:29 -0400
Date: Wed, 18 Jun 2014 17:46:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Simon Glass <sjg@chromium.org>, Wolfram Sang <wsa@the-dreams.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] mfd: cros_ec: IRQs for cros_ec should be optional
Message-ID: <20140618164621.GB25353@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-3-git-send-email-dianders@chromium.org>
 <20140618075551.GJ21030@lee--X1>
 <CAD=FV=Wn3u+DNerFBNpbbLhBPa+3A5bvrRiBXNq=vyRA00+-uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=Wn3u+DNerFBNpbbLhBPa+3A5bvrRiBXNq=vyRA00+-uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> Lee,
> 
> On Wed, Jun 18, 2014 at 12:55 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Mon, 16 Jun 2014, Doug Anderson wrote:
> >
> >> From: Bill Richardson <wfrichar@chromium.org>
> >>
> >> Preparing the way for the LPC device, which is just a plaform_device without
> >> interrupts.
> >>
> >> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >>  drivers/mfd/cros_ec.c | 26 +++++++++++++-------------
> >>  1 file changed, 13 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> >> index 38fe9bf..bd6f936 100644
> >> --- a/drivers/mfd/cros_ec.c
> >> +++ b/drivers/mfd/cros_ec.c
> >> @@ -119,17 +119,15 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
> >>                       return -ENOMEM;
> >>       }
> >>
> >> -     if (!ec_dev->irq) {
> >> -             dev_dbg(dev, "no valid IRQ: %d\n", ec_dev->irq);
> >> -             return err;
> >> -     }
> >> -
> >> -     err = request_threaded_irq(ec_dev->irq, NULL, ec_irq_thread,
> >> -                                IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> >> -                                "chromeos-ec", ec_dev);
> >> -     if (err) {
> >> -             dev_err(dev, "request irq %d: error %d\n", ec_dev->irq, err);
> >> -             return err;
> >> +     if (ec_dev->irq) {
> >> +             err = request_threaded_irq(ec_dev->irq, NULL, ec_irq_thread,
> >> +                                     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> >> +                                     "chromeos-ec", ec_dev);
> >
> > Is there anything stopping you using the devm_* version?
> 
> I'm generally quite hesitant about using the devm_ IRQ functions.
> Requesting an IRQ enables the IRQ at the time of request and freeing
> it disables it, right?  Leaving it up to the the devm subsystem to
> disable your IRQ tends to be a race waiting to happen if an IRQ
> happens after you've freed all your memory / cleaned up all your
> state.
> 
> Looking at cros_ec in particular though:
> 
> * Right now the last thing done in cros_ec_remove() (which is the last
> thing in both cros_ec_i2c_remove and cros_ec_spi_remove) is to free
> the IRQ.  That means that you're right: we could switch to devm_ in
> this case and it wouldn't introduce any new bugs.
> 
> * ...but I'm not convinced that the location of the free_irq() today
> is quite right.  I couldn't actually get it to crash or hang, but
> there is a time period where we've called mfd_remove_devices() and the
> IRQ is still active.  That doesn't seem like a super great situation
> to be in.  I'll add a move of the irq_free to the patch series.

I guess if you're concerned about ordering you could always use
devm_free_irq() in the places where you think it should be freed
earlier than release.  I'm pretty sure that discludes the failure
patch in probe() though, so we'd still be able to rid a few lines.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
