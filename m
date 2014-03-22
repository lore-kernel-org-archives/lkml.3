Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaCVLLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:11:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:49574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaCVLLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:11:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>, LKML <linux-kernel@vger.kernel.org>,
        zhuzhenhua@allwinnertech.com,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Date: Sat, 22 Mar 2014 12:11:24 +0100
Message-ID: <4177769.XedaQsoUgV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140321191739.GT27873@lukather>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com> <CAP=VYLqCmG6fRmPPABoW4xg_tFgGh2pji=f5ML=cBgCu4zZocg@mail.gmail.com> <20140321191739.GT27873@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:185MB+KuXGjPmajVxK4RKqvOGdaOEpc+1N+F/iZq21y
 squbT7nyOEJVWKChLS0Y0MoMgLSB3xv4d5UXYaP44NtiBIGS3e
 SiINtjsH/8WGTfkJEgtNfJbJCh7e57II005bhmZe0q9HHrWyR3
 wpF12N6vzmyudwRVy9D6bnE+IkVoGrST0OMRi3wF65sSF9O9X/
 yik/HE40/k24wbQTqvmzDGLm+V+MwV23DZcFvtjHTQKqLDTowH
 dG300ovGx+s6pS/rk50+R3YyKqznrNurXnWMSnsdAOX6RS/tu4
 +EUABGbLryxHxRmd1hgZTz9hwM5yuEndEKpVOifQ32254MYR9q
 mvyLr9wXFvKNy7Su6o+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 March 2014 20:17:39 Maxime Ripard wrote:
> On Fri, Mar 21, 2014 at 11:49:59AM -0400, Paul Gortmaker wrote:
> > On Mon, Mar 10, 2014 at 7:29 AM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > On Mon, Mar 10, 2014 at 11:58:08AM +0100, Maxime Ripard wrote:
> > >> On Fri, Mar 07, 2014 at 04:08:36PM +0000, Russell King - ARM Linux wrote:
> > >> > On Fri, Mar 07, 2014 at 03:59:30PM +0100, Maxime Ripard wrote:
> > >> > > @@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
> > >> > >  exit_free_irq:
> > >> > >   free_irq(drv_data->irq, drv_data);
> > >> > >  exit_reset:
> > >> > > - if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
> > >> > > + if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
> > >> > > +     !IS_ERR(drv_data->rstc))
> > >> > >           reset_control_assert(drv_data->rstc);
> > >> >
> > >> > Another question is... why do we need to check pd->dev.of_node here?
> > >> > If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
> > >> > controller node, so drv_data->rstc is either going to be a valid
> > >> > pointer, or it's going to be an error pointer - neither
> > >> > reset_control_get() nor devm_reset_control_get return NULL.
> > >>
> > >> Following back on this as I was doing the patch, actually,
> > >> drv_data->rstc will be NULL if we're not probed by DT, and hence never
> > >> call reset_control_get, that would set an error pointer.
> > >>
> > >> But then, we can use IS_ERR_OR_NULL on drv_data->rstc.
> > >
> > > I think you can also move the devm_reset_control_get() into the main
> > > probe function: you're only checking for -EPROBE_DEFER from it to fail,
> > > allowing other errors to continue with the driver init.  This means
> > > that on non-OF, devm_reset_control_get() will fail with -ENOENT.
> > 
> > Looping linux-next into the CC since this is the cause of the failure
> > in orion5x_defconfig there, and no point in anyone else re-doing the
> > same bisect.
> 
> I sent a fix for this that hasn't been picked up yet:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/239069.html
> 
> IIRC, Wolfram's away until Monday, so I guess it will be merged some
> time next week.

I think there is something wrong with an interface that makes you use
IS_ERR_OR_NULL(). If you are calling reset_control_get_optional(), that'
should not return an error when there is no reset controller listed
in the device tree. We should still have a way to propagate -EPROBE_DEFER,
or bail out if there is a reset controller but there is something wrong
with it, but otherwise I'd suggest just leaving NULL as a valid pointer
in drv_data->rstc and making sure that the reset controller functions
can just deal with a NULL argument, so you never have to check it again.

	Arnd
