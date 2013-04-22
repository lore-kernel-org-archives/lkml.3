Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3DVO0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:26:21 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62606 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3DVO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:26:19 -0400
X-Nat-Received: from [202.181.97.72]:50030 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1366640763.5186
To: andy.shevchenko@gmail.com, arjan@infradead.org, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: memcmp in modules
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com>
	<CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com>
In-Reply-To: <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com>
Message-Id: <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 22 Apr 2013 23:26:05 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 22042013 #9892721, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko wrote:
> What did I miss?

Well, as of linux-next-20130422, memcmp() is not correctly exported to modules.
Since linux-3.9-rc8 correctly exports memcmp(), this problem seems to be introduced
in linux-next tree. Also, this problem seems to involve CONFIG_MODVERSIONS=y.

  [root@localhost linux-next]# modprobe ipv6
  FATAL: Error inserting ipv6 (/lib/modules/3.9.0-rc8-next-20130422/kernel/net/ipv6/ipv6.ko): Invalid argument
  [root@localhost linux-next]# dmesg
  ipv6: no symbol version for memcmp
  ipv6: Unknown symbol memcmp (err -22)

Since arch/x86/include/asm/string_64.h uses

  int memcmp(const void *cs, const void *ct, size_t count);

while arch/x86/include/asm/string_32.h uses

  #define memcmp __builtin_memcmp

changing to what you have tried

  #define memcmp(a, b, n) __builtin_memcmp(a, b, n)

or changing to what x86_64 does

  int memcmp(const void *cs, const void *ct, size_t count);

might solve this problem. But I don't know which one is correct solution...
