Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaJASnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:43:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaJASm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:42:58 -0400
Date: Wed, 1 Oct 2014 11:42:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] Route keyboard LEDs through the generic LEDs layer.
Message-Id: <20141001114257.f0f6a94508bdd7df83602eda@linux-foundation.org>
In-Reply-To: <20140331122323.GC6044@type.bordeaux.inria.fr>
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 14:23:23 +0200 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> This permits to reassign keyboard LEDs to something else than keyboard "leds"
> state, by adding keyboard led and modifier triggers connected to a series
> of VT input LEDs, themselves connected to VT input triggers, which
> per-input device LEDs use by default.  Userland can thus easily change the LED
> behavior of (a priori) all input devices, or of particular input devices.
> 
> This also permits to fix #7063 from userland by using a modifier to implement
> proper CapsLock behavior and have the keyboard caps lock led show that modifier
> state.

When this patch is combined with current linux-next I'm getting the
below lockdep splat.  Config: http://ozlabs.org/~akpm/config-akpm2.txt

[    4.304279] 
[    4.304280] =============================================
[    4.304281] [ INFO: possible recursive locking detected ]
[    4.304283] 3.17.0-rc7-mm1 #5 Not tainted
[    4.304284] ---------------------------------------------
[    4.304285] kworker/6:1/398 is trying to acquire lock:
[    4.304294]  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffff81385474>] led_trigger_event+0x22/0x6b
[    4.304294] 
[    4.304294] but task is already holding lock:
[    4.304298]  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffff81385474>] led_trigger_event+0x22/0x6b
[    4.304299] 
[    4.304299] other info that might help us debug this:
[    4.304300]  Possible unsafe locking scenario:
[    4.304300] 
[    4.304301]        CPU0
[    4.304301]        ----
[    4.304303]   lock(&trig->leddev_list_lock);
[    4.304305]   lock(&trig->leddev_list_lock);
[    4.304306] 
[    4.304306]  *** DEADLOCK ***
[    4.304306] 
[    4.304307]  May be due to missing lock nesting notation
[    4.304307] 
[    4.304308] 11 locks held by kworker/6:1/398:
[    4.304315]  #0:  ("events_long"){.+.+.+}, at: [<ffffffff810542db>] process_one_work+0x1af/0x39d
[    4.304319]  #1:  (serio_event_work){+.+.+.}, at: [<ffffffff810542db>] process_one_work+0x1af/0x39d
[    4.304326]  #2:  (serio_mutex){+.+.+.}, at: [<ffffffff81350c83>] serio_handle_event+0x19/0x1f1
[    4.304332]  #3:  (&dev->mutex){......}, at: [<ffffffff812b6fb9>] __driver_attach+0x39/0x80
[    4.304336]  #4:  (&dev->mutex){......}, at: [<ffffffff812b6fc7>] __driver_attach+0x47/0x80
[    4.304341]  #5:  (&serio->drv_mutex){+.+.+.}, at: [<ffffffff813505cd>] serio_connect_driver+0x24/0x48
[    4.304346]  #6:  (input_mutex){+.+.+.}, at: [<ffffffff813554d2>] input_register_device+0x2e9/0x3c0
[    4.304351]  #7:  (vt_led_registered_lock){+.+.+.}, at: [<ffffffff81357a0d>] input_led_connect+0x50/0x1ff
[    4.304355]  #8:  (triggers_list_lock){++++.+}, at: [<ffffffff813858dc>] led_trigger_set_default+0x2b/0x88
[    4.304359]  #9:  (&led_cdev->trigger_lock){+.+.+.}, at: [<ffffffff813858e4>] led_trigger_set_default+0x33/0x88
[    4.304363]  #10:  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffff81385474>] led_trigger_event+0x22/0x6b
[    4.304364] 
[    4.304364] stack backtrace:
[    4.304367] CPU: 6 PID: 398 Comm: kworker/6:1 Not tainted 3.17.0-rc7-mm1 #5
[    4.304368] Hardware name:  , BIOS Bridgeport CRB BIOS 73 external 2006-08-05
[    4.304371] Workqueue: events_long serio_handle_event
[    4.304374]  ffffffff82190450 ffff880255b577f8 ffffffff81463e05 ffffffff82a886e0
[    4.304377]  ffff880255890850 ffff880255b578b8 ffffffff81076fef ffff880255b57838
[    4.304379]  ffffffff82190450 ffff880200000000 ffff880255891258 ffff880355b57848
[    4.304380] Call Trace:
[    4.304384]  [<ffffffff81463e05>] dump_stack+0x49/0x5c
[    4.304387]  [<ffffffff81076fef>] validate_chain+0x741/0xf93
[    4.304390]  [<ffffffff81074ef4>] ? check_usage_backwards+0x9a/0xd3
[    4.304394]  [<ffffffff81063689>] ? sched_clock_local+0x1c/0x82
[    4.304396]  [<ffffffff810781bb>] __lock_acquire+0x97a/0xa29
[    4.304398]  [<ffffffff81074248>] ? mark_lock+0x475/0x5a4
[    4.304400]  [<ffffffff81078314>] lock_acquire+0xaa/0xc4
[    4.304402]  [<ffffffff81385474>] ? led_trigger_event+0x22/0x6b
[    4.304405]  [<ffffffff81468da2>] _raw_read_lock+0x34/0x69
[    4.304408]  [<ffffffff81385474>] ? led_trigger_event+0x22/0x6b
[    4.304410]  [<ffffffff81385474>] led_trigger_event+0x22/0x6b
[    4.304412]  [<ffffffff81357831>] vt_led_set+0x32/0x34
[    4.304415]  [<ffffffff81384e23>] led_set_brightness+0x49/0x4b
[    4.304417]  [<ffffffff81385490>] led_trigger_event+0x3e/0x6b
[    4.304421]  [<ffffffff812924ff>] kbd_ledstate_trigger_activate+0x49/0x52
[    4.304423]  [<ffffffff813855f8>] led_trigger_set+0xfd/0x13b
[    4.304426]  [<ffffffff81467227>] ? down_write+0x8c/0xa4
[    4.304428]  [<ffffffff813858e4>] ? led_trigger_set_default+0x33/0x88
[    4.304430]  [<ffffffff81385909>] led_trigger_set_default+0x58/0x88
[    4.304433]  [<ffffffff813852b2>] led_classdev_register+0x124/0x12f
[    4.304435]  [<ffffffff81357a70>] input_led_connect+0xb3/0x1ff
[    4.304437]  [<ffffffff8135550a>] input_register_device+0x321/0x3c0
[    4.304441]  [<ffffffff8135cd67>] atkbd_connect+0x235/0x27e
[    4.304443]  [<ffffffff813505d8>] serio_connect_driver+0x2f/0x48
[    4.304447]  [<ffffffff8117efe5>] ? sysfs_create_link+0x2a/0x2c
[    4.304449]  [<ffffffff8135060c>] serio_driver_probe+0x1b/0x1d
[    4.304451]  [<ffffffff812b6e6e>] driver_probe_device+0xac/0x1be
[    4.304453]  [<ffffffff812b6fdc>] __driver_attach+0x5c/0x80
[    4.304455]  [<ffffffff812b6f80>] ? driver_probe_device+0x1be/0x1be
[    4.304457]  [<ffffffff812b56e6>] bus_for_each_dev+0x56/0x94
[    4.304460]  [<ffffffff812b6be2>] driver_attach+0x19/0x1b
[    4.304462]  [<ffffffff81350dcd>] serio_handle_event+0x163/0x1f1
[    4.304464]  [<ffffffff81054342>] process_one_work+0x216/0x39d
[    4.304466]  [<ffffffff810542db>] ? process_one_work+0x1af/0x39d
[    4.304468]  [<ffffffff8105482f>] worker_thread+0x366/0x442
[    4.304470]  [<ffffffff810747e0>] ? trace_hardirqs_on+0xd/0xf
[    4.304472]  [<ffffffff810544c9>] ? process_one_work+0x39d/0x39d
[    4.304475]  [<ffffffff81058390>] kthread+0xe1/0xe9
[    4.304478]  [<ffffffff810582af>] ? __init_kthread_worker+0x56/0x56
[    4.304481]  [<ffffffff8146922c>] ret_from_fork+0x7c/0xb0
[    4.304483]  [<ffffffff810582af>] ? __init_kthread_worker+0x56/0x56





