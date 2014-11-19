Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaKSXeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:34:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:40947 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbaKSXeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:34:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418947075"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        "ruiv.wang@gmail.com" <ruiv.wang@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: RE: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Topic: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Index: AQHQA9xP2DKrYSRRjki1N/RiQcamCZxoRecAgABTjfA=
Date: Wed, 19 Nov 2014 23:34:10 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
In-Reply-To: <20141119102954.GA5617@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAJNYJvW006714

>> No information besides that it is a machine check. This happens in two cases:
>> 1) The CPU logs the error with the MCi_STATUS.EN bit set to zero, and Linux
>>    ignores EN=0 entries (as it should).

> Well, I guess we shouldn't anymore. Apparently hw forgets to set the
> bit when raising an MCE so then we should ignore it too in mce-severity
> and delete that piece or grade it as higher severity based on, I dunno,
> b0rked hardware family/model/stepping or whatever bit we set...
>
>        MCESEV(
>                NO, "Not enabled",
>                BITCLR(MCI_STATUS_EN)
>                ),

The SDM has this to say about EN=0 (in section 15.10.4.1 of volume 3B):

   When the EN flag is zero but the VAL and UC flags are one in
   the IA32_MCi_STATUS register, the reported uncorrected error
   in this bank is not enabled. As uncorrected errors with the
   EN flag = 0 are not the source of machine check exceptions,
   the MCE handler should log and clear non-enabled errors when
   the S bit is set and should continue searching for enabled
   errors from the other IA32_MCi_STATUS registers. Note that
   when IA32_MCG_CAP [24] is 0, any uncorrected error condition
   (VAL =1 and UC=1) including the one with the EN flag cleared
   are fatal and the handler must signal the operating system to
   reset the system. For the errors that do not generate machine
   check exceptions, the EN flag has no meaning.

Note the "should log and clear".  We just clear ... just need to shuffle some code
in mce.c to add the logging.

But we still need something like Rui's patch - calling mcelog() doesn't ensure that
we see something on the console about possible cause of the problem.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
