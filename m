Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaLIXAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:00:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:56930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbaLIXAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,548,1413270000"; 
   d="scan'208";a="635246401"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Calvin Owens <calvinowens@fb.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Thread-Topic: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Thread-Index: AQHQEDOY6s0/Sb23BUq9y5V5/Trac5yIHAGA///FtYA=
Date: Tue, 9 Dec 2014 23:00:02 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
 <20141209180835.GF3990@pd.tnic>
In-Reply-To: <20141209180835.GF3990@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB9N0Ltv002778

> Right, so this polling thing once again proves its fragility to me - we
> have had problems with it in the past so maybe we should think about
> replacing it with something simpler and and much more robust instead of
> this flaky dynamically adjustable polling thing.

Dynamic intervals for polling make sense for cpus that don't support
CMCI.  We need to check occasionally to see if there are any corrected errors,
but we don't want to waste a lot of cpu time doing that too often. There are
almost never any errors to be found. So begin polling at 5 minute intervals
(eternity on a multi-GHz cpu). If we do find an error, then look more frequently,
because there are several cases where a single error source might generate
multiple errors (e.g. stuck bit).

But then we came along an co-opted this mechanism  for CMCI storm
control.  And you are right that we made things needlessly complex
by using the same variable rate mechanism.  If we had a storm, we know
we are having a high rate of errors (15 in one second) ... so we just want
to poll at a high-ish rate to collect a good sample of subsequent errors.
Also to detect when the storm ends in a timely manner. So we don't
gain much by tweaking the poll rate, and we have complex code.

> So I'm thinking of leaving the detection code as it is, when we detect
> a storm on a CPU, we set CMCI_STORM_ACTIVE and start a kernel thread at
> max freq HZ/100 and polling the MCA banks. No adjustable frequency, no
> timers, no nothing. A stupid per-cpu thread which polls.

Go for it.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
