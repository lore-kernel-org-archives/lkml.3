Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbaE2Qdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:33:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:21199 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923AbaE2Qda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,934,1392192000"; 
   d="scan'208";a="519760410"
Subject: Re: [PATCH v2] crypto: crc32c-pclmul - Shrink K_table to 32-bit
 words
From: Tim Chen <tim.c.chen@linux.intel.com>
To: George Spelvin <linux@horizon.com>
Cc: david.m.cote@intel.com, herbert@gondor.apana.org.au,
        james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, sandyw@twitter.com,
        wajdi.k.feghali@intel.com
In-Reply-To: <20140529032655.27479.qmail@ns.horizon.com>
References: <20140529032655.27479.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 May 2014 09:33:21 -0700
Message-ID: <1401381201.2970.431.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 23:26 -0400, George Spelvin wrote:
> > Can you do a tcrypt speed measurement with and without your changes?
> > Check to see if there's any slowdown.  Please make sure you pin
> > the frequency of your cpu when running the test.  
> > 
> > e.g.
> > echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> 
> I just now re-read your e-mail and noticed you suggested a specific tool.

Try to run the standard kernel crypto test with tcrypt.  For speed test
of crc32c, use test 319:

modprobe tcrypt mode=319

Then you will see the output in dmesg (or tail of /var/log/messages).
It will give you the cycles you spent for various block sizes.

For consistent test numbers, before test, 
disable turbo mode of cpu in BIOS and pin 
frequency of all your cpus to max with something like

i=0
num_cpus=`cat /proc/cpuinfo| grep "^processor"| wc -l `
while [ $i -lt $num_cpus ]
do
  echo performance > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
  i=`expr $i + 1`
done

> Oops, I haven't run that yet.  I just made up my own in user space.
> As I mentioned, since the changes are to the main loop that operates on
> aligned buffers in multiples of 24 bytes, I focused my benchmarking there:
> 
> #define BUFFER 6114
> static unsigned char buf[BUFFER] __attribute__ ((aligned(8)));
> #define ITER 24 /* Number of test iterations */
> 
> uint32_t
> do_test(uint32_t crc, uint32_t (*f)(void const *, unsigned, uint32_t))
> {
> 	int i, j;
> 	for (i = 0; i < BUFFER; i += 8)
> 		for (j = i+24; j <= BUFFER; j += 24)
> 			crc = f(buf+i, j-i, crc);
> 	return crc;
> }
> 
> uint32_t
> time_test(uint64_t *time, uint32_t crc, uint32_t (*f)(void const *, unsigned, ui
> nt32_t))
> {
> 	uint64_t start = rdtsc();
> 	crc = do_test(crc, f);
> 	*time = rdtsc() - start;
> 	return crc;
> }
> 
> The actual test goes in ABBA order to reduce bias:
> 
> 	for (i = 0; i < ITER; i += 2) {
> 		crc1 = time_test(times[i]+0, crc1, crc_pcl_1);
> 		crc2 = time_test(times[i]+1, crc2, crc_pcl_2);
> 		crc2 = time_test(times[i+1]+1, crc2, crc_pcl_2);
> 		crc1 = time_test(times[i+1]+0, crc1, crc_pcl_1);
> 	}
> 
> crc_pcl_1 is the old code, crc_pcl_2 is my revised version.
> 
> 
> The results are as follows (the last line is a total):
> 
>         Old code     New code
>  0:     85009953     71812457 (-13197496)
>  1:     57408829     63361572 (+5952743)

Maybe your cpu has not been pinned to constant frequency?
The cycles are much higher in the first few iterations.  
Likely cpu frequency is going up when governor detect 
the load on cpu. Please also check that turbo is 
turned off as this can introduce much variations
in your testing.

>  2:     52552399     49195266 (-3357133)
>  3:     43595130     45988364 (+2393234)
>  4:     41541760     39714198 (-1827562)
>  5:     36576082     38021344 (+1445262)
>  6:     35307854     34150656 (-1157198)
>  7:     32182230     33134236 (+952006)
>  8:     31341596     31307004 (-34592)
>  9:     31340900     31329408 (-11492)
> 10:     31344884     31329144 (-15740)
> 11:     31334144     31312492 (-21652)
> 12:     31338992     31330356 (-8636)
> 13:     31343744     31311344 (-32400)
> 14:     31339000     31340196 (+1196)
> 15:     31337492     31313988 (-23504)
> 16:     31341688     31334040 (-7648)
> 17:     31341804     31308936 (-32868)
> 18:     31339936     31332020 (-7916)
> 19:     31323228     31324240 (+1012)
> 20:     31339744     31331768 (-7976)
> 21:     31321536     31332688 (+11152)
> 22:     31340280     31335212 (-5068)
> 23:     31332056     31335768 (+3712)

Looks encouraging that the time difference is fairly
small between the two algorithms.

> 24:    885575261    876586697 (-8988564)

> 
> It doesn't look like a slowdown; more like a 1% speedup.

You will need to throw away the first few iterations of
the test to account for cache warming effects.

Thanks.

Tim

