Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaCDWFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:05:46 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60007 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaCDWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:05:45 -0500
Date: Tue, 4 Mar 2014 14:05:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "He, Bo" <bo.he@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "yanmin_zhang@intel.linux.com" <yanmin_zhang@intel.linux.com>,
        "Wang, Biao" <biao.wang@intel.com>
Subject: RE: [PATCH]  mm, oom: normalize the adj to ensure oom_badness return
 a positive number
In-Reply-To: <CD6925E8781EFD4D8E11882D20FC406D01AEE4A8@SHSMSX103.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1403041400020.5421@chino.kir.corp.google.com>
References: <CD6925E8781EFD4D8E11882D20FC406D01AEE4A8@SHSMSX103.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, He, Bo wrote:

> Sorry, the title is confusing. Change it to: mm, oom: normalize the adj to ensure oom_badness returns a positive number

There's something seriously wrong with your email client, it's not 
replying correctly to threads so this appears as a completely new thread.  
Meanwhile, your patch was completely whitespace damaged.  Please read 
Documentation/email-clients.txt.

> We are enabling android mobiles. When running stress memory test, there is a bad issue. Some critical processes such as Healthd and watchdogd are killed, while some other processes are still alive.
> OOM should kill the tasks whose oom_score are biggest. Many processes use a minus oom_score_adj. oom_badness returns 1 for all of them and their oom_score are all 0.
> 

No, you're confusing two different things.  A negative 
/proc/pid/oom_score_adj discounts a process's memory usage in comparison 
to other processes.  If this value discounts all memory usage for every 
process, then your setting of /proc/pid/oom_score_adj is wrong.

oom_badness() returns 1 so that the oom killer may still kill these 
processes, the /proc/pid/oom_score is irrelevant to this (and the only 
reason it appears as 0 is because it already normalizes by multiplying by 
1000 / totalpages).

> The patch tries to convert the minus oom_score_adj to a positive number when calculating oom_score. oom_score can keep right process priority sequence.
> 

Nack, this patch is completely disregarding the value specified by the 
user for /proc/pid/oom_score_adj.  Your userspace should be using 
/proc/pid/oom_score_adj, not /proc/pid/oom_adj. 
