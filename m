Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3KEPnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:43:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab3KEPnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:43:09 -0500
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes
 visible slowdown in ftrace switching
From: Petr Mladek <pmladek@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20131104170232.GS3947@linux.vnet.ibm.com>
References: <1383326384.6788.49.camel@pathway.suse.cz>
	 <20131104170232.GS3947@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary="=-eAOWjX+zvGUMLdFv39N4"
Date: Tue, 05 Nov 2013 16:43:06 +0100
Message-ID: <1383666186.27527.57.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eAOWjX+zvGUMLdFv39N4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hello Paul,

Paul E. McKenney píše v Po 04. 11. 2013 v 09:02 -0800:
> On Fri, Nov 01, 2013 at 06:19:44PM +0100, Petr Mladek wrote:
> > Hi,
> > 
> > I am doing some clean up in x86 ftrace code. I check the performance by
> > switching between different tracers and by enabling and disabling them.
> > 
> > The operation has started to be much slower after rebasing on the
> > kernel tip tree. Bisecting has shown that the difference was caused by
> > the commit c229828ca6bc62d6c654 (rcu: Throttle
> > rcu_try_advance_all_cbs() execution)

> This is a slowpath, and that commit did fix a real bug, so I am OK with
> this modest slowdown.
> 
> That said, if you have a workload where this is a problem, please try
> building with CONFIG_RCU_FAST_NO_HZ=n.  The fact that this commit had any
> effect at all leads me to believe that you used CONFIG_RCU_FAST_NO_HZ=y.

Yes, I used CONFIG_RCU_FAST_NO_HZ=y.

I am not aware of any other workload with this problem. I tried few
benchmarks: dbench, unixbench, and aim. They did not show any
considerable difference with and without the commit. If you are
interested you might find more details in the attached logs.

Just for record, I also checked how the ftrace test was affected by the
commit under various system load. The speed difference was there if at
least one CPU was idle. But the test was slower on idle system even
without the patch. Hence this is not the only change that causes some
difference. See the attached "ftrace" file for more details.

I am still a bit curious why ftrace code is so special here and why it
does not affect the other benchmarks. Anyway, I agree that ftrace
change/start/stop operations are not time critical and the extra delay
might be worth fixing the other bug. I am fine with it :-)


Best Regards,
Petr

--=-eAOWjX+zvGUMLdFv39N4
Content-Type: application/x-gmc-link; name="aim9"
Content-Disposition: attachment; filename="aim9"
Content-Transfer-Encoding: 7bit

test: AIM9 (s9110.tar.Z)
URL: http://sourceforge.net/projects/aimbench/files/aim-suite9/Initial%20release/
CPU: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
RAM: 4GB

Started using the command:

	./singleuser -nl

======

Results with c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs() execution)

AIM Independent Resource Benchmark - Suite IX v1.1, January 22, 1996
Copyright (c) 1996 - 2001 Caldera International, Inc.
All Rights Reserved

Starting time:      Tue Nov  5 09:35:14 2013
Projected Run Time: 0:20:00
Projected finish:   Tue Nov  5 09:55:14 2013

------------------------------------------------------------------------------------------------------------
 Test        Test        Elapsed  Iteration    Iteration          Operation
Number       Name      Time (sec)   Count   Rate (loops/sec)    Rate (ops/sec)
------------------------------------------------------------------------------------------------------------
     1 creat-clo           30.01       4930  164.27857       164278.57 File Creations and Closes/second
     2 page_test           30.00       5275  175.83333       298916.67 System Allocations & Pages/second
     3 brk_test            30.00       5779  192.63333      3274766.67 System Memory Allocations/second
     4 jmp_test            30.00    1923554 64118.46667     64118466.67 Non-local gotos/second
     5 signal_test         30.00      16044  534.80000       534800.00 Signal Traps/second
     6 exec_test           30.00       2705   90.16667          450.83 Program Loads/second
     7 fork_test           30.01       1430   47.65078         4765.08 Task Creations/second
     8 link_test           30.01      30062 1001.73276        63109.16 Link/Unlink Pairs/second
     9 disk_rr             30.06       1184   39.38789       201666.00 Random Disk Reads (K)/second
    10 disk_rw             30.02        976   32.51166       166459.69 Random Disk Writes (K)/second
    11 disk_rd             30.01      11583  385.97134      1976173.28 Sequential Disk Reads (K)/second
    12 disk_wrt            30.05       1379   45.89018       234957.74 Sequential Disk Writes (K)/second
    13 disk_cp             30.00       1139   37.96667       194389.33 Disk Copies (K)/second
    14 sync_disk_rw        59.49          2    0.03362           86.06 Sync Random Disk Writes (K)/second
    15 sync_disk_wrt       55.49          1    0.01802           46.13 Sync Sequential Disk Writes (K)/second
    16 sync_disk_cp        54.86          1    0.01823           46.66 Sync Disk Copies (K)/second
    17 disk_src            30.00      26445  881.50000        66112.50 Directory Searches/second
    18 fun_cal             30.00      32774 1092.46667    559342933.33 Function Calls (no arguments)/second
    19 fun_cal1            30.00      28517  950.56667    486690133.33 Function Calls (1 argument)/second
    20 fun_cal2            30.00      29735  991.16667    507477333.33 Function Calls (2 arguments)/second
    21 fun_cal15           30.00      11850  395.00000    202240000.00 Function Calls (15 arguments)/second
    22 matrix_rtns         30.00    2530767 84358.90000      8435890.00 Point Transformations/second
    23 array_rtns          30.00       3987  132.90000         2658.00 Linear Systems Solved/second
    24 string_rtns         30.01       4647  154.84838        15484.84 String Manipulations/second
    25 mem_rtns_1          30.00       3638  121.26667      3638000.00 Dynamic Memory Operations/second
    26 mem_rtns_2          30.00     509966 16998.86667      1699886.67 Block Memory Operations/second
    27 sort_rtns_1         30.01       8790  292.90237         2929.02 Sort Operations/second
    28 misc_rtns_1         30.00      47381 1579.36667        15793.67 Auxiliary Loops/second
    29 dir_rtns_1          30.00       5849  194.96667      1949666.67 Directory Operations/second
    30 shell_rtns_1        30.00       4238  141.26667          141.27 Shell Scripts/second
    31 shell_rtns_2        30.01       4240  141.28624          141.29 Shell Scripts/second
    32 shell_rtns_3        30.01       4257  141.85272          141.85 Shell Scripts/second
    33 shared_memory       30.00     204980 6832.66667       683266.67 Shared Memory Operations/second
    34 tcp_test            30.00      31223 1040.76667        93669.00 TCP/IP Messages/second
    35 udp_test            30.00      63222 2107.40000       210740.00 UDP/IP DataGrams/second
    36 fifo_test           30.00     236949 7898.30000       789830.00 FIFO Messages/second
    37 stream_pipe         30.00     184292 6143.06667       614306.67 Stream Pipe Messages/second
    38 dgram_pipe          30.00     172186 5739.53333       573953.33 DataGram Pipe Messages/second
    39 pipe_cpy            30.00     307022 10234.06667      1023406.67 Pipe Messages/second
    40 ram_copy            30.00    5052081 168402.70000   4213435554.00 Memory to Memory Copy/second
------------------------------------------------------------------------------------------------------------
Projected Completion time:  Tue Nov  5 09:55:14 2013
Actual Completion time:     Tue Nov  5 09:56:34 2013
Difference:                 0:01:20

AIM Independent Resource Benchmark - Suite IX
   Testing over

-------

AIM Independent Resource Benchmark - Suite IX v1.1, January 22, 1996
Copyright (c) 1996 - 2001 Caldera International, Inc.
All Rights Reserved

Starting time:      Tue Nov  5 09:57:25 2013
Projected Run Time: 0:20:00
Projected finish:   Tue Nov  5 10:17:25 2013

------------------------------------------------------------------------------------------------------------
 Test        Test        Elapsed  Iteration    Iteration          Operation
Number       Name      Time (sec)   Count   Rate (loops/sec)    Rate (ops/sec)
------------------------------------------------------------------------------------------------------------
     1 creat-clo           30.00       4898  163.26667       163266.67 File Creations and Closes/second
     2 page_test           30.00       5166  172.20000       292740.00 System Allocations & Pages/second
     3 brk_test            30.01       5916  197.13429      3351282.91 System Memory Allocations/second
     4 jmp_test            30.00    2521133 84037.76667     84037766.67 Non-local gotos/second
     5 signal_test         30.00      16063  535.43333       535433.33 Signal Traps/second
     6 exec_test           30.01       2700   89.97001          449.85 Program Loads/second
     7 fork_test           30.00       1419   47.30000         4730.00 Task Creations/second
     8 link_test           30.00      29812  993.73333        62605.20 Link/Unlink Pairs/second
     9 disk_rr             30.02       1191   39.67355       203128.58 Random Disk Reads (K)/second
    10 disk_rw             30.00        987   32.90000       168448.00 Random Disk Writes (K)/second
    11 disk_rd             30.00      11644  388.13333      1987242.67 Sequential Disk Reads (K)/second
    12 disk_wrt            30.02       1393   46.40240       237580.28 Sequential Disk Writes (K)/second
    13 disk_cp             30.06       1154   38.38989       196556.22 Disk Copies (K)/second
    14 sync_disk_rw        63.42          2    0.03154           80.73 Sync Random Disk Writes (K)/second
    15 sync_disk_wrt       54.85          1    0.01823           46.67 Sync Sequential Disk Writes (K)/second
    16 sync_disk_cp        54.69          1    0.01828           46.81 Sync Disk Copies (K)/second
    17 disk_src            30.00      26490  883.00000        66225.00 Directory Searches/second
    18 fun_cal             30.00      32736 1091.20000    558694400.00 Function Calls (no arguments)/second
    19 fun_cal1            30.00      28522  950.73333    486775466.67 Function Calls (1 argument)/second
    20 fun_cal2            30.00      29965  998.83333    511402666.67 Function Calls (2 arguments)/second
    21 fun_cal15           30.00      11876  395.86667    202683733.33 Function Calls (15 arguments)/second
    22 matrix_rtns         30.00    2531006 84366.86667      8436686.67 Point Transformations/second
    23 array_rtns          30.00       3987  132.90000         2658.00 Linear Systems Solved/second
    24 string_rtns         30.00       4645  154.83333        15483.33 String Manipulations/second
    25 mem_rtns_1          30.00       3656  121.86667      3656000.00 Dynamic Memory Operations/second
    26 mem_rtns_2          30.00     502217 16740.56667      1674056.67 Block Memory Operations/second
    27 sort_rtns_1         30.00       8747  291.56667         2915.67 Sort Operations/second
    28 misc_rtns_1         30.00      47126 1570.86667        15708.67 Auxiliary Loops/second
    29 dir_rtns_1          30.00       5834  194.46667      1944666.67 Directory Operations/second
    30 shell_rtns_1        30.01       4247  141.51949          141.52 Shell Scripts/second
    31 shell_rtns_2        30.00       4259  141.96667          141.97 Shell Scripts/second
    32 shell_rtns_3        30.01       4257  141.85272          141.85 Shell Scripts/second
    33 shared_memory       30.00     204139 6804.63333       680463.33 Shared Memory Operations/second
    34 tcp_test            30.00      31360 1045.33333        94080.00 TCP/IP Messages/second
    35 udp_test            30.00      64464 2148.80000       214880.00 UDP/IP DataGrams/second
    36 fifo_test           30.00     242772 8092.40000       809240.00 FIFO Messages/second
    37 stream_pipe         30.00     185787 6192.90000       619290.00 Stream Pipe Messages/second
    38 dgram_pipe          30.00     173151 5771.70000       577170.00 DataGram Pipe Messages/second
    39 pipe_cpy            30.00     315392 10513.06667      1051306.67 Pipe Messages/second
    40 ram_copy            30.00    5048760 168292.00000   4210665840.00 Memory to Memory Copy/second
------------------------------------------------------------------------------------------------------------
Projected Completion time:  Tue Nov  5 10:17:25 2013
Actual Completion time:     Tue Nov  5 10:18:48 2013
Difference:                 0:01:23

AIM Independent Resource Benchmark - Suite IX
   Testing over

-------

AIM Independent Resource Benchmark - Suite IX v1.1, January 22, 1996
Copyright (c) 1996 - 2001 Caldera International, Inc.
All Rights Reserved

Starting time:      Tue Nov  5 10:37:10 2013
Projected Run Time: 0:20:00
Projected finish:   Tue Nov  5 10:57:10 2013

------------------------------------------------------------------------------------------------------------
 Test        Test        Elapsed  Iteration    Iteration          Operation
Number       Name      Time (sec)   Count   Rate (loops/sec)    Rate (ops/sec)
------------------------------------------------------------------------------------------------------------
     1 creat-clo           30.00       4923  164.10000       164100.00 File Creations and Closes/second
     2 page_test           30.01       5135  171.10963       290886.37 System Allocations & Pages/second
     3 brk_test            30.00       6063  202.10000      3435700.00 System Memory Allocations/second
     4 jmp_test            30.00    2521225 84040.83333     84040833.33 Non-local gotos/second
     5 signal_test         30.00      15861  528.70000       528700.00 Signal Traps/second
     6 exec_test           30.01       2701   90.00333          450.02 Program Loads/second
     7 fork_test           30.01       1451   48.35055         4835.05 Task Creations/second
     8 link_test           30.00      29718  990.60000        62407.80 Link/Unlink Pairs/second
     9 disk_rr             30.01       1193   39.75342       203537.49 Random Disk Reads (K)/second
    10 disk_rw             30.03        982   32.70063       167427.24 Random Disk Writes (K)/second
    11 disk_rd             30.00      11465  382.16667      1956693.33 Sequential Disk Reads (K)/second
    12 disk_wrt            30.02       1386   46.16922       236386.41 Sequential Disk Writes (K)/second
    13 disk_cp             30.05       1150   38.26955       195940.10 Disk Copies (K)/second
    14 sync_disk_rw        53.89          2    0.03711           95.01 Sync Random Disk Writes (K)/second
    15 sync_disk_wrt       54.71          1    0.01828           46.79 Sync Sequential Disk Writes (K)/second
    16 sync_disk_cp        54.55          1    0.01833           46.93 Sync Disk Copies (K)/second
    17 disk_src            30.00      26521  884.03333        66302.50 Directory Searches/second
    18 fun_cal             30.00      32642 1088.06667    557090133.33 Function Calls (no arguments)/second
    19 fun_cal1            30.00      28519  950.63333    486724266.67 Function Calls (1 argument)/second
    20 fun_cal2            30.00      29832  994.40000    509132800.00 Function Calls (2 arguments)/second
    21 fun_cal15           30.01      11855  395.03499    202257914.03 Function Calls (15 arguments)/second
    22 matrix_rtns         30.00    2530591 84353.03333      8435303.33 Point Transformations/second
    23 array_rtns          30.00       3988  132.93333         2658.67 Linear Systems Solved/second
    24 string_rtns         30.01       4648  154.88171        15488.17 String Manipulations/second
    25 mem_rtns_1          30.00       3690  123.00000      3690000.00 Dynamic Memory Operations/second
    26 mem_rtns_2          30.00     420999 14033.30000      1403330.00 Block Memory Operations/second
    27 sort_rtns_1         30.00       8745  291.50000         2915.00 Sort Operations/second
    28 misc_rtns_1         30.00      47060 1568.66667        15686.67 Auxiliary Loops/second
    29 dir_rtns_1          30.00       5827  194.23333      1942333.33 Directory Operations/second
    30 shell_rtns_1        30.00       4169  138.96667          138.97 Shell Scripts/second
    31 shell_rtns_2        30.01       4166  138.82039          138.82 Shell Scripts/second
    32 shell_rtns_3        30.01       4167  138.85372          138.85 Shell Scripts/second
    33 shared_memory       30.00     205382 6846.06667       684606.67 Shared Memory Operations/second
    34 tcp_test            30.00      31378 1045.93333        94134.00 TCP/IP Messages/second
    35 udp_test            30.00      64574 2152.46667       215246.67 UDP/IP DataGrams/second
    36 fifo_test           30.00     243153 8105.10000       810510.00 FIFO Messages/second
    37 stream_pipe         30.00     186010 6200.33333       620033.33 Stream Pipe Messages/second
    38 dgram_pipe          30.00     173437 5781.23333       578123.33 DataGram Pipe Messages/second
    39 pipe_cpy            30.00     315935 10531.16667      1053116.67 Pipe Messages/second
    40 ram_copy            30.00    5052866 168428.86667   4214090244.00 Memory to Memory Copy/second
------------------------------------------------------------------------------------------------------------
Projected Completion time:  Tue Nov  5 10:57:10 2013
Actual Completion time:     Tue Nov  5 10:58:24 2013
Difference:                 0:01:14

AIM Independent Resource Benchmark - Suite IX
   Testing over


=======


Results with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
execution):

AIM Independent Resource Benchmark - Suite IX v1.1, January 22, 1996
Copyright (c) 1996 - 2001 Caldera International, Inc.
All Rights Reserved

Starting time:      Tue Nov  5 11:08:47 2013
Projected Run Time: 0:20:00
Projected finish:   Tue Nov  5 11:28:47 2013

------------------------------------------------------------------------------------------------------------
 Test        Test        Elapsed  Iteration    Iteration          Operation
Number       Name      Time (sec)   Count   Rate (loops/sec)    Rate (ops/sec)
------------------------------------------------------------------------------------------------------------
     1 creat-clo           30.00       4871  162.36667       162366.67 File Creations and Closes/second
     2 page_test           30.00       5260  175.33333       298066.67 System Allocations & Pages/second
     3 brk_test            30.00       5928  197.60000      3359200.00 System Memory Allocations/second
     4 jmp_test            30.00    2520798 84026.60000     84026600.00 Non-local gotos/second
     5 signal_test         30.00      15939  531.30000       531300.00 Signal Traps/second
     6 exec_test           30.01       2717   90.53649          452.68 Program Loads/second
     7 fork_test           30.01       1395   46.48451         4648.45 Task Creations/second
     8 link_test           30.00      29472  982.40000        61891.20 Link/Unlink Pairs/second
     9 disk_rr             30.00       1176   39.20000       200704.00 Random Disk Reads (K)/second
    10 disk_rw             30.03        983   32.73393       167597.74 Random Disk Writes (K)/second
    11 disk_rd             30.00      12319  410.63333      2102442.67 Sequential Disk Reads (K)/second
    12 disk_wrt            30.08       1361   45.24601       231659.57 Sequential Disk Writes (K)/second
    13 disk_cp             30.00       1153   38.43333       196778.67 Disk Copies (K)/second
    14 sync_disk_rw        64.92          2    0.03081           78.87 Sync Random Disk Writes (K)/second
    15 sync_disk_wrt       55.00          1    0.01818           46.55 Sync Sequential Disk Writes (K)/second
    16 sync_disk_cp        54.87          1    0.01822           46.66 Sync Disk Copies (K)/second
    17 disk_src            30.00      26496  883.20000        66240.00 Directory Searches/second
    18 fun_cal             30.00      32695 1089.83333    557994666.67 Function Calls (no arguments)/second
    19 fun_cal1            30.00      28522  950.73333    486775466.67 Function Calls (1 argument)/second
    20 fun_cal2            30.00      28880  962.66667    492885333.33 Function Calls (2 arguments)/second
    21 fun_cal15           30.00      11827  394.23333    201847466.67 Function Calls (15 arguments)/second
    22 matrix_rtns         30.00    2532152 84405.06667      8440506.67 Point Transformations/second
    23 array_rtns          30.01       3981  132.65578         2653.12 Linear Systems Solved/second
    24 string_rtns         30.00       4659  155.30000        15530.00 String Manipulations/second
    25 mem_rtns_1          30.01       3682  122.69244      3680773.08 Dynamic Memory Operations/second
    26 mem_rtns_2          30.00     506259 16875.30000      1687530.00 Block Memory Operations/second
    27 sort_rtns_1         30.00       8775  292.50000         2925.00 Sort Operations/second
    28 misc_rtns_1         30.00      47487 1582.90000        15829.00 Auxiliary Loops/second
    29 dir_rtns_1          30.00       5741  191.36667      1913666.67 Directory Operations/second
    30 shell_rtns_1        30.01       4270  142.28590          142.29 Shell Scripts/second
    31 shell_rtns_2        30.00       4271  142.36667          142.37 Shell Scripts/second
    32 shell_rtns_3        30.01       4274  142.41919          142.42 Shell Scripts/second
    33 shared_memory       30.00     205177 6839.23333       683923.33 Shared Memory Operations/second
    34 tcp_test            30.00      31218 1040.60000        93654.00 TCP/IP Messages/second
    35 udp_test            30.00      64064 2135.46667       213546.67 UDP/IP DataGrams/second
    36 fifo_test           30.00     242294 8076.46667       807646.67 FIFO Messages/second
    37 stream_pipe         30.00     187473 6249.10000       624910.00 Stream Pipe Messages/second
    38 dgram_pipe          30.00     175101 5836.70000       583670.00 DataGram Pipe Messages/second
    39 pipe_cpy            30.00     314452 10481.73333      1048173.33 Pipe Messages/second
    40 ram_copy            30.00    5053156 168438.53333   4214332104.00 Memory to Memory Copy/second
------------------------------------------------------------------------------------------------------------
Projected Completion time:  Tue Nov  5 11:28:47 2013
Actual Completion time:     Tue Nov  5 11:30:12 2013
Difference:                 0:01:25

AIM Independent Resource Benchmark - Suite IX
   Testing over

------

AIM Independent Resource Benchmark - Suite IX v1.1, January 22, 1996
Copyright (c) 1996 - 2001 Caldera International, Inc.
All Rights Reserved

Starting time:      Tue Nov  5 11:31:06 2013
Projected Run Time: 0:20:00
Projected finish:   Tue Nov  5 11:51:06 2013

------------------------------------------------------------------------------------------------------------
 Test        Test        Elapsed  Iteration    Iteration          Operation
Number       Name      Time (sec)   Count   Rate (loops/sec)    Rate (ops/sec)
------------------------------------------------------------------------------------------------------------
     1 creat-clo           30.00       4957  165.23333       165233.33 File Creations and Closes/second
     2 page_test           30.01       5269  175.57481       298477.17 System Allocations & Pages/second
     3 brk_test            30.00       5952  198.40000      3372800.00 System Memory Allocations/second
     4 jmp_test            30.00    2520947 84031.56667     84031566.67 Non-local gotos/second
     5 signal_test         30.00      15617  520.56667       520566.67 Signal Traps/second
     6 exec_test           30.01       2705   90.13662          450.68 Program Loads/second
     7 fork_test           30.03       1380   45.95405         4595.40 Task Creations/second
     8 link_test           30.00      29371  979.03333        61679.10 Link/Unlink Pairs/second
     9 disk_rr             30.10       1180   39.20266       200717.61 Random Disk Reads (K)/second
    10 disk_rw             30.03        977   32.53413       166574.76 Random Disk Writes (K)/second
    11 disk_rd             30.00      11816  393.86667      2016597.33 Sequential Disk Reads (K)/second
    12 disk_wrt            30.08       1371   45.57846       233361.70 Sequential Disk Writes (K)/second
    13 disk_cp             30.00       1150   38.33333       196266.67 Disk Copies (K)/second
    14 sync_disk_rw        52.63          2    0.03800           97.28 Sync Random Disk Writes (K)/second
    15 sync_disk_wrt       54.87          1    0.01822           46.66 Sync Sequential Disk Writes (K)/second
    16 sync_disk_cp        54.98          1    0.01819           46.56 Sync Disk Copies (K)/second
    17 disk_src            30.00      26530  884.33333        66325.00 Directory Searches/second
    18 fun_cal             30.00      32669 1088.96667    557550933.33 Function Calls (no arguments)/second
    19 fun_cal1            30.00      28521  950.70000    486758400.00 Function Calls (1 argument)/second
    20 fun_cal2            30.00      29009  966.96667    495086933.33 Function Calls (2 arguments)/second
    21 fun_cal15           30.00      11574  385.80000    197529600.00 Function Calls (15 arguments)/second
    22 matrix_rtns         30.00    2532418 84413.93333      8441393.33 Point Transformations/second
    23 array_rtns          30.01       3981  132.65578         2653.12 Linear Systems Solved/second
    24 string_rtns         30.00       4655  155.16667        15516.67 String Manipulations/second
    25 mem_rtns_1          30.01       3625  120.79307      3623792.07 Dynamic Memory Operations/second
    26 mem_rtns_2          30.00     511216 17040.53333      1704053.33 Block Memory Operations/second
    27 sort_rtns_1         30.00       8718  290.60000         2906.00 Sort Operations/second
    28 misc_rtns_1         30.00      47283 1576.10000        15761.00 Auxiliary Loops/second
    29 dir_rtns_1          30.00       5787  192.90000      1929000.00 Directory Operations/second
    30 shell_rtns_1        30.00       4253  141.76667          141.77 Shell Scripts/second
    31 shell_rtns_2        30.01       4237  141.18627          141.19 Shell Scripts/second
    32 shell_rtns_3        30.00       4270  142.33333          142.33 Shell Scripts/second
    33 shared_memory       30.00     204202 6806.73333       680673.33 Shared Memory Operations/second
    34 tcp_test            30.00      31086 1036.20000        93258.00 TCP/IP Messages/second
    35 udp_test            30.00      64298 2143.26667       214326.67 UDP/IP DataGrams/second
    36 fifo_test           30.00     243154 8105.13333       810513.33 FIFO Messages/second
    37 stream_pipe         30.00     186489 6216.30000       621630.00 Stream Pipe Messages/second
    38 dgram_pipe          30.00     175199 5839.96667       583996.67 DataGram Pipe Messages/second
    39 pipe_cpy            30.00     315871 10529.03333      1052903.33 Pipe Messages/second
    40 ram_copy            30.00    5051844 168394.80000   4213237896.00 Memory to Memory Copy/second
------------------------------------------------------------------------------------------------------------
Projected Completion time:  Tue Nov  5 11:51:06 2013
Actual Completion time:     Tue Nov  5 11:52:18 2013
Difference:                 0:01:12

AIM Independent Resource Benchmark - Suite IX
   Testing over

------

AIM Independent Resource Benchmark - Suite IX v1.1, January 22, 1996
Copyright (c) 1996 - 2001 Caldera International, Inc.
All Rights Reserved

Machine's name                                    : Machine's configuration                           : Number of seconds to run each test [2 to 1000]    : Path to disk files                                : 

Starting time:      Tue Nov  5 12:03:45 2013
Projected Run Time: 0:20:00
Projected finish:   Tue Nov  5 12:23:45 2013



------------------------------------------------------------------------------------------------------------
 Test        Test        Elapsed  Iteration    Iteration          Operation
Number       Name      Time (sec)   Count   Rate (loops/sec)    Rate (ops/sec)
------------------------------------------------------------------------------------------------------------
     1 creat-clo           30.00       4952  165.06667       165066.67 File Creations and Closes/second
     2 page_test           30.01       5201  173.30890       294625.12 System Allocations & Pages/second
     3 brk_test            30.00       5893  196.43333      3339366.67 System Memory Allocations/second
     4 jmp_test            30.00    2156188 71872.93333     71872933.33 Non-local gotos/second
     5 signal_test         30.00      15930  531.00000       531000.00 Signal Traps/second
     6 exec_test           30.00       2707   90.23333          451.17 Program Loads/second
     7 fork_test           30.00       1410   47.00000         4700.00 Task Creations/second
     8 link_test           30.01      29227  973.90870        61356.25 Link/Unlink Pairs/second
     9 disk_rr             30.06       1175   39.08849       200133.07 Random Disk Reads (K)/second
    10 disk_rw             30.00        977   32.56667       166741.33 Random Disk Writes (K)/second
    11 disk_rd             30.00      12222  407.40000      2085888.00 Sequential Disk Reads (K)/second
    12 disk_wrt            30.06       1355   45.07651       230791.75 Sequential Disk Writes (K)/second
    13 disk_cp             30.03       1146   38.16184       195388.61 Disk Copies (K)/second
    14 sync_disk_rw        30.97          1    0.03229           82.66 Sync Random Disk Writes (K)/second
    15 sync_disk_wrt       54.95          1    0.01820           46.59 Sync Sequential Disk Writes (K)/second
    16 sync_disk_cp        54.59          1    0.01832           46.90 Sync Disk Copies (K)/second
    17 disk_src            30.00      26344  878.13333        65860.00 Directory Searches/second
    18 fun_cal             30.00      32748 1091.60000    558899200.00 Function Calls (no arguments)/second
    19 fun_cal1            30.00      28522  950.73333    486775466.67 Function Calls (1 argument)/second
    20 fun_cal2            30.00      29361  978.70000    501094400.00 Function Calls (2 arguments)/second
    21 fun_cal15           30.01      11881  395.90137    202701499.50 Function Calls (15 arguments)/second
    22 matrix_rtns         30.00    2532026 84400.86667      8440086.67 Point Transformations/second
    23 array_rtns          30.00       3987  132.90000         2658.00 Linear Systems Solved/second
    24 string_rtns         30.00       4641  154.70000        15470.00 String Manipulations/second
    25 mem_rtns_1          30.01       3673  122.39254      3671776.07 Dynamic Memory Operations/second
    26 mem_rtns_2          30.00     496847 16561.56667      1656156.67 Block Memory Operations/second
    27 sort_rtns_1         30.01       8775  292.40253         2924.03 Sort Operations/second
    28 misc_rtns_1         30.00      45974 1532.46667        15324.67 Auxiliary Loops/second
    29 dir_rtns_1          30.00       5818  193.93333      1939333.33 Directory Operations/second
    30 shell_rtns_1        30.00       4231  141.03333          141.03 Shell Scripts/second
    31 shell_rtns_2        30.01       4214  140.41986          140.42 Shell Scripts/second
    32 shell_rtns_3        30.01       4203  140.05332          140.05 Shell Scripts/second
    33 shared_memory       30.00     206026 6867.53333       686753.33 Shared Memory Operations/second
    34 tcp_test            30.00      31143 1038.10000        93429.00 TCP/IP Messages/second
    35 udp_test            30.00      64317 2143.90000       214390.00 UDP/IP DataGrams/second
    36 fifo_test           30.00     243628 8120.93333       812093.33 FIFO Messages/second
    37 stream_pipe         30.00     187043 6234.76667       623476.67 Stream Pipe Messages/second
    38 dgram_pipe          30.00     175359 5845.30000       584530.00 DataGram Pipe Messages/second
    39 pipe_cpy            30.00     317087 10569.56667      1056956.67 Pipe Messages/second
    40 ram_copy            30.00    5051195 168373.16667   4212696630.00 Memory to Memory Copy/second
------------------------------------------------------------------------------------------------------------
Projected Completion time:  Tue Nov  5 12:23:45 2013
Actual Completion time:     Tue Nov  5 12:24:36 2013
Difference:                 0:00:51

AIM Independent Resource Benchmark - Suite IX
   Testing over

--=-eAOWjX+zvGUMLdFv39N4
Content-Type: application/x-gmc-link; name="dbench"
Content-Disposition: attachment; filename="dbench"
Content-Transfer-Encoding: 7bit

test: dbench
URL: http://dbench.samba.org/web/index.html
CPU: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
RAM: 4GB

Started using the command:

	dbench -c loadfiles/client.txt 2

======

Results with c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs() execution)

Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                      4     4.868     9.712
 Flush                    16000    73.216  1049.503
 Close                   167598     0.002     0.448
 LockX                      744     0.003     0.008
 Mkdir                        2     0.004     0.004
 Rename                    9667     0.037    14.142
 ReadX                   357881     0.004   180.536
 WriteX                  113473     0.071   150.569
 Unlink                   46056     0.047    67.031
 UnlockX                    744     0.002     0.008
 FIND_FIRST               79948     0.028     4.494
 SET_FILE_INFORMATION     18601     0.014    10.070
 QUERY_FILE_INFORMATION   36216     0.001     0.156
 QUERY_PATH_INFORMATION  206869     0.008    16.638
 QUERY_FS_INFORMATION     37913     0.093     4.189
 NTCreateX               228142     0.015    24.996

Throughput 11.9215 MB/sec  2 clients  2 procs  max_latency=1049.509 ms


Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                      4     4.939     9.817
 Flush                    15873    73.838   915.594
 Close                   166386     0.002     3.527
 LockX                      738     0.003     0.022
 Mkdir                        2     0.004     0.004
 Rename                    9598     0.036     8.199
 ReadX                   355194     0.004    19.869
 WriteX                  112651     0.068   323.327
 Unlink                   45765     0.050   168.347
 UnlockX                    738     0.002     0.003
 FIND_FIRST               79396     0.028     4.206
 SET_FILE_INFORMATION     18459     0.016    17.638
 QUERY_FILE_INFORMATION   35943     0.001     0.152
 QUERY_PATH_INFORMATION  205403     0.008    17.085
 QUERY_FS_INFORMATION     37656     0.095     6.027
 NTCreateX               226541     0.017   388.763

Throughput 11.8386 MB/sec  2 clients  2 procs  max_latency=915.606 ms


Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                      4     5.146    10.350
 Flush                    16641    70.374  1184.800
 Close                   174408     0.002     1.470
 LockX                      774     0.003     0.007
 Mkdir                        2     0.004     0.004
 Rename                   10060     0.038    17.348
 ReadX                   372395     0.004    24.474
 WriteX                  118039     0.063    49.941
 Unlink                   47920     0.044    20.622
 UnlockX                    774     0.002     0.018
 FIND_FIRST               83196     0.028     3.102
 SET_FILE_INFORMATION     19357     0.013     8.464
 QUERY_FILE_INFORMATION   37671     0.001     0.154
 QUERY_PATH_INFORMATION  215243     0.009   181.254
 QUERY_FS_INFORMATION     39448     0.093     4.522
 NTCreateX               237402     0.016   162.319

Throughput 12.4006 MB/sec  2 clients  2 procs  max_latency=1184.810 ms


=========


Results with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
execution):

Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                      4     4.909     9.741
 Flush                    16281    71.885  1036.111
 Close                   170558     0.002     0.231
 LockX                      756     0.003     0.007
 Mkdir                        2     0.004     0.004
 Rename                    9834     0.036     0.837
 ReadX                   364001     0.004    29.897
 WriteX                  115459     0.074   390.151
 Unlink                   46895     0.053   158.994
 UnlockX                    756     0.002     0.003
 FIND_FIRST               81377     0.029    17.054
 SET_FILE_INFORMATION     18925     0.014     9.660
 QUERY_FILE_INFORMATION   36836     0.001     0.111
 QUERY_PATH_INFORMATION  210536     0.008    62.214
 QUERY_FS_INFORMATION     38586     0.094     3.016
 NTCreateX               232176     0.015    87.432

Throughput 12.1209 MB/sec  2 clients  2 procs  max_latency=1036.124 ms


 Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                      4     5.118    10.218
 Flush                    15846    73.906  1140.505
 Close                   166062     0.002     0.207
 LockX                      738     0.003     0.007
 Mkdir                        2     0.004     0.004
 Rename                    9576     0.037     1.016
 ReadX                   354689     0.004    17.232
 WriteX                  112432     0.071   155.947
 Unlink                   45655     0.058   213.249
 UnlockX                    738     0.002     0.005
 FIND_FIRST               79235     0.028     2.505
 SET_FILE_INFORMATION     18408     0.014    10.620
 QUERY_FILE_INFORMATION   35883     0.001     0.071
 QUERY_PATH_INFORMATION  204992     0.008    17.238
 QUERY_FS_INFORMATION     37573     0.094     2.229
 NTCreateX               226117     0.016   215.061

Throughput 11.8087 MB/sec  2 clients  2 procs  max_latency=1140.517 ms


 Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                      4     5.133    10.196
 Flush                    16273    71.943  1387.189
 Close                   170561     0.002     0.135
 LockX                      756     0.003     0.011
 Mkdir                        2     0.004     0.004
 Rename                    9835     0.038     8.470
 ReadX                   364247     0.004    14.413
 WriteX                  115421     0.068    41.782
 Unlink                   46957     0.063   341.624
 UnlockX                    756     0.002     0.023
 FIND_FIRST               81413     0.028     1.740
 SET_FILE_INFORMATION     18901     0.017    26.449
 QUERY_FILE_INFORMATION   36821     0.001     0.083
 QUERY_PATH_INFORMATION  210587     0.008    21.702
 QUERY_FS_INFORMATION     38625     0.094     3.824
 NTCreateX               232279     0.016   159.963

Throughput 12.1177 MB/sec  2 clients  2 procs  max_latency=1387.201 ms

--=-eAOWjX+zvGUMLdFv39N4
Content-Disposition: attachment; filename="ftrace"
Content-Type: text/plain; name="ftrace"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

test: ftrace
CPU: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
RAM: 4GB

Started using the command:

	time ./test-ftrace

Where test-ftrace is:

--- cut ---
#!/bin/bash

echo "Testing ftrace - begin"
cd /sys/kernel/debug/tracing

count=0
while test $count -lt 100 ; do
    for tracer in function nop ; do
	echo $tracer >current_tracer
	echo 1 >tracing_on
	echo 0 >tracing_on
    done
    count=$(($count + 1))
done

cd -
echo "Testing ftrace - end"
--- cut ---

and the load was generated using the script make-load:

--- cut ---
#!/bin/bash

a=1
while true ; do
    a=$(($a+1))
done
--- cut ---

Now, results with no load on the system; with the commit c229828ca6bc62d
(rcu: Throttle rcu_try_advance_all_cbs() execution)

real    0m49.393s    0m49.632s    0m49.359
user    0m0.004s     0m0.000s	  0m0.004s
sys     0m0.996s     0m0.880s	  0m0.892s

and with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
execution)

real    0m35.320s    0m35.687s    0m35.920s
user    0m0.004s     0m0.004s	  0m0.000s
sys     0m1.140s     0m1.208s	  0m1.152s

---

Results with 100% load on one CPU and no load on 2nd CPU (started the script
make-load once) with c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
execution)

real    0m44.964s    0m45.083s    0m45.171s
user    0m0.000s     0m0.000s	  0m0.004s
sys     0m1.580s     0m1.612s	  0m1.576s

and with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
execution)

real    0m30.816s    0m31.326s    0m31.191s
user    0m0.004s     0m0.004s	  0m0.008s
sys     0m1.240s     0m1.248s	  0m1.232s

---

Results with 100% load on both CPUs (started script make-load twice)
with c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs() execution)

real    0m20.294s    0m20.538s    0m20.470s
user    0m0.004s     0m0.000s	  0m0.000s
sys     0m1.284s     0m1.388s	  0m1.612s

and with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
execution)

real    0m20.305s    0m20.056s    0m20.259
user    0m0.000s     0m0.000s	  0m0.000s
sys     0m1.416s     0m1.452s	  0m1.560s

--=-eAOWjX+zvGUMLdFv39N4
Content-Type: application/x-gmc-link; name="unixbench"
Content-Disposition: attachment; filename="unixbench"
Content-Transfer-Encoding: 7bit

test: unixbench-4.1.0 (scripts)
URL: http://www.tux.org/pub/tux/benchmarks/System/unixbench/unixbench-4.1.0.tgz
CPU: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
RAM: 4GB

Started using the command:

	./Run shell

======

Results with c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs() execution)

  BYTE UNIX Benchmarks (Version 4.1.0)
  System -- Linux walk 3.12.0-rc1-0.6.6-default+ #159 SMP Mon Nov 4 17:39:15 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
  Start Benchmark Run: Mon Nov  4 17:43:45 CET 2013
   1 interactive users.
   17:43pm  up   0:02,  1 user,  load average: 0.37, 0.29, 0.12
  lrwxrwxrwx 1 root root 4 Mar 13  2013 /bin/sh -> bash
  /bin/sh: symbolic link to `bash'
  /dev/sda5      165448984 94008064  63036544  60% /local
Shell Scripts (1 concurrent)               5442.0 lpm   (60.1 secs, 3 samples)
Shell Scripts (8 concurrent)               1106.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               563.3 lpm   (60.0 secs, 3 samples)


                     INDEX VALUES            
TEST                                        BASELINE     RESULT      INDEX

Shell Scripts (8 concurrent)                     6.0     1106.0     1843.3
                                                                 =========
     FINAL SCORE                                                    1843.3


  BYTE UNIX Benchmarks (Version 4.1.0)
  System -- Linux walk 3.12.0-rc1-0.6.6-default+ #159 SMP Mon Nov 4 17:39:15 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
  Start Benchmark Run: Mon Nov  4 17:55:14 CET 2013
   1 interactive users.
   17:55pm  up   0:13,  1 user,  load average: 1.33, 4.35, 2.68
  lrwxrwxrwx 1 root root 4 Mar 13  2013 /bin/sh -> bash
  /bin/sh: symbolic link to `bash'
  /dev/sda5      165448984 94008064  63036544  60% /local
Shell Scripts (1 concurrent)               5441.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1107.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               563.0 lpm   (60.0 secs, 3 samples)


                     INDEX VALUES            
TEST                                        BASELINE     RESULT      INDEX

Shell Scripts (8 concurrent)                     6.0     1107.0     1845.0
                                                                 =========
     FINAL SCORE                                                    1845.0


=======


Results with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
execution):

  BYTE UNIX Benchmarks (Version 4.1.0)
  System -- Linux walk 3.12.0-rc1-0.6.6-default+ #158 SMP Mon Nov 4 16:17:29 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
  Start Benchmark Run: Mon Nov  4 17:16:05 CET 2013
   2 interactive users.
   17:16pm  up   0:56,  2 users,  load average: 2.86, 3.64, 2.70
  lrwxrwxrwx 1 root root 4 Mar 13  2013 /bin/sh -> bash
  /bin/sh: symbolic link to `bash'
  /dev/sda5      165448984 94008056  63036552  60% /local
Shell Scripts (1 concurrent)               5499.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1101.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               561.0 lpm   (60.0 secs, 3 samples)


                     INDEX VALUES            
TEST                                        BASELINE     RESULT      INDEX

Shell Scripts (8 concurrent)                     6.0     1101.7     1836.2
                                                                 =========
     FINAL SCORE                                                    1836.2


  BYTE UNIX Benchmarks (Version 4.1.0)
  System -- Linux walk 3.12.0-rc1-0.6.6-default+ #158 SMP Mon Nov 4 16:17:29 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
  Start Benchmark Run: Mon Nov  4 17:28:14 CET 2013
   2 interactive users.
   17:28pm  up   1:08,  2 users,  load average: 0.56, 3.83, 3.65
  lrwxrwxrwx 1 root root 4 Mar 13  2013 /bin/sh -> bash
  /bin/sh: symbolic link to `bash'
  /dev/sda5      165448984 94008064  63036544  60% /local
Shell Scripts (1 concurrent)               5498.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1103.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               560.3 lpm   (60.0 secs, 3 samples)


                     INDEX VALUES            
TEST                                        BASELINE     RESULT      INDEX

Shell Scripts (8 concurrent)                     6.0     1103.3     1838.8
                                                                 =========
     FINAL SCORE                                                    1838.8

--=-eAOWjX+zvGUMLdFv39N4--

