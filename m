Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaEIUNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:13:36 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61524 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbaEIUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:13:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
Date: Fri, 09 May 2014 22:12:32 +0200
Message-ID: <28202282.tsYsyDGHCL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140509184505.GA30330@arch.cereza>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-4-git-send-email-arnd@arndb.de> <20140509184505.GA30330@arch.cereza>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8vlsQJHGoaw5HERiUACSQopB7SGpaAG8Y5IcjM2aL71
 uxZ5psNUysslx1fUwNbFicFm3d0xScXY10U3w5fglUXFc9+ysr
 r/aPootRl6mNQbA/90Tnkq6Z/MxD7HyxvTwBPtql+axL3a5T2M
 GLsSdz0OUqhjovyeSdWzioji3iaFVpfDB9ns1aL/GywP6Jsz1m
 WZ06u6mdrhLZQoqxYUhTxmZXTAaD7JOka6z62mcryWu4Fs/XKN
 0o4rUjhCpj6yxjz18pLrgEUJ3pjLw2giezNCzNpdrMAaTT7FuQ
 7MEyhVqa7IGUnSFROPjEnJoW6G1bochmLhK9754fgccGA5c/Ui
 pf95LVjFvx2y93y/+2HQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2014 15:45:05 Ezequiel Garcia wrote:
> On 08 May 04:56 PM, Arnd Bergmann wrote:
> 
> I gave this a try in order to answer Arnd's performance question.

Thanks a lot for testing!

> First of all,
> the patch seems wrong. I guess it's because readsl reads 4-bytes pieces, instead of
> 8-bytes.

Oops. I guess I was thinking of a 64-bit system and didn't even notice
the difference between 4 and 8 byte accesses here. I wonder where I have
my mind sometimes.

> In other words, the patch is still half-untested. Therefore, and given
> this is meant only to coherce a build, maybe we'd rather just loop over
> readb and stay on the safe side?

I guess that would be equal to calling memcpy_fromio().

> And now, answering Arnd's question:
> 
> # Using ldrd
> # time nanddump /dev/mtd5 -f /dev/null -q
> real	0m 5.90s
> user	0m 0.22s
> sys	0m 5.67s
> 
> # Using readsl
> # time nanddump /dev/mtd5 -f /dev/null -q
> real	0m 6.39s
> user	0m 0.17s
> sys	0m 6.20s
> 
> So I'd say, let's stick to the ldrd magic.

Ok, that is a noticeable difference. For scale, what is the size of that partition?
If this is something that actually affects people, it might be worth also trying
memcpy(), which should be better at saturating the bus, but might be wrong here
(if alignment the alignment requirements on the external bus are stricter than
what memcpy does) or it might not make a difference at all if the code is already
ideal.

	Arnd
