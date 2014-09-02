Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaIBRCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:02:49 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:63130 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaIBRCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:02:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1409021101450.2481@pobox.suse.cz>
References: <alpine.LNX.2.00.1409021101450.2481@pobox.suse.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 2 Sep 2014 10:02:26 -0700
Message-ID: <CAK5ve-KnjD58aAsqdtYSNgmZt7mNCP5fsr809y7D1_AtBaB7wg@mail.gmail.com>
Subject: Re: [PATCH] Revert "leds: convert blink timer to workqueue"
To: Jiri Kosina <jkosina@suse.cz>
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 2:03 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> This reverts commit 8b37e1bef5a6b60e949e28a4db3006e4b00bd758.
>
> It's broken as it changes led_blink_set() in a way that it can now sleep
> (while synchronously waiting for workqueue to be cancelled). That's a
> problem, because it's possible that this function gets called from atomic
> context (tpt_trig_timer() takes a readlock and thus disables preemption).
>
> This has been brought up 3 weeks ago already [1] but no proper fix has
> materialized, and I keep seeing the problem since 3.18-rc1.
>

Is this 3.18-rc1? I think it should be 3.17-rc1, right?

-Bryan


> [1] https://lkml.org/lkml/2014/8/16/128
>
>  BUG: sleeping function called from invalid context at kernel/workqueue.c:2650
>  in_atomic(): 1, irqs_disabled(): 0, pid: 2335, name: wpa_supplicant
>  5 locks held by wpa_supplicant/2335:
>   #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814c7c92>] rtnl_lock+0x12/0x20
>   #1:  (&wdev->mtx){+.+.+.}, at: [<ffffffffc06e649c>] cfg80211_mgd_wext_siwessid+0x5c/0x180 [cfg80211]
>   #2:  (&local->mtx){+.+.+.}, at: [<ffffffffc0817dea>] ieee80211_prep_connection+0x17a/0x9a0 [mac80211]
>   #3:  (&local->chanctx_mtx){+.+.+.}, at: [<ffffffffc08081ed>] ieee80211_vif_use_channel+0x5d/0x2a0 [mac80211]
>   #4:  (&trig->leddev_list_lock){.+.+..}, at: [<ffffffffc081e68c>] tpt_trig_timer+0xec/0x170 [mac80211]
>  CPU: 0 PID: 2335 Comm: wpa_supplicant Not tainted 3.17.0-rc3 #1
>  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>   ffff8800360b5a50 ffff8800751f76d8 ffffffff8159e97f ffff8800360b5a30
>   ffff8800751f76e8 ffffffff810739a5 ffff8800751f77b0 ffffffff8106862f
>   ffffffff810685d0 0aa2209200000000 ffff880000000004 ffff8800361c59d0
>  Call Trace:
>   [<ffffffff8159e97f>] dump_stack+0x4d/0x66
>   [<ffffffff810739a5>] __might_sleep+0xe5/0x120
>   [<ffffffff8106862f>] flush_work+0x5f/0x270
>   [<ffffffff810685d0>] ? mod_delayed_work_on+0x80/0x80
>   [<ffffffff810945ca>] ? mark_held_locks+0x6a/0x90
>   [<ffffffff81068a5f>] ? __cancel_work_timer+0x6f/0x100
>   [<ffffffff810946ed>] ? trace_hardirqs_on_caller+0xfd/0x1c0
>   [<ffffffff81068a6b>] __cancel_work_timer+0x7b/0x100
>   [<ffffffff81068b0e>] cancel_delayed_work_sync+0xe/0x10
>   [<ffffffff8147cf3b>] led_blink_set+0x1b/0x40
>   [<ffffffffc081e6b0>] tpt_trig_timer+0x110/0x170 [mac80211]
>   [<ffffffffc081ecdd>] ieee80211_mod_tpt_led_trig+0x9d/0x160 [mac80211]
>   [<ffffffffc07e4278>] __ieee80211_recalc_idle+0x98/0x140 [mac80211]
>   [<ffffffffc07e59ce>] ieee80211_idle_off+0xe/0x10 [mac80211]
>   [<ffffffffc0804e5b>] ieee80211_add_chanctx+0x3b/0x220 [mac80211]
>   [<ffffffffc08062e4>] ieee80211_new_chanctx+0x44/0xf0 [mac80211]
>   [<ffffffffc080838a>] ieee80211_vif_use_channel+0x1fa/0x2a0 [mac80211]
>   [<ffffffffc0817df8>] ieee80211_prep_connection+0x188/0x9a0 [mac80211]
>   [<ffffffffc081c246>] ieee80211_mgd_auth+0x256/0x2e0 [mac80211]
>   [<ffffffffc07eab33>] ieee80211_auth+0x13/0x20 [mac80211]
>   [<ffffffffc06cb006>] cfg80211_mlme_auth+0x106/0x270 [cfg80211]
>   [<ffffffffc06ce085>] cfg80211_conn_do_work+0x155/0x3b0 [cfg80211]
>   [<ffffffffc06cf670>] cfg80211_connect+0x3f0/0x540 [cfg80211]
>   [<ffffffffc06e6148>] cfg80211_mgd_wext_connect+0x158/0x1f0 [cfg80211]
>   [<ffffffffc06e651e>] cfg80211_mgd_wext_siwessid+0xde/0x180 [cfg80211]
>   [<ffffffffc06e36c0>] ? cfg80211_wext_giwessid+0x50/0x50 [cfg80211]
>   [<ffffffffc06e36dd>] cfg80211_wext_siwessid+0x1d/0x40 [cfg80211]
>   [<ffffffff81584d0c>] ioctl_standard_iw_point+0x14c/0x3e0
>   [<ffffffff810946ed>] ? trace_hardirqs_on_caller+0xfd/0x1c0
>   [<ffffffff8158502a>] ioctl_standard_call+0x8a/0xd0
>   [<ffffffff81584fa0>] ? ioctl_standard_iw_point+0x3e0/0x3e0
>   [<ffffffff81584b76>] wireless_process_ioctl.constprop.10+0xb6/0x100
>   [<ffffffff8158521d>] wext_handle_ioctl+0x5d/0xb0
>   [<ffffffff814cfb29>] dev_ioctl+0x329/0x620
>   [<ffffffff810946ed>] ? trace_hardirqs_on_caller+0xfd/0x1c0
>   [<ffffffff8149c7f2>] sock_ioctl+0x142/0x2e0
>   [<ffffffff811b0140>] do_vfs_ioctl+0x300/0x520
>   [<ffffffff815a67fb>] ? sysret_check+0x1b/0x56
>   [<ffffffff810946ed>] ? trace_hardirqs_on_caller+0xfd/0x1c0
>   [<ffffffff811b03e1>] SyS_ioctl+0x81/0xa0
>   [<ffffffff815a67d6>] system_call_fastpath+0x1a/0x1f
>  wlan0: send auth to 00:0b:6b:3c:8c:e4 (try 1/3)
>  wlan0: authenticated
>  wlan0: associate with 00:0b:6b:3c:8c:e4 (try 1/3)
>  wlan0: RX AssocResp from 00:0b:6b:3c:8c:e4 (capab=0x431 status=0 aid=2)
>  wlan0: associated
>  IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>  cfg80211: Calling CRDA for country: NA
>  wlan0: Limiting TX power to 27 (27 - 0) dBm as advertised by 00:0b:6b:3c:8c:e4
>
>  =================================
>  [ INFO: inconsistent lock state ]
>  3.17.0-rc3 #1 Not tainted
>  ---------------------------------
>  inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>  swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
>   ((&(&led_cdev->blink_work)->work)){+.?...}, at: [<ffffffff810685d0>] flush_work+0x0/0x270
>  {SOFTIRQ-ON-W} state was registered at:
>    [<ffffffff81094dbe>] __lock_acquire+0x30e/0x1a30
>    [<ffffffff81096c81>] lock_acquire+0x91/0x110
>    [<ffffffff81068608>] flush_work+0x38/0x270
>    [<ffffffff81068a6b>] __cancel_work_timer+0x7b/0x100
>    [<ffffffff81068b0e>] cancel_delayed_work_sync+0xe/0x10
>    [<ffffffff8147cf3b>] led_blink_set+0x1b/0x40
>    [<ffffffffc081e6b0>] tpt_trig_timer+0x110/0x170 [mac80211]
>    [<ffffffffc081ecdd>] ieee80211_mod_tpt_led_trig+0x9d/0x160 [mac80211]
>    [<ffffffffc07e4278>] __ieee80211_recalc_idle+0x98/0x140 [mac80211]
>    [<ffffffffc07e59ce>] ieee80211_idle_off+0xe/0x10 [mac80211]
>    [<ffffffffc0804e5b>] ieee80211_add_chanctx+0x3b/0x220 [mac80211]
>    [<ffffffffc08062e4>] ieee80211_new_chanctx+0x44/0xf0 [mac80211]
>    [<ffffffffc080838a>] ieee80211_vif_use_channel+0x1fa/0x2a0 [mac80211]
>    [<ffffffffc0817df8>] ieee80211_prep_connection+0x188/0x9a0 [mac80211]
>    [<ffffffffc081c246>] ieee80211_mgd_auth+0x256/0x2e0 [mac80211]
>    [<ffffffffc07eab33>] ieee80211_auth+0x13/0x20 [mac80211]
>    [<ffffffffc06cb006>] cfg80211_mlme_auth+0x106/0x270 [cfg80211]
>    [<ffffffffc06ce085>] cfg80211_conn_do_work+0x155/0x3b0 [cfg80211]
>    [<ffffffffc06cf670>] cfg80211_connect+0x3f0/0x540 [cfg80211]
>    [<ffffffffc06e6148>] cfg80211_mgd_wext_connect+0x158/0x1f0 [cfg80211]
>    [<ffffffffc06e651e>] cfg80211_mgd_wext_siwessid+0xde/0x180 [cfg80211]
>    [<ffffffffc06e36dd>] cfg80211_wext_siwessid+0x1d/0x40 [cfg80211]
>    [<ffffffff81584d0c>] ioctl_standard_iw_point+0x14c/0x3e0
>    [<ffffffff8158502a>] ioctl_standard_call+0x8a/0xd0
>    [<ffffffff81584b76>] wireless_process_ioctl.constprop.10+0xb6/0x100
>    [<ffffffff8158521d>] wext_handle_ioctl+0x5d/0xb0
>    [<ffffffff814cfb29>] dev_ioctl+0x329/0x620
>    [<ffffffff8149c7f2>] sock_ioctl+0x142/0x2e0
>    [<ffffffff811b0140>] do_vfs_ioctl+0x300/0x520
>    [<ffffffff811b03e1>] SyS_ioctl+0x81/0xa0
>    [<ffffffff815a67d6>] system_call_fastpath+0x1a/0x1f
>  irq event stamp: 493416
>  hardirqs last  enabled at (493416): [<ffffffff81068a5f>] __cancel_work_timer+0x6f/0x100
>  hardirqs last disabled at (493415): [<ffffffff81067e9f>] try_to_grab_pending+0x1f/0x160
>  softirqs last  enabled at (493408): [<ffffffff81053ced>] _local_bh_enable+0x1d/0x50
>  softirqs last disabled at (493409): [<ffffffff81054c75>] irq_exit+0xa5/0xb0
>
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
>
>         CPU0
>         ----
>    lock((&(&led_cdev->blink_work)->work));
>    <Interrupt>
>      lock((&(&led_cdev->blink_work)->work));
>
>   *** DEADLOCK ***
>
>  2 locks held by swapper/0/0:
>   #0:  (((&tpt_trig->timer))){+.-...}, at: [<ffffffff810b4c50>] call_timer_fn+0x0/0x180
>   #1:  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffffc081e68c>] tpt_trig_timer+0xec/0x170 [mac80211]
>
>  stack backtrace:
>  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc3 #1
>  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>   ffffffff8246eb30 ffff88007c203b00 ffffffff8159e97f ffffffff81a194c0
>   ffff88007c203b50 ffffffff81599c29 0000000000000001 ffffffff00000001
>   ffff880000000000 0000000000000006 ffffffff81a194c0 ffffffff81093ad0
>  Call Trace:
>   <IRQ>  [<ffffffff8159e97f>] dump_stack+0x4d/0x66
>   [<ffffffff81599c29>] print_usage_bug+0x1f4/0x205
>   [<ffffffff81093ad0>] ? check_usage_backwards+0x140/0x140
>   [<ffffffff810944d3>] mark_lock+0x223/0x2b0
>   [<ffffffff81094d60>] __lock_acquire+0x2b0/0x1a30
>   [<ffffffff81096c81>] lock_acquire+0x91/0x110
>   [<ffffffff810685d0>] ? mod_delayed_work_on+0x80/0x80
>   [<ffffffffc081e5a0>] ? __ieee80211_get_rx_led_name+0x10/0x10 [mac80211]
>   [<ffffffff81068608>] flush_work+0x38/0x270
>   [<ffffffff810685d0>] ? mod_delayed_work_on+0x80/0x80
>   [<ffffffff810945ca>] ? mark_held_locks+0x6a/0x90
>   [<ffffffff81068a5f>] ? __cancel_work_timer+0x6f/0x100
>   [<ffffffffc081e5a0>] ? __ieee80211_get_rx_led_name+0x10/0x10 [mac80211]
>   [<ffffffff8109469d>] ? trace_hardirqs_on_caller+0xad/0x1c0
>   [<ffffffffc081e5a0>] ? __ieee80211_get_rx_led_name+0x10/0x10 [mac80211]
>   [<ffffffff81068a6b>] __cancel_work_timer+0x7b/0x100
>   [<ffffffff81068b0e>] cancel_delayed_work_sync+0xe/0x10
>   [<ffffffff8147cf3b>] led_blink_set+0x1b/0x40
>   [<ffffffffc081e6b0>] tpt_trig_timer+0x110/0x170 [mac80211]
>   [<ffffffff810b4cc5>] call_timer_fn+0x75/0x180
>   [<ffffffff810b4c50>] ? process_timeout+0x10/0x10
>   [<ffffffffc081e5a0>] ? __ieee80211_get_rx_led_name+0x10/0x10 [mac80211]
>   [<ffffffff810b50ac>] run_timer_softirq+0x1fc/0x2f0
>   [<ffffffff81054805>] __do_softirq+0x115/0x2e0
>   [<ffffffff81054c75>] irq_exit+0xa5/0xb0
>   [<ffffffff810049b3>] do_IRQ+0x53/0xf0
>   [<ffffffff815a74af>] common_interrupt+0x6f/0x6f
>   <EOI>  [<ffffffff8147b56e>] ? cpuidle_enter_state+0x6e/0x180
>   [<ffffffff8147b732>] cpuidle_enter+0x12/0x20
>   [<ffffffff8108bba0>] cpu_startup_entry+0x330/0x360
>   [<ffffffff8158fb51>] rest_init+0xc1/0xd0
>   [<ffffffff8158fa90>] ? csum_partial_copy_generic+0x170/0x170
>   [<ffffffff81af3ff2>] start_kernel+0x44f/0x45a
>   [<ffffffff81af399c>] ? set_init_arg+0x53/0x53
>   [<ffffffff81af35ad>] x86_64_start_reservations+0x2a/0x2c
>   [<ffffffff81af36a0>] x86_64_start_kernel+0xf1/0xf4
>
> Cc: Vincent Donnefort <vdonnefort@gmail.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/leds/led-class.c | 14 +++++++-------
>  drivers/leds/led-core.c  | 11 +++++------
>  include/linux/leds.h     |  3 ++-
>  3 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 129729d..aa29198 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -15,10 +15,10 @@
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
>  #include <linux/device.h>
> +#include <linux/timer.h>
>  #include <linux/err.h>
>  #include <linux/ctype.h>
>  #include <linux/leds.h>
> -#include <linux/workqueue.h>
>  #include "leds.h"
>
>  static struct class *leds_class;
> @@ -97,10 +97,9 @@ static const struct attribute_group *led_groups[] = {
>         NULL,
>  };
>
> -static void led_work_function(struct work_struct *ws)
> +static void led_timer_function(unsigned long data)
>  {
> -       struct led_classdev *led_cdev =
> -               container_of(ws, struct led_classdev, blink_work.work);
> +       struct led_classdev *led_cdev = (void *)data;
>         unsigned long brightness;
>         unsigned long delay;
>
> @@ -144,8 +143,7 @@ static void led_work_function(struct work_struct *ws)
>                 }
>         }
>
> -       queue_delayed_work(system_wq, &led_cdev->blink_work,
> -                          msecs_to_jiffies(delay));
> +       mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
>  }
>
>  static void set_brightness_delayed(struct work_struct *ws)
> @@ -233,7 +231,9 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>
>         INIT_WORK(&led_cdev->set_brightness_work, set_brightness_delayed);
>
> -       INIT_DELAYED_WORK(&led_cdev->blink_work, led_work_function);
> +       init_timer(&led_cdev->blink_timer);
> +       led_cdev->blink_timer.function = led_timer_function;
> +       led_cdev->blink_timer.data = (unsigned long)led_cdev;
>
>  #ifdef CONFIG_LEDS_TRIGGERS
>         led_trigger_set_default(led_cdev);
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 4bb1168..71b40d3 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -16,7 +16,6 @@
>  #include <linux/module.h>
>  #include <linux/rwsem.h>
>  #include <linux/leds.h>
> -#include <linux/workqueue.h>
>  #include "leds.h"
>
>  DECLARE_RWSEM(leds_list_lock);
> @@ -52,7 +51,7 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>                 return;
>         }
>
> -       queue_delayed_work(system_wq, &led_cdev->blink_work, 1);
> +       mod_timer(&led_cdev->blink_timer, jiffies + 1);
>  }
>
>
> @@ -76,7 +75,7 @@ void led_blink_set(struct led_classdev *led_cdev,
>                    unsigned long *delay_on,
>                    unsigned long *delay_off)
>  {
> -       cancel_delayed_work_sync(&led_cdev->blink_work);
> +       del_timer_sync(&led_cdev->blink_timer);
>
>         led_cdev->flags &= ~LED_BLINK_ONESHOT;
>         led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> @@ -91,7 +90,7 @@ void led_blink_set_oneshot(struct led_classdev *led_cdev,
>                            int invert)
>  {
>         if ((led_cdev->flags & LED_BLINK_ONESHOT) &&
> -            delayed_work_pending(&led_cdev->blink_work))
> +            timer_pending(&led_cdev->blink_timer))
>                 return;
>
>         led_cdev->flags |= LED_BLINK_ONESHOT;
> @@ -108,7 +107,7 @@ EXPORT_SYMBOL(led_blink_set_oneshot);
>
>  void led_stop_software_blink(struct led_classdev *led_cdev)
>  {
> -       cancel_delayed_work_sync(&led_cdev->blink_work);
> +       del_timer_sync(&led_cdev->blink_timer);
>         led_cdev->blink_delay_on = 0;
>         led_cdev->blink_delay_off = 0;
>  }
> @@ -117,7 +116,7 @@ EXPORT_SYMBOL_GPL(led_stop_software_blink);
>  void led_set_brightness(struct led_classdev *led_cdev,
>                         enum led_brightness brightness)
>  {
> -       /* delay brightness setting if need to stop soft-blink work */
> +       /* delay brightness setting if need to stop soft-blink timer */
>         if (led_cdev->blink_delay_on || led_cdev->blink_delay_off) {
>                 led_cdev->delayed_set_value = brightness;
>                 schedule_work(&led_cdev->set_brightness_work);
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 6a599dc..e436864 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -15,6 +15,7 @@
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
>  #include <linux/rwsem.h>
> +#include <linux/timer.h>
>  #include <linux/workqueue.h>
>
>  struct device;
> @@ -68,7 +69,7 @@ struct led_classdev {
>         const char              *default_trigger;       /* Trigger to use */
>
>         unsigned long            blink_delay_on, blink_delay_off;
> -       struct delayed_work      blink_work;
> +       struct timer_list        blink_timer;
>         int                      blink_brightness;
>
>         struct work_struct      set_brightness_work;
> --
> Jiri Kosina
> SUSE Labs
