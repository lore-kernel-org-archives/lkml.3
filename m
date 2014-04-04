Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaDDVyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:54:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:40392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbaDDVyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,797,1389772800"; 
   d="scan'208";a="507263993"
From: "Du, Wenkai" <wenkai.du@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Topic: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Index: Ac9QJwrpXJhe4Vv7Q76dkBKVgbE+4AARZeWAAA7Jh9D//5EOAIAATf0Q
Date: Fri, 4 Apr 2014 21:54:33 +0000
Message-ID: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
 <20140404181613.GB19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
 <20140404184232.GC19349@intel.com>
In-Reply-To: <20140404184232.GC19349@intel.com>
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

>Interrupt masking is done already after each transaction.

At end of transfer, the code uses __i2c_dw_enable(dev, false) to disable adapter. This function doesn't mask interrupts. There is another function i2c_dw_disable that masks and clears interrupts. This could be used, but that means we need to fix in 2 places: 

1. add interrupt masking to i2c_dw_init();
2. change call __i2c_dw_enable(dev, false) to i2c_dw_disable;

I think simply masking interrupt in i2c_dw_xfer_init is cleaner and safer.

>The problem here is that after reset, the interrupt mask register gets 0x8ff value (HW default), which means that most of the interrupts are left unmasked.
>That is the reason why this only happens right after we resume from system sleep. Masking interrupts on that path fixes the problem.

The time out also happened in case of going into suspend and during normal operations. But at much less occurrence at 1-2 per 1000 cycles. 


