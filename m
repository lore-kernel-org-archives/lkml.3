Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaGKTGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:06:42 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:43983 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaGKTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:06:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140711092454.GA17083@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<20140710164151.GA5603@pd.tnic>
	<CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
	<20140710184416.GE5603@pd.tnic>
	<CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
	<20140710191224.GF5603@pd.tnic>
	<20140711092454.GA17083@pd.tnic>
Date: Fri, 11 Jul 2014 12:06:40 -0700
Message-ID: <CA+8MBbKYo_Tmb3Zk4W9gBZmZqBpCu4uLUu9M5C2MZAYZEb16Vg@mail.gmail.com>
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

> +               if (atomic_add_unless(&mce_banks[i].poll_reader, 1, 1)) {
> +                       m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));

Same as yesterday. You may skip reading a bank because someone else
is reading the same bank number, even though you don't share that bank
with them.

If we are willing to be rather flexible amount when polling happens,
and not allow very fast poll rates. Then we could do something like
have the lowest numbered online cpu be the only one that sets a
timer. When it goes off, it scans its own banks, and then uses an
async cross-processor call to poke the next highest numbered
online cpu to have it scan banks and poke the next guy.

That way we know that two cpus can't be polling at the same time,
because we convoy them all one at a time.

Fast poll rates would be a problem on very large systems. Might
need to have the highest numbered cpu notice that it is at the
end of the chain and set some flag so the lowest one can tell
whether it is safe to begin the next ripple.

-Tony
