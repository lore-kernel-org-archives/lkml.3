Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaE3FZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:25:06 -0400
Received: from ns.horizon.com ([71.41.210.147]:25091 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750892AbaE3FZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:25:05 -0400
Date: 30 May 2014 01:25:02 -0400
Message-ID: <20140530052502.12443.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tim.c.chen@linux.intel.com
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140530013734.13780.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olay, recompiled with the acpi-cpufreq driver, so the performance governor
actually works, pegging the frequency at 3900 MHz.

Existing (old) code:
[  455.641397] 
[  455.641397] testing speed of crc32c
[  455.641403] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     73 cycles/operation,    4 cycles/byte
[  455.641406] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    418 cycles/operation,    6 cycles/byte
[  455.641409] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     89 cycles/operation,    1 cycles/byte
[  455.641411] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1330 cycles/operation,    5 cycles/byte
[  455.641417] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    502 cycles/operation,    1 cycles/byte
[  455.641420] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    170 cycles/operation,    0 cycles/byte
[  455.641422] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4971 cycles/operation,    4 cycles/byte
[  455.641440] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    805 cycles/operation,    0 cycles/byte
[  455.641445] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    371 cycles/operation,    0 cycles/byte
[  455.641448] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   9839 cycles/operation,    4 cycles/byte
[  455.641484] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1436 cycles/operation,    0 cycles/byte
[  455.641490] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    824 cycles/operation,    0 cycles/byte
[  455.641494] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    494 cycles/operation,    0 cycles/byte
[  455.641498] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19561 cycles/operation,    4 cycles/byte
[  455.641568] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2757 cycles/operation,    0 cycles/byte
[  455.641579] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1633 cycles/operation,    0 cycles/byte
[  455.641586] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    861 cycles/operation,    0 cycles/byte
[  455.641590] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39015 cycles/operation,    4 cycles/byte
[  455.641729] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5412 cycles/operation,    0 cycles/byte
[  455.641749] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3106 cycles/operation,    0 cycles/byte
[  455.641762] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1656 cycles/operation,    0 cycles/byte
[  455.641769] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1639 cycles/operation,    0 cycles/byte
[  480.885336] 
[  480.885336] testing speed of crc32c
[  480.885342] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     81 cycles/operation,    5 cycles/byte
[  480.885345] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    426 cycles/operation,    6 cycles/byte
[  480.885348] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     96 cycles/operation,    1 cycles/byte
[  480.885350] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1331 cycles/operation,    5 cycles/byte
[  480.885356] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    497 cycles/operation,    1 cycles/byte
[  480.885359] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    179 cycles/operation,    0 cycles/byte
[  480.885361] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4961 cycles/operation,    4 cycles/byte
[  480.885380] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    795 cycles/operation,    0 cycles/byte
[  480.885384] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    366 cycles/operation,    0 cycles/byte
[  480.885387] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   9827 cycles/operation,    4 cycles/byte
[  480.885423] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1445 cycles/operation,    0 cycles/byte
[  480.885430] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    834 cycles/operation,    0 cycles/byte
[  480.885434] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    495 cycles/operation,    0 cycles/byte
[  480.885437] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19560 cycles/operation,    4 cycles/byte
[  480.885507] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2767 cycles/operation,    0 cycles/byte
[  480.885518] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1643 cycles/operation,    0 cycles/byte
[  480.885525] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    862 cycles/operation,    0 cycles/byte
[  480.885530] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39013 cycles/operation,    4 cycles/byte
[  480.885669] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5417 cycles/operation,    0 cycles/byte
[  480.885689] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3113 cycles/operation,    0 cycles/byte
[  480.885701] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1665 cycles/operation,    0 cycles/byte
[  480.885708] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1646 cycles/operation,    0 cycles/byte

Proposed (new) code:
[  800.253907] 
[  800.253907] testing speed of crc32c
[  800.253913] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     75 cycles/operation,    4 cycles/byte
[  800.253915] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    421 cycles/operation,    6 cycles/byte
[  800.253919] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     88 cycles/operation,    1 cycles/byte
[  800.253920] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1339 cycles/operation,    5 cycles/byte
[  800.253942] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    511 cycles/operation,    1 cycles/byte
[  800.253945] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    180 cycles/operation,    0 cycles/byte
[  800.253947] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4972 cycles/operation,    4 cycles/byte
[  800.253966] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    789 cycles/operation,    0 cycles/byte
[  800.253970] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    371 cycles/operation,    0 cycles/byte
[  800.253973] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  10093 cycles/operation,    4 cycles/byte
[  800.254010] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1443 cycles/operation,    0 cycles/byte
[  800.254017] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    829 cycles/operation,    0 cycles/byte
[  800.254021] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    495 cycles/operation,    0 cycles/byte
[  800.254024] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19556 cycles/operation,    4 cycles/byte
[  800.254094] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2762 cycles/operation,    0 cycles/byte
[  800.254105] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1640 cycles/operation,    0 cycles/byte
[  800.254113] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    854 cycles/operation,    0 cycles/byte
[  800.254117] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39015 cycles/operation,    4 cycles/byte
[  800.254256] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5415 cycles/operation,    0 cycles/byte
[  800.254276] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3113 cycles/operation,    0 cycles/byte
[  800.254288] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1666 cycles/operation,    0 cycles/byte
[  800.254295] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1638 cycles/operation,    0 cycles/byte
[  808.113346] 
[  808.113346] testing speed of crc32c
[  808.113353] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     70 cycles/operation,    4 cycles/byte
[  808.113355] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    432 cycles/operation,    6 cycles/byte
[  808.113359] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     89 cycles/operation,    1 cycles/byte
[  808.113360] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1330 cycles/operation,    5 cycles/byte
[  808.113366] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    514 cycles/operation,    2 cycles/byte
[  808.113369] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    171 cycles/operation,    0 cycles/byte
[  808.113371] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4968 cycles/operation,    4 cycles/byte
[  808.113390] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    833 cycles/operation,    0 cycles/byte
[  808.113394] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    368 cycles/operation,    0 cycles/byte
[  808.113398] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   9842 cycles/operation,    4 cycles/byte
[  808.113434] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1462 cycles/operation,    0 cycles/byte
[  808.113440] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    827 cycles/operation,    0 cycles/byte
[  808.113444] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    494 cycles/operation,    0 cycles/byte
[  808.113448] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19556 cycles/operation,    4 cycles/byte
[  808.113518] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2783 cycles/operation,    0 cycles/byte
[  808.113529] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1645 cycles/operation,    0 cycles/byte
[  808.113536] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    853 cycles/operation,    0 cycles/byte
[  808.113540] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39019 cycles/operation,    4 cycles/byte
[  808.113679] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5437 cycles/operation,    0 cycles/byte
[  808.113700] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3118 cycles/operation,    0 cycles/byte
[  808.113712] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1652 cycles/operation,    0 cycles/byte
[  808.113719] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1639 cycles/operation,    0 cycles/byte

As you can see, the differences look comparable to the spread in the
measured values.  Considering just the last 4 tests (since only blocks
of at least 200 bytes are affected by the change), here are 10 more runs
of each:

Existing (old) code:
[ 2168.651975] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39013 cycles/operation,    4 cycles/byte
[ 2168.652114] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5425 cycles/operation,    0 cycles/byte
[ 2168.652134] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3121 cycles/operation,    0 cycles/byte
[ 2168.652146] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1654 cycles/operation,    0 cycles/byte
[ 2168.652153] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1644 cycles/operation,    0 cycles/byte
[ 2168.672956] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39025 cycles/operation,    4 cycles/byte
[ 2168.673095] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5494 cycles/operation,    0 cycles/byte
[ 2168.673116] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3113 cycles/operation,    0 cycles/byte
[ 2168.673157] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1674 cycles/operation,    0 cycles/byte
[ 2168.673169] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1636 cycles/operation,    0 cycles/byte
[ 2168.696197] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39012 cycles/operation,    4 cycles/byte
[ 2168.696336] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5410 cycles/operation,    0 cycles/byte
[ 2168.696356] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3119 cycles/operation,    0 cycles/byte
[ 2168.696368] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1667 cycles/operation,    0 cycles/byte
[ 2168.696375] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1635 cycles/operation,    0 cycles/byte
[ 2168.716198] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39015 cycles/operation,    4 cycles/byte
[ 2168.716337] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5543 cycles/operation,    0 cycles/byte
[ 2168.716358] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3111 cycles/operation,    0 cycles/byte
[ 2168.716370] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1673 cycles/operation,    0 cycles/byte
[ 2168.716377] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1636 cycles/operation,    0 cycles/byte
[ 2168.739520] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39022 cycles/operation,    4 cycles/byte
[ 2168.739659] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5484 cycles/operation,    0 cycles/byte
[ 2168.739680] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3110 cycles/operation,    0 cycles/byte
[ 2168.739692] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1687 cycles/operation,    0 cycles/byte
[ 2168.739699] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1640 cycles/operation,    0 cycles/byte
[ 2168.762814] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39015 cycles/operation,    4 cycles/byte
[ 2168.762953] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5412 cycles/operation,    0 cycles/byte
[ 2168.762973] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3109 cycles/operation,    0 cycles/byte
[ 2168.762985] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1675 cycles/operation,    0 cycles/byte
[ 2168.762992] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1634 cycles/operation,    0 cycles/byte
[ 2168.796244] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39008 cycles/operation,    4 cycles/byte
[ 2168.796383] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5413 cycles/operation,    0 cycles/byte
[ 2168.796403] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3106 cycles/operation,    0 cycles/byte
[ 2168.796415] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1658 cycles/operation,    0 cycles/byte
[ 2168.796422] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1637 cycles/operation,    0 cycles/byte
[ 2168.819616] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39040 cycles/operation,    4 cycles/byte
[ 2168.819757] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5416 cycles/operation,    0 cycles/byte
[ 2168.819777] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3109 cycles/operation,    0 cycles/byte
[ 2168.819814] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1674 cycles/operation,    0 cycles/byte
[ 2168.819823] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1649 cycles/operation,    0 cycles/byte
[ 2168.859652] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39011 cycles/operation,    4 cycles/byte
[ 2168.859806] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5412 cycles/operation,    0 cycles/byte
[ 2168.859826] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3117 cycles/operation,    0 cycles/byte
[ 2168.859841] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1665 cycles/operation,    0 cycles/byte
[ 2168.859850] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1639 cycles/operation,    0 cycles/byte
[ 2168.896378] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39023 cycles/operation,    4 cycles/byte
[ 2168.896532] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5424 cycles/operation,    0 cycles/byte
[ 2168.896554] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3126 cycles/operation,    0 cycles/byte
[ 2168.896567] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1664 cycles/operation,    0 cycles/byte
[ 2168.896574] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1634 cycles/operation,    0 cycles/byte

Proposed (new) code:
[ 2061.715381] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39018 cycles/operation,    4 cycles/byte
[ 2061.715520] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5420 cycles/operation,    0 cycles/byte
[ 2061.715540] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3101 cycles/operation,    0 cycles/byte
[ 2061.715552] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1662 cycles/operation,    0 cycles/byte
[ 2061.715559] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1647 cycles/operation,    0 cycles/byte
[ 2061.734935] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39029 cycles/operation,    4 cycles/byte
[ 2061.735074] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5416 cycles/operation,    0 cycles/byte
[ 2061.735094] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3253 cycles/operation,    0 cycles/byte
[ 2061.735107] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1685 cycles/operation,    0 cycles/byte
[ 2061.735114] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1642 cycles/operation,    0 cycles/byte
[ 2061.761667] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39027 cycles/operation,    4 cycles/byte
[ 2061.761806] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5415 cycles/operation,    0 cycles/byte
[ 2061.761826] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3112 cycles/operation,    0 cycles/byte
[ 2061.761838] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1673 cycles/operation,    0 cycles/byte
[ 2061.761845] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1644 cycles/operation,    0 cycles/byte
[ 2061.781846] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39010 cycles/operation,    4 cycles/byte
[ 2061.781985] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5424 cycles/operation,    0 cycles/byte
[ 2061.782005] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3242 cycles/operation,    0 cycles/byte
[ 2061.782018] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1687 cycles/operation,    0 cycles/byte
[ 2061.782025] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1641 cycles/operation,    0 cycles/byte
[ 2061.801881] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39020 cycles/operation,    4 cycles/byte
[ 2061.802020] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5424 cycles/operation,    0 cycles/byte
[ 2061.802041] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3113 cycles/operation,    0 cycles/byte
[ 2061.802053] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1673 cycles/operation,    0 cycles/byte
[ 2061.802060] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1638 cycles/operation,    0 cycles/byte
[ 2061.822194] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39034 cycles/operation,    4 cycles/byte
[ 2061.822333] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5414 cycles/operation,    0 cycles/byte
[ 2061.822353] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3246 cycles/operation,    0 cycles/byte
[ 2061.822366] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1703 cycles/operation,    0 cycles/byte
[ 2061.822373] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1643 cycles/operation,    0 cycles/byte
[ 2061.842361] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39017 cycles/operation,    4 cycles/byte
[ 2061.842500] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5411 cycles/operation,    0 cycles/byte
[ 2061.842520] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3115 cycles/operation,    0 cycles/byte
[ 2061.842532] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1671 cycles/operation,    0 cycles/byte
[ 2061.842539] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1641 cycles/operation,    0 cycles/byte
[ 2061.875909] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39020 cycles/operation,    4 cycles/byte
[ 2061.876048] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5414 cycles/operation,    0 cycles/byte
[ 2061.876068] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3250 cycles/operation,    0 cycles/byte
[ 2061.876081] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1699 cycles/operation,    0 cycles/byte
[ 2061.876088] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1640 cycles/operation,    0 cycles/byte
[ 2061.899397] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39017 cycles/operation,    4 cycles/byte
[ 2061.899536] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5420 cycles/operation,    0 cycles/byte
[ 2061.899556] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3109 cycles/operation,    0 cycles/byte
[ 2061.899568] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1683 cycles/operation,    0 cycles/byte
[ 2061.899576] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1640 cycles/operation,    0 cycles/byte
[ 2061.922872] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39016 cycles/operation,    4 cycles/byte
[ 2061.923010] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5538 cycles/operation,    0 cycles/byte
[ 2061.923032] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3248 cycles/operation,    0 cycles/byte
[ 2061.923044] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1683 cycles/operation,    0 cycles/byte
[ 2061.923052] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1640 cycles/operation,    0 cycles/byte

Averaging the 8K bytes per update, I do see an average of 3.2 cycles per
operation (that is, per 8K of data processed) lost, or about 1 cycle per
(3K or less) block processed.  I'm hoping the reduced D-cache polution
makes it up somewhere else.

Comments?
