Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaKFR13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:27:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:46988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaKFR12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:27:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="632772118"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Chen Yucong <slaoub@gmail.com>
CC: "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Thread-Topic: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Thread-Index: AQHP+LPxnTcFzUHCrEu4gxFYauoR5JxUQ1cA//+R0PA=
Date: Thu, 6 Nov 2014 17:27:14 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329240AE@ORSMSX114.amr.corp.intel.com>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
 <20141106153539.GC4318@pd.tnic>
In-Reply-To: <20141106153539.GC4318@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA6HRYs5005619

>> +int mce_severity(struct mce *m, int tolerant, char **msg, bool is_excp)
>
> You're adding a function argument which is carrying redundant info which
> is already present in *m...
>
>>  {
>> +	enum exception excp = (is_excp ? EXCP_CONTEXT : NO_EXCP);
>
> ... and so this should be:
>
>	excp = ((m->mcg_status & MCG_STATUS_MCIP) ? EXCP_CONTEXT : NO_EXCP);

That only works if you trust that MCG_STATUS.MCIP is correctly set to indicate whether
we are in MCE or CMCI context. The current code doesn't do that - we check for, and flag
it as a fatal error if we find ourselves in the MCE handler with MCIP==0. If you add the
code you suggest, then it completely neuters the severity check:

        MCESEV(
                PANIC, "MCIP not set in MCA handler",
                MCGMASK(MCG_STATUS_MCIP, 0)
                ),

I'm also a bit worried about the check for DEFERRED errors in
the severity table.  That isn't conditional on an:
  if (intel) do_onething(); else /*amd/ do_anotherthing();
So if we can misinterpret some bits on an Intel cpu as if
we had a deferred error.

Overall, this might have seemed like a good idea to begin with,
but we are piling more complexity into mce_severity() [a routine
which everyone agrees is already tough to understand].

It doesn't even buy us some simple code in the polling path.
We still have to do more checks on MCi_STATUS.MCACOD above
and beyond what we get back from mce_severity()

Boris: Do you still want to keep pushing this way? Or should
we look back fondly at version 1 of this patch?

-Tony


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
