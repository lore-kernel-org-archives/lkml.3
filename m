Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaFLDoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:44:00 -0400
Received: from ns.horizon.com ([71.41.210.147]:47679 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932118AbaFLDn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:43:59 -0400
Date: 11 Jun 2014 23:43:58 -0400
Message-ID: <20140612034358.4453.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140611163818.GD27151@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to add to my total confusion about the totally disparate performance
numbers we're seeing, I did some benchmarks on other machines.

The speedup isn't as good one-pass as it is iterated, and as I mentioned
it's slower on a P4, but it's not 7 times slower by any stretch.

There are all 1-iteration numbers, run immediately after scp-ing the
binary to the machine so there's no possibility if anything being cached.

(The "64" and "32" versions are compiled -m32 and -m64,
of course.)

2.5 GHz Phenom 9850:

$ /tmp/random64
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:        199        142 (-57)
 1:        104         95 (-9)
 2:        104        110 (+6)
 3:        103        109 (+6)
 4:        105         89 (-16)
 5:        103         88 (-15)
 6:        104         89 (-15)
 7:        104         95 (-9)
 8:        105         85 (-20)
 9:        105         85 (-20)
$ /tmp/random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:        324        147 (-177)
 1:        100         86 (-14)
 2:        100         99 (-1)
 3:        100         88 (-12)
 4:        100         86 (-14)
 5:        100         86 (-14)
 6:        100         89 (-11)
 7:        100        111 (+11)
 8:        100        111 (+11)
 9:        100         88 (-12)
$ /tmp/random64 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     554788     220327 (-334461)
 1:     554825     220176 (-334649)
 2:     553505     220148 (-333357)
 3:     554661     220064 (-334597)
 4:     569559     220064 (-349495)
 5:     612798     220065 (-392733)
 6:     570287     220064 (-350223)
 7:     554790     220064 (-334726)
 8:     554715     220065 (-334650)
 9:     569840     220064 (-349776)
$ /tmp/random32 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     520117     280225 (-239892)
 1:     520125     280154 (-239971)
 2:     520104     280094 (-240010)
 3:     520079     280060 (-240019)
 4:     520069     280060 (-240009)
 5:     520060     280060 (-240000)
 6:     558971     280060 (-278911)
 7:     520102     280060 (-240042)
 8:     520082     280060 (-240022)
 9:     520058     280060 (-239998)


3 GHz i5-3330:
$ /tmp/random64
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         78         75 (-3)
 1:         36         33 (-3)
 2:         33         39 (+6)
 3:         36         30 (-6)
 4:         36         33 (-3)
 5:         30         33 (+3)
 6:         30         54 (+24)
 7:         24         48 (+24)
 8:         27         33 (+6)
 9:         30         33 (+3)
$ /tmp/random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         66         78 (+12)
 1:         39         39 (+0)
 2:         36         39 (+3)
 3:         45         33 (-12)
 4:         42         33 (-9)
 5:         33         42 (+9)
 6:         45         33 (-12)
 7:         39         36 (-3)
 8:        105         48 (-57)
 9:         42         39 (-3)
$ /tmp/random64 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     406188     218104 (-188084)
 1:     402620     246968 (-155652)
 2:     402652     239840 (-162812)
 3:     402720     200312 (-202408)
 4:     402584     200080 (-202504)
 5:     447488     200228 (-247260)
 6:     402788     200312 (-202476)
 7:     402688     200080 (-202608)
 8:     427140     224320 (-202820)
 9:     402576     200080 (-202496)
$ /tmp/random32 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     406485     266670 (-139815)
 1:     392694     266463 (-126231)
 2:     392496     266763 (-125733)
 3:     426003     266145 (-159858)
 4:     392688     266667 (-126021)
 5:     432231     266589 (-165642)
 6:     392754     298734 (-94020)
 7:     392883     284994 (-107889)
 8:     392637     266694 (-125943)
 9:     392985     267024 (-125961)


3.5 GHz i7-2700:
# /tmp/perftest /tmp/random64
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         82         90 (+8)
 1:         38         41 (+3)
 2:         46         38 (-8)
 3:         35         41 (+6)
 4:         46         41 (-5)
 5:         38         38 (+0)
 6:         41         55 (+14)
 7:         41         35 (-6)
 8:         46         24 (-22)
 9:         35         38 (+3)
# /tmp/perftest /tmp/random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         82         76 (-6)
 1:         32         53 (+21)
 2:         49         44 (-5)
 3:         35         41 (+6)
 4:         46         35 (-11)
 5:         35         44 (+9)
 6:         49         50 (+1)
 7:         41         41 (+0)
 8:         32         44 (+12)
 9:         49         44 (-5)
# /tmp/perftest /tmp/random64 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     445486     227993 (-217493)
 1:     445089     227602 (-217487)
 2:     445381     227736 (-217645)
 3:     445220     227661 (-217559)
 4:     445159     227798 (-217361)
 5:     445285     227608 (-217677)
 6:     445005     227806 (-217199)
 7:     445439     227608 (-217831)
 8:     445328     227798 (-217530)
 9:     445533     227625 (-217908)
# /tmp/perftest /tmp/random32 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     437001     335959 (-101042)
 1:     437004     336120 (-100884)
 2:     436683     335936 (-100747)
 3:     436806     336452 (-100354)
 4:     436996     335988 (-101008)
 5:     436916     336210 (-100706)
 6:     437042     354722 (-82320)
 7:     436896     336146 (-100750)
 8:     436981     336741 (-100240)
 9:     437016     331920 (-105096)


And on a 1.6 GHz P4:
$ /tmp/random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:        312        176 (-136)
 1:        112        112 (+0)
 2:        112        112 (+0)
 3:        112        112 (+0)
 4:        112        112 (+0)
 5:        112        112 (+0)
 6:        112        112 (+0)
 7:        112        112 (+0)
 8:        112        112 (+0)
 9:        112        112 (+0)
$ /tmp/random32 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     480344     550192 (+69848)
 1:     480088     550084 (+69996)
 2:     480140     550128 (+69988)
 3:     480088     550084 (+69996)
 4:     480088     550084 (+69996)
 5:     480088     550084 (+69996)
 6:     480088     550084 (+69996)
 7:     480088     550084 (+69996)
 8:     480088     550084 (+69996)
 9:     480088     550084 (+69996)


And just for lulz, a 1.533 GHz Athlon XP:
$ /tmp/random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         91         83 (-8)
 1:         58         57 (-1)
 2:         58         57 (-1)
 3:         58         57 (-1)
 4:         58         45 (-13)
 5:         58         45 (-13)
 6:         58         45 (-13)
 7:         58         45 (-13)
 8:         58         45 (-13)
 9:         58         45 (-13)
$ /tmp/random32 10000
pool 1 = 54b3ba06 4769d67a eb04bbf3 5e42df6e
pool 2 = 9d3c469e 6fecdb60 423af4ca 465173d1
 0:     570094     380159 (-189935)
 1:     550045     380088 (-169957)
 2:     550028     380043 (-169985)
 3:     568533     380087 (-188446)
 4:     550028     380021 (-170007)
 5:     550028     380021 (-170007)
 6:     550028     380021 (-170007)
 7:     550028     380021 (-170007)
 8:     550028     382985 (-167043)
 9:     550088     380021 (-170067)
