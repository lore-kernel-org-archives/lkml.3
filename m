Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaFLENU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 00:13:20 -0400
Received: from ns.horizon.com ([71.41.210.147]:35326 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750787AbaFLENT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 00:13:19 -0400
Date: 12 Jun 2014 00:13:18 -0400
Message-ID: <20140612041318.11805.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140612032248.GA2437@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I redid my numbers, and I can no longer reproduce the 7x slowdown.  I
> do see that if you compile w/o -O2, fast_mix2 is twice as slow.  But
> it's not 7x slower.

For my single-round, I needed to drop to 2 loops rather than 3 to match
the speed.  That's in the source I posted, but I didn't point it out.

(It wasn't an attempt to be deceptive, that's just how I happened
to have left the file when I was experimenting with various options.
I figured if we were looking for 7x, 1.5x wasn't all that important.)

That explains some of the residual difference between our figures.

When developing, I was using a many-iteration benchmark, and I suspect it
fitted in the Ivy Bridge uop cache, which let it saturate the execution
resources.

Sorry for the premature alarm; I'll go back to work and find something
better.

I still get comparable speed for 2 loops and -O2:
$ cc -W -Wall -m32 -O2 -march=native random.c -o random32
# ./perftest ../spooky/random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:        148        124 (-24)
 1:         48         36 (-12)
 2:         40         36 (-4)
 3:         44         40 (-4)
 4:         44         40 (-4)
 5:         36         36 (+0)
 6:         52         36 (-16)
 7:         44         32 (-12)
 8:         44         36 (-8)
 9:         48         36 (-12)
$ cc -W -Wall -m64 -O2 -march=native random.c -o random64
# ./perftest ../spooky/random64
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:        132        104 (-28)
 1:         40         40 (+0)
 2:         36         44 (+8)
 3:         32         40 (+8)
 4:         40         36 (-4)
 5:         32         40 (+8)
 6:         36         44 (+8)
 7:         40         40 (+0)
 8:         36         44 (+8)
 9:         40         36 (-4)
$ cc -W -Wall -m32 -O3 -march=native random.c -o random32
# ./perftest ./random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         88         48 (-40)
 1:         36         40 (+4)
 2:         36         44 (+8)
 3:         32         40 (+8)
 4:         36         40 (+4)
 5:         96         40 (-56)
 6:         40         40 (+0)
 7:         36         40 (+4)
 8:         28         48 (+20)
 9:         28         40 (+12)
$ cc -W -Wall -m64 -O3 -march=native random.c -o random64
# ./perftest ./random64
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         72         80 (+8)
 1:         36         52 (+16)
 2:         32         36 (+4)
 3:         32         36 (+4)
 4:         28         40 (+12)
 5:         32         40 (+8)
 6:         32         40 (+8)
 7:         32         36 (+4)
 8:         28         44 (+16)
 9:         36         36 (+0)
$ cc -W -Wall -m32 -Os -march=native random.c -o random32
# ./perftest ./random32
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:        108        132 (+24)
 1:         44         44 (+0)
 2:         76         40 (-36)
 3:         44         48 (+4)
 4:         36         40 (+4)
 5:         32         44 (+12)
 6:         40         56 (+16)
 7:         44         36 (-8)
 8:         44         40 (-4)
 9:         32         40 (+8)
$ $ cc -W -Wall -m64 -Os -march=native random.c -o random64
# ./perftest ./random64
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         96        108 (+12)
 1:         44         52 (+8)
 2:         40         40 (+0)
 3:         40         36 (-4)
 4:         40         32 (-8)
 5:         36         36 (+0)
 6:         44         32 (-12)
 7:         36         36 (+0)
 8:         40         36 (-4)
 9:         40         36 (-4)

Yours looks much more careful about the timing.

A few GCC warnings I ended up fixing:
1) "volatile" on rdtsc is meaningless and ignore (with a warning)
2) fast_mix2() needs a void return type; it defaults to int.
3) int main() needs a "return 0"


Here's what I got running *your* program, unmodified except
for the above (meaning 3 inner loop iterations).
Compiled with GCC 4.9.0 (Devian 4.9.0-6), -O2.

i7-4940K# ./perftest ./ted32   
fast_mix: 430   fast_mix2: 431
fast_mix: 442   fast_mix2: 464
fast_mix: 442   fast_mix2: 465
fast_mix: 442   fast_mix2: 431
fast_mix: 442   fast_mix2: 465
fast_mix: 431   fast_mix2: 430
fast_mix: 442   fast_mix2: 431
fast_mix: 431   fast_mix2: 465
fast_mix: 431   fast_mix2: 465
fast_mix: 431   fast_mix2: 431
i7-4940K# ./perftest ./ted64
fast_mix: 454   fast_mix2: 465
fast_mix: 453   fast_mix2: 465
fast_mix: 442   fast_mix2: 464
fast_mix: 453   fast_mix2: 464
fast_mix: 454   fast_mix2: 465
fast_mix: 453   fast_mix2: 465
fast_mix: 442   fast_mix2: 464
fast_mix: 453   fast_mix2: 464
fast_mix: 453   fast_mix2: 464
fast_mix: 453   fast_mix2: 465

In other words, pretty damn near the same
speed (with 3 loops).

So we still have some discrepancy to track down.

A few other machines.
i5-3330$ /tmp/ted32
fast_mix: 226   fast_mix2: 277
fast_mix: 561   fast_mix2: 429
fast_mix: 156   fast_mix2: 406
fast_mix: 504   fast_mix2: 534
fast_mix: 579   fast_mix2: 270
fast_mix: 240   fast_mix2: 270
fast_mix: 494   fast_mix2: 270
fast_mix: 240   fast_mix2: 138
fast_mix: 750   fast_mix2: 277
fast_mix: 124   fast_mix2: 270
i5-3330$ /tmp/ted64
fast_mix: 224   fast_mix2: 277
fast_mix: 226   fast_mix2: 312
fast_mix: 646   fast_mix2: 276
fast_mix: 233   fast_mix2: 456
fast_mix: 591   fast_mix2: 570
fast_mix: 413   fast_mix2: 563
fast_mix: 584   fast_mix2: 270
fast_mix: 231   fast_mix2: 261
fast_mix: 233   fast_mix2: 459
fast_mix: 528   fast_mix2: 277

Pentium4$ /tmp/ted32
fast_mix: 912   fast_mix2: 396
fast_mix: 792   fast_mix2: 160
fast_mix: 524   fast_mix2: 160
fast_mix: 1460  fast_mix2: 440
fast_mix: 496   fast_mix2: 160
fast_mix: 672   fast_mix2: 160
fast_mix: 700   fast_mix2: 160
fast_mix: 336   fast_mix2: 540
fast_mix: 896   fast_mix2: 160
fast_mix: 1052  fast_mix2: 156

Phemom9850$ /tmp/ted32
fast_mix: 463   fast_mix2: 158
fast_mix: 276   fast_mix2: 174
fast_mix: 194   fast_mix2: 135
fast_mix: 620   fast_mix2: 424
fast_mix: 584   fast_mix2: 424
fast_mix: 610   fast_mix2: 418
fast_mix: 651   fast_mix2: 1107
fast_mix: 634   fast_mix2: 439
fast_mix: 632   fast_mix2: 456
fast_mix: 534   fast_mix2: 205
Phemom9850$ /tmp/ted64
fast_mix: 783   fast_mix2: 185
fast_mix: 903   fast_mix2: 144
fast_mix: 955   fast_mix2: 178
fast_mix: 515   fast_mix2: 437
fast_mix: 642   fast_mix2: 580
fast_mix: 610   fast_mix2: 525
fast_mix: 523   fast_mix2: 119
fast_mix: 180   fast_mix2: 315
fast_mix: 596   fast_mix2: 570
fast_mix: 598   fast_mix2: 775

AthlonXP$ /tmp/ted32
fast_mix: 119   fast_mix2: 113
fast_mix: 139   fast_mix2: 109
fast_mix: 155   fast_mix2: 123
fast_mix: 134   fast_mix2: 140
fast_mix: 126   fast_mix2: 154
fast_mix: 134   fast_mix2: 113
fast_mix: 176   fast_mix2: 140
fast_mix: 145   fast_mix2: 113
fast_mix: 134   fast_mix2: 144
fast_mix: 155   fast_mix2: 112


So I'm still a bit confused.  Would any bystanders like to
chip in?  Ted, shall I send you some binaries?
