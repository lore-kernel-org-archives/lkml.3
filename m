Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaIBQA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:00:58 -0400
Received: from mail-db3lrp0079.outbound.protection.outlook.com ([213.199.154.79]:2898
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754190AbaIBQA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:00:56 -0400
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2014 12:00:55 EDT
From: Itzcak Pechtalt <itzcak@flashnetworks.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@redhat.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Race condition in HR timers that cause double insertion and hard
 lockup -- all latest versions
Thread-Topic: Race condition in HR timers that cause double insertion and hard
 lockup -- all latest versions
Thread-Index: Ac/GxJS2CAsOsHuZTuKoM+hFYbOusA==
Date: Tue, 2 Sep 2014 15:45:59 +0000
Message-ID: <5dfbace37c434be58ed26ea524aa0675@AM3PR06MB388.eurprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [212.143.111.82]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199003)(377424004)(31966008)(74502001)(74662001)(108616004)(85306004)(50986999)(99396002)(33646002)(19580405001)(19580395003)(83322001)(54356999)(110136001)(46102001)(81542001)(21056001)(64706001)(85852003)(101416001)(83072002)(90102001)(79102001)(80022001)(15975445006)(66066001)(2656002)(86362001)(77982001)(76482001)(105586002)(2351001)(20776003)(87936001)(4396001)(229853001)(92566001)(76576001)(107046002)(95666004)(74316001)(81342001)(106356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:AM3PR06MB385;H:AM3PR06MB388.eurprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: flashnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I opened a bug in https://bugzilla.kernel.org/show_bug.cgi?id=83601  for this subject with full description.
There is also a short fix patch for kernel/hrtimer.c file.
Even if this bug occurs rary, however it resolves system hard lockup option.

I suspect that it was targeted by mistake to not active list (timers_realtime-clock@kernel-bugs.osdl.org).
Following is the fix patch based on kernel 3.16.1 (just simple):
diff -uNr a/kernel/hrtimer.c b/kernel/hrtimer.c
--- a/kernel/hrtimer.c 2014-08-31 20:59:52.177452123 +0300
+++ b/kernel/hrtimer.c 2014-08-31 21:02:14.972166540 +0300
@@ -941,7 +941,7 @@
if (!timerqueue_getnext(&base->active))
base->cpu_base->active_bases &= ~(1 << base->index);
out:
- timer->state = newstate;
+ timer->state = (newstate | (timer_state & HRTIMER_STATE_CALLBACK));
}

/*

Is there a chance for this patch fix to insert into next kernel release?

Thanks

Itzcak Pechtalt

