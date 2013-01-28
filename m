Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3A1Cgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:36:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:17346 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3A1Cg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:36:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,548,1355126400"; 
   d="scan'208";a="282864228"
Message-ID: <1359340583.2249.14.camel@rzhang1-mobl4>
Subject: Re: [Intel-gfx] [RFC PATCH 3/3] i915: ignore lid open event when
 resuming
From: Zhang Rui <rui.zhang@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        rjw@sisk.pl, lenb@kernel.org
Date: Mon, 28 Jan 2013 10:36:23 +0800
In-Reply-To: <CAKMK7uF4u-3XFogzdQQCBqA2Q61D1s3PhVF7BOT90d88TkqT0g@mail.gmail.com>
References: <1359300060-2967-1-git-send-email-rui.zhang@intel.com>
	 <1359300060-2967-3-git-send-email-rui.zhang@intel.com>
	 <CAKMK7uF4u-3XFogzdQQCBqA2Q61D1s3PhVF7BOT90d88TkqT0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-27 at 16:45 +0100, Daniel Vetter wrote:
> On Sun, Jan 27, 2013 at 4:21 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> > i915 driver needs to do modeset when
> > 1. system resumes from sleep
> > 2. lid is opened
> >
> > In PM_SUSPEND_MEM state, all the GPEs are cleared when system resumes,
> > thus it is the i915_resume code does the modeset rather than intel_lid_notify().
> >
> > In PM_SUSPEND_FREEZE state, system is still resposive to the lid events.
> > 1. When we close the lid in Freeze state, intel_lid_notify() sets modeset_on_lid.
> > 2. When we reopen the lid, intel_lid_notify() will do a modeset,
> >    before the system is resumed.
> >
> > here is the error log,
> >
> > [92146.548074] WARNING: at drivers/gpu/drm/i915/intel_display.c:1028 intel_wait_for_pipe_off+0x184/0x190 [i915]()
> > [92146.548076] Hardware name: VGN-Z540N
> > [92146.548078] pipe_off wait timed out
> > [92146.548167] Modules linked in: hid_generic usbhid hid snd_hda_codec_realtek snd_hda_intel snd_hda_codec parport_pc snd_hwdep ppdev snd_pcm_oss i915 snd_mixer_oss snd_pcm arc4 iwldvm snd_seq_dummy mac80211 snd_seq_oss snd_seq_midi fbcon tileblit font bitblit softcursor drm_kms_helper snd_rawmidi snd_seq_midi_event coretemp drm snd_seq kvm btusb bluetooth snd_timer iwlwifi pcmcia tpm_infineon i2c_algo_bit joydev snd_seq_device intel_agp cfg80211 snd intel_gtt yenta_socket pcmcia_rsrc sony_laptop agpgart microcode psmouse tpm_tis serio_raw mxm_wmi soundcore snd_page_alloc tpm acpi_cpufreq lpc_ich pcmcia_core tpm_bios mperf processor lp parport firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci thermal e1000e
> > [92146.548173] Pid: 4304, comm: kworker/0:0 Tainted: G        W    3.8.0-rc3-s0i3-v3-test+ #9
> > [92146.548175] Call Trace:
> > [92146.548189]  [<c10378e2>] warn_slowpath_common+0x72/0xa0
> > [92146.548227]  [<f86398b4>] ? intel_wait_for_pipe_off+0x184/0x190 [i915]
> > [92146.548263]  [<f86398b4>] ? intel_wait_for_pipe_off+0x184/0x190 [i915]
> > [92146.548270]  [<c10379b3>] warn_slowpath_fmt+0x33/0x40
> > [92146.548307]  [<f86398b4>] intel_wait_for_pipe_off+0x184/0x190 [i915]
> > [92146.548344]  [<f86399c2>] intel_disable_pipe+0x102/0x190 [i915]
> > [92146.548380]  [<f8639ea4>] ? intel_disable_plane+0x64/0x80 [i915]
> > [92146.548417]  [<f8639f7c>] i9xx_crtc_disable+0xbc/0x150 [i915]
> > [92146.548456]  [<f863ebee>] intel_crtc_update_dpms+0x5e/0x90 [i915]
> > [92146.548493]  [<f86437cf>] intel_modeset_setup_hw_state+0x42f/0x8f0 [i915]
> > [92146.548535]  [<f8645b0b>] intel_lid_notify+0x9b/0xc0 [i915]
> > [92146.548543]  [<c15610d3>] notifier_call_chain+0x43/0x60
> > [92146.548550]  [<c105d1e1>] __blocking_notifier_call_chain+0x41/0x80
> > [92146.548556]  [<c105d23f>] blocking_notifier_call_chain+0x1f/0x30
> > [92146.548563]  [<c131a684>] acpi_lid_send_state+0x78/0xa4
> > [92146.548569]  [<c131aa9e>] acpi_button_notify+0x3b/0xf1
> > [92146.548577]  [<c12df56a>] ? acpi_os_execute+0x17/0x19
> > [92146.548582]  [<c12e591a>] ? acpi_ec_sync_query+0xa5/0xbc
> > [92146.548589]  [<c12e2b82>] acpi_device_notify+0x16/0x18
> > [92146.548595]  [<c12f4904>] acpi_ev_notify_dispatch+0x38/0x4f
> > [92146.548600]  [<c12df0e8>] acpi_os_execute_deferred+0x20/0x2b
> > [92146.548607]  [<c1051208>] process_one_work+0x128/0x3f0
> > [92146.548613]  [<c1564f73>] ? common_interrupt+0x33/0x38
> > [92146.548618]  [<c104f8c0>] ? wake_up_worker+0x30/0x30
> > [92146.548624]  [<c12df0c8>] ? acpi_os_wait_events_complete+0x1e/0x1e
> > [92146.548629]  [<c10524f9>] worker_thread+0x119/0x3b0
> > [92146.548634]  [<c10523e0>] ? manage_workers+0x240/0x240
> > [92146.548640]  [<c1056e84>] kthread+0x94/0xa0
> > [92146.548647]  [<c1060000>] ? ftrace_raw_output_sched_stat_runtime+0x70/0xf0
> > [92146.548652]  [<c15649b7>] ret_from_kernel_thread+0x1b/0x28
> > [92146.548658]  [<c1056df0>] ? kthread_create_on_node+0xc0/0xc0
> >
> > so I'd like to use tristate for modeset_on_lid instead of bool.
> > -1: ingore all the lid events.
> > 0:  do not do modeset when there is a lid-open event.
> > 1:  do modeset when there is a lid-open event.
> > In this way, only device resume code will do modeset in a suspend/resume cycle.
> >
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
> Given that this essentially requires users to manually set this module
> option to make stuff work I don't like this.
> 
sorry, I do not understand.
this patch just disables modeset_on_lid during suspend.

> I see a few possible options:
> - plug the races between all the different parts - I've never really
> understood why acpi sends us events before the resume code has
> completed ... If that's indeed intentional, we could delay the
> handling a bit until at least the i915 resume code completed.

IMO, the real question is that, during a suspend/resume cycle, if we
need to take care of the lid open event or not.
To me, the answer is no, because when resuming from STR, i915 is not
aware of such an event, and the i915 resume code works well, right?
so I do not think it is a problem to ignore the lid event for another
lightweight suspend state, which is introduced in Patch 1/3 in this
series.

> - Judging from the diff context you're not on the latest 3.8-rc
> codebase - we've applied a few fixes to this lid hack recently. Please
> retest on a kernel with
> 
the patch is based on 3.8.0-rc3, which already includes the commit
below.
And yes, the problem still exists.

thanks,
rui
> commit 45e2b5f640b3766da3eda48f6c35f088155c06f3
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Fri Nov 23 18:16:34 2012 +0100
> 
>     drm/i915: force restore on lid open
> 
> - This lid hack is only required since a few moronic BIOS
> implementations touch the display hw state behind our backs. On
> platforms with OpRegion support this shouldn't be the case any longer
> (which means pretty much everything shipped in the last few years), so
> we could conditionalize this hack on that (e.g. check out the existing
> dev_priv->opregion.header check in the i915_resume function in
> i915_drv.c in drm-next).
> 
> Yours, Daniel
> 
> > ---
> >  drivers/gpu/drm/i915/i915_drv.c   |    4 ++--
> >  drivers/gpu/drm/i915/i915_drv.h   |    2 +-
> >  drivers/gpu/drm/i915/intel_lvds.c |    2 ++
> >  3 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> > index 1172658..d7613cb 100644
> > --- a/drivers/gpu/drm/i915/i915_drv.c
> > +++ b/drivers/gpu/drm/i915/i915_drv.c
> > @@ -492,8 +492,8 @@ static int i915_drm_freeze(struct drm_device *dev)
> >
> >         intel_opregion_fini(dev);
> >
> > -       /* Modeset on resume, not lid events */
> > -       dev_priv->modeset_on_lid = 0;
> > +       /* Modeset on resume, ignore lid events */
> > +       dev_priv->modeset_on_lid = -1;
> >
> >         console_lock();
> >         intel_fbdev_set_suspend(dev, 1);
> > diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> > index ed30595..3fec498 100644
> > --- a/drivers/gpu/drm/i915/i915_drv.h
> > +++ b/drivers/gpu/drm/i915/i915_drv.h
> > @@ -748,7 +748,7 @@ typedef struct drm_i915_private {
> >         unsigned long quirks;
> >
> >         /* Register state */
> > -       bool modeset_on_lid;
> > +       int modeset_on_lid;     /* -1: invalid, 0: no modeset, 1: do modeset */
> >
> >         struct {
> >                 /** Bridge to intel-gtt-ko */
> > diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> > index 17aee74..4ddae6d 100644
> > --- a/drivers/gpu/drm/i915/intel_lvds.c
> > +++ b/drivers/gpu/drm/i915/intel_lvds.c
> > @@ -512,6 +512,8 @@ static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
> >         if (dev->switch_power_state != DRM_SWITCH_POWER_ON)
> >                 return NOTIFY_OK;
> >
> > +       if (dev_priv->modeset_on_lid == -1)
> > +               return NOTIFY_OK;
> >         /*
> >          * check and update the status of LVDS connector after receiving
> >          * the LID nofication event.
> > --
> > 1.7.9.5
> >
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
> 
> 


