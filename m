Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3JRU5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:57:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:40424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3JRU52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:57:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,525,1378882800"; 
   d="scan'208";a="395141004"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Thread-Topic: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Thread-Index: AQHOy92NO8Ykl3Pixk2WuH27ZgvdfZn621sAgAAEVACAAAzW0A==
Date: Fri, 18 Oct 2013 20:57:22 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D41E37@ORSMSX106.amr.corp.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com> <20131018125326.GC1007@pd.tnic>
In-Reply-To: <20131018125326.GC1007@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9IKvv4a020676

> Hmm, that's a good question you raise: but the more important question
> is, do you guys - Gong and Tony - want to replace the logging we're
> already doing, i.e. mce_log() with extlog or not.

Long term ... I'd be happy to see mce_log() go away.  But we need to have
a robust, well tested replacement in place for some time before such a
move is up for discussion.

> Because if you want to replace the current logging you actually have to
> exit machine_check_poll() after having done mce_ext_err_print() so that
> the rest of the chain doesn't see the error.

Yes - double error reporting should be avoided.

> And, does mce_ext_err_print only report DRAM ECC errors or other error
> types too?

Our first platforms to implement this only do so for memory errors.  This
could change in the future (the UEFI appendix N error record has defined
sub-sections for lots of types of errors).

Currently EDAC hooked into the mce even notification chain provides a
return code to indicate whether it completely processed the error, or
whether to fall through to the rest of mce_log():

	if (ret == NOTIFY_STOP)
		return;

Having both EDAC and this new extended error log both registered on this
chain would probably not be helpful in most cases.  Not sure if we should
handle that with user education to not load both an EDAC and ext_log driver
or if there should be some enforcement.

> Btw, if we keep both, then we're going to have two tracepoints -
> trace_mce_record() in mce_log() and this one - issuing each a record for
> the same event. Which is not really what we want I'd say...

trace_mce_record() dumps the raw data from the machine check banks.
I think there may still be a case for having this.  Analysis tools that look at
this trace as well should be smart enough to connect the dots.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
