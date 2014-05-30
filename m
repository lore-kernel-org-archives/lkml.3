Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaE3BHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:07:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:33440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbaE3BHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:07:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,937,1392192000"; 
   d="scan'208";a="548662213"
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
From: Tim Chen <tim.c.chen@linux.intel.com>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140529235432.19207.qmail@ns.horizon.com>
References: <20140529235432.19207.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 May 2014 18:07:16 -0700
Message-ID: <1401412036.2970.459.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 19:54 -0400, George Spelvin wrote:
> Sorry for the delay; my Ivy Bridge test machine isn't in my
> office and getting to the console to tweak the BIOS is a
> bit of a bother.
> 
> Anyway, i7-4930K, turbo boost & hyperthreading disabled,
> $ cat /sys/devices/system/cpu/cpu?/cpufreq/scaling_governor
> performance
> performance
> performance
> performance
> performance
> performance
> 
> Oddly, though, CPU speed still seems to be fluctuating:
> $ grep MHz /proc/cpuinfo
> cpu MHz         : 1255.875
> cpu MHz         : 3168.375
> cpu MHz         : 3062.125
> cpu MHz         : 1468.375
> cpu MHz         : 1309.000
> cpu MHz         : 2212.125
> $ grep MHz /proc/cpuinfo
> cpu MHz         : 1255.875
> cpu MHz         : 2690.250
> cpu MHz         : 1255.875
> cpu MHz         : 2530.875
> cpu MHz         : 2212.125
> cpu MHz         : 1521.500

This is odd.  On my Ivy Bridge system the CPU speed from /proc/cpuinfo 
is at max freq once I set the performance governor.  
The numbers above almost look like
the cpu frequency is fluctuating and an average is taken.
What version of the kernel are you running?  Is 
CONFIG_CPU_FREQ_GOV_PERFORMANCE compiled in?

Does /sys/devices/system/cpu/cpu?/cpufreq/scaling_cur_freq
also changes?

Can you check what are the available governors in your system
and available frequencies?

cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies

If userspace governor is available, you can try set the governor
to userspace, then pin frequency to 3400 MHz (assuming that's your
max) with command like:

i=0
num_cpus=`cat /proc/cpuinfo| grep "^processor"| wc -l `
while [ $i -lt $num_cpus ]
do
  echo userspace > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
  echo 3400000 > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_setspeed
  i=`expr $i + 1`
done


> 
> It does this even if I set scaling_min_freq to 3400000.
> Very annoying.  Should I be using a different
> scaling_governor than intel_pstate?
> 
> >> It doesn't look like a slowdown; more like a 1% speedup.
> >
> > You will need to throw away the first few iterations of
> > the test to account for cache warming effects.
> 
> You're absolutely right; that's exactly *why* I ran it 24 times and
> listed them all separately.  The "1%" number was B.S. and I was not
> thinking when I quoted it.
> 
> What I had legitimately noticed was that the code with the patch took
> slightly fewer cycles most of the time, even after discounting the
> first few.  Not statistically significant, but enough to argue that it
> didn't cause a noticeable slowdown.
> 
> 
> Anyway, two iterations each of "modprobe tcrypt mode=319".
> 
> Old code:
> [ 1530.513529] 
> [ 1530.513529] testing speed of crc32c
> [ 1530.513535] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     75 cycles/operation,    4 cycles/byte
> [ 1530.513537] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    413 cycles/operation,    6 cycles/byte
> [ 1530.513540] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     88 cycles/operation,    1 cycles/byte
> [ 1530.513542] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1327 cycles/operation,    5 cycles/byte
> [ 1530.513548] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    503 cycles/operation,    1 cycles/byte
> [ 1530.513551] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    178 cycles/operation,    0 cycles/byte
> [ 1530.513553] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4972 cycles/operation,    4 cycles/byte
> [ 1530.513572] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    806 cycles/operation,    0 cycles/byte
> [ 1530.513576] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    370 cycles/operation,    0 cycles/byte
> [ 1530.513579] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   9835 cycles/operation,    4 cycles/byte
> [ 1530.513615] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1461 cycles/operation,    0 cycles/byte
> [ 1530.513622] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    847 cycles/operation,    0 cycles/byte
> [ 1530.513626] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    495 cycles/operation,    0 cycles/byte
> [ 1530.513630] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19571 cycles/operation,    4 cycles/byte
> [ 1530.513700] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2758 cycles/operation,    0 cycles/byte
> [ 1530.513711] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1676 cycles/operation,    0 cycles/byte
> [ 1530.513718] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    859 cycles/operation,    0 cycles/byte
> [ 1530.513722] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39012 cycles/operation,    4 cycles/byte
> [ 1530.513861] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5417 cycles/operation,    0 cycles/byte
> [ 1530.513882] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3162 cycles/operation,    0 cycles/byte
> [ 1530.513894] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1678 cycles/operation,    0 cycles/byte
> [ 1530.513901] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1653 cycles/operation,    0 cycles/byte
> 
> [ 1662.359717] 
> [ 1662.359717] testing speed of crc32c
> [ 1662.359723] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     80 cycles/operation,    5 cycles/byte
> [ 1662.359725] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    430 cycles/operation,    6 cycles/byte
> [ 1662.359729] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     81 cycles/operation,    1 cycles/byte
> [ 1662.359730] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1324 cycles/operation,    5 cycles/byte
> [ 1662.359736] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    503 cycles/operation,    1 cycles/byte
> [ 1662.359740] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    171 cycles/operation,    0 cycles/byte
> [ 1662.359741] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4983 cycles/operation,    4 cycles/byte
> [ 1662.359760] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    832 cycles/operation,    0 cycles/byte
> [ 1662.359764] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    366 cycles/operation,    0 cycles/byte
> [ 1662.359768] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   9839 cycles/operation,    4 cycles/byte
> [ 1662.359804] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1437 cycles/operation,    0 cycles/byte
> [ 1662.359810] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    862 cycles/operation,    0 cycles/byte
> [ 1662.359815] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    494 cycles/operation,    0 cycles/byte
> [ 1662.359818] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19553 cycles/operation,    4 cycles/byte
> [ 1662.359901] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2761 cycles/operation,    0 cycles/byte
> [ 1662.359912] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1715 cycles/operation,    0 cycles/byte
> [ 1662.359919] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    852 cycles/operation,    0 cycles/byte
> [ 1662.359928] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39016 cycles/operation,    4 cycles/byte
> [ 1662.360069] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5538 cycles/operation,    0 cycles/byte
> [ 1662.360090] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3280 cycles/operation,    0 cycles/byte
> [ 1662.360102] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1695 cycles/operation,    0 cycles/byte
> [ 1662.360110] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1639 cycles/operation,    0 cycles/byte
> 
> New code:
> [  710.814463] 
> [  710.814463] testing speed of crc32c
> [  710.814469] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     80 cycles/operation,    5 cycles/byte
> [  710.814472] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    410 cycles/operation,    6 cycles/byte
> [  710.814476] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     94 cycles/operation,    1 cycles/byte
> [  710.814477] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1327 cycles/operation,    5 cycles/byte
> [  710.814483] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    492 cycles/operation,    1 cycles/byte
> [  710.814486] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    175 cycles/operation,    0 cycles/byte
> [  710.814488] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4970 cycles/operation,    4 cycles/byte
> [  710.814507] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    797 cycles/operation,    0 cycles/byte
> [  710.814511] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    370 cycles/operation,    0 cycles/byte
> [  710.814514] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   9846 cycles/operation,    4 cycles/byte
> [  710.814551] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1452 cycles/operation,    0 cycles/byte
> [  710.814557] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    840 cycles/operation,    0 cycles/byte
> [  710.814561] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    497 cycles/operation,    0 cycles/byte
> [  710.814564] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19563 cycles/operation,    4 cycles/byte
> [  710.814635] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2764 cycles/operation,    0 cycles/byte
> [  710.814646] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1646 cycles/operation,    0 cycles/byte
> [  710.814653] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    858 cycles/operation,    0 cycles/byte
> [  710.814657] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39020 cycles/operation,    4 cycles/byte
> [  710.814796] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5422 cycles/operation,    0 cycles/byte
> [  710.814816] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3182 cycles/operation,    0 cycles/byte
> [  710.814829] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1669 cycles/operation,    0 cycles/byte
> [  710.814836] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1636 cycles/operation,    0 cycles/byte
> 
> [ 1751.451733] 
> [ 1751.451733] testing speed of crc32c
> [ 1751.451739] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):     75 cycles/operation,    4 cycles/byte
> [ 1751.451741] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    414 cycles/operation,    6 cycles/byte
> [ 1751.451745] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):     87 cycles/operation,    1 cycles/byte
> [ 1751.451746] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1329 cycles/operation,    5 cycles/byte
> [ 1751.451752] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    499 cycles/operation,    1 cycles/byte
> [ 1751.451756] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    170 cycles/operation,    0 cycles/byte
> [ 1751.451757] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   4964 cycles/operation,    4 cycles/byte
> [ 1751.451776] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    836 cycles/operation,    0 cycles/byte
> [ 1751.451780] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    370 cycles/operation,    0 cycles/byte
> [ 1751.451784] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   9844 cycles/operation,    4 cycles/byte
> [ 1751.451820] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1468 cycles/operation,    0 cycles/byte
> [ 1751.451826] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    835 cycles/operation,    0 cycles/byte
> [ 1751.451830] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    493 cycles/operation,    0 cycles/byte
> [ 1751.451834] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  19564 cycles/operation,    4 cycles/byte
> [ 1751.451904] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2776 cycles/operation,    0 cycles/byte
> [ 1751.451915] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1662 cycles/operation,    0 cycles/byte
> [ 1751.451922] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    858 cycles/operation,    0 cycles/byte
> [ 1751.451927] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  39531 cycles/operation,    4 cycles/byte
> [ 1751.452067] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   5427 cycles/operation,    0 cycles/byte
> [ 1751.452088] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3175 cycles/operation,    0 cycles/byte
> [ 1751.452100] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1666 cycles/operation,    0 cycles/byte
> [ 1751.452107] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   1634 cycles/operation,    0 cycles/byte
> 
> The tests are pretty short, but there's no obvious slowdown.  Particularly
> on the tests with > 200 byte per update where the modified code paths are
> found.

So far, the numbers look good.

BTW, why do you place the K table in .text, instead of .rodata? 

Thanks.

Tim


