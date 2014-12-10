Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaLJAzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:55:16 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42482 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaLJAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:55:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAF6AEGu2gmYUux9c0pfc+J1wbCc8555pn-WD4iKDtvmD52dvWg@mail.gmail.com>
References: <1417702295-11001-1-git-send-email-ruiv.wang@gmail.com>
	<CANVTcTaSMCoc364qW=gOM9wq9-=nrVe7AaUcxu33vCSdh=ixKQ@mail.gmail.com>
	<CAF6AEGu2gmYUux9c0pfc+J1wbCc8555pn-WD4iKDtvmD52dvWg@mail.gmail.com>
Date: Wed, 10 Dec 2014 08:55:09 +0800
Message-ID: <CANVTcTZj7xntm5OcKpdKu5GopHrOXAQ6RUPF-4brnu7afYZu4g@mail.gmail.com>
Subject: Re: [PATCH] drm: fb helper should avoid sleeping in panic context
From: rui wang <ruiv.wang@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: "airlied@redhat.com" <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, tony.luck@intel.com,
        bp@alien8.de, aris@redhat.com, rui.y.wang@intel.com,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,
Yes it's exactly what I'm doing. Please scroll down and review my patch.

Thanks
Rui

On 12/10/14, Rob Clark <robdclark@gmail.com> wrote:
> perhaps fb helpers could use __drm_modeset_lock_all() w/ trylock=true
> in panic context?
>
> BR,
> -R
>
> On Tue, Dec 9, 2014 at 7:09 PM, rui wang <ruiv.wang@gmail.com> wrote:
>> Hi All,
>>
>> Any comment ? Or any better idea how this should be fixed?
>>
>> Regards,
>> Rui
>>
>> ---------- Forwarded message ----------
>> From: ruiv.wang@gmail.com
>> Date: Thu,  4 Dec 2014 22:11:35 +0800
>> Subject: [PATCH] drm: fb helper should avoid sleeping in panic context
>> To: airlied@redhat.com, daniel.vetter@ffwll.ch, tony.luck@intel.com,
>> bp@alien8.de, aris@redhat.com, rui.y.wang@intel.com
>> Cc: linux-kernel@vger.kernel.org
>>
>> From: Rui Wang <rui.y.wang@intel.com>
>>
>> There are still some places in the fb helper that need to avoid
>> sleeping in panic context. Here's an example:
>>
>> [   65.615496] bad: scheduling from the idle thread!
>> [   65.620747] CPU: 92 PID: 0 Comm: swapper/92 Tainted: G   M        E
>>  3.18.0-rc4-7-default+ #20
>>
>> [   65.630364] Hardware name: Intel Corporation BRICKLAND/BRICKLAND,
>> BIOS BRHSXSD1.86B.0056.R01.1409242327 09/24/2014
>> [   65.641923]  ffff88087f693d80 ffff88087f689878 ffffffff81566db9
>> 0000000000000000
>> [   65.650226]  ffff88087f693d80 ffff88087f689898 ffffffff810871ff
>> ffff88046eb3e0d0
>> [   65.658527]  ffff88087f693d80 ffff88087f6898c8 ffffffff8107c1fa
>> 000000017f6898b8
>> [   65.666830] Call Trace:
>> [   65.669557]  <#MC>  [<ffffffff81566db9>] dump_stack+0x46/0x58
>> [   65.675994]  [<ffffffff810871ff>] dequeue_task_idle+0x2f/0x40
>> [   65.682412]  [<ffffffff8107c1fa>] dequeue_task+0x5a/0x80
>> [   65.688345]  [<ffffffff810804f3>] deactivate_task+0x23/0x30
>> [   65.694569]  [<ffffffff81569050>] __schedule+0x580/0x7f0
>> [   65.700502]  [<ffffffff81569739>] schedule_preempt_disabled+0x29/0x70
>> [   65.707696]  [<ffffffff8156abb6>] __ww_mutex_lock_slowpath+0xb8/0x162
>> [   65.714891]  [<ffffffff8156acb3>] __ww_mutex_lock+0x53/0x85
>> [   65.721125]  [<ffffffffa00b3a5d>] drm_modeset_lock+0x3d/0x110 [drm]
>> [   65.728132]  [<ffffffffa00b3c2a>] __drm_modeset_lock_all+0x8a/0x120
>> [drm]
>> [   65.735721]  [<ffffffffa00b3cd0>] drm_modeset_lock_all+0x10/0x30 [drm]
>> [   65.743015]  [<ffffffffa01af8bf>]
>> drm_fb_helper_pan_display+0x2f/0xf0 [drm_kms_helper]
>> [   65.751857]  [<ffffffff8132bd21>] fb_pan_display+0xd1/0x1a0
>> [   65.758081]  [<ffffffff81326010>] bit_update_start+0x20/0x50
>> [   65.764400]  [<ffffffff813259f2>] fbcon_switch+0x3a2/0x550
>> [   65.770528]  [<ffffffff813a01c9>] redraw_screen+0x189/0x240
>> [   65.776750]  [<ffffffff81322f8a>] fbcon_blank+0x20a/0x2d0
>> [   65.782778]  [<ffffffff8137d359>] ? erst_writer+0x209/0x330
>> [   65.789002]  [<ffffffff810ba2f3>] ? internal_add_timer+0x63/0x80
>> [   65.795710]  [<ffffffff810bc137>] ? mod_timer+0x127/0x1e0
>> [   65.801740]  [<ffffffff813a0cd8>] do_unblank_screen+0xa8/0x1d0
>> [   65.808255]  [<ffffffff813a0e10>] unblank_screen+0x10/0x20
>> [   65.814381]  [<ffffffff812ca0d9>] bust_spinlocks+0x19/0x40
>> [   65.820508]  [<ffffffff81561ca7>] panic+0x106/0x1f5
>> [   65.825955]  [<ffffffff8102336c>] mce_panic+0x2ac/0x2e0
>> [   65.831789]  [<ffffffff812c796a>] ? delay_tsc+0x4a/0x80
>> [   65.837625]  [<ffffffff81024e1f>] do_machine_check+0xbaf/0xbf0
>> [   65.844138]  [<ffffffff813365d7>] ? intel_idle+0xc7/0x150
>> [   65.850166]  [<ffffffff8156f03f>] machine_check+0x1f/0x30
>> [   65.856195]  [<ffffffff813365d7>] ? intel_idle+0xc7/0x150
>> [   65.862222]  <<EOE>>  [<ffffffff814283d5>]
>> cpuidle_enter_state+0x55/0x170
>> [   65.869823]  [<ffffffff814285a7>] cpuidle_enter+0x17/0x20
>> [   65.875852]  [<ffffffff81097b08>] cpu_startup_entry+0x2d8/0x370
>> [   65.882467]  [<ffffffff8102fe29>] start_secondary+0x159/0x180
>>
>> There's __drm_modeset_lock_all() which Daniel Vetter introduced for this
>> purpose. We can leverage that without reinventing anything. This patch
>> works with the latest kernel.
>>
>> Signed-off-by: Rui Wang <rui.y.wang@intel.com>
>> ---
>>  drivers/gpu/drm/drm_fb_helper.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_fb_helper.c
>> b/drivers/gpu/drm/drm_fb_helper.c
>> index 0c0c39b..70dd2f4 100644
>> --- a/drivers/gpu/drm/drm_fb_helper.c
>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>> @@ -732,7 +732,9 @@ int drm_fb_helper_setcmap(struct fb_cmap *cmap,
>> struct fb_info *info)
>>         int i, j, rc = 0;
>>         int start;
>>
>> -       drm_modeset_lock_all(dev);
>> +       if (__drm_modeset_lock_all(dev, !!oops_in_progress)) {
>> +               return -EBUSY;
>> +       }
>>         if (!drm_fb_helper_is_bound(fb_helper)) {
>>                 drm_modeset_unlock_all(dev);
>>                 return -EBUSY;
>> @@ -910,7 +912,9 @@ int drm_fb_helper_pan_display(struct fb_var_screeninfo
>> *var,
>>         int ret = 0;
>>         int i;
>>
>> -       drm_modeset_lock_all(dev);
>> +       if (__drm_modeset_lock_all(dev, !!oops_in_progress)) {
>> +               return -EBUSY;
>> +       }
>>         if (!drm_fb_helper_is_bound(fb_helper)) {
>>                 drm_modeset_unlock_all(dev);
>>                 return -EBUSY;
>> --
>> 1.7.5.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
