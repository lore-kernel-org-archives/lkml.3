Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaKLBHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:07:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:11144 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbaKLBHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:07:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,364,1413270000"; 
   d="scan'208";a="620879306"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOAgAAKAgCAAAXbAIAAAfAAgAAIKwCAAAM7AP//iBaggACOCID//33YEA==
Date: Wed, 12 Nov 2014 01:06:06 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic>
 <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
 <20141111223316.GQ31490@pd.tnic>
 <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
In-Reply-To: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAC17FEP008937

> I've thought about one sneaky option.  If we can reliably determine
> that we're an innocent bystander of a broadcast #MC, can we send an
> IPI-to-self and return without clearing MCIP?  Then we get another
> interrupt as soon as interrupts are enabled, and we can clear MCIP at
> a time when we're definitely not running on the IST stack.

Innocent bystanders have RIPV=1, EIPV=0 in MCG_STATUS ... so they
are quite easy to spot.  Perhaps we might look at subverting the silly
broadcast by just having them immediately clear MCG_STATUS and iret
(i.e. not go to do_machine_check() at all).  That would require lots of
surgery to do_machine_check() and friends - now it wouldn't be sure
how many processors to expect to show up.  It also opens a different
window - once they are back running normal code they might trip another
machine check while the victims of the first are still processing - so
another "boom, you're dead".  The advantage of hitting everyone
with the machine check is that it lessens the chance that another will
happen as everyone is running looking at a few pages of kernel code
& data.

The worrying part in that is "as soon as interrupts are enabled". Until
we do clear MCIP we're sitting in a mode where another machine check
means instant death no saving throw.  Nominally better than the "we'll
mess the stack up for you" that we are trying to avoid - but the old window
is quite short and known to be bounded. The new one might be a lot bigger.

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
