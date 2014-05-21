Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaEUXFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:05:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:43253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbaEUXFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,883,1392192000"; 
   d="scan'208";a="515693401"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>
CC: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: RE: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Topic: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Index: AQHPdT5wRvlmui20OUO5csd5VXpJ+ZtMCOaA//+MFSCAAHmbAP//i7GAgAB3ZAD//4s2oAAPHlmAAABRNgAADkH6oA==
Date: Wed, 21 May 2014 23:05:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
References: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic>
 <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
 <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
 <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
 <20140521224816.GP25130@pd.tnic>
In-Reply-To: <20140521224816.GP25130@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4LN5nYm022938

On Wed, May 21, 2014 at 03:39:11PM -0700, Andy Lutomirski wrote:
> But if we get a new MCE in here, it will be an MCE from kernel context
> and it's fatal. So, yes, we'll clobber the stack, but we'll never
> return (unless tolerant is set to something insane), so who cares?

Remember that machine checks are broadcast.  So some other cpu
can hit a recoverable machine check in user mode ... but that int#18
goes everywhere.  Other cpus are innocent bystanders ... they will
see MCG_STATUS.RIPV=1, MCG_STATUS.EIPV=0 and nothing important
in any of their machine check banks.

But if we are still finishing off processing the previous machine check,
this will be a nested one - and BOOM, we are dead.

-Tony

[If you peer closely at the latest edition of the SDM - you'll see the
bits are defined for a non-broadcast model ... e.g. LMCE_S bit in
MCG_STATUS .... but currently shipping silicon doesn't use that]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
