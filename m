Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab3IHARx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 20:17:53 -0400
Received: from zill.ext.symas.net ([69.43.206.106]:56679 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3IHARw (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Sat, 7 Sep 2013 20:17:52 -0400
X-Greylist: delayed 999 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Sep 2013 20:17:52 EDT
Message-ID: <522BBE46.9060809@symas.com>
Date: Sat, 07 Sep 2013 17:01:10 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:25.0) Gecko/20100101 Firefox/25.0 SeaMonkey/2.22a1
MIME-Version: 1.0
To: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: dirty_expire_centisecs, msync behavior
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for dirty_expire_centisecs states: "Data which has been 
dirty in-memory for longer than this interval will be written out next time a 
flusher thread wakes up."

In practice, it appears that once the expire time has passed, all dirty pages 
get flushed, regardless of their age. This behavior makes this setting fairly 
useless. This appears to have been the behavior for most of 2.6 and 3.x. Can 
anyone explain, is the current behavior really as intended, and is the doc 
just out of date?

On a slightly related note, what was the key problem with this patch "msync: 
support syncing a small part of the file"? 
http://thread.gmane.org/gmane.linux.kernel/1313767/focus=1317498

Andrew Morton's message states that Paolo's patch would break nonlinear 
mappings, and the matter was dropped. Why wasn't it possible to write a patch 
that would also work with nonlinear mappings? I couldn't find any earlier 
context for that subject, pointers welcome.

My interest in both of these questions stems from what I've observed while 
testing the LMDB memory-mapped database. On a machine with 32GB RAM, using a 
database that occupies about 18GB of memory, doing continuous writes to the DB 
without ever calling msync, and default writeback settings, I see DB 
throughput spike downward every time the flusher wakes up. The DB is a mmap'd 
file on an XFS partition, and a DB write operation simply dirties a random set 
of pages. After the program has been running for more than 
dirty_expire_centisecs, every dirty_writeback_centisecs the DB app basically 
stops while the flusher writes out all the dirty pages.

I'm curious about a couple things - since the DB knows which pages it is 
dirtying in a given transaction, would it help overall throughput if the DB 
told the OS (via msync) exactly which ranges to flush? Obviously not, in the 
current implementation of msync, but can a patch like Paolo's make this 
better? And can the dirty_expire_centisecs behavior be fixed, so that it's 
only writing out a smaller set of pages on each wakeup? What else can we do to 
minimize the impact of the flusher? If I turn it off completely the throughput 
nearly doubles, from 5100 DB writes/sec to 9000/sec. If I turn off the timed 
flush and just use dirty_background_bytes the throughput just slows to around 
7000/sec.

It seems to me the main slowdown is because the OS is locking dirty pages 
indiscriminately. The DB does copy-on-write, so pages that it dirties in one 
transaction will not be written again in the next transaction. I would have 
expected read-only accesses to these pages to be able to progress without any 
delay but that doesn't seem to be the case.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
