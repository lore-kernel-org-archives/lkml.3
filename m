Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbbAMRVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:21:35 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43882 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbAMRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:21:33 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <54B536BA.3070001@imgtec.com>
References: <1421147933-21802-1-git-send-email-qais.yousef@imgtec.com> <20150113145931.GD3085@intel.com> <54B536BA.3070001@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2] ALSA: ASoC: soc-compress.c: fix NULL dereference
From: James Hogan <james.hogan@imgtec.com>
Date: Tue, 13 Jan 2015 17:21:12 +0000
To: Qais Yousef <qais.yousef@imgtec.com>, Vinod Koul <vinod.koul@intel.com>
CC: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Message-ID: <BB5B134B-1BFA-4F77-A8CC-45C0137EBF57@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 January 2015 15:16:10 GMT+00:00, Qais Yousef <qais.yousef@imgtec.com> wrote:
>On 01/13/2015 02:59 PM, Vinod Koul wrote:
>> On Tue, Jan 13, 2015 at 11:18:53AM +0000, Qais Yousef wrote:
>>> In soc_new_compress() when rtd->dai_link->daynmic is set, we create
>the pcm
>> 					   ^^^^^^^^
>> typo
>>> substreams with this call:
>>>
>>>     ret = snd_pcm_new_internal(rtd->card->snd_card, new_name, num,
>>>                                     1, 0, &be_pcm);
>>>
>>> which passes 0 as capture_count leading to
>>>
>>>     be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream
>>>
>>> being NULL, hence when trying to set rtd a few lines below we get an
>oops.
>> It is a good practice to add the oops here
>
>Will this really be helpful? I think it'll be more clutter (the 
>backtrace on metag arch is not great):

I suspect you don't have frame pointers enabled in your kernel config. That should improve the meaningfulness of the backtrace.

>
>Oops: err 8007 (Unknown fault) addr 00000008 [#1]
>  Modules linked in:
>  CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.18.0-rc4+ #1904
>  Workqueue: deferwq _deferred_probe_work_func
>  task: 4f030780 ti: 4f044000 task.ti: 4f044000
>   pt_regs @ 4f044388
>   SaveMask = 0x4041
>   Flags = 0x0008 (Znoc)
>   TXRPT = 0x00000000
>   PC = 0x402e6c58
>   A0StP = 0x4f044388     A1GbP = 0x60001000
>   A0FrP = 0x4f044110     A1LbP = 0x40000048
>   A0.2  = 0x00000000     A1.2  = 0x00000000
>   A0.3  = 0x40090000     A1.3  = 0x00000001
>   D0Re0 = 0x00000000     D1Re0 = 0x00000001
>   D0Ar6 = 0x00000000     D1Ar5 = 0x4b5c1a00
>   D0Ar4 = 0x4f044330     D1Ar3 = 0x405833a8
>   D0Ar2 = 0x4f1d7170     D1Ar1 = 0x4b5c25a0
>   D0FrT = 0x00000001     D1RtP = 0x402e6c20
>   D0.5  = 0x00000000     D1.5  = 0x4f1f65c4
>   D0.6  = 0x4f1f65c4     D1.6  = 0x4f1d0500
>   D0.7  = 0x00000001     D1.7  = 0x4f1e3e40
>
>  Call trace:
>  [<40410004>] _ieee80211_change_bss+0x1b4/0x220
>  [<400f8034>] _kernfs_add_one+0x10c/0x17c
>  [<400fa2b0>] ___kernfs_create_file+0x94/0xdc
>  [<402d8bf0>] _snd_soc_register_card+0x12b8/0x1380
>  [<400170e8>] ___request_region+0x58/0x150
>  [<402068b4>] _devres_add+0x14/0x2c
>  [<402e97f0>] _zero1xx_probe+0x2b8/0x37c
>  [<40205004>] _platform_drv_probe+0x4c/0xc0
>  [<40204fb4>] _platform_drv_remove+0x3c/0x40
>  [<402032e0>] _driver_probe_device+0xc8/0x294
>  [<40204fb4>] _platform_drv_remove+0x3c/0x40
>  [<40203624>] _wait_for_device_probe+0x7c/0x80
>  [<40201cac>] _bus_for_each_drv+0x5c/0xb0
>  [<40203708>] _device_attach+0x84/0x9c
>  [<40202258>] _bus_probe_device+0x90/0xd0
>  [<4020354c>] _deferred_probe_work_func+0x70/0xac
>  [<40025d84>] _process_one_work+0x110/0x364
>  [<402034d8>] _device_bind_driver+0x2c/0x30
>  [<40046150>] _mod_timer+0xc4/0x178
>  [<400286a4>] _worker_thread+0x14c/0x4d4
>  [<4002b90c>] _kthread_parkme+0x14/0x18
>  [<40028554>] _pool_mayday_timeout+0xe8/0xec
>  [<4002ba08>] _kthread+0xf8/0x100
>  [<4000aeb4>] _ret_from_fork+0x44/0x110
>  [<4002b90c>] _kthread_parkme+0x14/0x18
>  [<40000044>] _text+0x44/0x48
>  [<40000044>] _text+0x44/0x48
>  [<4002b90c>] _kthread_parkme+0x14/0x18
>
>  Process: kworker/u2:0 (pid: 6, stack limit = 4f046000)
>  ---[ end trace fabdbb359f5c60d8 ]---


--
James Hogan
