Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab3BUCBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:01:17 -0500
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:50920 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab3BUCBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:01:15 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Lubomir Rintel <lkundrak@v3.sk>
CC: Harro Haan <hrhaan@gmail.com>, Dan Williams <dcbw@redhat.com>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Feb 2013 17:59:43 -0800
Subject: RE: [PATCH] libertas sdio: remove CMD_FUNC_INIT call
Thread-Topic: [PATCH] libertas sdio: remove CMD_FUNC_INIT call
Thread-Index: Ac4OXCKUhkr4IZLyTnS2gs+wqAcsnwBeiRvw
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D6CEA08@SC-VEXCH1.marvell.com>
References: <1358493883-28433-1-git-send-email-lkundrak@v3.sk>
	 <477F20668A386D41ADCC57781B1F70430D140B07DE@SC-VEXCH1.marvell.com>
 <1361249203.14137.27.camel@unicorn.kokotovo>
In-Reply-To: <1361249203.14137.27.camel@unicorn.kokotovo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1L21ak1007294

Hi Lubomir,

> > > @@ -825,20 +825,6 @@ static void if_sdio_finish_power_on(struct if_sdio_card *card)
> > >
> > >  	sdio_release_host(func);
> > >
> > > -	/*
> > > -	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
> > > -	 */
> > > -	if (card->model == MODEL_8688) {
> > > -		struct cmd_header cmd;
> > > -
> > > -		memset(&cmd, 0, sizeof(cmd));
> > > -
> > > -		lbs_deb_sdio("send function INIT command\n");
> > > -		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
> > > -				lbs_cmd_copyback, (unsigned long) &cmd))
> > > -			netdev_alert(priv->dev, "CMD_FUNC_INIT cmd failed\n");
> > > -	}
> > > -
> >
> > Removing FUNC_INIT could break things in some scenarios.
> > Could you please test the following case?
> >
> > 1. insmod liberates -> download firmware, send FUNC_INIT, ...
> > 2. rmmod libertas -> send FUNC_SHUTDOWN command to firmware; BT is still working.
> > 3. insmod libertas -> skip firmware downloading, send FUNC_INIT, ...
> >
> > If FUNC_INIT is removed, I don't expect step 3 to work.
> 
> In case btmrvl_sdio is loaded, the driver always locks up in FUNC_INIT
> upon probe time, thus I'm not able to proceed to further steps.
> 
> [  209.338953] [<c0502248>] (__schedule+0x610/0x764) from [<bf20ae24>] (__lbs_cmd+0xb8/0x130
> [libertas])
> [  209.348340] [<bf20ae24>] (__lbs_cmd+0xb8/0x130 [libertas]) from [<bf222474>]
> (if_sdio_finish_power_on+0xec/0x1b0 [libertas_sdio])
> [  209.360136] [<bf222474>] (if_sdio_finish_power_on+0xec/0x1b0 [libertas_sdio]) from [<bf2226c4>]
> (if_sdio_power_on+0x18c/0x20c [libertas_sdio])
> [  209.373052] [<bf2226c4>] (if_sdio_power_on+0x18c/0x20c [libertas_sdio]) from [<bf222944>]
> (if_sdio_probe+0x200/0x31c [libertas_sdio])
> [  209.385316] [<bf222944>] (if_sdio_probe+0x200/0x31c [libertas_sdio]) from [<bf01d820>]
> (sdio_bus_probe+0x94/0xfc [mmc_core])
> [  209.396748] [<bf01d820>] (sdio_bus_probe+0x94/0xfc [mmc_core]) from [<c02e729c>]
> (driver_probe_device+0x12c/0x348)
> [  209.407214] [<c02e729c>] (driver_probe_device+0x12c/0x348) from [<c02e7530>]
> (__driver_attach+0x78/0x9c)
> [  209.416798] [<c02e7530>] (__driver_attach+0x78/0x9c) from [<c02e5658>] (bus_for_each_dev+0x50/0x88)
> [  209.425946] [<c02e5658>] (bus_for_each_dev+0x50/0x88) from [<c02e6810>]
> (bus_add_driver+0x108/0x268)
> [  209.435180] [<c02e6810>] (bus_add_driver+0x108/0x268) from [<c02e782c>]
> (driver_register+0xa4/0x134)
> [  209.444426] [<c02e782c>] (driver_register+0xa4/0x134) from [<bf22601c>]
> (if_sdio_init_module+0x1c/0x3c [libertas_sdio])
> [  209.455339] [<bf22601c>] (if_sdio_init_module+0x1c/0x3c [libertas_sdio]) from [<c00085b8>]
> (do_one_initcall+0x98/0x174)
> [  209.466236] [<c00085b8>] (do_one_initcall+0x98/0x174) from [<c0076504>] (load_module+0x1c5c/0x1f80)
> [  209.475390] [<c0076504>] (load_module+0x1c5c/0x1f80) from [<c007692c>]
> (sys_init_module+0x104/0x128)
> [  209.484632] [<c007692c>] (sys_init_module+0x104/0x128) from [<c0008c40>]
> (ret_fast_syscall+0x0/0x38)
> 
> In case btmrvl_sdio is _not_ loaded, insmod returns, but driver locks up
> waiting for FUNC_INIT to finish:
> 
> [  300.538859] [<c0502248>] (__schedule+0x610/0x764) from [<bf1fae24>] (__lbs_cmd+0xb8/0x130
> [libertas])
> [  300.548600] [<bf1fae24>] (__lbs_cmd+0xb8/0x130 [libertas]) from [<bf212474>]
> (if_sdio_finish_power_on+0xec/0x1b0 [libertas_sdio])
> [  300.560398] [<bf212474>] (if_sdio_finish_power_on+0xec/0x1b0 [libertas_sdio]) from [<bf213230>]
> (if_sdio_do_prog_firmware+0x414/0x454 [libertas_sdio])
> [  300.574052] [<bf213230>] (if_sdio_do_prog_firmware+0x414/0x454 [libertas_sdio]) from [<bf1fffbc>]
> (lbs_fw_loaded+0x24/0x58 [libertas])
> [  300.586907] [<bf1fffbc>] (lbs_fw_loaded+0x24/0x58 [libertas]) from [<c02f02c0>]
> (request_firmware_work_func+0xb0/0xf4)
> [  300.597746] [<c02f02c0>] (request_firmware_work_func+0xb0/0xf4) from [<c003ae0c>]
> (process_one_work+0x348/0x6a8)
> [  300.608288] [<c003ae0c>] (process_one_work+0x348/0x6a8) from [<c003b408>]
> (worker_thread+0x268/0x390)
> [  300.617630] [<c003b408>] (worker_thread+0x268/0x390) from [<c00414b0>] (kthread+0xc0/0xd4)
> [  300.625947] [<c00414b0>] (kthread+0xc0/0xd4) from [<c0008ce8>] (ret_from_fork+0x14/0x20)
> [  300.634135] 2 locks held by kworker/0:1/19:
> [  300.638383]  #0:  (events){.+.+.+}, at: [<c003accc>] process_one_work+0x208/0x6a8
> [  300.646512]  #1:  ((&fw_work->work)){+.+.+.}, at: [<c003accc>] process_one_work+0x208/0x6a8

There seems to be a race condition in lbs_thread().

At line 582:
 582                 if (!priv->fw_ready)
 583                         continue;

The fw_ready is 0, so you never get the chance to execute the FUNC_INIT command.

 617                 /* Execute the next command */
 618                 if (!priv->dnld_sent && !priv->cur_cmd)
 619                         lbs_execute_next_command(priv);


Could you try the following change?

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libe
index 739309e..8f5d977 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -825,6 +825,8 @@ static void if_sdio_finish_power_on(struct if_sdio_card *car

        sdio_release_host(func);

+       priv->fw_ready = 1;
+
        /*
         * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
         */
@@ -839,7 +841,6 @@ static void if_sdio_finish_power_on(struct if_sdio_card *car
                        netdev_alert(priv->dev, "CMD_FUNC_INIT cmd failed\n");
        }

-       priv->fw_ready = 1;
        wake_up(&card->pwron_waitq);

        if (!card->started) {

Thanks,
Bing

> 
> If I remove the FUNC_INIT call, wifi works fine, but bluetooth stops
> working after a network scan:
> 
> [root@megalodon lkundrak]# iwlist scan >/dev/null 2>&1
> [root@megalodon lkundrak]# hcitool scan --flush
> Device is not available: No such device
> [root@megalodon lkundrak]#
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
