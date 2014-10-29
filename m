Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaJ2Hoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:44:46 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:51935 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaJ2Hoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:44:44 -0400
Date: Wed, 29 Oct 2014 08:41:34 +0100
From: Johan Hovold <johan@kernel.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Johan Hovold <johan@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel.vetter@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: NULL derefs after failed suspend (i915, pm, ext4, slub)
Message-ID: <20141029074134.GB7841@localhost>
References: <20141028142910.GU2006@localhost>
 <87zjcgjkti.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjcgjkti.fsf@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 05:06:01PM +0200, Jani Nikula wrote:
> On Tue, 28 Oct 2014, Johan Hovold <johan@kernel.org> wrote:
> > Hi, 
> >
> > I have had some problems with crashes involving suspend-to-disk after
> > updating to v3.16.
> >
> > Below is a log with 3.16.6 from a failed suspend attempt after which I
> > get a NULL deref in ext4 code.
> >
> > A couple of weeks ago I got something similar, with backtraces from 
> > ext4 (ext4_alloc_inode) and NULL-derefs in vfs (vfs_get_attr_nosec) when
> > trying to do IO after resuming from suspend. That was with 3.16.3 and I
> > was hoping that whatever it was would have been fixed in 3.16.6 (there
> > were some ext4 error handling patches in there). I only got photos of
> > those oopses but it involved kmem_cache_alloc (slub) and a NULL-deref in
> > vfs_get_attr_nosec. I can put the photos up somewhere. That time I also
> > got back to X and could issue a dmesg in an xterm, but any process trying
> > to do IO died.
> >
> > Something similar happened with 3.16.1 but unfortunately I do not have
> > any logs from that.
> >
> > I also have experienced occasional hangs during suspend, but I believe I
> > have seen this with older kernels as well so not sure if related. Seems
> > to be more frequent with 3.16.
> >
> > This is my main machine so not keen on trying to bisect this on it.
> >
> > It's an i7-4770 on an Intel DH87MC using the integrated HD Graphics 4600.
> >
> > I'm CCing the Intel graphics guys due to some errors drm errors in the
> > logs, and reports of other people having problems involving suspend and
> > this driver.
> 
> My first suggestion would be to try to reproduce the NULL deref without
> i915 loaded, and track the issues you have independently.

I actually don't think this is i915 related, the new drm errors after
failed suspend could possibly just be a side effect of whatever is
causing the apparent memory corruption. As I mentioned, the first log I
have of this do not seem to point at i915 (even if backlight-restore
happens when tasks are restarted).

> Please file any i915 issues against DRM/Intel at [1].

I'll see if I can get around to that. There are bug reports in various
distro tracker about the intel_ddi_pll_enable warning dating back to
April.

It's there on every resume. For instance this morning:

[108109.324398] WARNING: CPU: 1 PID: 7298 at /home/johan/src/linux/linux-xi/drivers/gpu/drm/i915/intel_ddi.c:911 intel_ddi_pll_enable+0x233/0x240()
[108109.324398] WRPLL1 already enabled
[108109.324399] Modules linked in:
[108109.324400] CPU: 1 PID: 7298 Comm: kworker/u16:8 Tainted: G        W     3.16.6 #1
[108109.324401] Hardware name:                  /DH87MC, BIOS MCH8710H.86A.0154.2014.0123.1542 01/23/2014
[108109.324403] Workqueue: events_unbound async_run_entry_fn
[108109.324405]  0000000000000000 0000000000000009 ffffffff81739c03 ffff88053e89baf8
[108109.324405]  ffffffff810850f6 ffff8807fadf0000 00000000b035061f 0000000000000001
[108109.324406]  0000000000046040 ffffffff81a10a41 ffffffff810851d5 ffffffff81a10a83
[108109.324407] Call Trace:
[108109.324410]  [<ffffffff81739c03>] ? dump_stack+0x49/0x6a
[108109.324412]  [<ffffffff810850f6>] ? warn_slowpath_common+0x86/0xb0
[108109.324414]  [<ffffffff810851d5>] ? warn_slowpath_fmt+0x45/0x50
[108109.324415]  [<ffffffff814445c3>] ? intel_ddi_pll_enable+0x233/0x240
[108109.324417]  [<ffffffff814208ea>] ? haswell_crtc_mode_set+0x1a/0x30
[108109.324419]  [<ffffffff8142e168>] ? __intel_set_mode+0x6a8/0x1590
[108109.324420]  [<ffffffff814335f7>] ? intel_modeset_setup_hw_state+0x817/0xd10
[108109.324422]  [<ffffffff813d4ae9>] ? drm_modeset_lock_all_crtcs+0x39/0x50
[108109.324424]  [<ffffffff81328570>] ? pci_pm_suspend_noirq+0x1b0/0x1b0
[108109.324426]  [<ffffffff813d719e>] ? __i915_drm_thaw+0x11e/0x1a0
[108109.324426]  [<ffffffff813d786f>] ? i915_resume+0x1f/0x40
[108109.324428]  [<ffffffff814749ef>] ? dpm_run_callback+0x4f/0x150
[108109.324428]  [<ffffffff814756b3>] ? device_resume+0x93/0x1d0
[108109.324429]  [<ffffffff81475804>] ? async_resume+0x14/0x40
[108109.324430]  [<ffffffff810aaabd>] ? async_run_entry_fn+0x2d/0x120
[108109.324433]  [<ffffffff8109eb58>] ? process_one_work+0x158/0x410
[108109.324434]  [<ffffffff8109f376>] ? worker_thread+0x116/0x510
[108109.324435]  [<ffffffff810c11ec>] ? __wake_up_common+0x4c/0x80
[108109.324436]  [<ffffffff8109f260>] ? init_pwq+0x160/0x160
[108109.324437]  [<ffffffff810a538c>] ? kthread+0xbc/0xe0
[108109.324439]  [<ffffffff810a0000>] ? workqueue_sysfs_register+0x110/0x150
[108109.324440]  [<ffffffff810a52d0>] ? kthread_freezable_should_stop+0x60/0x60
[108109.324442]  [<ffffffff81741aac>] ? ret_from_fork+0x7c/0xb0
[108109.324443]  [<ffffffff810a52d0>] ? kthread_freezable_should_stop+0x60/0x60

Thanks,
Johan
