Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaKRX1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:27:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:52872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401AbaKRX1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:27:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,413,1413270000"; 
   d="scan'208";a="639320034"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOAgAAKAgCAAAXbAIAAAfAAgAAIKwCAAAM7AP//iBaggACOCID//33YEIAAoQn1gADe14CAAAmMgIABruEAgAFGphCABQ+BAIAAEq4AgAAB1ACAAACVgP//kExAABLiaAAAD6th0P//ng0AgACB8wD//4wmgP//ZAXAgAIPRYCAAIIoEA==
Date: Tue, 18 Nov 2014 23:26:30 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329407F2@ORSMSX114.amr.corp.intel.com>
References: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic>
 <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic>
 <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F5DA@ORSMSX114.amr.corp.intel.com>
 <CALCETrU6x4yVQy57KGm-Rk==ZYNqHorytAs6WvgKNVoT+Dk9Uw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F64E@ORSMSX114.amr.corp.intel.com>
 <CALCETrWPzO1vz+Rcjs78B+wWWi4eu_g__-k9iCHH1G1Mc6af+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F681@ORSMSX114.amr.corp.intel.com>
 <CALCETrXsxJ6eotRJG1tjPD8dkpAd6P2roDm+fj+Yqi36uh3WHA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293FFBA@ORSMSX114.amr.corp.intel.com>
 <CALCETrXdfKut2MDi1Z-iS1aJF30Ebfyumh65=QTm4MCihBbv1A@mail.gmail.com>
In-Reply-To: <CALCETrXdfKut2MDi1Z-iS1aJF30Ebfyumh65=QTm4MCihBbv1A@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAINRAoD027923

> Your test case is presumably doing something that involves setting
> undocumented registers* to program the CPU or memory controller to
> generate a machine check on access to some address.  Presumably this
> is done by broadcasting an SMI and programming the registers in SMM.

Good theory - but not quite how it works.  The ACPI/EINJ table does trigger
an SMI so the BIOS can do the injection.  What BIOS actually does is to play
with the memory controller so that the next write to the target address will
flip some ECC bits in an unnatural way (to either plant a correctable error
with just one bit flipped, or a UC error with two bits flipped).  Then the SMI
returns.

Then my application reads the target address, and we see CMCI or MCE
when the ECC check fails.

Hopefully this keeps the SMI path decoupled from the MCE ... I even sleep
a little after injection and before consumption just in case there are any
stragglers late returning from the (broadcast) SMI that planted the error.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
