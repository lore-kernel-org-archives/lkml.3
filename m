Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaFNLOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 07:14:10 -0400
Received: from ns.horizon.com ([71.41.210.147]:34882 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751636AbaFNLOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 07:14:07 -0400
Date: 14 Jun 2014 07:14:05 -0400
Message-ID: <20140614111405.9630.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140614080329.29871.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And I have of course embarrassed myself publicly by getting the sign
wrong.  That's what I get for posting *before* booting the result.

You may now point and bray like a donkey. :-)


Anyway. the following actually works:

#if ADD_INTERRUPT_BENCH
static unsigned long avg_cycles, avg_deviation;

#define AVG_SHIFT 8	/* Exponential average factor k=1/256 */
#define FIXED_1_2 (1 << (AVG_SHIFT-1))

static void add_interrupt_bench(cycles_t start)
{
	long delta = random_get_entropy() - start;

	/* Use a weighted moving average */
	delta = delta - ((avg_cycles + FIXED_1_2) >> AVG_SHIFT);
	avg_cycles += delta;
	/* And average deviation */
	delta = abs(delta) - ((avg_deviation + FIXED_1_2) >> AVG_SHIFT);
	avg_deviation += delta;
}
#else
#define add_interrupt_bench(x)
#endif

And here are some measurements (uncorrected for *256 scaling) on my
primary (Ivy Bridge E) test machine.  I've included 10 samples of
each value, takesn at 10s intervals.  avg_cycles is first, followed
by avg_deviation.  The three conditions are idle (1.2 GHz), idle with
performance governor enabled (3.9 GHz), and during a "make -j7" in the
kernel tree (also all processors at maximum).

Rather against my intuition, a busy system greatly *reduces* the
time spent.  Just to see what interrupt rate did, on the last kernel
I also tested it while being ping flooded.

They're sorted in increasing order of speed.  Unrolling definitely
makes a difference, but it's not faster than the old code until I drop
to 2 iterations in the inner loop (which would be called 4 rounds by
most people).  The 64-bit mix is noticeably faster yet.

Idle		performance	make -j7

ORIG_FAST_MIX=0
74761 22228	78799 20305	46527 24966
71984 23619	78466 20599	50044 25202
71949 23760	77262 21363	48295 25460
72966 23859	76188 21921	47393 25130
73974 23543	76040 22135	42979 24341
74601 23407	75294 22602	50502 26715
75359 23169	71267 24990	45649 25338
75450 22855	71065 25022	48792 25731
76338 22711	71569 25016	48564 26040
76546 22567	71143 24972	48414 27882

ORIG_FAST_MIX=0, unrolled:
54830 20312	60343 21814	29577 16699
55510 20787	60655 22504	40344 24749
56994 21080	60691 22497	41095 27184
57674 21566	60261 22713	39578 26717
57560 22221	60690 22709	41361 26138
58220 22593	59978 22924	36334 24249
58646 22422	58391 23466	37125 25089
59485 21927	58000 23968	24091 11892
60444 21959	58633 24486	28816 15585
60637 22133	58576 24593	25125 13174

ORIG_FAST_MIX=1
50554 13117	54732 13010	24043 12804
51294 13623	53269 14066	35671 25957
51063 13682	52531 14214	34391 22749
49833 13612	51833 14272	24097 13802
49458 13624	49288 15046	31378 18110
50383 13936	48720 15540	25088 17320
51167 14210	49058 15637	26478 13247
51356 14157	48206 15787	30542 19717
51077 14155	48587 15742	27461 15865
52199 14361	48710 15933	27608 14826

ORIG_FAST_MIX=0, unrolled, 2 (double) rounds:
43011 10685	44846 10523	21469 10994
42568 10261	43968 10834	19694 8501
42012 10304	43657 10619	19174 8557
42166 10063	43064 10598	20221 9398
41496 10353	42125 10843	19034 6685
42176 10826	41547 10984	19462 8002
41671 10947	40756 11242	21654 12140
41691 10643	40309 11312	20526 9188
41091 10817	40135 11318	20159 9267
41151 10553	39877 11484	19653 8393

64-bit hash, 2 (double) rounds (which is excellent avalanche):
36117 11269	39285 11171	16953 5664	35107 14735
35391 11035	36564 11600	18143 7216      35322 14176
34728 11280	35278 12085	16815 6245      35479 14453
35552 11606	35627 11863	16876 5841      34717 14505
35553 11633	35145 11892	17825 6166      35241 14555
35468 11406	35773 11857	16834 5094      34814 14719
35301 11390	35357 11771	16750 4987      35248 14566
34841 10821	35785 11531	19170 8296      35627 14103
34818 10942	35045 11592	17004 6814      34948 14399
35113 11158	35469 11343	19344 7969      33859 14035

Idle		performance	make -j7	ping -f (from outside)

(Again, all numbers must be divided by 256 to get cycles.  You
can probably divide by 1000 amd multiply by 5 in your head, which
is a pretty good approximation.))
