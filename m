Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaAZLLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 06:11:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:51860 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaAZLLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 06:11:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,723,1384329600"; 
   d="txt'?scan'208";a="472596648"
Message-ID: <1390734675.2487.14.camel@ideak-mobl>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: fix dp/sdvo i2c cleanup
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jan 2014 13:11:15 +0200
In-Reply-To: <CAKMK7uGQ-jj7rUzoJ4MuTMzbASBP_1wjnC0DEuOivd6SA8FBQA@mail.gmail.com>
References: <1390554955-26380-1-git-send-email-imre.deak@intel.com>
	 <1390567654-27547-1-git-send-email-imre.deak@intel.com>
	 <20140125203737.GN9772@phenom.ffwll.local>
	 <1390697490.4025.29.camel@ideak-mobl>
	 <CAKMK7uGQ-jj7rUzoJ4MuTMzbASBP_1wjnC0DEuOivd6SA8FBQA@mail.gmail.com>
Organization: Intel
Content-Type: multipart/mixed; boundary="=-yzyLkoL29HDpSoXBWinE"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yzyLkoL29HDpSoXBWinE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Sun, 2014-01-26 at 10:21 +0100, Daniel Vetter wrote:
> On Sun, Jan 26, 2014 at 1:51 AM, Imre Deak <imre.deak@intel.com> wrote:
> > On Sat, 2014-01-25 at 21:37 +0100, Daniel Vetter wrote:
> >> On Fri, Jan 24, 2014 at 02:47:33PM +0200, Imre Deak wrote:
> >> > Atm we try to remove the connector's i2c sysfs entry too late in the
> >> > encoder's destroy callback. By that time the kobject used as the parent
> >> > for all connector sysfs entries is already removed when we do an early
> >> > removal of all connector sysfs entries in intel_modeset_cleanup(). Fix
> >> > this by adding an early_destroy encoder callback, where we remove the
> >> > encoder's i2c adapter.
> >> >
> >> > v2:
> >> > - add missing static to function, use existing sdvo cast helper,
> >> >   s/intel_sdvo/sdvo/ (Chris)
> >> >
> >> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=70523
> >> >
> >> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> >>
> >> This looks fishy ... sysfs should all be reference-counted, so I'm
> >> confused what's going on here. Also I think this smells a bit like it's
> >> going overall in the wrong direction - essentially with sysfs we can't
> >> really force-remove stuff but have to wait until the refcount drops to 0.
> >> Or at least that's how I think it works, I'd need to blow through a pile
> >> of time to figure this all out.
> >
> > Hm, I haven't thought about refcounting :) Now, I agree that should
> > normally allow for removing a parent and child device in both order.
> >
> > What happens and why we can't remove first the parent then the child:
> >
> > In
> >
> > intel_dp_init_connector()->
> >   intel_dp_i2c_init()
> >
> > we set the i2c adapter.dev.parent = intel_connector->base.kdev;
> >
> > device_register will then add the i2c sysfs entry to the connector sysfs
> > dir. Refcounting here looks ok, both the parent connector kobject and
> > its sysfs dir entry gets a reference from the child.
> >
> > During module cleanup, we call
> >
> > intel_modeset_cleanup()->
> >   drm_sysfs_connector_remove()
> >     device_unregister(connector->kdev)
> >
> > which is the i2c adapter's parent kdev. Then:
> >
> > device_del()->
> >   kobject_del()->
> >     sysfs_remove_dir()
> >
> > will remove all entries recursively in the connector's sysfs dir, along
> > with all the i2c sysfs entries. Afterwards the intel encoder->destroy()
> > callback calls i2c_del_adapter()->device_unregister()->device_del() and
> > that will try to remove its own sysfs attributes, namely the power sysfs
> > group, but won't find it since it was removed above and give a WARN.
> >
> > Note that the parent's recursive removal happens regardless of its
> > kobject's or sysfs entry's refcount. The kobject itself will be put
> > after device_del() in put_device() and only destroyed after the i2c
> > adapter releases the refcount it holds on it. I admit it feels strange
> > that the sysfs entries are removed before the last reference on the
> > kobject is dropped, not sure if it's by design or an overlook..
> 
> I have no idea either how exactly this is supposed to work, and I
> quick scan through Documentation/ didn't point me into a useful
> direction either.
> 
> Adding Greg (and more mailing lists) for insight.

Attached the corresponding dmesg.

Also one more thought. Imo whether or not it's a valid thing to delete
first a parent device and only then its child device, in this case we
don't have a reason to do so. We created first the connector device
(parent) and then the i2c adapter device (child) and the cleanup should
happen in reverse order. This is so regardless of what order the
corresponding kobjects get destroyed based on their refcounts.

--Imre

--=-yzyLkoL29HDpSoXBWinE
Content-Disposition: attachment; filename="dmesg.txt"
Content-Type: text/plain; name="dmesg.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[ 7516.461543] WARNING: CPU: 1 PID: 4976 at fs/sysfs/group.c:215 sysfs_remove_group+0x5e/0xc0()
[ 7516.461555] sysfs group ffffffff81d11960 not found for kobject 'i2c-6' name 'power'
[ 7516.461566] Modules linked in: tun ccm fuse snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy snd_seq_oss arc4 snd_seq_midi iwldvm mac80211 snd_rawmidi i915(-) serio_raw snd_seq_midi_event snd_seq iwlwifi snd_seq_device btusb bnep rfcomm snd_timer bluetooth cfbfillrect thinkpad_acpi cfg80211 cfbimgblt tpm_tis tpm i2c_algo_bit cfbcopyarea snd lpc_ich drm_kms_helper rfkill drm mfd_core intel_smartconnect wmi soundcore vfat fat usbhid [last unloaded: snd_hda_intel]
[ 7516.461739] CPU: 1 PID: 4976 Comm: rmmod Not tainted 3.13.0-rc8+ #38
[ 7516.461763] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
[ 7516.461788]  0000000000000009 ffff8800d36f5b90 ffffffff816fd5bc ffff8800d36f5bd8
[ 7516.461830]  ffff8800d36f5bc8 ffffffff81057bcc ffffffff81d11960 0000000000000000
[ 7516.461860]  ffff8800d494a1b8 ffff8800d494a1a8 ffff8800d494a290 ffff8800d36f5c28
[ 7516.461890] Call Trace:
[ 7516.461908]  [<ffffffff816fd5bc>] dump_stack+0x4e/0x7a
[ 7516.461931]  [<ffffffff81057bcc>] warn_slowpath_common+0x8c/0xc0
[ 7516.461953]  [<ffffffff81057cbc>] warn_slowpath_fmt+0x4c/0x50
[ 7516.461974]  [<ffffffff8170440e>] ? mutex_unlock+0xe/0x10
[ 7516.462003]  [<ffffffff81234b1f>] ? sysfs_get_dirent_ns+0x6f/0x80
[ 7516.462027]  [<ffffffff81235c5e>] sysfs_remove_group+0x5e/0xc0
[ 7516.462049]  [<ffffffff8141382c>] dpm_sysfs_remove+0x3c/0x40
[ 7516.462071]  [<ffffffff81409943>] device_del+0x43/0x1b0
[ 7516.462092]  [<ffffffff81409af8>] device_unregister+0x48/0x60
[ 7516.462114]  [<ffffffff81544b77>] i2c_del_adapter+0x277/0x350
[ 7516.462169]  [<ffffffffa02c0502>] intel_dp_encoder_destroy+0x32/0x90 [i915]
[ 7516.462216]  [<ffffffffa004cd17>] drm_mode_config_cleanup+0x67/0x2a0 [drm]
[ 7516.462270]  [<ffffffffa02b4590>] intel_modeset_cleanup+0xd0/0x110 [i915]
[ 7516.462310]  [<ffffffffa0277675>] i915_driver_unload+0xc5/0x2f0 [i915]
[ 7516.462345]  [<ffffffffa004562c>] drm_dev_unregister+0x2c/0xb0 [drm]
[ 7516.462380]  [<ffffffffa0045a28>] drm_put_dev+0x58/0x70 [drm]
[ 7516.462413]  [<ffffffffa027380d>] i915_pci_remove+0x1d/0x20 [i915]
[ 7516.462432]  [<ffffffff813458a2>] pci_device_remove+0x52/0xd0
[ 7516.462456]  [<ffffffff8140ce4f>] __device_release_driver+0x8f/0xf0
[ 7516.462478]  [<ffffffff8140d90b>] driver_detach+0x9b/0xd0
[ 7516.462501]  [<ffffffff8140cc10>] bus_remove_driver+0xa0/0xc0
[ 7516.462525]  [<ffffffff8140dfd9>] driver_unregister+0x49/0x50
[ 7516.462545]  [<ffffffff813452d2>] pci_unregister_driver+0x22/0xa0
[ 7516.462585]  [<ffffffffa0047d07>] drm_pci_exit+0x47/0xd0 [drm]
[ 7516.462644]  [<ffffffffa02f5afc>] i915_exit+0x20/0x22 [i915]
[ 7516.462668]  [<ffffffff810db024>] SyS_delete_module+0x194/0x250
[ 7516.462719]  [<ffffffff8131b54e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 7516.462749]  [<ffffffff8170df52>] system_call_fastpath+0x16/0x1b

--=-yzyLkoL29HDpSoXBWinE--

