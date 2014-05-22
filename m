Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaEVPKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:10:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64974 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaEVPKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:10:16 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: crypto: Add Allwinner Security System crypto accelerator
Date: Thu, 22 May 2014 17:09:53 +0200
Message-Id: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello

This is the driver for the Security System included in Allwinner SoC A20.
The Security System (SS for short) is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
It could be found on others Allwinner SoC: 
- A10s, A10 and A31 diagram speak about it
- A13 manual give the same datasheet for SS than A20
But I do not have access on any of those hardware, tests are welcome.

This driver currently supports:
- MD5 and SHA1 hash algorithms
- AES block cipher in CBC mode with 128/196/256bits keys.
- DES and 3DES block cipher in CBC mode
- PRNG
The driver exposes all those algorithms through the kernel cryptographic API.

The driver support only CPU driven (aka poll mode) transfer mode since the DMA engine of the A20 does not have a driver yet.


Since it is my first cryptographic driver, I have some questions with it:
- When setting .cra_priority to 300 (so more priority than krng), the PRNG seems not to be used (any of the dev_* message was never seen).
  But something use/lock it, because I cannot unload the module.
  So for the moment I have set its .cra_priority to 100 and need to investigate more.

- Some values of crypto_alg struct are not well documented, what exactly cra_alignmask involves ?

- Since SS could only process one request at a time, I have use shash and blkcipher (vs ahash/ablkcipher) does it is a good choice ?
  I think ahash/ablkcipher would be good if I add an interrupt driven driver, does I am right ?


Now speak about performance.
The performance are very good, up to x2 for hashing and 30/50% for AES:
(r/s means requests per second)
- MD5 without SS
10000 requests of 16 bytes in 813409us (0.813409s) 12293.938477r/s
10000 requests of 32 bytes in 824489us (0.824489s) 12128.724609r/s
10000 requests of 64 bytes in 834231us (0.834231s) 11987.087891r/s
10000 requests of 128 bytes in 851992us (0.851992s) 11737.199219r/s
10000 requests of 256 bytes in 866311us (0.866311s) 11543.198242r/s
10000 requests of 512 bytes in 909070us (0.909070s) 11000.252930r/s
10000 requests of 1024 bytes in 956643us (0.956643s) 10453.220703r/s
10000 requests of 2048 bytes in 1086405us (1.086405s) 9204.670898r/s
10000 requests of 4096 bytes in 1338719us (1.338719s) 7469.827637r/s
10000 requests of 8192 bytes in 1867788us (1.867788s) 5353.926758r/s
10000 requests of 16384 bytes in 2972250us (2.972250s) 3364.454590r/s
10000 requests of 32768 bytes in 4945905us (4.945905s) 2021.874634r/s
10000 requests of 65536 bytes in 8971740us (8.971740s) 1114.610962r/s
1000 requests of 131072 bytes in 1705265us (1.705265s) 586.419128r/s
1000 requests of 262144 bytes in 3340201us (3.340201s) 299.383179r/s
1000 requests of 524288 bytes in 6552412us (6.552412s) 152.615555r/s
1000 requests of 1048576 bytes in 13027299us (13.027299s) 76.761887r/s
1000 requests of 2097152 bytes in 25890814us (25.890814s) 38.623737r/s

- MD5 with SS
10000 requests of 16 bytes in 833828us (0.833828s) 11992.880859r/s
10000 requests of 32 bytes in 839807us (0.839807s) 11907.498047r/s
10000 requests of 64 bytes in 849816us (0.849816s) 11767.252930r/s
10000 requests of 128 bytes in 859020us (0.859020s) 11641.172852r/s
10000 requests of 256 bytes in 867209us (0.867209s) 11531.246094r/s
10000 requests of 512 bytes in 886111us (0.886111s) 11285.267578r/s
10000 requests of 1024 bytes in 934183us (0.934183s) 10704.541016r/s
10000 requests of 2048 bytes in 1008961us (1.008961s) 9911.185547r/s
10000 requests of 4096 bytes in 1171796us (1.171796s) 8533.908203r/s
10000 requests of 8192 bytes in 1518018us (1.518018s) 6587.537109r/s
10000 requests of 16384 bytes in 2665293us (2.665293s) 3751.932617r/s
10000 requests of 32768 bytes in 3580903us (3.580903s) 2792.591797r/s
10000 requests of 65536 bytes in 6260570us (6.260570s) 1597.298706r/s
1000 requests of 131072 bytes in 1164345us (1.164345s) 858.851990r/s
1000 requests of 262144 bytes in 2243004us (2.243004s) 445.830688r/s
1000 requests of 524288 bytes in 4404737us (4.404737s) 227.028305r/s
1000 requests of 1048576 bytes in 8720956us (8.720956s) 114.666328r/s
1000 requests of 2097152 bytes in 17383040us (17.383039s) 57.527336r/s

- SHA1 without SS
10000 requests of 16 bytes in 875042us (0.875042s) 11428.022461r/s
10000 requests of 32 bytes in 823671us (0.823671s) 12140.769531r/s
10000 requests of 64 bytes in 871748us (0.871748s) 11471.205078r/s
10000 requests of 128 bytes in 862865us (0.862865s) 11589.298828r/s
10000 requests of 256 bytes in 881417us (0.881417s) 11345.368164r/s
10000 requests of 512 bytes in 950922us (0.950922s) 10516.109375r/s
10000 requests of 1024 bytes in 1050256us (1.050256s) 9521.488281r/s
10000 requests of 2048 bytes in 1258961us (1.258961s) 7943.057617r/s
10000 requests of 4096 bytes in 1683097us (1.683097s) 5941.428223r/s
10000 requests of 8192 bytes in 2526498us (2.526498s) 3958.047852r/s
10000 requests of 16384 bytes in 4269592us (4.269592s) 2342.144287r/s
10000 requests of 32768 bytes in 7602177us (7.602177s) 1315.412720r/s
10000 requests of 65536 bytes in 14377450us (14.377450s) 695.533630r/s
1000 requests of 131072 bytes in 2765845us (2.765845s) 361.553162r/s
1000 requests of 262144 bytes in 5445735us (5.445735s) 183.629944r/s
1000 requests of 524288 bytes in 10789435us (10.789435s) 92.683258r/s
1000 requests of 1048576 bytes in 21505394us (21.505394s) 46.499962r/s
1000 requests of 2097152 bytes in 42825792us (42.825790s) 23.350414r/s

- SHA1 with SS
10000 requests of 16 bytes in 889208us (0.889208s) 11245.962891r/s
10000 requests of 32 bytes in 842736us (0.842736s) 11866.112305r/s
10000 requests of 64 bytes in 852888us (0.852888s) 11724.869141r/s
10000 requests of 128 bytes in 861924us (0.861924s) 11601.951172r/s
10000 requests of 256 bytes in 869454us (0.869454s) 11501.470703r/s
10000 requests of 512 bytes in 885505us (0.885505s) 11292.991211r/s
10000 requests of 1024 bytes in 936839us (0.936839s) 10674.192383r/s
10000 requests of 2048 bytes in 1012891us (1.012891s) 9872.730469r/s
10000 requests of 4096 bytes in 1185065us (1.185065s) 8438.355469r/s
10000 requests of 8192 bytes in 1521115us (1.521115s) 6574.125000r/s
10000 requests of 16384 bytes in 2234033us (2.234033s) 4476.209473r/s
10000 requests of 32768 bytes in 3571667us (3.571667s) 2799.812988r/s
10000 requests of 65536 bytes in 6266210us (6.266210s) 1595.860962r/s
1000 requests of 131072 bytes in 1164847us (1.164847s) 858.481873r/s
1000 requests of 262144 bytes in 2246109us (2.246109s) 445.214355r/s
1000 requests of 524288 bytes in 4454817us (4.454817s) 224.476105r/s
1000 requests of 1048576 bytes in 8807469us (8.807469s) 113.539993r/s
1000 requests of 2097152 bytes in 17339978us (17.339977s) 57.670200r/s

- AES 128 without SS
1000000 requests of 16 bytes in 12796270us (12.796270s) 78147.773438r/s
100000 requests of 32 bytes in 1354404us (1.354404s) 73833.210938r/s
100000 requests of 64 bytes in 1513001us (1.513001s) 66093.804688r/s
100000 requests of 128 bytes in 1827315us (1.827315s) 54725.101562r/s
10000 requests of 256 bytes in 243519us (0.243519s) 41064.558594r/s
10000 requests of 512 bytes in 364327us (0.364327s) 27447.869141r/s
10000 requests of 1024 bytes in 622588us (0.622588s) 16061.986328r/s
10000 requests of 2048 bytes in 1097997us (1.097997s) 9107.493164r/s
10000 requests of 4096 bytes in 2219479us (2.219479s) 4505.562012r/s
10000 requests of 8192 bytes in 4315617us (4.315617s) 2317.165771r/s
10000 requests of 16384 bytes in 8392507us (8.392507s) 1191.539062r/s
10000 requests of 32768 bytes in 16723522us (16.723522s) 597.960144r/s
10000 requests of 65536 bytes in 33682600us (33.682598s) 296.889191r/s
10000 requests of 131072 bytes in 66817472us (66.817474s) 149.661453r/s
5000 requests of 262144 bytes in 66956952us (66.956955s) 74.674843r/s
5000 requests of 524288 bytes in 130631872us (130.631866s) 38.275497r/s
1000 requests of 1048576 bytes in 52419776us (52.419777s) 19.076769r/s

- AES 128 with SS
1000000 requests of 16 bytes in 13789299us (13.789299s) 72520r/s
100000 requests of 32 bytes in 1408070us (1.408070s) 71019.195312r/s
100000 requests of 64 bytes in 1460338us (1.460338s) 68477.296875r/s
100000 requests of 128 bytes in 1665112us (1.665112s) 60056.019531r/s
10000 requests of 256 bytes in 209169us (0.209169s) 47808.230469r/s
10000 requests of 512 bytes in 288330us (0.288330s) 34682.480469r/s
10000 requests of 1024 bytes in 450088us (0.450088s) 22217.876953r/s
10000 requests of 2048 bytes in 779608us (0.779608s) 12826.958984r/s
10000 requests of 4096 bytes in 1459871us (1.459871s) 6849.920410r/s
10000 requests of 8192 bytes in 2795100us (2.795100s) 3577.689453r/s
10000 requests of 16384 bytes in 5465166us (5.465166s) 1829.770630r/s
10000 requests of 32768 bytes in 10775686us (10.775686s) 928.015137r/s
10000 requests of 65536 bytes in 21437566us (21.437567s) 466.470856r/s
10000 requests of 131072 bytes in 42685016us (42.685017s) 234.274246r/s
5000 requests of 262144 bytes in 42684292us (42.684292s) 117.139114r/s
5000 requests of 524288 bytes in 85359792us (85.359795s) 58.575588r/s
1000 requests of 1048576 bytes in 34153296us (34.153297s) 29.279751r/s

- AES 192 without SS
1000000 requests of 16 bytes in 20133432us (20.133432s) 49668.628906r/s
100000 requests of 32 bytes in 2094374us (2.094374s) 47746.964844r/s
100000 requests of 64 bytes in 2337254us (2.337254s) 42785.250000r/s
100000 requests of 128 bytes in 2633498us (2.633498s) 37972.308594r/s
10000 requests of 256 bytes in 331907us (0.331907s) 30128.921875r/s
10000 requests of 512 bytes in 469994us (0.469994s) 21276.867188r/s
10000 requests of 1024 bytes in 754699us (0.754699s) 13250.315430r/s
10000 requests of 2048 bytes in 1303181us (1.303181s) 7673.531250r/s
10000 requests of 4096 bytes in 2533219us (2.533219s) 3947.546631r/s
10000 requests of 8192 bytes in 4812353us (4.812353s) 2077.985596r/s
10000 requests of 16384 bytes in 9409004us (9.409004s) 1062.811768r/s
10000 requests of 32768 bytes in 18517712us (18.517712s) 540.023499r/s
10000 requests of 65536 bytes in 36765264us (36.765263s) 271.995880r/s
10000 requests of 131072 bytes in 74134720us (74.134720s) 134.889557r/s
5000 requests of 262144 bytes in 73354224us (73.354225s) 68.162399r/s
5000 requests of 524288 bytes in 146576640us (146.576645s) 34.111847r/s
1000 requests of 1048576 bytes in 59421648us (59.421646s) 16.828884r/s

- AES 192 with SS
1000000 requests of 16 bytes in 13977035us (13.977035s) 71545.929688r/s
100000 requests of 32 bytes in 1415502us (1.415502s) 70646.312500r/s
100000 requests of 64 bytes in 1520800us (1.520800s) 65754.867188r/s
100000 requests of 128 bytes in 1747678us (1.747678s) 57218.777344r/s
10000 requests of 256 bytes in 215039us (0.215039s) 46503.191406r/s
10000 requests of 512 bytes in 296430us (0.296430s) 33734.777344r/s
10000 requests of 1024 bytes in 461102us (0.461102s) 21687.175781r/s
10000 requests of 2048 bytes in 785948us (0.785948s) 12723.488281r/s
10000 requests of 4096 bytes in 1470694us (1.470694s) 6799.510742r/s
10000 requests of 8192 bytes in 2796490us (2.796490s) 3575.911133r/s
10000 requests of 16384 bytes in 5456299us (5.456299s) 1832.744141r/s
10000 requests of 32768 bytes in 11207501us (11.207501s) 892.259583r/s
10000 requests of 65536 bytes in 21422548us (21.422548s) 466.797882r/s
10000 requests of 131072 bytes in 42843424us (42.843426s) 233.408051r/s
5000 requests of 262144 bytes in 43383952us (43.383953s) 115.249992r/s
5000 requests of 524288 bytes in 86114304us (86.114304s) 58.062363r/s
1000 requests of 1048576 bytes in 34595356us (34.595356s) 28.905613r/s

- AES 256 without SS
1000000 requests of 16 bytes in 13021451us (13.021451s) 76796.359375r/s
100000 requests of 32 bytes in 1403426us (1.403426s) 71254.203125r/s
100000 requests of 64 bytes in 1613680us (1.613680s) 61970.152344r/s
100000 requests of 128 bytes in 2016162us (2.016162s) 49599.187500r/s
10000 requests of 256 bytes in 279614us (0.279614s) 35763.589844r/s
10000 requests of 512 bytes in 437451us (0.437451s) 22859.703125r/s
10000 requests of 1024 bytes in 749297us (0.749297s) 13345.842773r/s
10000 requests of 2048 bytes in 1382859us (1.382859s) 7231.395020r/s
10000 requests of 4096 bytes in 2718771us (2.718771s) 3678.132568r/s
10000 requests of 8192 bytes in 5290314us (5.290314s) 1890.246948r/s
10000 requests of 16384 bytes in 10419478us (10.419478s) 959.740967r/s
10000 requests of 32768 bytes in 20698064us (20.698065s) 483.136963r/s
10000 requests of 65536 bytes in 41186012us (41.186012s) 242.800888r/s
10000 requests of 131072 bytes in 82355632us (82.355629s) 121.424606r/s
5000 requests of 262144 bytes in 82577168us (82.577171s) 60.549423r/s
5000 requests of 524288 bytes in 164405808us (164.405807s) 30.412550r/s
1000 requests of 1048576 bytes in 66188452us (66.188454s) 15.108376r/s

- AES 256 with SS
1000000 requests of 16 bytes in 14093180us (14.093180s) 70956.304688r/s
100000 requests of 32 bytes in 1483984us (1.483984s) 67386.171875r/s
100000 requests of 64 bytes in 1588778us (1.588778s) 62941.453125r/s
100000 requests of 128 bytes in 1802914us (1.802914s) 55465.761719r/s
10000 requests of 256 bytes in 222742us (0.222742s) 44894.992188r/s
10000 requests of 512 bytes in 310578us (0.310578s) 32198.031250r/s
10000 requests of 1024 bytes in 480900us (0.480900s) 20794.343750r/s
10000 requests of 2048 bytes in 822032us (0.822032s) 12164.976562r/s
10000 requests of 4096 bytes in 1548041us (1.548041s) 6459.777344r/s
10000 requests of 8192 bytes in 2938495us (2.938495s) 3403.102539r/s
10000 requests of 16384 bytes in 5730902us (5.730902s) 1744.926025r/s
10000 requests of 32768 bytes in 11309177us (11.309177s) 884.237671r/s
10000 requests of 65536 bytes in 22495560us (22.495560s) 444.532166r/s
10000 requests of 131072 bytes in 45363720us (45.363720s) 220.440475r/s
5000 requests of 262144 bytes in 44884176us (44.884174s) 111.397835r/s
5000 requests of 524288 bytes in 89794592us (89.794594s) 55.682640r/s
1000 requests of 1048576 bytes in 35895056us (35.895058s) 27.858990r/s

Bests regards
