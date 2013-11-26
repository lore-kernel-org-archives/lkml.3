Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3KZPHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:07:52 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:42646 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab3KZPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:07:45 -0500
X-AuditID: cbfec37d-b7fa86d000003175-b1-5294b93f3cfc
Message-id: <5294B92E.6080009@samsung.com>
Date: Tue, 26 Nov 2013 08:07:26 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: anton@enomsg.org, dwmw2@infradead.org, fweisbec@gmail.com,
        mingo@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v3 2/2] tracing: Fix Oops from NULL pointer dereference
 from __assign_str
References: <cover.1385138418.git.shuah.kh@samsung.com>
 <f00015390df673a747ab397d8bccdb877464f97e.1385138418.git.shuah.kh@samsung.com>
 <4392832.qmtCDxa3F5@vostro.rjw.lan>
 <20131126094620.035fa2ec@gandalf.local.home>
In-reply-to: <20131126094620.035fa2ec@gandalf.local.home>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+wn679zilBBkd+61kc3KppMXHlZGaL
	ma+7mSyaF69ns7i8aw6bxaUDC5gszpy+xGqxr+MBk8XXnw4WCzY+YnTg8pjQ/4nRY+esu+we
	LftusXtsXqHlsX/uGnaP9/uusnlsudrO4vF5k1wARxSXTUpqTmZZapG+XQJXxr4NE1gKdlhV
	dExbyNjA2GrYxcjJISFgInHtxAE2CFtM4sK99UA2F4eQwDJGiVm9M5khnF4miVf/5kM5Gxkl
	ns64yQjSwiugJTFn51smEJtFQFXi8f0JrCA2m4C6xOfXO9hBbCEBOYmmJauZQWxRgQiJo6uf
	sUL0Ckr8mHyPBcQWEQiW2LD2DCPIAmaBu4wSPSe6wYqEBeIlFnxfwQSxGShx8X0DWIJTwFJi
	/bJVYN3MAtYSKydtY4Sw5SU2r3nLDLFZWeLP5VNAzRxAzylKbF9tNYFRZBaS3bOQdM9C0r2A
	kXkVo1hpcXJBcVJ6aoWJXnFibnFpXrpecn7uJkZIDNbuYLz/1eYQowAHoxIPr0Tn5CAh1sSy
	4srcQ4wSHMxKIryx06cECfGmJFZWpRblxxeV5qQWH2Jk4uCUamA8ZsB15ucitzDVPcqaa9of
	iO+7xn9qZigfe+wvaYWkjj3H1rzgL4jOfhe7ienazOdc6+7P8y9q/Xi5eZLSp5NXZi1YFljB
	MP2N2kXZQ2tlY8zuTk6sddYKO3TF3jl08Z6EzyaZkxsPv9dN15vs/Wvz5l03LsUc3iHHaPtU
	tWe1t/Vv47eXInoklViKMxINtZiLihMBR0fYq58CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 07:46 AM, Steven Rostedt wrote:
> On Fri, 22 Nov 2013 23:18:09 +0100
> "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
>
>> On Friday, November 22, 2013 10:54:29 AM Shuah Khan wrote:
>>> Tracing infrastructure routine __assign_str doesn't handle null strings.
>>> As a result when an trace event passes in a null string, kernel panics
>>> when skip_spaces() is invoked on the string. The following oops occurred
>>> when a null wakeup source name is specified.
>>>
>>> power_supply_register() calls device_init_wakeup() to register a wakeup
>>> source before initializing dev_name. As a result, device_wakeup_enable()
>>> end up registering wakeup source with a null name when wakeup_source_register()
>>> gets called with dev_name(dev) which is null at the time.
>>>
>>> When kernel is booted with wakeup_source_activate enabled, it will panic
>>> when the trace point code tries to dereference ws->name. Registering a
>>> a wakeup source without a name should be possible.
>>>
>>> Fix tracing infrastructure to be more robust in handling null strings in
>>> __assign_string() and __string(). With this change null string is handled
>>> gracefully and replacing it with "(null)" when trace is generated. This will
>>> address the problem at the tracing infrastructure level which is better than
>>> fixing individual tracepoint code.
>>>
>>> Trace after the fix:
>>>              bash-2177  [000] d...   583.560106: wakeup_source_activate: (null) state=0x20001
>>>       kworker/0:2-378   [000] d...   583.560714: wakeup_source_deactivate: (null) state=0x30000
>>>
>>> Oops message:
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
>>> Cc: stable@vger.kernel.org
>>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The below is my patch. I have it in my queue and I will be pushing it
> after it succeeds all my testing.
>
> -- Steve

I am happy as long as the problem is fixed. :)

-- Shuah

>
>>
>>> ---
>>>   include/trace/ftrace.h | 7 +++++--
>>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
>>> index 52594b2..79f4639 100644
>>> --- a/include/trace/ftrace.h
>>> +++ b/include/trace/ftrace.h
>>> @@ -372,7 +372,9 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
>>>   	__data_size += (len) * sizeof(type);
>>>
>>>   #undef __string
>>> -#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
>>> +#define __string(item, src)						\
>>> +	__dynamic_array(char, item,					\
>>> +	   strlen((const char *)src ? (const char *)src : "(null)") + 1)
>>>
>>>   #undef DECLARE_EVENT_CLASS
>>>   #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>>> @@ -501,7 +503,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
>>>
>>>   #undef __assign_str
>>>   #define __assign_str(dst, src)						\
>>> -	strcpy(__get_str(dst), src);
>>> +	strcpy(__get_str(dst),						\
>>> +		((const char *)src ? (const char *)src : "(null)"))
>>>
>>>   #undef TP_fast_assign
>>>   #define TP_fast_assign(args...) args
>>>
>
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
