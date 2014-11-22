Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaKVQ4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 11:56:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaKVQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 11:56:19 -0500
Message-ID: <5470C02F.6080103@canonical.com>
Date: Sat, 22 Nov 2014 17:56:15 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Marineau <mike@marineau.org>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>
Subject: Re: 3.18-rc regression: drm/nouveau: use shared fences for readable
 objects
References: <CAHW-aUcEipi+NeU3wapLABV41Sud7Qy_=EYXCei9Dmf18SxuZA@mail.gmail.com>	<546C5085.1020300@canonical.com>	<CAHW-aUf7zkWbwDSoL62X9A6pWMAHRGwG=YPQ80o_4OicD7EJPQ@mail.gmail.com>	<546DAC16.80704@canonical.com> <CAHW-aUcv3g7mGxmZawe-mfMMdFNnkKep-u-JyH9hhJqoaMM2Mw@mail.gmail.com>
In-Reply-To: <CAHW-aUcv3g7mGxmZawe-mfMMdFNnkKep-u-JyH9hhJqoaMM2Mw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 22-11-14 om 01:19 schreef Michael Marineau:
> On Thu, Nov 20, 2014 at 12:53 AM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> Op 20-11-14 om 05:06 schreef Michael Marineau:
>>> On Wed, Nov 19, 2014 at 12:10 AM, Maarten Lankhorst
>>> <maarten.lankhorst@canonical.com> wrote:
>>>> Hey,
>>>>
>>>> On 19-11-14 07:43, Michael Marineau wrote:
>>>>> On 3.18-rc kernel's I have been intermittently experiencing GPU
>>>>> lockups shortly after startup, accompanied with one or both of the
>>>>> following errors:
>>>>>
>>>>> nouveau E[   PFIFO][0000:01:00.0] read fault at 0x000734a000 [PTE]
>>>>> from PBDMA0/HOST_CPU on channel 0x007faa3000 [unknown]
>>>>> nouveau E[     DRM] GPU lockup - switching to software fbcon
>>>>>
>>>>> I was able to trace the issue with bisect to commit
>>>>> 809e9447b92ffe1346b2d6ec390e212d5307f61c "drm/nouveau: use shared
>>>>> fences for readable objects". The lockups appear to have cleared up
>>>>> since reverting that and a few related followup commits:
>>>>>
>>>>> 809e9447: "drm/nouveau: use shared fences for readable objects"
>>>>> 055dffdf: "drm/nouveau: bump driver patchlevel to 1.2.1"
>>>>> e3be4c23: "drm/nouveau: specify if interruptible wait is desired in
>>>>> nouveau_fence_sync"
>>>>> 15a996bb: "drm/nouveau: assign fence_chan->name correctly"
>>>> Weird. I'm not sure yet what causes it.
>>>>
>>>> http://cgit.freedesktop.org/~mlankhorst/linux/commit/?h=fixed-fences-for-bisect&id=86be4f216bbb9ea3339843a5658d4c21162c7ee2
>>> Building a kernel from that commit gives me an entirely new behavior:
>>> X hangs for at least 10-20 seconds at a time with brief moments of
>>> responsiveness before hanging again while gitk on the kernel repo
>>> loads. Otherwise the system is responsive. The head of that
>>> fixed-fences-for-bisect branch (1c6aafb5) which is the "use shared
>>> fences for readable objects" commit I originally bisected to does
>>> feature the complete lockups I was seeing before.
>> Ok for the sake of argument lets just assume they're separate bugs, and we should look at xorg
>> hanging first.
>>
>> Is there anything in the dmesg when the hanging happens?
>>
>> And it's probably 15 seconds, if it's called through nouveau_fence_wait.
>>
>> Try changing else if (!ret) to else if (WARN_ON(!ret)) in that function, and see if you get some dmesg spam. :)
> Adding the WARN_ON to 86be4f21 repots the following:
>
> [ 1188.676073] ------------[ cut here ]------------
> [ 1188.676161] WARNING: CPU: 1 PID: 474 at
> drivers/gpu/drm/nouveau/nouveau_fence.c:359
> nouveau_fence_wait.part.9+0x33/0x40 [nouveau]()
> [ 1188.676166] Modules linked in: rndis_host cdc_ether usbnet mii bnep
> ecb btusb bluetooth rfkill bridge stp llc hid_generic usb_storage
> joydev mousedev hid_apple usbhid bcm5974 nls_iso8859_1 nls_cp437 vfat
> fat nouveau snd_hda_codec_hdmi coretemp x86_pkg_temp_thermal
> intel_powerclamp kvm_intel kvm iTCO_wdt crct10dif_pclmul
> iTCO_vendor_support crc32c_intel evdev aesni_intel mac_hid aes_x86_64
> lrw glue_helper ablk_helper applesmc snd_hda_codec_cirrus cryptd
> input_polldev snd_hda_codec_generic mxm_wmi led_class wmi microcode
> hwmon snd_hda_intel ttm snd_hda_controller lpc_ich i2c_i801 mfd_core
> snd_hda_codec i2c_algo_bit snd_hwdep drm_kms_helper snd_pcm sbs drm
> apple_gmux i2ccore snd_timer snd agpgart mei_me soundcore sbshc mei
> video xhci_hcd usbcore usb_common apple_bl button battery ac efivars
> autofs4
> [ 1188.676300]  efivarfs
> [ 1188.676308] CPU: 1 PID: 474 Comm: Xorg Tainted: G        W
> 3.17.0-rc2-nvtest+ #147
> [ 1188.676313] Hardware name: Apple Inc.
> MacBookPro11,3/Mac-2BD1B31983FE1663, BIOS
> MBP112.88Z.0138.B11.1408291503 08/29/2014
> [ 1188.676316]  0000000000000009 ffff88045daebce8 ffffffff814f0c09
> 0000000000000000
> [ 1188.676325]  ffff88045daebd20 ffffffff8104ea5d ffff88006a6c1468
> 00000000fffffff0
> [ 1188.676333]  0000000000000000 0000000000000000 ffff88006a6c1000
> ffff88045daebd30
> [ 1188.676341] Call Trace:
> [ 1188.676356]  [<ffffffff814f0c09>] dump_stack+0x4d/0x66
> [ 1188.676369]  [<ffffffff8104ea5d>] warn_slowpath_common+0x7d/0xa0
> [ 1188.676377]  [<ffffffff8104eb3a>] warn_slowpath_null+0x1a/0x20
> [ 1188.676439]  [<ffffffffc04dd523>]
> nouveau_fence_wait.part.9+0x33/0x40 [nouveau]
> [ 1188.676496]  [<ffffffffc04ddfe6>] nouveau_fence_wait+0x16/0x30 [nouveau]
> [ 1188.676552]  [<ffffffffc04e598f>]
> nouveau_gem_ioctl_cpu_prep+0xef/0x1f0 [nouveau]
> [ 1188.676578]  [<ffffffffc01c2f4c>] drm_ioctl+0x1ec/0x660 [drm]
> [ 1188.676590]  [<ffffffff814f9026>] ? _raw_spin_unlock_irqrestore+0x36/0x70
> [ 1188.676600]  [<ffffffff81094f6d>] ? trace_hardirqs_on+0xd/0x10
> [ 1188.676655]  [<ffffffffc04da5b4>] nouveau_drm_ioctl+0x54/0xc0 [nouveau]
> [ 1188.676663]  [<ffffffff811a8950>] do_vfs_ioctl+0x300/0x520
> [ 1188.676671]  [<ffffffff814f9e55>] ? sysret_check+0x22/0x5d
> [ 1188.676677]  [<ffffffff811a8bb1>] SyS_ioctl+0x41/0x80
> [ 1188.676683]  [<ffffffff814f9e29>] system_call_fastpath+0x16/0x1b
> [ 1188.676688] ---[ end trace 6f7a510865b4674f ]---
>
> Here are the fence events that fired during that particular fence_wait:
>             Xorg   474 [004]  1173.667645: fence:fence_wait_start:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56910
>             Xorg   474 [004]  1173.667647: fence:fence_enable_signal:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56910
>          swapper     0 [007]  1173.667688: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56900
>          swapper     0 [007]  1173.667692: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56900
>          swapper     0 [007]  1173.667839: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56901
>          swapper     0 [007]  1173.667842: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56901
>          swapper     0 [007]  1173.668021: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56902
>          swapper     0 [007]  1173.668482: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56903
>          swapper     0 [007]  1173.668485: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56903
>          swapper     0 [007]  1173.668489: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56904
>          swapper     0 [007]  1173.668496: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56905
>          swapper     0 [007]  1173.668499: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56905
>          swapper     0 [007]  1173.668502: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56906
>          swapper     0 [007]  1173.668505: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56907
>          swapper     0 [007]  1173.668508: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56907
>          swapper     0 [007]  1173.668511: fence:fence_signaled:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56908
>          swapper     0 [007]  1173.668513: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56908
>      kworker/4:1    80 [004]  1173.676265: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56896
>      kworker/4:1    80 [004]  1173.676273: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56898
>      kworker/4:1    80 [004]  1173.676277: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56902
>      kworker/4:1    80 [004]  1173.676280: fence:fence_destroy:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56904
>             Xorg   474 [001]  1188.676067: fence:fence_wait_end:
> driver=nouveau timeline=Xorg[474] context=2 seqno=56910
>
> I assume that excludes the context you really want so the full fence
> event log and corresponding dmesg output are attached.

Yep, the trace events are useful. The fence is emitted and presumably no event is fired after emission.

Lets find out if the nvif crap is buggy or it's a result of some other issue, what happens when you change:
.wait = fence_default_wait,
to
.wait = nouveau_fence_wait_legacy,
in nouveau_fence.c?

~Maarten
