Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891AbaDIXqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:46:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:20777 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182AbaDIXqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:46:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,829,1389772800"; 
   d="scan'208";a="510497123"
From: "Du, Wenkai" <wenkai.du@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Topic: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Index: Ac9QJwrpXJhe4Vv7Q76dkBKVgbE+4AARZeWAAA7Jh9D//5EOAIAATf0QgABzAACAAldQAIAA/RGAgABeqgCAAAfmAIAAXh4QgADlsQD//ghNMA==
Date: Wed, 9 Apr 2014 23:45:54 +0000
Message-ID: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A73919@ORSMSX109.amr.corp.intel.com>
References: <20140404181613.GB19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
 <20140404184232.GC19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
 <20140405061316.GF19349@intel.com>
 <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
 <20140407090403.GG19349@intel.com>
 <20140407154252.6b8f0f7e@alan.etchedpixels.co.uk>
 <20140407151107.GL19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A72207@ORSMSX109.amr.corp.intel.com>
 <20140408103006.GQ19349@intel.com>
In-Reply-To: <20140408103006.GQ19349@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Westerberg, Mika
> Sent: Tuesday, April 08, 2014 3:30 AM
> To: Du, Wenkai
> Cc: One Thousand Gnomes; linux-i2c@vger.kernel.org; Wolfram Sang; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller enable

> Yes, but only after resume. In normal cases the driver re-programs DW_IC_INTR_TX_EMPTY to
> the mask (the other 3 flags are already set but they should be harmless as long as the TX fifo is
> still empty).
I have sent you failure traces in normal path. None of 4 interrupt sources was masked.  

> Where did you get this 25us required delay? My spec doesn't say anything about that. It does
> however say that if the state bit is not yet changed, wait 25us (@400kHz) and re-read the bit.
> So it can be that we don't wait at all once we toggle that bit.
I believe the delay patch ("i2c-designware: enable/disable the controller properly") was from you? I would be happy to see the patch reverted if these delay are really not needed. 25us-250us delay 3 times (2 disable, 1 enable) at every transfer slow down the bus too much.
 
> All in all, I think we can solve this resume path timeout issue, by moving
> __i2c_dw_enable() to be last in i2c_dw_xfer_init().
This will invalidate 2 previous patches from you: " i2c-designware: enable/disable the controller properly" , and "i2c-designware: always clear interrupts before enabling them". Are you sure they can be all reverted?

> In addition we should fix the potential posted-write problem Alan pointed out (as a separate
> patch). That could actually explain the issue you have seen where timeout occurs during normal
> operation. Maybe fix here is to mask all interrupts at the end of the ISR and make sure that
> possible posted writes gets flushed to the hardware before returning?
But these patches attempt to fix "leaking" as we know of today. In my view, masking interrupts right before enable HW is still the best, which is common practice to most drivers. It is the spirit of the original driver as well: the original driver enables interrupts _after_ core enable. I think the author must have thought the interrupt have been disabled, otherwise why enable them again? Masking interrupts fixes all the known and unknown leaks and is future proof.
