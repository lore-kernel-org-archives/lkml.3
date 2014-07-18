Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204AbaGRVXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:23:07 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:58559 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbaGRVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:23:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140717105025.GA22549@pd.tnic>
References: <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<20140710164151.GA5603@pd.tnic>
	<CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
	<20140710184416.GE5603@pd.tnic>
	<CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
	<20140710191224.GF5603@pd.tnic>
	<20140711092454.GA17083@pd.tnic>
	<CA+8MBbKYo_Tmb3Zk4W9gBZmZqBpCu4uLUu9M5C2MZAYZEb16Vg@mail.gmail.com>
	<20140711195200.GA18246@pd.tnic>
	<CAFQmdRZ7d6Mgxob2A0nuJP09oAWW=BykL_bH7DeWo_8CM3YywA@mail.gmail.com>
	<20140717105025.GA22549@pd.tnic>
Date: Fri, 18 Jul 2014 14:23:04 -0700
Message-ID: <CA+8MBbLdD=MHVjQpUAsVhMJEfa3nxsnja6hDAytP_esRotF=Vg@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Havard Skinnemoen <hskinnemoen@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 3:50 AM, Borislav Petkov <bp@alien8.de> wrote:
> Well, maybe it is about time we tracked shared banks.

For cpus that support CMCI and the MCi_CTL2 registers we do track
sharing. Only one cpu gets to be the "owner" of a bank that supports
CMCI (the first one to find it and set bit 30 in the CTL2 register).

The test_bit()  at the top of the loop in machine_check_poll() makes
sure only the owner of a bank actually looks at it.

        for (i = 0; i < mca_cfg.banks; i++) {
                if (!mce_banks[i].ctl || !test_bit(i, *b))
                        continue;

If we don't have CMCI, then we don't have the CTL2 registers, and
so have no way to find out which banks are shared.


> We can evaluate later if the IRQs disabling is too heavy after all.

I'd be surprised if it was a problem in practice. If we have  CMCI,
then we limit the banks that we look at (and if we see a high rate
of interrupts, then we turn off interrupts an poll).

If we don't have CMCI, then we are polling at a pretty low rate
(current code adjusts the rate higher if we are finding errors to
log, but we don't let that rate rise forever ... cap is ~ 1HZ).

-Tony
