Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaFKEdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:33:12 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:37447 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaFKEdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:33:10 -0400
Message-ID: <1402461178.24669.40.camel@localhost>
Subject: Counting currently open file descriptors per process.
From: wmealing <wmealing@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: wmealing@redhat.com
Date: Wed, 11 Jun 2014 14:32:58 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-21.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gday,

I'm seeking some guidance on how to best (or if) to implement a feature.
 
Please CC me on any reply, I am not subscribed to this list.

The feature is, "an application would like to know how many files another 
process has open".

>From user space, the cheapest way  would be to use the call
syscall(SYS_getdents ...) in the proc/pid/fd directory. 

Alternatively from kernel space one could achieve a similar behavior by
iterating through the tasks fdtable, as i have attempted to here:

https://gist.github.com/wmealing/c0836bc6a38f8f90aa0d

Colleagues of mine have pointed out that this may have performance 
impacts for tools that frequently parse /proc/pid/status.

I have compiled a kernel with the above patch and here are the performance stats.

System settings
# sysctl -w fs.file-max=5000000
fs.file-max = 5000000

Increase this sessions limits.
# ulimit -n 1000000

test.py had 500002 files open each time.

Here are some of the performance benchmarks on an idle
system: 

# time cat /proc/`pidof python test.py`/status |grep FD
FDSize:	524288
FDCount: 500002

real	0m0.008s
user	0m0.002s
sys	0m0.004s

# time ./test-getdents /proc/`pidof python test.py`/fd &> /dev/null 

real	0m0.631s
user	0m0.001s
sys	0m0.485s

or this time with readdir(3)

# time ./test-opendir /proc/`pidof python test.py`/fd &> /dev/null

real	0m0.129s
user	0m0.001s
sys	0m0.007s

(which oddly seems faster?)

My benchmark values above are not meant for micro-benchmarking 
but rather as a scale to know how far behind the code is.

Is the current method of getting a live fd count acceptable, if 
not how should it be done ?

Thanks for your time.

Wade Mealing.

[1] https://github.com/wmealing/live-fd-count/  
git repo with code used in the above.

