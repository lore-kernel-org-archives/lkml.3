Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaIVR0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:26:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52318 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaIVR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:26:08 -0400
Date: Mon, 22 Sep 2014 13:26:03 -0400 (EDT)
Message-Id: <20140922.132603.812620829504982755.davem@davemloft.net>
To: jim.epost@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20140922, in
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+r1ZhhHsR=1JRv80Oahp2FeGXU0zkMGdUB56Ryjx50yxWbhKQ@mail.gmail.com>
References: <CA+r1ZhhHsR=1JRv80Oahp2FeGXU0zkMGdUB56Ryjx50yxWbhKQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Sep 2014 10:26:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8MHQFKL029904

From: Jim Davis <jim.epost@gmail.com>
Date: Mon, 22 Sep 2014 10:16:26 -0700

> drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c: In function
> ¡pch_ptp_match¢:
> drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:130:2: error:
> implicit declaration of function ¡ptp_classify_raw¢
> [-Werror=implicit-function-declaration]
>   if (ptp_classify_raw(skb) == PTP_CLASS_NONE)
>   ^
> cc1: some warnings being treated as errors
> make[5]: *** [drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.o] Error 1

These dependencies are so broken.

You cannot select crap without also selecting all of that options
dependencies, and so on and so forth all the way up to the direct
and indirect dependencies that have no dependencies of their own.

The issue specifically is PCH_GBE needs NET_PTP_CLASSIFY.

PCH_GBE "selects" PTP_1588_CLOCK_PCH, which selects PTP_1588_CLOCK,
which selects NET_PTP_CLASSIFY.

But that does not reliably turn on NET_PTP_CLASSIFY.  If the top
level PTP_1588_CLOCK_PCH select is what triggers, as explained
about this does not end up select'ing NET_PTP_CLASSIFY.

Said another way, 'select' does not recursively process dependencies.
You have to do them all by hand at each and every selection point.

I'm going to add the NET_PTP_CLASSIFY select to PCH_GBE's Kconfig
entry, but this is not the thing to do long term.

Long term we should be using 'depends' for all of these non-trivial
dependencies, not 'select'.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
