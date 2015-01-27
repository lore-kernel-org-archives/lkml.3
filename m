Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbbA0XzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:55:11 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50601 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbbA0XzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:55:09 -0500
Message-ID: <1422402906.29618.41.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] lib/checksum.c: fix carry in csum_tcpudp_nofold
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Karl Beldan <karl.beldan@rivierawaves.com>,
        Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Date: Tue, 27 Jan 2015 15:55:06 -0800
In-Reply-To: <20150127231314.GA21679@gobelin>
References: <1422372316-25287-1-git-send-email-karl.beldan@rivierawaves.com>
	 <20150127220332.GZ29656@ZenIV.linux.org.uk>
	 <20150127231314.GA21679@gobelin>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 00:13 +0100, Karl Beldan wrote:

> Here however I don't assume that a is "small", however I assume it has
> never overflowed, which is trivial to verify since we only add 3 32bits
> values and 2 16 bits values to a 64bits.
> Now we just want (a + b + carry(a + b)) % 2^32, and here I assume
> (a + b + carry(a + b)) % 2^32 == (a + b) % 2^32 + carry(a + b), I
> guess this is the trick, and this is easy to convince oneself with:
> 0xffffffff + 0xffffffff == 0x1fffffffe ==>
> ((u32)-1 + (u32)-1 + 1) % 2^32 == 0xfffffffe % 2^32 + 1
> We get this carry pushed out from the MSbs side by the s+= addition
> pushed back in to the LSbs side of the upper 32bits and this carry
> doesn't make the upper side overflow.
> 
> If this explanation is acceptable, I can reword the commit message with
> it. Sorry if my initial commit log lacked details, and thanks for your
> detailed input


...

Look, we already have from32to16() helper :

static inline unsigned short from32to16(unsigned int x)
{
        /* add up 16-bit and 16-bit for 16+c bit */
        x = (x & 0xffff) + (x >> 16);
        /* add up carry.. */
        x = (x & 0xffff) + (x >> 16);
        return x;
}

Simply add a clean 

static inline u32 from64to32(u64 x)
{
        x = (x & 0xffffffff) + (x >> 32);
        /* add up carry.. */
        x = (x & 0xffffffff) + (x >> 32);
        return (u32)x;
}

This would be self explanatory.


