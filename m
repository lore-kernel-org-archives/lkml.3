Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaDGUAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:00:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38647 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbaDGUAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:00:32 -0400
Date: Mon, 7 Apr 2014 22:00:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Baron <jbaron@akamai.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: tony.luck@intel.com, dougthompson@xmission.com, m.chehab@samsung.com,
        mitake@dcl.info.waseda.ac.jp, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add new ie31200_edac driver
Message-ID: <20140407200028.GB20822@pd.tnic>
References: <cover.1396645124.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1396645124.git.jbaron@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:13:45PM +0000, Jason Baron wrote:
> Hi,
> 
> Add support for memory errors for the Intel E3-1200 processors.
> 
> While testing the driver, I found that doing a readq() on the
> memory mapped memory controller hub registers caused a hard lockup
> on my x86_64 system. It turns out that a read across a DW boundary
> is a no no here.
> 
> "
> Software must not access B0/D0/F0 32-bit memory-mapped registers with
> requests that cross a DW boundary.
> "
> 
> (http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200-family-vol-2-datasheet.html p. 16)
> 
> Thus, I've added a generic lo_hi_[read|write]_q API, to deal with
> this issue.
> 
> I think longer term the right thing is maybe to simply add these
> definitions to include/asm-generic/io.h, as I didn't see any
> in tree users of 'io-64-nonatomic-hi-lo.h', and simply remove
> io-64-nonatomic-hi-lo.h and io-64-nonatomic-lo-hi.h. But I didn't want to
> tie that cleanup to this edac driver submission.

Makes sense to me. There are a couple of drivers which include
io-64-nonatomic-lo-hi.h though.

As part of the cleanup, it might be even clearer to do the lo_hi_* calls
directly instead of the readq/writeq defines as a means of documenting
that this particular code cannot stomach doubleword-crossing accesses.

x86 guys, opinions? Especially patch 1/3, should I pick it up or you
want?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
