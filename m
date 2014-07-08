Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaGHG2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:28:16 -0400
Received: from odin2.bull.net ([129.184.85.11]:48158 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaGHG2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:28:14 -0400
Message-ID: <53BB8F7C.1060505@bull.net>
Date: Tue, 8 Jul 2014 08:28:12 +0200
From: Sebastien Buisson <sebastien.buisson@bull.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
References: <53B667F9.90306@bull.net> <87y4w6sbp7.fsf@tassilo.jf.intel.com> <53BA772C.6040506@bull.net> <20140707163003.GA18735@two.firstfloor.org> <20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org> <20140707224634.GE18735@two.firstfloor.org>
In-Reply-To: <20140707224634.GE18735@two.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.192.1.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Can anyone demonstrate why we shouldn't just do
>
> I was assuming due to memory usage: with 4K blocks 32K->64K
>

Moreover, performance gain was not that satisfactory on ext4 when 
increasing BH_LRU_SIZE to 16.
Here are the performances I got with:
(a) mdtest on ramdisk device, single shared dir, with large ACL and SELinux
(b) mdtest on ramdisk device, single shared dir, with large ACL but NO 
SELinux

(results show performance gain in percentage when increasing BH_LRU_SIZE 
to 16)

(a)
files       tasks     dir size     Creation   Stat     Removal
1000000      1     	  0          -8,7        -2,7     -0,5
1000000      1       100000          -5,2        -0,5     -1,1
1000000      1       500000          -5,1        -3,7     -1,5
1000000      1      2000000          -5,1        -4,0     -8,5
1000000      1      5000000          -4,2        -5,3     -10,2
1000000      1     10000000          -3,5        -8,0     -10,9
1000000      8            0          -0,3        -3,8     -1,2
1000000      8       100000          -1,2        -3,7     -1,5
1000000      8       500000           0,5        -3,2     -5,3
1000000      8      2000000          -1,7        -6,1     -8,7
1000000      8      5000000          -5,9        -7,7     -11,9
1000000      8     10000000          -4,1        -8,8     -13,6

(b)
files      tasks     dir size     Creation   Stat     Removal
1000000      1           0            0,0        -0,9     -1,1
1000000      1      100000            1,0        -3,0     -3,5
1000000      1      500000            3,7        -3,0     -2,4
1000000      1     2000000            1,1         3,6     -0,2
1000000      1     5000000            3,5         0,1      5,9
1000000      1    10000000            9,0         3,8      6,4
1000000      8           0            2,4        -1,2     -4,3
1000000      8      100000           -0,2        -1,8     -2,4
1000000      8      500000            1,1        -0,3      2,0
1000000      8     2000000           -0,3        -2,8     -3,3
1000000      8     5000000            0,3        -3,1     -1,3
1000000      8    10000000            1,5         0,0      0,7


To compare with the performances I got on Lustre with:
(c) mds-survey on ramdisk device, quota enabled, shared directory
(d) mds-survey on ramdisk device, quota enabled, directory per process

(c)
fi         dir     threads     create   lookup   destroy
1000000     1        1          11,3      1,2      7,2
1000000     1        2           6,4      2,3      6,9
1000000     1        4           1,9      3,0      1,3
1000000     1        8          -0,6      4,3      0,7
1000000     1       16           0,5      4,4      0,6

(d)
files      dir     threads     create   lookup   destroy
1000000     4       4            3,2     28,5      5,3
1000000     8       8            1,2     33,9      2,0
1000000    16      16            0,6      7,9     -0,2


Sebastien.
