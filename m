Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaEUVJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:09:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:56141 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaEUVJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,882,1392192000"; 
   d="scan'208";a="435218094"
From: "Luck, Tony" <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Chen Yucong <slaoub@gmail.com>
CC: "bp@alien8.de" <bp@alien8.de>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
Thread-Topic: [PATCH v2] x86/mce: Distirbute the clear operation of
 mces_seen to Per-CPU rather than only monarch CPU
Thread-Index: AQHPc9EexFpBbtkln0+oVFnaZ6Q3e5tKuQIAgAAGTACAAAs0AIAACkoAgAAEgACAAKhUQA==
Date: Wed, 21 May 2014 21:09:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328115FD@ORSMSX114.amr.corp.intel.com>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
		 <537C040E.3040901@jp.fujitsu.com> <1400637782.14703.32.camel@debian>
	 <537C12BC.6080408@jp.fujitsu.com> <1400642398.14703.42.camel@debian>
 <537C1F24.8000604@jp.fujitsu.com>
In-Reply-To: <537C1F24.8000604@jp.fujitsu.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4LL9sRQ022212

>> mce_regin, which is only called by monarch CPU, can be used for system
>> panics as quickly as possible if there is a truly data corrupting error.
>> But Monarch CPU don't have to help all other CPU to clean mces_clean.
>> One advantage of Per-CPU is the isolation of errors propagation, being
>> so, why do not we clean mces_seen by Per-CPU?
>
> What kind of error propagations are you expecting/concerning here?
> Could you explain the problem more in detail?

Please do give us more detail on the scenario that you see that would
make your new version behave better.

I'm sure the current code has no races w.r.t. clearing mces_seen. The
monarch clears them all in mce_reign() before clearing mce_executing
at the foot of mce_end() and allowing the others to run again.

Your code has the monarch release all the other cpus from the spinloop
in mce_end() so they will all rush together through the final lines of
do_machine_check().  Some of them will have work to do if they saw
errors - they may have to send signals, or log the error. Others can
fly directly to the end of do_machine_check() and clear MCG_STATUS
and return to executing whatever code was interrupted.

So it is possible that some processors will be out doing things that can
generate another machine check, before others have finished their
tasks and got to the point to clear mces_seen.(*)

-Tony

(*) maybe that doesn't matter because they haven't zeroed MCG_STATUS
yet - so this second machine check will force those cpus to shutdown. See MCIP
description in "15.3.1.2 IA32_MCG_STATUS_MSR" section of software
developer manual.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
