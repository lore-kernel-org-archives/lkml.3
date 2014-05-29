Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbaE2D1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:27:01 -0400
Received: from ns.horizon.com ([71.41.210.147]:21969 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755157AbaE2D1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:27:00 -0400
Date: 28 May 2014 23:26:55 -0400
Message-ID: <20140529032655.27479.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tim.c.chen@linux.intel.com
Subject: Re: [PATCH v2] crypto: crc32c-pclmul - Shrink K_table to 32-bit words
Cc: david.m.cote@intel.com, herbert@gondor.apana.org.au,
        james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, sandyw@twitter.com,
        wajdi.k.feghali@intel.com
In-Reply-To: <1401318135.2970.399.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you do a tcrypt speed measurement with and without your changes?
> Check to see if there's any slowdown.  Please make sure you pin
> the frequency of your cpu when running the test.  
> 
> e.g.
> echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

I just now re-read your e-mail and noticed you suggested a specific tool.
Oops, I haven't run that yet.  I just made up my own in user space.
As I mentioned, since the changes are to the main loop that operates on
aligned buffers in multiples of 24 bytes, I focused my benchmarking there:

#define BUFFER 6114
static unsigned char buf[BUFFER] __attribute__ ((aligned(8)));
#define ITER 24 /* Number of test iterations */

uint32_t
do_test(uint32_t crc, uint32_t (*f)(void const *, unsigned, uint32_t))
{
	int i, j;
	for (i = 0; i < BUFFER; i += 8)
		for (j = i+24; j <= BUFFER; j += 24)
			crc = f(buf+i, j-i, crc);
	return crc;
}

uint32_t
time_test(uint64_t *time, uint32_t crc, uint32_t (*f)(void const *, unsigned, ui
nt32_t))
{
	uint64_t start = rdtsc();
	crc = do_test(crc, f);
	*time = rdtsc() - start;
	return crc;
}

The actual test goes in ABBA order to reduce bias:

	for (i = 0; i < ITER; i += 2) {
		crc1 = time_test(times[i]+0, crc1, crc_pcl_1);
		crc2 = time_test(times[i]+1, crc2, crc_pcl_2);
		crc2 = time_test(times[i+1]+1, crc2, crc_pcl_2);
		crc1 = time_test(times[i+1]+0, crc1, crc_pcl_1);
	}

crc_pcl_1 is the old code, crc_pcl_2 is my revised version.


The results are as follows (the last line is a total):

        Old code     New code
 0:     85009953     71812457 (-13197496)
 1:     57408829     63361572 (+5952743)
 2:     52552399     49195266 (-3357133)
 3:     43595130     45988364 (+2393234)
 4:     41541760     39714198 (-1827562)
 5:     36576082     38021344 (+1445262)
 6:     35307854     34150656 (-1157198)
 7:     32182230     33134236 (+952006)
 8:     31341596     31307004 (-34592)
 9:     31340900     31329408 (-11492)
10:     31344884     31329144 (-15740)
11:     31334144     31312492 (-21652)
12:     31338992     31330356 (-8636)
13:     31343744     31311344 (-32400)
14:     31339000     31340196 (+1196)
15:     31337492     31313988 (-23504)
16:     31341688     31334040 (-7648)
17:     31341804     31308936 (-32868)
18:     31339936     31332020 (-7916)
19:     31323228     31324240 (+1012)
20:     31339744     31331768 (-7976)
21:     31321536     31332688 (+11152)
22:     31340280     31335212 (-5068)
23:     31332056     31335768 (+3712)
24:    885575261    876586697 (-8988564)

I swapped the link order of the two .o files in case cache
placement made a difference:

 0:     84305981     71483150 (-12822831)
 1:     57341376     63129024 (+5787648)
 2:     52361618     49240069 (-3121549)
 3:     43520576     45822670 (+2302094)
 4:     41500104     39684116 (-1815988)
 5:     36542864     37940196 (+1397332)
 6:     35281570     34144348 (-1137222)
 7:     32149420     33088652 (+939232)
 8:     31342368     31329056 (-13312)
 9:     31338788     31313212 (-25576)
10:     31336324     31335612 (-712)
11:     31341892     31319576 (-22316)
12:     31336224     31322808 (-13416)
13:     31338560     31315084 (-23476)
14:     31338332     31332976 (-5356)
15:     31337300     31315088 (-22212)
16:     31334300     31330884 (-3416)
17:     31318660     31329916 (+11256)
18:     31334984     31327740 (-7244)
19:     31315084     31327768 (+12684)
20:     31334708     31345872 (+11164)
21:     31325988     31330948 (+4960)
22:     31333956     31339800 (+5844)
23:     31322880     31327316 (+4436)
24:    884333857    875775881 (-8557976)

It doesn't look like a slowdown; more like a 1% speedup.

I'll figure out tcrypt in a bit.
