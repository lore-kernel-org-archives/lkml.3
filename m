Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3HUVF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:05:57 -0400
Received: from mout.gmx.net ([212.227.15.18]:54844 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab3HUVF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:05:56 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Wed, 21 Aug 2013 23:05:51 +0200
From: "Tibor Billes" <tbilles@gmx.com>
Message-ID: <20130821210551.168660@gmx.com>
MIME-Version: 1.0
Subject: Re: Unusually high system CPU usage with recent kernels
To: paulmck@linux.vnet.ibm.com
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
Content-Transfer-Encoding: 8bit
X-GMX-UID: +E5ncoYgeSEqJL5QQHchcYV+IGRvb8AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Paul E. McKenney Sent: 08/21/13 09:12 PM
> On Wed, Aug 21, 2013 at 08:14:46PM +0200, Tibor Billes wrote:
> > > From: Paul E. McKenney Sent: 08/20/13 11:43 PM
> > > On Tue, Aug 20, 2013 at 10:52:26PM +0200, Tibor Billes wrote:
> > > > > From: Paul E. McKenney Sent: 08/20/13 04:53 PM
> > > > > On Tue, Aug 20, 2013 at 08:01:28AM +0200, Tibor Billes wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I was using the 3.9.7 stable release and tried to upgrade to the 3.10.x series.
> > > > > > The 3.10.x series was showing unusually high (>75%) system CPU usage in some
> > > > > > situations, making things really slow. The latest stable I tried is 3.10.7.
> > > > > > I also tried 3.11-rc5, they both show this behaviour. This behaviour doesn't
> > > > > > show up when the system is idling, only when doing some CPU intensive work,
> > > > > > like compiling with multiple threads. Compiling with only one thread seems not
> > > > > > to trigger this behaviour.
> > > > > > 
> > > > > > To be more precise I did a `perf record -a` while compiling a large C++ program
> > > > > > with scons using 4 threads, the result is appended at the end of this email.
> > > > > 
> > > > > New one on me! You are running a mainstream system (x86_64), so I am
> > > > > surprised no one else noticed.
> > > > > 
> > > > > Could you please send along your .config file?
> > > > 
> > > > Here it is
> > > 
> > > Interesting. I don't see RCU stuff all that high on the list, but
> > > the items I do see lead me to suspect RCU_FAST_NO_HZ, which has some
> > > relevance to the otherwise inexplicable group of commits you located
> > > with your bisection. Could you please rerun with CONFIG_RCU_FAST_NO_HZ=n?
> > > 
> > > If that helps, there are some things I could try.
> > 
> > It did help. I didn't notice anything unusual when running with CONFIG_RCU_FAST_NO_HZ=n.
> 
> Interesting. Thank you for trying this -- and we at least have a
> short-term workaround for this problem. I will put a patch together
> for further investigation.

I don't specifically need this config option so I'm fine without it in
the long term, but I guess it's not supposed to behave like that.
 
> In the meantime, could you please tell me how you were measuring
> performance for your kernel builds? Wall-clock time required to complete
> one build? Number of builds completed per unit time? Something else?

Actually, I wasn't all this sophisticated. I have a system monitor
applet on my top panel (using MATE, Linux Mint), four little graphs,
one of which shows CPU usage. Different colors indicate different kind
of CPU usage. Blue shows user space usage, red shows system usage, and
two more for nice and iowait. During a normal compile it's almost
completely filled with blue user space CPU usage, only the top few
pixels show some iowait and system usage. With CONFIG_RCU_FAST_NO_HZ
set, about 3/4 of the graph was red system CPU usage, the rest was
blue. So I just looked for a pile of red on my graphs when I tested
different kernel builds. But also compile speed was horrible I couldn't
wait for the build to finish. Even the UI got unresponsive.

Now I did some measuring. In the normal case a compile finished in 36
seconds, compiled 315 object files. Here are some output lines from
dstat -tasm --vm during compile:
----system---- ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system-- ----swap--- ------memory-usage----- -----virtual-memory----
     time     |usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw | used  free| used  buff  cach  free|majpf minpf alloc  free
21-08 21:48:05| 91   8   2   0   0   0|   0  5852k|   0     0 |   0     0 |1413  1772 |   0  7934M| 581M 58.0M  602M 6553M|   0    71k   46k   54k
21-08 21:48:06| 93   6   1   0   0   0|   0  2064k| 137B  131B|   0     0 |1356  1650 |   0  7934M| 649M 58.0M  604M 6483M|   0    72k   47k   28k
21-08 21:48:07| 86  11   4   0   0   0|   0  5872k|   0     0 |   0     0 |2000  2991 |   0  7934M| 577M 58.0M  627M 6531M|   0    99k   67k   79k
21-08 21:48:08| 87   9   3   0   0   0|   0  2840k|   0     0 |   0     0 |2558  4164 |   0  7934M| 597M 58.0M  632M 6507M|   0    96k   57k   51k
21-08 21:48:09| 93   7   1   0   0   0|   0  3032k|   0     0 |   0     0 |1329  1512 |   0  7934M| 641M 58.0M  626M 6469M|   0    61k   48k   39k
21-08 21:48:10| 93   6   0   0   0   0|   0  4984k|   0     0 |   0     0 |1160  1146 |   0  7934M| 572M 58.0M  628M 6536M|   0    50k   40k   57k
21-08 21:48:11| 86   9   6   0   0   0|   0  2520k|   0     0 |   0     0 |2947  4760 |   0  7934M| 605M 58.0M  631M 6500M|   0   103k   55k   45k
21-08 21:48:12| 90   8   2   0   0   0|   0  2840k|   0     0 |   0     0 |2674  4179 |   0  7934M| 671M 58.0M  635M 6431M|   0    84k   59k   42k
21-08 21:48:13| 90   9   1   0   0   0|   0  4656k|   0     0 |   0     0 |1223  1410 |   0  7934M| 643M 58.0M  638M 6455M|   0    90k   62k   68k
21-08 21:48:14| 91   8   1   0   0   0|   0  3572k|   0     0 |   0     0 |1432  1828 |   0  7934M| 647M 58.0M  641M 6447M|   0    81k   59k   57k
21-08 21:48:15| 91   8   1   0   0   0|   0  5116k| 116B    0 |   0     0 |1194  1295 |   0  7934M| 605M 58.0M  644M 6487M|   0    69k   54k   64k
21-08 21:48:16| 87  10   3   0   0   0|   0  5140k|   0     0 |   0     0 |1761  2586 |   0  7934M| 584M 58.0M  650M 6502M|   0   105k   64k   68k

The abnormal case compiled only 182 object file in 6 and a half minutes,
then I stopped it. The same dstat output for this case:
----system---- ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system-- ----swap--- ------memory-usage----- -----virtual-memory----
     time     |usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw | used  free| used  buff  cach  free|majpf minpf alloc  free
21-08 22:10:49| 27  62   0   0  11   0|   0     0 | 210B    0 |   0     0 |1414  3137k|   0  7934M| 531M 57.6M  595M 6611M|   0  1628  1250   322 
21-08 22:10:50| 25  60   4   0  11   0|   0    88k| 126B    0 |   0     0 |1337  3110k|   0  7934M| 531M 57.6M  595M 6611M|   0    91   128   115 
21-08 22:10:51| 26  63   0   0  11   0|   0   184k| 294B    0 |   0     0 |1411  3147k|   0  7934M| 531M 57.6M  595M 6611M|   0  1485   814   815 
21-08 22:10:52| 26  63   0   0  11   0|   0     0 | 437B  239B|   0     0 |1355  3160k|   0  7934M| 531M 57.6M  595M 6611M|   0    24    94    97 
21-08 22:10:53| 26  63   0   0  11   0|   0     0 | 168B    0 |   0     0 |1397  3155k|   0  7934M| 531M 57.6M  595M 6611M|   0   479   285   273 
21-08 22:10:54| 26  63   0   0  11   0|   0  4096B| 396B  324B|   0     0 |1346  3154k|   0  7934M| 531M 57.6M  595M 6611M|   0    27   145   145 
21-08 22:10:55| 26  63   0   0  11   0|   0    60k|   0     0 |   0     0 |1353  3148k|   0  7934M| 531M 57.6M  595M 6610M|   0    93   117    36 
21-08 22:10:56| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1341  3172k|   0  7934M| 531M 57.6M  595M 6610M|   0   158    87    74 
21-08 22:10:57| 26  62   1   0  11   0|   0     0 |  42B   60B|   0     0 |1332  3162k|   0  7934M| 531M 57.6M  595M 6610M|   0    56    82    78 
21-08 22:10:58| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1334  3178k|   0  7934M| 531M 57.6M  595M 6610M|   0    26    56    56 
21-08 22:10:59| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1336  3179k|   0  7934M| 531M 57.6M  595M 6610M|   0     3    33    32 
21-08 22:11:00| 26  63   0   0  11   0|   0    24k|  90B  108B|   0     0 |1347  3172k|   0  7934M| 531M 57.6M  595M 6610M|   0    41    73    71

I have four logical cores so 25% makes up 1 core. I don't know if the ~26% user CPU usage has anthing to do with this fact or just coincidence. The rest is ~63% system and ~11% hardware interrupt. Do these support what you suspect?

Tibor
