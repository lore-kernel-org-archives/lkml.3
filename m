Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3LKXXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:23:08 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:23484 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LKXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:23:06 -0500
X-IronPort-AV: E=Sophos;i="4.93,874,1378882800"; 
   d="scan'208";a="1700640"
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: Michael Chan <mchan@broadcom.com>
To: David Miller <davem@davemloft.net>
CC: <sergei.shtylyov@cogentembedded.com>, <natg@google.com>,
        <nsujir@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20131210.222313.694303616856894486.davem@davemloft.net>
References: <1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <20131210.134340.114603867817512238.davem@davemloft.net>
	 <1386701379.1752.26.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <20131210.222313.694303616856894486.davem@davemloft.net>
Content-Type: text/plain; charset="cp1252"
Date: Wed, 11 Dec 2013 15:21:18 -0800
Message-ID: <1386804078.1752.58.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 22:23 -0500, David Miller wrote:
> Ok, that may be true, but I'd like to consider the much larger issue
> at hand.
> 
> If the indirect mechanism is enabled, some of the offsets that may be
> in there might be value, but would be entirely undesirable to be read
> because the read has side effects.
> 
> What if the interrupt status register is what gets read if the user
> scans config space at just the wrong moment, and therefore an
> interrupt gets lost?
> 
I did a quick audit of the driver to see if we are seriously exposed to
this problem.  Only very old chips (5700 to 5703) use indirect register
access as workarounds for various issues.  I looked at the IRQ path
which uses status block to determine if there is work to do.  If status
block contains no new data, we check the PCI_STATE register and the bits
don't get cleared on read.  MAC status register which is used to
determine link status does not have bits that are cleared on read.  So
we should be ok.

We use the statistics block for counters on these older chips so there
is no conflict.  On newer chips, we read counters from registers which
get cleared on read, but we never use indirect methods to read these
counters.

On all new chips, indirect method is not used except to download
firmware (on 57766 only).  Userspace read will not interfere with
firmware download.

So it looks to me that we are in good shape.  Thanks.

