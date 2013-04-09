Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935758Ab3DIXzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:55:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:24859 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935092Ab3DIXzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:55:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="316894988"
Message-ID: <33544.10.7.197.74.1365551736.squirrel@linux.intel.com>
In-Reply-To: <38514.10.7.197.74.1365440092.squirrel@linux.intel.com>
References: <1363886546-6517-1-git-send-email-daniel.leung@linux.intel.com>
    <51507136.4020308@linux.intel.com>
    <alpine.LNX.2.00.1303271608500.23442@pobox.suse.cz>
    <38514.10.7.197.74.1365440092.squirrel@linux.intel.com>
Date: Tue, 9 Apr 2013 16:55:36 -0700 (PDT)
Subject: Re: [PATCH] HID: hid-sensor-hub: do not process feature reports in 
          raw_event
From: "Daniel Leung" <daniel.leung@linux.intel.com>
To: "Daniel Leung" <daniel.leung@linux.intel.com>
Cc: "Jiri Kosina" <jkosina@suse.cz>,
        "Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
        daniel.leung@linux.intel.com, srinivas.pandruvada@intel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Mon, 25 Mar 2013, Srinivas Pandruvada wrote:
>>
>>> Daniel,
>>>
>>> I am looking at 3.9.rc1.
>>> The only place I see the raw_event callback is called from
>>> hid/hid_input_report(). hid_input_report is called with type
>>> HID_INPUT_REPORT
>>> in all cases, except hid_ctrl(), where it can be different depending on
>>> xx.report->type. But here, the return value is not checked.
>>>
>>> Do you know the call chain for HID_FETURE_REPORT, where this is
>>> creating
>>> problem?
>>
>> This was exactly what I was wondering about when I have seen the initial
>> patch a few weeks ago.
>>
>> Daniel, could you please elaborate? Is there a out-of-tree driver for
>> Acer
>> Iconia W700?
>
> Sorry for the late reply. I was out of town and was having difficulties
> accessing the mail server.
>
> For the call path, here is what I got (using WARN_ON()):
>
> <4>[  150.943775] ------------[ cut here ]------------
> <4>[  150.943861] WARNING: at
> ../../../../../../../../../../home/dleung/android/ia/private/jb-mr1-internal/kernel/intel/drivers/hid/hid-sensor-hub.c:418
> sensor_hub_raw_event+0x2d0/0x3b0 [hid_sensor_hub]()
> <4>[  150.944028] Hardware name: ICONIA W700
> <7>[  150.944071] Modules linked in: hid_sensor_als hid_sensor_gyro_3d
> hid_sensor_accel_3d uvcvideo videobuf2_vmalloc videobuf2_memops
> videobuf2_core btusb bluetooth hid_multitouch ath9k ath9k_common ath9k_hw
> ath snd_hda_codec_hdmi snd_hda_codec_realtek ip6table_raw snd_hda_intel
> iptable_raw snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd
> soundcore hid_sensor_trigger hid_sensor_iio_common hid_sensor_hub
> industrialio_triggered_buffer kfifo_buf industrialio coretemp
> <7>[  150.944132] Pid: 0, comm: swapper/1 Not tainted
> 3.8.0-aia1-00043-gd7fd780-dirty #2
> <7>[  150.944136] Call Trace:
> <7>[  150.944141]  <IRQ>  [<ffffffff8105b5bf>]
> warn_slowpath_common+0x7f/0xc0
> <7>[  150.944163]  [<ffffffff8105b61a>] warn_slowpath_null+0x1a/0x20
> <7>[  150.944173]  [<ffffffffa00315e0>] sensor_hub_raw_event+0x2d0/0x3b0
> [hid_sensor_hub]
> <7>[  150.944184]  [<ffffffff819021e7>] ?
> _raw_spin_unlock_irqrestore+0x57/0x70
> <7>[  150.944195]  [<ffffffff816ccce3>] hid_input_report+0x283/0x2d0
> <7>[  150.944203]  [<ffffffff816d9faf>] hid_ctrl+0x9f/0x180
> <7>[  150.944212]  [<ffffffff815b2087>] usb_hcd_giveback_urb+0x77/0x110
> <7>[  150.944222]  [<ffffffff8160073f>] xhci_irq+0x60f/0x1530
> <7>[  150.944230]  [<ffffffff810df0fe>] ? handle_edge_irq+0x1e/0x130
> <7>[  150.944239]  [<ffffffff810af04f>] ?
> __lock_acquire.isra.31+0x28f/0xa70
> <7>[  150.944247]  [<ffffffff81601671>] xhci_msi_irq+0x11/0x20
> <7>[  150.944258]  [<ffffffff810dc395>] handle_irq_event_percpu+0x55/0x210
> <7>[  150.944267]  [<ffffffff810dc598>] handle_irq_event+0x48/0x70
> <7>[  150.944273]  [<ffffffff810df157>] handle_edge_irq+0x77/0x130
> <7>[  150.944283]  [<ffffffff81004180>] handle_irq+0x60/0x150
> <7>[  150.944293]  [<ffffffff81906406>] ?
> atomic_notifier_call_chain+0x16/0x20
> <7>[  150.944302]  [<ffffffff8190c38a>] do_IRQ+0x5a/0xe0
> <7>[  150.944309]  [<ffffffff8190266f>] common_interrupt+0x6f/0x6f
> <7>[  150.944313]  <EOI>  [<ffffffff816a97f5>] ?
> cpuidle_wrap_enter+0x55/0xa0
> <7>[  150.944327]  [<ffffffff816a97f1>] ? cpuidle_wrap_enter+0x51/0xa0
> <7>[  150.944334]  [<ffffffff816a9850>] cpuidle_enter_tk+0x10/0x20
> <7>[  150.944341]  [<ffffffff816a940f>] cpuidle_idle_call+0xaf/0x2b0
> <7>[  150.944350]  [<ffffffff8100b3aa>] cpu_idle+0xda/0x130
> <7>[  150.944360]  [<ffffffff818f081d>] start_secondary+0x266/0x268
> <4>[  150.944365] ---[ end trace 32319d39ebee5616 ]---
>
>
> You can see that it went through hid_ctrl().
>
> From what I can gather using usbmon, the sensor hub sends the feature
> report correctly. However, the in-kernel struct is not updated when the
> report comes in. Therefore, the report from sensor_hub_report() is always
> zero-filled. When calling sensor_hub_set_feature(), those zeros are being
> sent back to the device. The feature report contains fields for power
> state and reporting state. If they are set to zero, the firmware does not
> know what to do as zero means undefined state. Both power and reporting
> states have to be set for sensor to report values. Given the zero-filled
> report, and we can only deal with one field in sensor_hub_set_feature(),
> setting power state to non-zero also sends zero (i.e. undefined state) to
> the reporting state field, and vice versa.
>
> The sensor hub on Acer Iconia W700 is using drivers/hid/hid-sensor-hub.c.
> I also played with Sony Vaio Duo 11 a while back (before having this
> patch), and was having trouble turning on gyroscope. I suspect it is
> caused by the same issue. The sensor hub on Acer is from STMicro, while
> the one in Vaio Duo is from Freescale.

Just to clarify a little bit on the issue.

Although hid_ctrl() does not care the return value of hid_input_report(),
the issue is within hid_input_report(). In drivers/hid/hid-core.c:1317
where raw_event() is called, if return is non-zero, the following call of
hid_report_raw_event() is skipped. This call is needed to have the
in-kernel struct updated with the actual feature report from device.


Daniel
