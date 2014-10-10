Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaJJSqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:46:10 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:28800 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaJJSqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:46:08 -0400
From: "Vinod, Chegu" <chegu_vinod@hp.com>
To: Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "mingo@kernel.org" <mingo@kernel.org>, "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
Subject: RE: [PATCH RFC 0/5] sched,numa: task placement with complex NUMA
 topologies
Thread-Topic: [PATCH RFC 0/5] sched,numa: task placement with complex NUMA
 topologies
Thread-Index: AQHP4y9g/RLhsa8FxkijFaC0vgBd+ZwnE/nAgACRbACAAf0nwA==
Date: Fri, 10 Oct 2014 18:44:12 +0000
Message-ID: <4168C988EBDF2141B4E0B6475B6A73D126F59AD0@G6W2504.americas.hpqcorp.net>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
 <4168C988EBDF2141B4E0B6475B6A73D126F58E4F@G6W2504.americas.hpqcorp.net>
 <54367446.3020603@redhat.com>
In-Reply-To: <54367446.3020603@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.201.12.24]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9AIkInI007391

>This patch set integrates two algorithms I have previously tested,
>one for glueless mesh NUMA topologies, where NUMA nodes communicate
>with far-away nodes through intermediary nodes, and backplane
>topologies, where communication with far-away NUMA nodes happens
>through backplane controllers (which cannot run tasks).
>
>Due to the inavailability of 8 node systems, and the fact that I
>am flying out to Linuxcon Europe / Plumbers / KVM Forum on Friday,
>I have not tested these patches yet. However, with a conference (and
>many familiar faces) coming up, it seemed like a good idea to get
>the code out there, anyway.
>
>The algorithms have been tested before, on both kinds of system.
>The new thing about this series is that both algorithms have been
>integrated into the same code base, and new code to select the
>preferred_nid for tasks in numa groups.
>
>Placement of tasks on smaller, directly connected, NUMA systems
>should not be affected at all by this patch series.
>
>I am interested in reviews, as well as test results on larger
>NUMA systems :)


Tested-by: Chegu Vinod <chegu_vinod@hp.com>

---

Hi Rik,

Applied your RFC patches along with the patch : https://lkml.org/lkml/2014/10/9/604   
on a 3.17.0 kernel on ran a quick test on two platforms with different NUMA topologies:

1) 8 socket Westmere-EX system  (HT-off)
2) 8 socket IvyBridge-EX prototype system  (HT-on)
       
On both these system  ran 4 instances of a 2-socket wide SpecJbb2005 workload and  
then ran 2 instances of a 4-socket wide SpecJbb2005 workload.  Repeated the 
experiment 10 times.

Having these patches enabled the desired NUMA nodes to selected for both sized 
workloads on both these systems...which is quite an encouraging sign !

Pl. see below a sampling of memory consumed by the java processes (as reported 
by numastat captured 120 seconds into each of the runs).

Thanks
Vinod

---


1) 8 socket Westmere-EX system with the following SLIT table :


node distances:
node   0   1   2   3   4   5   6   7
  0:  10  12  17  17  19  19  19  19
  1:  12  10  17  17  19  19  19  19
  2:  17  17  10  12  19  19  19  19
  3:  17  17  12  10  19  19  19  19
  4:  19  19  19  19  10  12  17  17
  5:  19  19  19  19  12  10  17  17
  6:  19  19  19  19  17  17  10  12
  7:  19  19  19  19  17  17  12  10

1a) 4 x  2 socket wide instances  (each instance has 20 warehouse threads)

Note: The correct NUMA nodes got picked 9 out of 10 runs..

PID           Node 0 Node 1 Node 2 Node 3 Node 4 Node 5 Node 6 Node 7 Total
15758 (java)       0     33   1904   1542      0      9      0     14  3503
15759 (java)       1     27      0     36   1694   1738      5      5  3506
15760 (java)    1884   1607      8      9      0     11      0      2  3521
15761 (java)       3     26      2     10      0      2   1553   1929  3525

16536 (java)       2      0      1     23      1     31   1934   1526  3517
16537 (java)    1831   1614      0      9      0     33      2     11  3501
16538 (java)       1      0      0      5   1940   1537      2     11  3497
16539 (java)       1      1   1596   1868      0     25     12      8  3511

17504 (java)       1      1      1      9   1769   1687      3     45  3516     <
17505 (java)       1      4      1      6      6      3   1522   1971  3514
17506 (java)    1413      1      9   2039      0      9      2     33  3506  <
17507 (java)     114   1887   1430      5      7     16      3     37  3500  <

17933 (java)       0      1      0     14   1707   1751      8     28  3510
17934 (java)       0      0   1745   1729      0      7      7     33  3522
17935 (java)    1700   1771      4     25     10      3      1     28  3542
17936 (java)      16     15      0      9      0      0   1702   1765  3507

18344 (java)       5      0      7      4   1567   1910      2     11  3507
18345 (java)       1      3   1557   1932     17     26      6      8  3550
18346 (java)       8      0      2     10      4     29   1317   2124  3497
18347 (java)    1591   1856      0      8      8     28      0     16  3508

18753 (java)    1737   1786      4      5      0      1      0     18  3552
18754 (java)       5     28      0      4   1617   1833      3     26  3515
18755 (java)      21     27      0      6      0      0   1518   1937  3509
18756 (java)       1     25   1690   1785      0      0      0      8  3509

19166 (java)      41      1   1829   1628      0      9      3     13  3523
19167 (java)    1737   1736      3      8      0      1     10     15  3511
19168 (java)      33      8      8     13      2      2   1546   1905  3517
19169 (java)      36      9      4      5   1634   1802      0     10  3500

19983 (java)    1617   1818      8     34     12      5      3      2  3501
19984 (java)       0      1      2     41      0      0   1724   1743  3513
19985 (java)       1      3   1901   1570      0      0      3      9  3487
19986 (java)       3     21      0     32   1634   1816      0      6  3514

20947 (java)       0      0      2     27   1652   1819      0      3  3506
20948 (java)       0      0      2      9      1     33   1848   1635  3528
20949 (java)       1      0   1873   1597      1     31      0      4  3508
20950 (java)    1624   1821     10      9      3     33      0      3  3503

21354 (java)       1     17     30      8    601   1400      1   1445  3503  <
21355 (java)       0      3   1542   1963      0     16      1      9  3536  
21356 (java)    1761   1672     27      8      8      8      1     10  3494   <
21357 (java)       0      0     25      3   1221      8   1843    410  3511

1b) 2 x 4 socket wide instances  (each instance has 40 warehouse threads)

Note: The correct NUMA nodes got picked 9 out of 10 runs.

PID           Node 0 Node 1 Node 2 Node 3 Node 4 Node 5 Node 6 Node 7 Total
21847 (java)       1      0      1     16    821   1154   1241   1330  4563
21848 (java)    1274   1497    917    807     14      3      1     25  4537

22120 (java)       1     26      1      5    860    948   1367   1348  4555
22121 (java)    1269   1392    929    896      1      1      5     13  4505

23298 (java)     847    829   1346   1470      0     30      7      3  4533
23299 (java)       3      4      0     15    876   1130   1184   1308  4521

23603 (java)    1277   1447    951    817      2      1      8     20  4521
23604 (java)       1     10      1     28    876    831   1343   1460  4551

23874 (java)       0      3      2     37    864    853   1309   1473  4542
23875 (java)    1452   1382    859    873      1      1      1     10  4579

24148 (java)       1      1      1     21   1132   1296   1084   1039  4574
24149 (java)     896    836   1223   1615      0     30      1      8  4611

24421 (java)    1447   1413    818    849      1      0      0     24  4551
24422 (java)       1     27      1      6    865    817   1420   1427  4563

25064 (java)     861    907   1344   1404      0     24      0      7  4547
25065 (java)       1      1      0     14   1197   1376    827   1168  4583

25881 (java)       1      3      0     19   1043   1204   1123   1167  4559
25882 (java)     884    874   1402   1323      0      0      1     37  4522

26150 (java)       1      1      6    781     11    886   1347   1514  4546         <
26151 (java)    1129   1322    811    459    760     11      9     29  4531     <


----
2) 8 socket IvyBridge-EX prototype system with the following SLIT table :

node distances:
node   0   1   2   3   4   5   6   7
  0:  10  16  30  30  30  30  30  30
  1:  16  10  30  30  30  30  30  30
  2:  30  30  10  16  30  30  30  30
  3:  30  30  16  10  30  30  30  30
  4:  30  30  30  30  10  16  30  30
  5:  30  30  30  30  16  10  30  30
  6:  30  30  30  30  30  30  10  16
  7:  30  30  30  30  30  30  16  10

2a) 4 x  2 socket wide instances  (each instance has 60 warehouse threads)

PID           Node 0 Node 1 Node 2 Node 3 Node 4 Node 5 Node 6 Node 7 Total
18680 (java)       2     18      1     20      1     12   3626   4820  8500
18681 (java)       1      8      5    174   4721   3579     12      3  8504
18682 (java)       4     18   5002   3461      9     13     13      3  8523
18683 (java)    5045   3428      3      7      1     18      6      3  8511

19745 (java)    5472   2984      4      7      8     22     10     20  8527
19746 (java)       8     30   3467   4976      3     22      7      5  8519
19747 (java)       2     18      4      9   4390   4068      1      2  8493
19748 (java)       5      7      2     11      4     16   4251   4186  8482

20796 (java)    4176   4301      4      6      9     13      5      6  8517
20797 (java)      13     47     27      1   3311   5127      5      3  8535
20798 (java)       6      5   2973   5498      3     19     29     11  8544
20799 (java)       9      7      9    130      2     14   3034   5315  8519

21852 (java)       6      1     14     14     24   2043   2346   4035  8484
21853 (java)    3551   4841     10     23      4     11     86      4  8532
21854 (java)       2      1   3194   5286      2      5     17     12  8519
21855 (java)      11      3      1     12   6943   1288    166     78  8502

22907 (java)       5      1   4165   4307      8     15     21      8  8531
22908 (java)       4     10      2      2   3066   5421      4      1  8511
22909 (java)       3      2      5      8      6     16   3544   4943  8527
22910 (java)    3340   5127      1     18      6     16      9      4  8520

23955 (java)       7      2     19      3   2436   6000      2     47  8515
23956 (java)      12      2   2785   5668     25      5      3     25  8525
23957 (java)    3651   4790     15      2     24      8      1     17  8508
23958 (java)       9      4      5      1     13      5   4794   3688  8519

25011 (java)    3532   4931      1      6      8      7      3     32  8520
25012 (java)       7     14      2      8   2763   5683      1     28  8506
25013 (java)      13     12      1     11     18      5   5373   3095  8528
25014 (java)      15      9   5455   3013      4      7      8     11  8522

26060 (java)       1      1      1      3     29     28   4651   3784  8498
26061 (java)       2      1   6245   2212     13     39      0      5  8519
26062 (java)      68   5294      1      3   1879   1262      1      3  8511
26063 (java)    7522    637      1     78    107    160      1      6  8512

27116 (java)       2     37      2      2      9      5   5110   3368  8535
27117 (java)    5376   3115     12      4     10      3      5      6  8532
27118 (java)       9     22   2850   5610      4     17      1     18  8531
27119 (java)      10     26      2      3   3472   4987      1      5  8505

28162 (java)    3332   5103      1      4      8      4      7     45  8504
28163 (java)      12      4      3     18   3079   5383      1     24  8524
28164 (java)      17      9   5533   2921      9      5      1     16  8510
28165 (java)       7      2      1     16     10      7   5166   3299  8508


2b) 2 x 4 socket wide instances  (each instance has 120 warehouse threads)

PID           Node 0 Node 1 Node 2 Node 3 Node 4 Node 5 Node 6 Node 7 Total
29228 (java)       2      8   2394   3868     15     82   1130   1085  8585
29229 (java)    2824   3773     19      6    963    923     24     59  8589

29964 (java)    1084   1080     28     31   2841   3497      8      2  8569
29965 (java)      16     18   1186   1077      3      6   2841   3436  8583

30683 (java)      19   4281   1830   2137     73     94     13     26  8472
30684 (java)    3763     31     10     10     75     56   2174   2394  8514

31399 (java)       6     25   2608   3116     10     18   1424   1388  8595
31400 (java)    1518   1532      2     12   2259   3188     20     32  8562

32113 (java)     692    620     28     18   3141   4033     25     20  8577
32114 (java)       8      8   2231   2390      3     15   1955   1974  8583

32827 (java)    2324   2663     79   3423     24     20      8     13  8554
32828 (java)      15      3   2448     26    515    855   2214   2489  8566

33543 (java)    1090   1129      3     23     22     25   2923   3366  8581
33544 (java)      12     10   2686   3375   1745    726      4     22  8580

34258 (java)    2127   1928   1924   2558      7     18      8      4  8574
34259 (java)       5     23      8     11   1182   1266   2731   3347  8572

34978 (java)      16     14   1617   1964     14     23   2258   2677  8583
34979 (java)    1721   1704     62     19   2339   2726      6     10  8588

35692 (java)    3599   2721     50     58      6      9    700   1421  8564
35693 (java)      18     49     74     83   3162   4822    309     46  8563



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
