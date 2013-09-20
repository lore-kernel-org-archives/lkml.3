Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3ITNdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:33:46 -0400
Received: from gts6.roserve.net ([128.140.230.209]:42519 "EHLO
	gts6.roserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3ITNdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:33:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Sep 2013 15:22:04 +0300
From: Andrei Banu <andrei.banu@redhost.ro>
To: linux-kernel@vger.kernel.org
Subject: Anomaly with 2 x 840Pro SSDs in software raid 1
Message-ID: <dc777e20b10d0ed8a93ff67c4acee813@redhost.ro>
User-Agent: Roundcube Webmail/0.9.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gts6.roserve.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - redhost.ro
X-Get-Message-Sender-Via: gts6.roserve.net: authenticated_id: andrei.banu@redhost.ro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have a troubling server fitted with 2 840Pro Samsung SSDs. Besides 
other problems addressed also here a while ago (to which I have still 
found no solution) we have one more anomaly (or so I believe).

Although both SSDs worked 100% of the time their wear is very different. 
/dev/sda has a wear of 95% while /dev/sdb has a wear of 77%. The total 
number of LBAs is different only by 9.76%. But the wear level is with 
463.75% higher for sdb.

Shouldn't these be proportional?

root [~]# smartctl --attributes /dev/sda
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-358.11.1.el6.x86_64] 
(local build)

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE

   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always 
       -       4014
  12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always 
       -       5
177 Wear_Leveling_Count     0x0013   095   095   000    Pre-fail  Always 
       -       149
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always 
       -       18515581190

root [~]# smartctl --attributes /dev/sdb
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-358.11.1.el6.x86_64] 
(local build)

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE

   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always 
       -       4014
  12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always 
       -       5
177 Wear_Leveling_Count     0x0013   077   077   000    Pre-fail  Always 
       -       840
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always 
       -       20324371103


A 'iostat -x' returns this:

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda              10.10    46.15  803.26  121.32  8672.87  1543.00    
11.05     0.33    0.36   0.06   5.47
sdb               9.15    52.77  318.00  114.68  4577.24  1543.00    
14.14     0.20    0.47   0.30  13.16
md1               0.00     0.00    1.41    1.29    11.27    10.36     
8.00     0.00    0.00   0.00   0.00
md2               0.00     0.00 1119.61  164.21 10796.10  1530.64     
9.60     0.00    0.00   0.00   0.00
md0               0.00     0.00    0.42    0.01     3.20     0.01     
7.46     0.00    0.00   0.00   0.00

Shouldn't also the %util of 2 members of the same raid-1 array be the 
same? Also svctm seems very different by a similar factor of x5.

A little background info about the system:
- CentOS 6.4
- Linux 2.6.32-358.11.1.el6.x86_64 #1 SMP Wed Jun 12 03:34:52 UTC 2013 
x86_64 x86_64 x86_64 GNU/Linux
- E3-1270v2, 16GB RAM, SuperMicro SYS-5017C-MTRF, 2 x Samsung 840 Pro 
512GB in mdraid-1
- cat /proc/mdstat
md0 : active raid1 sdb2[1] sda2[0]
       204736 blocks super 1.0 [2/2] [UU]
md2 : active raid1 sdb3[1] sda3[0]
       404750144 blocks super 1.0 [2/2] [UU]
md1 : active raid1 sdb1[1] sda1[0]
       2096064 blocks super 1.1 [2/2] [UU]

Kind regards!
