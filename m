Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaKKSoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:44:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:27277 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaKKSoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:44:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="606094176"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Chen Yucong <slaoub@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Thread-Topic: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Thread-Index: AQHP+vUgoD/q7VyRgEG5Av0WO+I2NJxa9TcAgAADNAD//4mloIABKNEAgAAZJLA=
Date: Tue, 11 Nov 2014 18:44:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329293DE@ORSMSX114.amr.corp.intel.com>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
 <546136C8.5060104@amd.com> <20141110221728.GA23419@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329282FA@ORSMSX114.amr.corp.intel.com>
 <20141111085612.GA31490@pd.tnic>
In-Reply-To: <20141111085612.GA31490@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sABIiTpr007001

>> The bank 7 error reported as severity 0 because EN=0 ... so we took no action for it.
>
> How come EN is 0? Bank7 error reporting is not enabled? Why? Or the
> error injection thing doesn't do it?

The "EN" bit is poorly named, and not well documented.  Here's a clip from the SDM:

One of bullets in 15.10.4.1 Machine-Check Exception Handler for Error Recovery

 When the EN flag is zero but the VAL and UC flags are one in the
 IA32_MCi_STATUS register, the reported uncorrected error in this bank
 is not enabled. As uncorrected errors with the EN flag = 0 are not the
 source of machine check exceptions, the MCE handler should log and clear
 non-enabled errors when the S bit is set and should continue searching
 for enabled errors from the other IA32_MCi_STATUS registers. Note that
 when IA32_MCG_CAP [24] is 0, any uncorrected error condition (VAL =1
 and UC=1) including the one with the EN flag cleared are fatal and the
 handler must signal the operating system to reset the system. For the
 errors that do not generate machine check exceptions, the EN flag has
 no meaning. See Chapter 19: Table 19-15 to find the errors that do not
 generate machine check exceptions.

Unfortunately the reference to chapter 19 is stale (that is now all about
performance monitoring - I'll log a bug with the SDM editor to find the
right reference and fix this).

What this is trying to say is that the "EN" bit is to enable signaling
of machine checks - so it only has meaning when checking banks from the
machine check handler.  Errors that are logged, but not signaled, or signaled
as CMCI will have MCi_STATUS.EN=0


>> The bank 3 error got past that hurdle, then through the next BIT(8) set indicates a
>> cache error. Fell at the last check because ADDRV=0.
>
> I guess you could tweak the injection path to write in a default address
> so that that check gets bypassed...

I don't think this is an injection artifact. I think on this processor the mid-level-cache
just isn't providing an address in this case.  It doesn't help to make one up - our whole
game plan is to offline a page with a UC error - and we must have an address to know
which page to offline.

Perhaps the severity table entries for UCNA and DEFERRED errors should look to see
if ADDRV is set - if not, don't report this as UCNA/DEFERRED?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
