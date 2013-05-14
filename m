Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3ENXQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 19:16:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57036 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758644Ab3ENXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 19:16:31 -0400
X-Sasl-enc: /qGpT1xHJmPUw5RGc86BYH2eOf8OCmQ/8ItxhbJ95fCd 1368573389
Date: Wed, 15 May 2013 09:16:26 +1000
From: Robert Norris <robn@opera.com>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130514231626.GA12961@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:22:32AM +1000, Robert Norris wrote:
> We have a number of Intel x3550 servers (Intel 5000-series). They've
> been running 3.7.2 fine.
> 
> In the last week I've run 3.8.11, 3.8.12 and 3.9.2 on them. All have
> long hangs at boot, and later hung tasks in modprobe.

I bisected this and tracked it to this commit:

    commit 6676a847d48ac48908cf467b42da9045b5463a6e
    Author: Jean Delvare <khali@linux-fr.org>
    Date:   Sun Dec 16 21:11:55 2012 +0100

        i2c-i801: Enable interrupts for all post-ICH5 chips
        
        I did not receive a single bug report after interrupt support was
        added for a limited number of chips. So I'd say the code is good and
        should be enabled for all supported chips, that is: ICH5 and later.
        
        Signed-off-by: Jean Delvare <khali@linux-fr.org>
        Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

I've tested by building 3.9.2 with that single commit reverted, and it
boots without issue.

According to lspci I have:

    00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)

Which has PCI ID 0x269b (ie PCI_DEVICE_ID_INTEL_ESB2_17).

For now I will either revert this commit in my kernel builds or
blacklist the module on these machines (I haven't decided which I prefer
yet).

Obviously, I can reproduce this reliably, and am happy to test.

Cheers,
Rob N.
