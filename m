Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaIZNEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:04:23 -0400
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:2491
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753908AbaIZNEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:04:22 -0400
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2014 09:04:21 EDT
From: Thomas Shao <huishao@microsoft.com>
To: Mike Surcouf <mps.surcouf.lkml@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Olaf Hering <olaf@aepfle.de>, "Robo Bot" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
Thread-Topic: [PATCH] Drivers: hv: util: Implement Time Synchronization
 using host time sample
Thread-Index: AQHP2XESGfKWnzoNvEy532a+Bg3JTpwTTgaAgAAIEqA=
Date: Fri, 26 Sep 2014 12:30:14 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD8401415409846D@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411725736-49225-1-git-send-email-huishao@microsoft.com>
 <CAL7Bo8HoYU1mbUbw-k0ufj7n8D=Z_hLtf268gKeyACcnZHH5rw@mail.gmail.com>
In-Reply-To: <CAL7Bo8HoYU1mbUbw-k0ufj7n8D=Z_hLtf268gKeyACcnZHH5rw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.91.240.4]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(51704005)(377454003)(199003)(189002)(13464003)(16796002)(92726001)(86362001)(47776003)(74662003)(33656002)(85852003)(77982003)(54356999)(66066001)(31966008)(10300001)(26826002)(86612001)(92566001)(50466002)(23676002)(64706001)(20776003)(83072002)(77096002)(2656002)(95666004)(50986999)(76482002)(86146001)(55846006)(69596002)(87936001)(106116001)(74502003)(110136001)(81342003)(44976005)(83322001)(19580405001)(80022003)(4396001)(6806004)(81156004)(21056001)(76176999)(107046002)(106466001)(90102001)(81542003)(85306004)(99396003)(79102003)(68736004)(84676001)(19580395003)(97736003)(120916001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1214;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8QD4RU8032263


> -----Original Message-----
> From: Mike Surcouf [mailto:mps.surcouf.lkml@gmail.com]
> Sent: Friday, September 26, 2014 7:53 PM
> To: Thomas Shao
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; Olaf Hering; Robo Bot;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
> host time sample
> 
> > +/* helper function to call adjtimex command in user mode */ static
> > +void run_adjtimex_cmd(s64 tickvalue) {
> > +       char *argv[4], *envp[3];
> > +       char str_tickvalue[20];
> > +
> > +       sprintf(str_tickvalue, "%lld", tickvalue);
> > +
> > +       argv[0] = "/sbin/adjtimex";
> > +       argv[1] = "-t";
> > +       argv[2] = str_tickvalue;
> > +       argv[3] = NULL;
> > +
> > +       envp[0] = "HOME=/";
> > +       envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
> > +       envp[2] = NULL;
> > +
> > +       call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC); }
> 
> 
> What happens when adjtimex is not present?
> Is there no kernel space function for that?
> Does this patch affect "not setting correct time on restore" or "not setting
> correct time on  live migration" bug?
> 

If adjtimex is not present, then the slew time part didn't take effect.
There is a kernel space do_adjtmex, but it's only for sys call and not exposed to module. So I didn't use it in my patch.
With this patch, it will step the clock if the time drift is larger than 1 seconds, so it can solve
the issue your mentioned. And on the other hand, "setting correct time on restore" is already fixed
in other patch, which is already in upstream.


> Thanks
> 
> Mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
