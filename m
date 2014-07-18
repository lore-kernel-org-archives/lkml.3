Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708AbaGRRSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:18:49 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:55425 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965820AbaGRRSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:18:47 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
 from the basic I/O timeout
Thread-Index: AQHPgAqrrlGx/1kfQ0SPzg5EQKxH1pthLVSAgAADsICAAh1LgIAAFoiAgADx34CAAAl2AIAACGQAgBY20ACAKpUsgIAAA6+ggAEEl4CAABaekA==
Date: Fri, 18 Jul 2014 17:17:31 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958BB2E3D@G9W0745.americas.hpqcorp.net>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
	 <1401901323.17510.23.camel@dabdike>
	 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
	 <53911A35.7010805@cs.wisc.edu>
	 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
	 <5391F801.4010107@cs.wisc.edu>
	 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
	 <539206FA.1020001@kernel.dk>
	 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
	 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
	 <94D0CD8314A33A4D9D801C0FE68B402958BAC6DC@G9W0745.americas.hpqcorp.net>
 <1405697964.605.27.camel@jarvis.lan>
In-Reply-To: <1405697964.605.27.camel@jarvis.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6IHIrkw017503



> From: James Bottomley [mailto:jbottomley@parallels.com]
> 
> On Fri, 2014-07-18 at 00:51 +0000, Elliott, Robert (Server Storage)
> wrote:
...
> >
> > Also, in both sd_setup_flush_cmnd and sd_sync_cache:
> >       cmd->cmnd[0] = SYNCHRONIZE_CACHE;
> >       cmd->cmd_len = 10;
> >
> > SYNCHRONIZE CACHE (16) should be favored over SYNCHRONIZE
> > CACHE (10) unless SYNCHRONIZE CACHE (10) is not supported.

(sorry - meant "unless ... 16 is not supported")

> For what reason.  We usually go for the safe alternatives, which is 10
> byte commands because they have the widest testing and greatest level of
> support.  We don't do range flushes currently, so there doesn't seem to
> be a practical different.  If we did support range flushes, we'd likely
> only use SC(16) on >2TB devices.
> 
> James

A goal of the simplified SCSI feature set idea is to drop all the
short CDBs that have larger, more capable equivalents - don't carry
READ 6/10/12/16 and SYNCHRONIZE CACHE 10/16, just keep the 16-byte 
versions.  With modern serial IU-based protocols, short CDBs don't 
save any transfer time.  This will simplify design and testing on
both initiator and target sides. Competing command sets like NVMe 
rightly point out that SCSI has too much legacy baggage - all you 
need for IO is one READ, one WRITE, and one FLUSH command.

That's why SBC-3 ended up with these warning notes for all the
non-16 byte CDBs:

	NOTE 15 - Migration from the SYNCHRONIZE CACHE (10) command to
	the SYNCHRONIZE CACHE (16) command is recommended for all
	implementations.

If the LBA field in SYNCHRONIZE CACHE went obsolete, then maybe
SYNCHRONIZE CACHE (10) would be kept instead of (16), but that
field is still present.  So, (16) is the likely survivor.

---
Rob Elliott    HP Server Storage


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
