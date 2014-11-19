Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaKSSaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:30:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:64256 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbaKSSaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:30:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,418,1413270000"; 
   d="scan'208";a="610600095"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: RE: [PATCH v3 0/3] Handle IST interrupts from userspace on the
 normal stack
Thread-Topic: [PATCH v3 0/3] Handle IST interrupts from userspace on the
 normal stack
Thread-Index: AQHQA4Wd0mUcEWkVvUGRw61hvv/6XpxoNPrw
Date: Wed, 19 Nov 2014 18:29:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32940EF2@ORSMSX114.amr.corp.intel.com>
References: <cover.1416352397.git.luto@amacapital.net>
In-Reply-To: <cover.1416352397.git.luto@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NB: Tony has seen odd behavior when stress-testing injected
> machine checks with this series applied.  I suspect that
> it's a bug in something else, possibly his BIOS.  Bugs in
> this series shouldn't be ruled out, though.

v3 did 3.5x better than earlier ones ... survived overnight but died at 91724
injection/consumption/recovery cycles just now. Different symptom,
instead of losing some cpus, there was a fatal machine check (PCC=1
and OVER=1 bits set in the machine check bank). This might be from a
known issue.
Not sure if this was due to some improvement in the code, or because
I changed the system configuration by pulling out all the memory except
for that on memory controller 0 on node 0. Our BIOS team had told me
they'd seen some instability in the injection code on fully populated
systems.

I did instrument the synchronization in mce_start(). I was a bit worried
that with ever increasing numbers of cpus the 100ns delay between
pounding on atomic ops on mce_callin might not be enough. But it
seems we are not in trouble yet. Slowest synchronization recorded
took 1.8M TSC cycles. Mean is 500K cycles.  So my gut feeling that
the one second timeout was very conservative is correct.

-Tony
