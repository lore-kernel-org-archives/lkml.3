Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaFMSWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:22:33 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40660 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaFMSWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAJE_dJzjcWP=e_CPM1M64URVHiEFFb+fP6g2YKZVdoFntkQMZg@mail.gmail.com>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
	<874mzr41kf.fsf@x220.int.ebiederm.org>
	<20140611225228.GO4581@linux.vnet.ibm.com>
	<87ioo7vy5s.fsf@x220.int.ebiederm.org>
	<20140611234902.GQ4581@linux.vnet.ibm.com>
	<87bntzt24g.fsf@x220.int.ebiederm.org>
	<CAJE_dJzzj2uf+YEXhAngJDKev=Lc4O6fyKfHoO2PbzD90VuuVw@mail.gmail.com>
	<874mzrszlk.fsf@x220.int.ebiederm.org>
	<CAJE_dJzShXxjsywRo_kwa0ez6Seu7+dModbz2Lvha5iuJw7FTw@mail.gmail.com>
	<CAJE_dJzjcWP=e_CPM1M64URVHiEFFb+fP6g2YKZVdoFntkQMZg@mail.gmail.com>
Date: Fri, 13 Jun 2014 15:22:30 -0300
Message-ID: <CAJE_dJzh06yTp9Ukd3c7u1ornj44krvvKNU_9wkX_9pjzKxmJA@mail.gmail.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
From: Rafael Tinoco <rafael.tinoco@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chiluk <chiluk@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay,

Tests with the same script were done.
I'm comparing : master + patch vs 3.15.0-rc5 (last sync'ed rcu commit)
and 3.9 last bisect good.

Same tests were made. I'm comparing the following versions:

1) master + suggested patch
2) 3.15.0-rc5 (last rcu commit in my clone)
3) 3.9-rc2 (last bisect good)

         master + sug patch          3.15.0-rc5 (last rcu)
3.9-rc2 (bisec good)
mark      no      none    all         no       none     all        no

# (netns add) / sec

 250      125.00  250.00  250.00      20.83    22.73    50.00      83.33
 500      250.00  250.00  250.00      22.73    22.73    50.00      125.00
 750      250.00  125.00  125.00      20.83    22.73    62.50      125.00
1000      125.00  250.00  125.00      20.83    20.83    50.00      250.00
1250      125.00  125.00  250.00      22.73    22.73    50.00      125.00
1500      125.00  125.00  125.00      22.73    22.73    41.67      125.00
1750      125.00  125.00  83.33       22.73    22.73    50.00      83.33
2000      125.00  83.33   125.00      22.73    25.00    50.00      125.00

-> From 3.15 to patched tree, netns add performance was ***
restored/improved *** OK

# (netns add + 1 x exec) / sec

 250      11.90   14.71   31.25       5.00     6.76     15.63      62.50
 500      11.90   13.89   31.25       5.10     7.14     15.63      41.67
 750      11.90   13.89   27.78       5.10     7.14     15.63      50.00
1000      11.90   13.16   25.00       4.90     6.41     15.63      35.71
1250      11.90   13.89   25.00       4.90     6.58     15.63      27.78
1500      11.36   13.16   25.00       4.72     6.25     15.63      25.00
1750      11.90   12.50   22.73       4.63     5.56     14.71      20.83
2000      11.36   12.50   22.73       4.55     5.43     13.89      17.86

-> From 3.15 to patched tree, performance improves +100% but still
-50% of 3.9-rc2

# (netns add + 2 x exec) / sec

250       6.58    8.62    16.67       2.81     3.97     9.26       41.67
500       6.58    8.33    15.63       2.78     4.10     9.62       31.25
750       5.95    7.81    15.63       2.69     3.85     8.93       25.00
1000      5.95    7.35    13.89       2.60     3.73     8.93       20.83
1250      5.81    7.35    13.89       2.55     3.52     8.62       16.67
1500      5.81    7.35    13.16       0.00     3.47     8.62       13.89
1750      5.43    6.76    13.16       0.00     3.47     8.62       11.36
2000      5.32    6.58    12.50       0.00     3.38     8.33        9.26

-> Same as before.

# netns add + 2 x exec + 1 x ip link to netns

250       7.14    8.33    14.71       2.87     3.97     8.62       35.71
500       6.94    8.33    13.89       2.91     3.91     8.93       25.00
750       6.10    7.58    13.89       2.75     3.79     8.06       19.23
1000      5.56    6.94    12.50       2.69     3.85     8.06       14.71
1250      5.68    6.58    11.90       2.58     3.57     7.81       11.36
1500      5.56    6.58    10.87       0.00     3.73     7.58       10.00
1750      5.43    6.41    10.42       0.00     3.57     7.14       8.62
2000      5.21    6.25    10.00       0.00     3.33     7.14       6.94

-> Ip link add to netns did not change performance proportion much.

# netns add + 2 x exec + 2 x ip link to netns

250       7.35    8.62    13.89       2.94     4.03     8.33       31.25
500       7.14    8.06    12.50       2.94     4.03     8.06       20.83
750       6.41    7.58    11.90       2.81     3.85     7.81       15.63
1000      5.95    7.14    10.87       2.69     3.79     7.35       12.50
1250      5.81    6.76    10.00       2.66     3.62     7.14       10.00
1500      5.68    6.41    9.62        3.73     6.76     8.06
1750      5.32    6.25    8.93        3.68     6.58     7.35
2000      5.43    6.10    8.33        3.42     6.10     6.41

-> Same as before.

OBS:

1) It seems that performance got improved for network namespace
addiction but maybe there can be some improvement also on netns
execution. This way we might achieve same performance as 3.9.0-rc2
(good bisect) had.

2) These tests were made with 4 cpu only.

3) Initial charts showed that 1 cpu case with all cpus as no-cb
(without this patch) had something like 50% of bisect good. The 4 cpu
(nocball) case had 26% of bisect good (like showed above in the last
case -> 31.25 -- 8.33).

4) With the patch, using 4 cpus and nocball, we now have 44% of bisect
good performance (against 26% we had).

5) NOCB_* is still an issue. It is clear that only NOCB_CPU_ALL option
is giving us something near last good commit performance.

Thank you

Rafael
