Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaGYKKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:10:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45999 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaGYKKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:10:10 -0400
Message-ID: <1406283005.13064.2.camel@gmail.com>
Subject: Re: [Intel-gfx] [BUG?] 3.16-rc6 ... at
 drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12d/0x160()
From: Ian Kumlien <ian.kumlien@gmail.com>
To: imre.deak@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Date: Fri, 25 Jul 2014 12:10:05 +0200
In-Reply-To: <1406280517.17325.3.camel@intelbox>
References: <1406158393.13064.1.camel@gmail.com>
	 <1406280517.17325.3.camel@intelbox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On fre, 2014-07-25 at 12:28 +0300, Imre Deak wrote:
> On Thu, 2014-07-24 at 01:33 +0200, Ian Kumlien wrote:
> > Try four, now including CC lists for the intel driver...
> 
> Could you give a try to the 2 patches at:
> https://patchwork.kernel.org/patch/4437061/
> 
> If these don't fix the issue, could you send a full dmesg log with the
> drm.debug=14 kernel option set?

I will, but the tests will be a bit delayed (earliest tomorrow evening)

> Thanks,
> Imre
> 
> > 
> > ---
> > 
> > Hi again,
> > 
> > 
> > Playing some more with the new kernel release i noticed this:
> > [ 9064.008821] WARNING: CPU: 3 PID: 22929 at drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12d/0x160()
> > [ 9064.008822] Modules linked in: uas bnep b43 mac80211 cfg80211 snd_hda_codec_hdmi btusb bluetooth 6lowpan_iphc rfkill snd_hda_codec_cirrus uvcvideo snd_hda_codec_generic videobuf2_vmalloc videobuf2_memops videobuf2_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer sdhci_pci snd sdhci soundcore mmc_core bcma
> > [ 9064.008839] CPU: 3 PID: 22929 Comm: kworker/3:2 Tainted: G        W     3.16.0-rc6 #23
> > [ 9064.008840] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B03.1211161133 11/16/2012
> > [ 9064.008843] Workqueue: events edp_panel_vdd_work
> > [ 9064.008844]  0000000000000009 ffff88015ba77d28 ffffffff8198ea2d 0000000000000000
> > [ 9064.008846]  ffff88015ba77d60 ffffffff810cbac8 ffff8802610b002c 00000000000c7204
> > [ 9064.008848]  0000000000000001 ffff8802610b80f0 ffff8802610b0000 ffff88015ba77d70
> > [ 9064.008850] Call Trace:
> > [ 9064.008854]  [<ffffffff8198ea2d>] dump_stack+0x4e/0x7a
> > [ 9064.008857]  [<ffffffff810cbac8>] warn_slowpath_common+0x78/0xa0
> > [ 9064.008858]  [<ffffffff810cbba5>] warn_slowpath_null+0x15/0x20
> > [ 9064.008860]  [<ffffffff815bdb3d>] intel_display_power_put+0x12d/0x160
> > [ 9064.008862]  [<ffffffff8161e084>] edp_panel_vdd_off_sync+0xf4/0x1c0
> > [ 9064.008863]  [<ffffffff8161e17f>] edp_panel_vdd_work+0x2f/0x40
> > [ 9064.008866]  [<ffffffff810e63be>] process_one_work+0x16e/0x480
> > [ 9064.008868]  [<ffffffff810e6cbb>] worker_thread+0x11b/0x520
> > [ 9064.008870]  [<ffffffff810e6ba0>] ? create_and_start_worker+0x50/0x50
> > [ 9064.008872]  [<ffffffff810ecb24>] kthread+0xc4/0xe0
> > [ 9064.008874]  [<ffffffff810eca60>] ? kthread_create_on_node+0x170/0x170
> > [ 9064.008877]  [<ffffffff81997e6c>] ret_from_fork+0x7c/0xb0
> > [ 9064.008878]  [<ffffffff810eca60>] ? kthread_create_on_node+0x170/0x170
> > [ 9064.008880] ---[ end trace 17f9738f20aec288 ]---
> > ----
> > 
> > 
> > I had multiples of them in my dmesg, however, this seems to fix it:
> > diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> > index 8a1a4fb..4c3249d 100644
> > --- a/drivers/gpu/drm/i915/intel_dp.c
> > +++ b/drivers/gpu/drm/i915/intel_dp.c
> > @@ -1252,6 +1252,7 @@ static void edp_panel_vdd_off_sync(struct intel_dp *intel_dp)
> >                         intel_dp->last_power_cycle = jiffies;
> >  
> >                 power_domain = intel_display_port_power_domain(intel_encoder);
> > +               intel_display_power_get(dev_priv, power_domain);
> >                 intel_display_power_put(dev_priv, power_domain);
> >         }
> >  }
> > @@ -1371,6 +1372,7 @@ void intel_edp_panel_off(struct intel_dp *intel_dp)
> >  
> >         /* We got a reference when we enabled the VDD. */
> >         power_domain = intel_display_port_power_domain(intel_encoder);
> > +       intel_display_power_get(dev_priv, power_domain);
> >         intel_display_power_put(dev_priv, power_domain);
> >  }
> > ---
> > 
> > 
> > The question however is: Is this the correct approach? Should it be done
> > differently?
> > (This handles the "close and open lid" usecase, i don't know if there
> > are others, a grep indicated that there might be two more missing...)
> > 
> > 
> > 
> > 
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 


