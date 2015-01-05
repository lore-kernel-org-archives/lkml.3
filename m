Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbbAECLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 21:11:49 -0500
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:39456
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752989AbbAECLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 21:11:47 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v17 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v17 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQJJeXOvuLh01Zx0CtOZ9FR0tCH5yp36QAgAbp+uA=
Date: Mon, 5 Jan 2015 01:57:29 +0000
Message-ID: <BN1PR06MB07053E7C7D520975F08D0BFD1580@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1419988621-2919-1-git-send-email-dudl@cypress.com>
 <20141231161120.GA1385@newt.localdomain>
In-Reply-To: <20141231161120.GA1385@newt.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0601MB1074;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1074;
x-forefront-prvs: 0447DB1C71
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(164054003)(189002)(51164003)(51704005)(199003)(13464003)(33656002)(107046002)(40100003)(50986999)(110136001)(101416001)(74316001)(92566001)(122556002)(102836002)(97736003)(66066001)(68736005)(64706001)(31966008)(54606007)(76176999)(77156002)(20776003)(120916001)(54356999)(62966003)(87936001)(1411001)(86362001)(2950100001)(2900100001)(99396003)(54206007)(2656002)(99286002)(19580395003)(19580405001)(46102003)(4396001)(21056001)(105586002)(106116001)(76576001)(106356001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0601MB1074;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2015 01:57:29.5811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0601MB1074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t052Buie003008

Thanks, Jeremiah.

It seems the power manage code has been updated in kernel-next,
the same code didn't genereate any error before.
I updated with latest kernel-next, the compiling error also happened.
To fix this code, need to add stubs for cyapa_runtime_suspend() and
cyapa_runtime_resume() when CONFIG_PM_RUNTIME is not defined.

 #ifdef CONFIG_PM_RUNTIME
 static int cyapa_runtime_suspend(struct device *dev)
 {
 struct cyapa *cyapa = dev_get_drvdata(dev);
 int error;

 error = cyapa->ops->set_power_mode(cyapa,
 cyapa->runtime_suspend_power_mode,
 cyapa->runtime_suspend_sleep_time);
 if (error)
 dev_warn(dev, "runtime suspend failed: %d\n", error);

 return 0;
 }

 static int cyapa_runtime_resume(struct device *dev)
 {
 struct cyapa *cyapa = dev_get_drvdata(dev);
 int error;

 error = cyapa->ops->set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE, 0);
 if (error)
 dev_warn(dev, "runtime resume failed: %d\n", error);

 return 0;
 }
+#else
+static inline int cyapa_runtime_suspend(struct device *dev) { return 0; }
+static inline int cyapa_runtime_resume(struct device *dev) { return 0; }
 #endif /* CONFIG_PM_RUNTIME */

 static const struct dev_pm_ops cyapa_pm_ops = {
 SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
 SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume, NULL)
 };

Thanks,
dudley

> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: 2015å¹´1æœˆ1æ—¥ 0:11
> To: Dudley Du
> Cc: dmitry.torokhov@gmail.com; rydberg@euromail.se; bleung@google.com;
> David Solda; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v17 00/12] input: cyapa: instruction of cyapa patches
>
> Dudley,
>
> On Wed, Dec 31, 2014 at 09:16:49AM +0800, Dudley Du wrote:
> > V17 patches have below updates, details of other updates see history list:
> > 1) Fix kernel oops when system booting up with finger on TP.
> > 2) Remove unnecessary error log that may to system.
> > 3) Slipt out pm sleep code into cyapa_prepare_wakeup_controls(),
> >    remove #indefs in function body of CONFIG_PM_SLEEP and
> CONFIG_PM_RUNTIME.
> > 4) Supply stubs to cyapa_gen3_ops and cyapa_gen5_ops data structure to avoid
> >    checking for presence of various methods in ops.
> > 6) Fix the meanings of some comments and return error code not clear issue.
> [...]
>
> It has build errors :(
>
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CHK     kernel/config_data.h
>   CC [M]  drivers/input/mouse/cyapa.o
> In file included from include/linux/device.h:25:0,
>                  from include/linux/i2c.h:30,
>                  from drivers/input/mouse/cyapa.c:18:
> drivers/input/mouse/cyapa.c:1339:21: error: â€˜cyapa_runtime_suspendâ€™
> undeclared here (not in a function)
>   SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume,
> NULL)
>                      ^
> include/linux/pm.h:347:21: note: in definition of macro â€˜SET_RUNTIME_PM_OPSâ€™
>   .runtime_suspend = suspend_fn, \
>                      ^
> drivers/input/mouse/cyapa.c:1339:44: error: â€˜cyapa_runtime_resumeâ€™
> undeclared here (not in a function)
>   SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume,
> NULL)
>                                             ^
> include/linux/pm.h:348:20: note: in definition of macro â€˜SET_RUNTIME_PM_OPSâ€™
>   .runtime_resume = resume_fn, \
>                     ^
> scripts/Makefile.build:257: recipe for target 'drivers/input/mouse/cyapa.o' failed
> make[3]: *** [drivers/input/mouse/cyapa.o] Error 1
> scripts/Makefile.build:402: recipe for target 'drivers/input/mouse' failed
> make[2]: *** [drivers/input/mouse] Error 2
> scripts/Makefile.build:402: recipe for target 'drivers/input' failed
> make[1]: *** [drivers/input] Error 2
> make[1]: *** Waiting for unfinished jobs....
> Makefile:955: recipe for target 'drivers' failed
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....
>
> --
> - Jeremiah Mahler

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
