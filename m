Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbaEPRZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:25:25 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59220 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaEPRZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:25:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140516115346.GO27580@intel.com>
References: <20140509170335.GZ18465@intel.com>
	<CADDKRnAiQawK6vi0XO2FDdfGDbcwWQzdeu-rfEU8viJzARO+yQ@mail.gmail.com>
	<CAKMK7uHLSfW0wN-uXMejOcnvaYpZfVSfSh7+NpqAUBCOvbK2eg@mail.gmail.com>
	<CADDKRnCzHQw7_Cr2jpZ7qC50hrdmr0XRaYyMxaOSaqihNGccDA@mail.gmail.com>
	<20140512190300.GF25056@phenom.ffwll.local>
	<CADDKRnAOkdaziCQ_NGkt01hiQqjiAiKza2+QbCuDBuY72LJK=A@mail.gmail.com>
	<CAKMK7uGy3bKdj-B21rCpeF2EPEE4Wi8CxLbDWFBGpLWskoDj3w@mail.gmail.com>
	<20140513132200.GC3908@phenom.ffwll.local>
	<CADDKRnADucv7wMRgEDZ_DKRJqkPPZdgymL6VJhtG_JD9MkiJhA@mail.gmail.com>
	<20140513163832.GM3908@phenom.ffwll.local>
	<20140516115346.GO27580@intel.com>
Date: Fri, 16 May 2014 19:25:23 +0200
Message-ID: <CADDKRnAhB2i1fKExPn3kAm_nX=PS1tf_YhasTHNCEHM6JatP5A@mail.gmail.com>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Damien Lespiau <damien.lespiau@intel.com>, David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-16 13:53 GMT+02:00 Ville Syrjälä <ville.syrjala@linux.intel.com>:
> On Tue, May 13, 2014 at 06:38:32PM +0200, Daniel Vetter wrote:
>> On Tue, May 13, 2014 at 05:21:49PM +0200, Jörg Otte wrote:
>> > 2014-05-13 15:22 GMT+02:00 Daniel Vetter <daniel@ffwll.ch>:
>> > > On Tue, May 13, 2014 at 12:38:41PM +0200, Daniel Vetter wrote:
>> > >> On Tue, May 13, 2014 at 12:29 PM, Jörg Otte <jrg.otte@gmail.com> wrote:
>> > >> >>> Branch drm-intel-nightly as of
>> > >> >>> ed60c27 drm-intel-nightly: 2014y-05m-09d-21h-51m-45s integration manifest
>> > >> >>> looks badly:
>> > >> >>>    - KDE splash screen on boot-up is not visible
>> > >> >>>    - x-windows don't have title and menu bars
>> > >> >>>    - KDE system menu is not visible
>> > >> >>>    - moving windows around destroys its content
>> > >> >>
>> > >> >> Ugh, that's ugly. Nothing else change like e.g. the version of
>> > >> >> xfree-video-intel?
>> > >> >
>> > >> >  (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
>> > >> >  (II) Module intel: vendor="X.Org Foundation"
>> > >> >  compiled for 1.11.3, module version = 2.17.0
>> > >> >  Module class: X.Org Video Driver
>> > >> >  ABI class: X.Org Video Driver, version 11.0
>> > >>
>> > >> Chris, any ideas? It's an ivybridge apparently.
>> > >>
>> > >> For the fifo underruns I think we've fully confirmed that they only
>> > >> happen on boot-up. I'll try to come up with some ideas what could have
>> > >> gone wrong there.
>> > >
>> > > Please test the below patch.
>> > > -Daniel
>> > >
>> > > diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
>> > > index b10fbde1d5ee..63ced2dee027 100644
>> > > --- a/drivers/gpu/drm/i915/i915_irq.c
>> > > +++ b/drivers/gpu/drm/i915/i915_irq.c
>> > > @@ -427,9 +427,6 @@ bool __intel_set_cpu_fifo_underrun_reporting(struct drm_device *dev,
>> > >
>> > >         ret = !intel_crtc->cpu_fifo_underrun_disabled;
>> > >
>> > > -       if (enable == ret)
>> > > -               goto done;
>> > > -
>> > >         intel_crtc->cpu_fifo_underrun_disabled = !enable;
>> > >
>> > >         if (enable && (INTEL_INFO(dev)->gen < 5 || IS_VALLEYVIEW(dev)))
>> > > @@ -441,7 +438,6 @@ bool __intel_set_cpu_fifo_underrun_reporting(struct drm_device *dev,
>> > >         else if (IS_GEN8(dev))
>> > >                 broadwell_set_fifo_underrun_reporting(dev, pipe, enable);
>> > >
>> > > -done:
>> > >         return ret;
>> > >  }
>> > >
>> > > --
>> >
>> > Doesn't work for me, I still have an underrun at boot-up.
>>
>> I'm at a loss tbh with ideas. We successfully disable both pipes, then
>> enable pipe A and it all works.
>>
>> Then we enable pipe B and _both_ pipes underrun immediately afterwards.
>> Really strange. Can you please reproduce the issue again on
>> drm-intel-nightly (latest -nightly should also have the display
>> corruptions fixed, so good to retest anyway) and attach a new dmesg with
>> drm.debug=0xe.
>
> I see a few underrun on my IVB as well. But it seems to be limited to
> cases that involve the VGA connector, which doesn't actually exist on
> this machine so I can't be sure if it's really properly set up on the
> PCH. But so far with just two HDMI connectors I was unable to reproduce
> it.
>
>>
>> Meanwhile I'll try to come up with new theories and ideas.
>
> I was thinking that we might frob with the PCH refclk during driver init
> and that might cause the PCH underrun for Jörg, but it looks like the
> underruns really happen at the modeset time which is much later than the
> PCH refclock init.
>
> For the 1<->n pipe transition, I don't think we handle it correctly at
> the moment. I have a fix as part of my remaining watermark patches. I
> rebased those and I'll repost them soon. In the meantime I pushed them
> to [1]. Jörg, can you give that branch a go?
>
> [1] git://gitorious.org/vsyrjala/linux.git watermarks_intm_31_notrace
>
Unfortunately not working for me.
It gives me some more errors:

[drm:ivybridge_set_fifo_underrun_reporting] *ERROR* uncleared fifo
underrun on pipe A
[drm:ivb_err_int_handler] *ERROR* Pipe A FIFO underrun
[drm:ivybridge_set_fifo_underrun_reporting] *ERROR* uncleared fifo
underrun on pipe B
[drm:ivb_err_int_handler] *ERROR* Pipe B FIFO underrun
[drm:cpt_set_fifo_underrun_reporting] *ERROR* uncleared pch fifo
underrun on pch transcoder A
[drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[drm:cpt_set_fifo_underrun_reporting] *ERROR* uncleared pch fifo
underrun on pch transcoder B
[drm:cpt_serr_int_handler] *ERROR* PCH transcoder B FIFO underrun

Thanks, Jörg
