Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab3FGIRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:17:11 -0400
Received: from mail.abilis.ch ([195.70.19.74]:15402 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3FGIRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:17:05 -0400
Date: Fri, 7 Jun 2013 10:16:37 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: designware: fix race between subsequent xfers
Message-ID: <20130607081636.GC11875@ab42.lan>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
 <20130607052353.GB11878@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130607052353.GB11878@intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 08:23:53AM +0300, Mika Westerberg wrote:
> Hi Christian,
> 
> On Thu, Jun 06, 2013 at 03:43:35PM +0200, Christian Ruppert wrote:
> > The designware block is not always properly disabled in the case of
> > transfer errors. Interrupts from aborted transfers might be handled
> > after the data structures for the following transfer are initialised but
> > before the hardware is set up. This might corrupt the data structures to
> > the point that the system is stuck in an infinite interrupt loop (where
> > FIFOs are never emptied).
> > This patch cleanly disables the designware-i2c hardware at the end of
> > every transfer, successful or not.
> 
> Have you tried with the latest mainline driver? There is a commit that
> solves similar problem:
> 
> 2a2d95e9d6d29e7	i2c: designware: always clear interrupts before enabling them
> 
> Maybe it helps?

Hi Mika,

Thanks for the hint but I have checked both main line and Wolfram's
branch and I saw this patch. I actually hoped it would fix our problem
but it didn't.

Here some more details: We experienced system lockups (complete lock up,
no reaction whatsoever) in long-term tests under heavy system load with
lots of scheduling and forking/killing. These lockups could be traced to
the I2C driver which after some time ended up in an incoherent state:
i2c_dw_isr was being called with DW_IC_INTR_RX_FULL but
dev->msg_read_idx == dev->msgs_num. This resulted in the FIFO never
being emptied by i2c_dw_read. Since the DW_IC_INTR_RX_FULL interrupt is
cleared by emptying the FIFO, this situation results in an IRQ loop
locking up the system.

We found that the situation systematically occurs just after the
originating process is interrupted (premature return of
wait_for_completion_interruptible_timeout) and further analysis showed
the race condition: Interrupts from the previous transfer are sometimes
triggered after the initialisation of dev in the beginning of
i2c_dw_xfer, thus corrupting the state. If these interrupts occur before
dev is initialised everything works fine.

An alternative solution would probably be to make sure the hardware is
disabled before initialising the dev structure in i2c_dw_xfer.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
