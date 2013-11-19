Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3KSXxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:53:07 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:26063 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3KSXxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:53:03 -0500
X-AuditID: cbfec37b-b7fa96d00000716e-4a-528bf9deef36
Message-id: <528BF9DB.6050308@samsung.com>
Date: Tue, 19 Nov 2013 16:52:59 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: len.brown@intel.com, pavel@ucw.cz, anton@enomsg.org, dwmw2@infradead.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 2/2] power: Change device_wakeup_enable() to WARN_ON on
 null dev_name(dev)
References: <cover.1384875691.git.shuah.kh@samsung.com>
 <622a097f9780dc721354d0e2b6cb512280da1ebc.1384875691.git.shuah.kh@samsung.com>
 <20131119231401.GC24054@kroah.com> <4885530.zkZVX2zzgu@vostro.rjw.lan>
In-reply-to: <4885530.zkZVX2zzgu@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wn+69n91BBt0XuC0ObtW0mLhyMrNF
	8+L1bBazpuxlsri8aw6bxefeI4wWd08dZbM4c/oSq8XXnw4OnB4T+j8xeuycdZfdY/MKLY/F
	e14yeeyfu4bdY8vVdhaPFau/s3t83iQXwBHFZZOSmpNZllqkb5fAlXF/4nT2gpNmFVNmTmBs
	YHyp28XIySEhYCLx5u5/NghbTOLCvfVANheHkMAyRoltDZPYIZxeJomFW9cwQTibGCXunLzC
	DtLCK6AlsfrVaUYQm0VAVWLazmlgcTYBdYnPr3eA2UICchJNS1Yzg9iiAhESR1c/Y4XoFZT4
	MfkeC4gtIhAscet9P9gCZoEDjBJfjy0ESwgLJEi8aLvNBjHoIqPEweceIDangIHEj0+dYHFm
	ATOJRy3rmCFseYnNa94yQ9QrS/y5fApoKAfQb4oS21dbTWAUmYVk9Swk3bOQdC9gZF7FKFZa
	nFxQnJSeWmGkV5yYW1yal66XnJ+7iRESd9U7GO9+tTnEKMDBqMTDK7GgO0iINbGsuDL3EKME
	B7OSCO+aF0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjHZvSmX37r30Urf169YdLeJKrpezbhfe
	rZz8OVsu9Pb+5RU7Lt28yFZ+1MD82+vvoTevP56g8snlwaFd7RxnNI2l3e0+vX89p29q2v6L
	f9MbN6ZfX2xTzHMiWTPDu+Dv4y2HgtzDMpYlv3ogsUxzy7Sc9CfF7euy6t+X7nDSdlnzL0nL
	iumS50wlluKMREMt5qLiRABhnGTPmQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 04:56 PM, Rafael J. Wysocki wrote:
> On Tuesday, November 19, 2013 03:14:01 PM Greg KH wrote:
>> On Tue, Nov 19, 2013 at 09:05:46AM -0700, Shuah Khan wrote:
>>> device_wakeup_enable() uses dev_name(dev) as the wakeup source name.
>>> When it gets called with a device with its name not yet set, ws structure
>>> with ws->name = NULL gets created.
>>>
>>> When kernel is booted with wakeup_source_activate enabled, it will panic
>>> when the trace point code tries to dereferences ws->name.
>>>
>>> Change device_wakeup_enable() to WARN_ON on dev_name(dev) null condition
>>> to detect driver bugs that result in calling device_wakeup_enable() before
>>> device is fully initialized with its name in device_wakeup_enable().
>>>
>>> This change without the power_supply_register() fix will result in early
>>> boot panics when AC Adapter and Battery device drivers try to register
>>> wakeup source.
>>>
>>> The following panic resulted from power_supply_register() registering
>>> wakeup source with a null device name.
>>>
>>> [  819.769934] device: 'BAT1': device_add
>>> [  819.770078] PM: Adding info for No Bus:BAT1
>>> [  819.770235] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>> [  819.770435] IP: [<ffffffff813381c0>] skip_spaces+0x30/0x30
>>> [  819.770572] PGD 3efd90067 PUD 3eff61067 PMD 0
>>> [  819.770716] Oops: 0000 [#1] SMP
>>> [  819.770829] Modules linked in: arc4 iwldvm mac80211 x86_pkg_temp_thermal coretemp kvm_intel joydev i915 kvm uvcvideo ghash_clmulni_intel videobuf2_vmalloc aesni_intel videobuf2_memops videobuf2_core aes_x86_64 ablk_helper cryptd videodev iwlwifi lrw rfcomm gf128mul glue_helper bnep btusb media bluetooth parport_pc hid_generic ppdev snd_hda_codec_hdmi drm_kms_helper snd_hda_codec_realtek cfg80211 drm tpm_infineon samsung_laptop snd_hda_intel usbhid snd_hda_codec hid snd_hwdep snd_pcm microcode snd_page_alloc snd_timer psmouse i2c_algo_bit lpc_ich tpm_tis video wmi mac_hid serio_raw ext2 lp parport r8169 mii
>>> [  819.771802] CPU: 0 PID: 2167 Comm: bash Not tainted 3.12.0+ #25
>>> [  819.771876] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P03AAC 07/12/2012
>>> [  819.772022] task: ffff88002e6ddcc0 ti: ffff8804015ca000 task.ti: ffff8804015ca000
>>> [  819.772119] RIP: 0010:[<ffffffff813381c0>]  [<ffffffff813381c0>] skip_spaces+0x30/0x30
>>> [  819.772242] RSP: 0018:ffff8804015cbc70  EFLAGS: 00010046
>>> [  819.772310] RAX: 0000000000000003 RBX: ffff88040cfd6d40 RCX: 0000000000000018
>>> [  819.772397] RDX: 0000000000020001 RSI: 0000000000000000 RDI: 0000000000000000
>>> [  819.772484] RBP: ffff8804015cbcc0 R08: 0000000000000000 R09: ffff8803f0768d40
>>> [  819.772570] R10: ffffea001033b800 R11: 0000000000000000 R12: ffffffff81c519c0
>>> [  819.772656] R13: 0000000000020001 R14: 0000000000000000 R15: 0000000000020001
>>> [  819.772744] FS:  00007ff98309b740(0000) GS:ffff88041f200000(0000) knlGS:0000000000000000
>>> [  819.772845] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  819.772917] CR2: 0000000000000000 CR3: 00000003f59dc000 CR4: 00000000001407f0
>>> [  819.773001] Stack:
>>> [  819.773030]  ffffffff81114003 ffff8804015cbcb0 0000000000000000 0000000000000046
>>> [  819.773146]  ffff880409757a18 ffff8803f065a160 0000000000000000 0000000000020001
>>> [  819.773273]  0000000000000000 0000000000000000 ffff8804015cbce8 ffffffff8143e388
>>> [  819.773387] Call Trace:
>>> [  819.773434]  [<ffffffff81114003>] ? ftrace_raw_event_wakeup_source+0x43/0xe0
>>> [  819.773520]  [<ffffffff8143e388>] wakeup_source_report_event+0xb8/0xd0
>>> [  819.773595]  [<ffffffff8143e3cd>] __pm_stay_awake+0x2d/0x50
>>> [  819.773724]  [<ffffffff8153395c>] power_supply_changed+0x3c/0x90
>>> [  819.773795]  [<ffffffff8153407c>] power_supply_register+0x18c/0x250
>>> [  819.773869]  [<ffffffff813d8d18>] sysfs_add_battery+0x61/0x7b
>>> [  819.773935]  [<ffffffff813d8d69>] battery_notify+0x37/0x3f
>>> [  819.774001]  [<ffffffff816ccb7c>] notifier_call_chain+0x4c/0x70
>>> [  819.774071]  [<ffffffff81073ded>] __blocking_notifier_call_chain+0x4d/0x70
>>> [  819.774149]  [<ffffffff81073e26>] blocking_notifier_call_chain+0x16/0x20
>>> [  819.774227]  [<ffffffff8109397a>] pm_notifier_call_chain+0x1a/0x40
>>> [  819.774316]  [<ffffffff81095b66>] hibernate+0x66/0x1c0
>>> [  819.774407]  [<ffffffff81093931>] state_store+0x71/0xa0
>>> [  819.774507]  [<ffffffff81331d8f>] kobj_attr_store+0xf/0x20
>>> [  819.774613]  [<ffffffff811f8618>] sysfs_write_file+0x128/0x1c0
>>> [  819.774735]  [<ffffffff8118579d>] vfs_write+0xbd/0x1e0
>>> [  819.774841]  [<ffffffff811861d9>] SyS_write+0x49/0xa0
>>> [  819.774939]  [<ffffffff816d1052>] system_call_fastpath+0x16/0x1b
>>> [  819.775055] Code: 89 f8 48 89 e5 f6 82 c0 a6 84 81 20 74 15 0f 1f 44 00 00 48 83 c0 01 0f b6 10 f6 82 c0 a6 84 81 20 75 f0 5d c3 66 0f 1f 44 00 00 <80> 3f 00 55 48 89 e5 74 15 48 89 f8 0f 1f 40 00 48 83 c0 01 80
>>> [  819.775760] RIP  [<ffffffff813381c0>] skip_spaces+0x30/0x30
>>> [  819.775881]  RSP <ffff8804015cbc70>
>>> [  819.775949] CR2: 0000000000000000
>>> [  819.794175] ---[ end trace c4ef25127039952e ]---
>>>
>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>> ---
>>>   drivers/base/power/wakeup.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
>>> index 2d56f41..a605f0d 100644
>>> --- a/drivers/base/power/wakeup.c
>>> +++ b/drivers/base/power/wakeup.c
>>> @@ -223,6 +223,9 @@ int device_wakeup_enable(struct device *dev)
>>>   	if (!dev || !dev->power.can_wakeup)
>>>   		return -EINVAL;
>>>
>>> +	if (WARN_ON(!dev_name(dev)))
>>> +		return -EINVAL;
>>> +
>>>   	ws = wakeup_source_register(dev_name(dev));
>>
>> Shouldn't wakeup_source_register() just handle a NULL for a name better?
>
> In fact, it does.
>
> The bug is in wakeup_source_activate() and that's because it passes ws->name
> to trace_wakeup_source_activate() which then doesn't bother to check it against
> NULL.
>
> So the solution here is to check ws->name before attempting to pass
> it to trace_wakeup_source_activate() in wakeup_source_activate().  It is
> actually valid to have a wakeup source with a NULL name and it shouldn't
> blow up like this.
>
> Thanks,
> Rafael
>

Rafael beat me to it. Yes adding the following to 
DECLARE_EVENT_CLASS(wakeup_source, should take care of the problem:


               const char *tmp_i = name ? name : "ws no name";

                 __assign_str(name, tmp_i);

should make trace_wakeup_source_activate() not blow up. I did consider 
this as one of the fixes to the oops. Would you rather see this fix 
instead of this change to device_wakeup_enable()?

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
