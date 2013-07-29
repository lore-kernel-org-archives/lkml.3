Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3G2UMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab3G2UMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:12:41 -0400
Date: Mon, 29 Jul 2013 16:12:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: xingchao.wang@linux.intel.com, tiwai@suse.de, liam.r.girdwood@intel.com,
        david.henningsson@canonical.com, daniel.vetter@ffwll.ch,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ALSA: hda - Add power-welll support for haswell HDA
Message-ID: <20130729201208.GA21037@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	xingchao.wang@linux.intel.com, tiwai@suse.de,
	liam.r.girdwood@intel.com, david.henningsson@canonical.com,
	daniel.vetter@ffwll.ch,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130709233626.3E8F4660AF6@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709233626.3E8F4660AF6@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 11:36:26PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=99a2008d0b32d72dfc2a54e7be1eb698dd2e3bd6
 > Commit:     99a2008d0b32d72dfc2a54e7be1eb698dd2e3bd6
 > Parent:     5c90680e42b08a1e4a6800ca02e75ad201f8037f
 > Author:     Wang Xingchao <xingchao.wang@linux.intel.com>
 > AuthorDate: Thu May 30 22:07:10 2013 +0800
 > Committer:  Daniel Vetter <daniel.vetter@ffwll.ch>
 > CommitDate: Thu Jun 6 17:31:56 2013 +0200
 > 
 >     ALSA: hda - Add power-welll support for haswell HDA
 >     
 >     For Intel Haswell chip, HDA controller and codec have
 >     power well dependency from GPU side. This patch added support
 >     to request/release power well in audio driver. Power save
 >     feature should be enabled to get runtime power saving.
 >     
 >     There's deadlock when request_module(i915) in azx_probe.
 >     It looks like:
 >     device_lock(audio pci device) -> azx_probe -> module_request
 >     (or symbol_request) -> modprobe (userspace) -> i915 init ->
 >     drm_pci_init -> pci_register_driver -> bus_add_driver -> driver_attach ->
 >     which in turn tries all locks on pci bus, and when it tries the one on the
 >     audio device, it will deadlock.
 >     
 >     This patch introduce a work to store remaining probe stuff, and let
 >     request_module run in safe work context.

That deadlock sounds nasty, but..

 > +#ifdef CONFIG_SND_HDA_I915
 > +		probe_now = false;
 > +		schedule_work(&chip->probe_work);
 > +#else
 > +		snd_printk(KERN_ERR SFX "Haswell must build in CONFIG_SND_HDA_I915\n");
 > +#endif

runtime surprises like this are also a pain. There has to be a way in Kconfig
to express this (through addition of a new option). Though having to build this
in for distro kernels is also unfortunate. This means we'll also have to build-in
all the ALSA stuff even for users who never use it.

	Dave

