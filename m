Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab3KMUd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:33:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36231 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab3KMUds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:33:48 -0500
Date: Wed, 13 Nov 2013 21:33:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Message-ID: <20131113203319.GB23962@pd.tnic>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at>
 <20131113200914.GG7251@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131113200914.GG7251@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more suggestions, in addition to Daniel's:

On Wed, Nov 13, 2013 at 09:09:14PM +0100, Daniel Vetter wrote:
> > Nov 13 09:36:21 maistor kernel: [   40.447271] ------------[ cut 
> > here ]------------
> > Nov 13 09:36:21 maistor kernel: [   40.447311] WARNING: CPU: 1 PID: 4142 at 
> > drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 [i915]
> > ()
> > Nov 13 09:36:21 maistor kernel: [   40.447313] pipe state doesn't match!

That's

	if (active &&
	    !intel_pipe_config_compare(dev, &crtc->config, &pipe_config)) {
		WARN(1, "pipe state doesn't match!\n");				<---
		intel_dump_pipe_config(crtc, &pipe_config,
				       "[hw state]");
		intel_dump_pipe_config(crtc, &crtc->config,
				       "[sw state]");
	}

> > Nov 13 09:36:21 maistor kernel: [   40.447315] Modules linked in: snd_hrtimer 
> > acpi_pad sbs sbshc fan binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
> > snd
> > _hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss 
> > snd_pcm snd_page_alloc snd_seq_dummy snd_seq_oss snd_seq_midi 
> > snd_seq_midi_eve
> > nt snd_rawmidi snd_seq snd_seq_device snd_timer arc4 iTCO_wdt snd gpio_ich 
> > iwl3945 dell_wmi sparse_keymap i2c_i801 iTCO_vendor_support ehci_pci iwlegacy 
> > mac8
> > 0211 cfg80211 soundcore rfkill dell_laptop lpc_ich yenta_socket pcmcia_rsrc 
> > irda 8250 evdev wmi processor dcdbas rtc_cmos battery crc_ccitt ac joydev 
> > sha256_
> > ssse3 sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod sg b44 
> > sr_mod cdrom ssb i915 cfbfillrect cfbimgblt mmc_core mii pcmcia pcmcia_core 
> > uhci_
> > hcd i2c_algo_bit cfbcopyarea firewire_ohci video backlight firewire_core 
> > crc_itu_t drm_kms_helper drm ehci_hcd sd_mod i2c_core thermal thermal_sys 
> > freq_table
> >  usbcore usb_common button intel_agp intel_gtt agpgart
> > Nov 13 09:36:21 maistor kernel: [   40.447384] CPU: 1 PID: 4142 Comm: Xorg 
> > Tainted: P             3.11.6eko2 #3

And there's that taint P again due to the vmware modules.

I know that you tried without the vmware modules where your kernel
wasn't tainted but then you got a #GP which could be something entirely
different. But now you're hitting some sanity-checking code which could
mean there's some corruption happening.

So, can you reproduce that exact same warning, i.e. this one:

WARNING: CPU: 1 PID: 4142 at drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 [i915]()
pipe state doesn't match!

*without* the vmware modules installed?

Also, it wouldn't hurt to try the shiny new 3.12.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
