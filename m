Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbbA2O7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:59:22 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:43036 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbA2O7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:59:19 -0500
From: "S. Gilles" <sgilles@terpmail.umd.edu>
X-Google-Original-From: "S. Gilles" <sgilles@umd.edu>
Date: Thu, 29 Jan 2015 09:59:08 -0500
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: "S. Gilles" <sgilles@terpmail.umd.edu>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maik Broemme <mbroemme@plusserver.de>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: i915 framebuffer init too slow to find logo
Message-ID: <20150129145907.GA2440@number16>
References: <20150129023247.GA10967@number16>
 <54C9EAC3.9040509@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C9EAC3.9040509@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-29T10:09:39+0200, Tomi Valkeinen wrote:
> On 29/01/15 04:32, S. Gilles wrote:
> > Since commit 92b004d1aa9f367c372511ca0330f58216b25703 : prevent use of
> > logs after they have been freed, my i915 machine has no logo on boot
> > (reverting that commit brings it back on recent trees). My .config
> > builds nothing but wireless as =m, so I think this is a genuine false
> > positive (as predicted by the commit). Examining an augmented dmesg,
> 
> It's not so much about modules, but when the code tries to use the
> logos. Drivers as modules might cause the use of logos to happen later,
> but that's only one possible reason.
> 
> > it appears that the framebuffer setup is too slow by about 0.3s, which
> > I wouldn't really expect from this system/driver.
> > 
> > Is this slowness considered worth fixing, or is this issue considered
> > too cosmetic? (Or is this just PEBKAC?)
> > 
> > Possibly useful information:
> > 
> > $ lspci | grep VGA
> > 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
> > 
> > From various printk()s, it looks like the slow portion of
> > fb_console_init() is restore_fbdev_mode(), specifically
> > drm_mode_set_config_internal(), which takes about 0.45s, while the
> > fb_logo_late_init() call happens about 0.15s into that. I can give the
> > full details if requested.
> 
> When does the driver probe() happen? Does the initialization happen
> outside of the probe(), via workqueue or such? If so, then the fix is
> valid for your case also, as the work could be ran after the logos have
> been freed.

It looks like the fix is indeed valid, since the initialization
happens without probe() in the trace: the result of putting
dump_stack() at the beginning of the relevant functions is (in far too
much detail)

...
[    0.302391] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5+ #26
[    0.302476] Hardware name: LENOVO 4286CTO/4286CTO, BIOS 8DET42WW (1.12 ) 04/01/2011
[    0.302561]  ffff880138ffd000 ffff880139563c98 ffffffff817945db 0000000000000126
[    0.302882]  ffffffff81849d20 ffff880139563cc8 ffffffff813b7ec4 ffff880138ffd000
[    0.303189]  ffffffff81848b10 ffffffff81c3ad58 ffff880138ffd090 ffff880139563cf8
[    0.303511] Call Trace:
[    0.303578]  [<ffffffff817945db>] dump_stack+0x45/0x57
[    0.303677]  [<ffffffff813b7ec4>] i915_pci_probe+0x1a/0x68
[    0.303769]  [<ffffffff8131c209>] pci_device_probe+0x54/0xa3
[    0.303850]  [<ffffffff8144367d>] driver_probe_device+0x99/0x1c8
[    0.303916]  [<ffffffff81443841>] __driver_attach+0x5d/0x80
[    0.303980]  [<ffffffff814437e4>] ? __device_attach+0x38/0x38
[    0.305851]  [<ffffffff81441d7c>] bus_for_each_dev+0x7b/0x85
[    0.305914]  [<ffffffff81443240>] driver_attach+0x19/0x1b
[    0.305975]  [<ffffffff81442f28>] bus_add_driver+0x109/0x1d3
[    0.306038]  [<ffffffff81443c20>] driver_register+0x8a/0xc7
[    0.306141]  [<ffffffff8131bf4b>] __pci_register_driver+0x5c/0x60
[    0.306219]  [<ffffffff81d052cc>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9f/0x9f
[    0.306329]  [<ffffffff813a5fa3>] drm_pci_init+0x4d/0xcd
[    0.306428]  [<ffffffff81d052cc>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9f/0x9f
[    0.306505]  [<ffffffff81d05356>] i915_init+0x8a/0x92
[    0.306566]  [<ffffffff81d052cc>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9f/0x9f
[    0.306650]  [<ffffffff8100030d>] do_one_initcall+0xe9/0x172
[    0.306746]  [<ffffffff81ccefb1>] kernel_init_freeable+0x117/0x19f
[    0.306827]  [<ffffffff81cce7c0>] ? initcall_blacklist+0xa3/0xa3
[    0.306926]  [<ffffffff8178e559>] ? rest_init+0xb6/0xb6
[    0.306993]  [<ffffffff8178e562>] kernel_init+0x9/0xd0
[    0.307085]  [<ffffffff8179ceec>] ret_from_fork+0x7c/0xb0
[    0.307176]  [<ffffffff8178e559>] ? rest_init+0xb6/0xb6
...
[    0.646722] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5+ #26
[    0.646723] Hardware name: LENOVO 4286CTO/4286CTO, BIOS 8DET42WW (1.12 ) 04/01/2011
[    0.646726]  ffff8800b5aff000 ffff880139563e78 ffffffff817945db 0000000000000013
[    0.646728]  ffffffff81d00a08 ffff880139563e88 ffffffff81d00a1f ffff880139563ef8
[    0.646730]  ffffffff8100030d 0000000000000000 ffffffff81b7f6b8 0000019d00070007
[    0.646730] Call Trace:
[    0.646733]  [<ffffffff817945db>] dump_stack+0x45/0x57
[    0.646736]  [<ffffffff81d00a08>] ? fb_console_init+0x116/0x116
[    0.646738]  [<ffffffff81d00a1f>] fb_logo_late_init+0x17/0x22
[    0.646741]  [<ffffffff8100030d>] do_one_initcall+0xe9/0x172
[    0.646744]  [<ffffffff81ccefb1>] kernel_init_freeable+0x117/0x19f
[    0.646745]  [<ffffffff81cce7c0>] ? initcall_blacklist+0xa3/0xa3
[    0.646747]  [<ffffffff8178e559>] ? rest_init+0xb6/0xb6
[    0.646749]  [<ffffffff8178e562>] kernel_init+0x9/0xd0
[    0.646752]  [<ffffffff8179ceec>] ret_from_fork+0x7c/0xb0
[    0.646754]  [<ffffffff8178e559>] ? rest_init+0xb6/0xb6
...
[    1.162602] CPU: 1 PID: 6 Comm: kworker/u16:0 Not tainted 3.19.0-rc5+ #26
[    1.162605] Hardware name: LENOVO 4286CTO/4286CTO, BIOS 8DET42WW (1.12 ) 04/01/2011
[    1.162627]  0000000000000018 ffff8801395a3918 ffffffff817945db ffffffff81caeee0
[    1.162634]  0000000000000018 ffff8801395a3938 ffffffff8178f5f7 0000000000000000
[    1.162641]  ffff8800b5ff0c00 ffff8801395a3968 ffffffff813321fb 0000000000000320
[    1.162643] Call Trace:
[    1.162653]  [<ffffffff817945db>] dump_stack+0x45/0x57
[    1.162661]  [<ffffffff8178f5f7>] fb_find_logo+0xd/0x43
[    1.162669]  [<ffffffff813321fb>] fb_prepare_logo+0x87/0x12d
[    1.162675]  [<ffffffff81328fed>] fbcon_prepare_logo+0x7f/0x2e8
[    1.162680]  [<ffffffff8132b3b9>] fbcon_init+0x3d9/0x447
[    1.162688]  [<ffffffff813817de>] visual_init+0xb7/0x10d
[    1.162695]  [<ffffffff81383000>] do_bind_con_driver+0x1ab/0x2cd
[    1.162702]  [<ffffffff813835e1>] do_take_over_console+0x132/0x162
[    1.162707]  [<ffffffff813292ac>] do_fbcon_takeover+0x56/0x9a
[    1.162712]  [<ffffffff8132cb6a>] fbcon_event_notify+0x31c/0x644
[    1.162718]  [<ffffffff810bcf4f>] notifier_call_chain+0x39/0x5c
[    1.162723]  [<ffffffff810bd208>] __blocking_notifier_call_chain+0x47/0x60
[    1.162729]  [<ffffffff810bd230>] blocking_notifier_call_chain+0xf/0x11
[    1.162735]  [<ffffffff81331cc3>] fb_notifier_call_chain+0x16/0x18
[    1.162741]  [<ffffffff81333b50>] register_framebuffer+0x261/0x299
[    1.162750]  [<ffffffff8139bcfb>] drm_fb_helper_initial_config+0x26e/0x328
[    1.162757]  [<ffffffff8141da68>] intel_fbdev_initial_config+0x16/0x18
[    1.162762]  [<ffffffff810be0a0>] async_run_entry_fn+0x33/0xca
[    1.162770]  [<ffffffff810b800b>] process_one_work+0x223/0x3f9
[    1.162775]  [<ffffffff810b7f8f>] ? process_one_work+0x1a7/0x3f9
[    1.162781]  [<ffffffff810b8905>] worker_thread+0x260/0x354
[    1.162788]  [<ffffffff810b86a5>] ? cancel_delayed_work_sync+0x10/0x10
[    1.162794]  [<ffffffff810bc333>] kthread+0xe8/0xf0
[    1.162802]  [<ffffffff810bc24b>] ? kthread_create_on_node+0x1b1/0x1b1
[    1.162810]  [<ffffffff8179ceec>] ret_from_fork+0x7c/0xb0
[    1.162817]  [<ffffffff810bc24b>] ? kthread_create_on_node+0x1b1/0x1b1
...

> However, it does seem that the fix seems to cause logos to disappear for
> many people. I'd be interesting to know how many of those cases were
> working by luck, either by
> 
> 1) an async work being ran fast enough, before the logos had been freed
> 2) the use of logos happening after the logos had been freed, but if no
> one had trashed the logo memory yet, it still works

In my case, it looks like #1 is the case: free_initmem() was called
~6.96s into boot on the run matching the traces above, so the initdata
looks safe barring async trickery.

> I don't care so much about the logo myself but people do seem to like
> it, so perhaps we need to change the code as Thierry suggested:
> allocating memory for the logos and keeping them in memory until someone
> uses them the first time, and then free the memory.

I'm not too concerned about the pixels myself, but I was concerned
that the initialization was happening slow enough to be caught by this
(perhaps this might have been a warning sign if setting up the console
was depending unsafely on other initdata?). It is also rather obvious,
so it's something a novice like myself can easily bisect and report.

-- 
S. Gilles
