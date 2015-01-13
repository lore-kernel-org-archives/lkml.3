Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbbAMRZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:25:22 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:5650 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAMRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:25:20 -0500
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="54880065"
Subject: Re: [3.19-rc3] tg3: BUG: sleeping function called from invalid
 context
From: Michael Chan <mchan@broadcom.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Prashant Sreedharan <prashant@broadcom.com>, <netdev@vger.kernel.org>,
        Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <54B513F4.5020403@hurleysoftware.com>
References: <54B46DD5.9050802@hurleysoftware.com>
	 <1421131762.7208.31.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <54B513F4.5020403@hurleysoftware.com>
Content-Type: text/plain; charset="cp1252"
Date: Tue, 13 Jan 2015 09:25:02 -0800
Message-ID: <1421169902.7208.39.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 07:47 -0500, Peter Hurley wrote: 
> > tp->lock is held in this code path.  If synchronize_irq() sleeps in
> > wait_event(desc->wait_for_threads, ...), we'll get the warning.
> > 
> > The synchronize_irq() call is to wait for any tg3 irq handler to finish
> > so that it is guaranteed that next time it will see the CHIP_RESETTING
> > flag and do nothing.
> > 
> > Not sure if we can drop the tp->lock before we call synchronize_irq()
> > and then take it again after synchronize_irq().
> 
> Well, this device [1] is using MSI (INTx disabled) so if the synchronize_irq()
> is _only_ for the CHIP_RESETTING logic then it would seem ok to skip it (the
> synchronize_irq()). 

It is only for INTx.  But any device can operate in INTx mode if
MSI/MSIX is not available, so the fix needs to work in all cases.

Let me review the code some more.  If we can guarantee that another
reset, the timer code, etc, cannot come in even if we drop the tp->lock,
the simplest fix will be to drop it before calling synchronize_irq().

Thanks. 

