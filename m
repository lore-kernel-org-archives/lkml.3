Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3DOQJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:09:54 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56746 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3DOQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:09:53 -0400
Date: Mon, 15 Apr 2013 12:13:19 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: perf: forcing instructions event to run on Fixed Counter 0
Message-ID: <alpine.DEB.2.02.1304151205140.17281@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It turns out that perf_event for intel seems to use the INST_RETIRED.ALL
event interchangably with the "Fixed Counter 0" event.

It turns out they are not equivelent.  The Fixed Counter 0 event turns out 
to be deterministic, while INST_RETIRED.ALL has a bug where it counts 
extra events due to hardware interrupts.

Having a user-accessible deterministic instructions event would be really 
useful.  So is there a way we can specify we want an event to run on Fixed 
Counter 0?  I think there is code already that does this for Fixed Counter 
2 for similar reasons.

For an example of this happening in real life, take the 
./retired_instr.all.x86_64 from my deterministic benchmark that
I'll be presenting at the ISPASS conference next week.  
  (can be found here git://github.com/deater/deterministic.git )

If you run this benchmark with the same event listed 5 times on an Ivy
Bridge machine you get these results, notice the last one is the "proper"
deterministic result and thus the one that ran on Fixed Counter 0.

$ perf stat -e instructions:u,instructions:u,instructions:u,instructions:u,instructions:u ./retired_instr.all.x86_64
...
 Performance counter stats for './retired_instr.all.x86_64':

       227,010,687 instructions:u            #    0.00  insns per cycle        
       227,010,687 instructions:u            #    0.00  insns per cycle        
       227,010,687 instructions:u            #    0.00  insns per cycle        
       227,010,687 instructions:u            #    0.00  insns per cycle        
       227,000,723 instructions:u            #    0.00  insns per cycle        

       1.902648316 seconds time elapsed

Thanks,

Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
