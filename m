Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbbAPOB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:01:29 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57418 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbAPOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:01:27 -0500
Message-ID: <54B919B5.4020300@linaro.org>
Date: Fri, 16 Jan 2015 14:01:25 +0000
From: Zoltan Kiss <zoltan.kiss@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Thread scheduler misbehaviour OR Oprofile bug?
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using OProfile to check some suspicious behaviour of dpdk-pktgen, 
and I can see something which troubles me. Either the scheduler lies 
about core affinity or Oprofile accounts some samples wrongly.
This userspace app runs in threads, which are assigned explicitly to one 
single core with pthread_setaffinity_np (I've added some debug lines 
which checks the affinity with pthread_getaffinity_np to make sure that 
the affinity was correctly set indeed)
These threads run infinite loops, calling different functions. In my 
example one of these functions (pktgen_main_rxtx_loop) should only be 
called by the thread on core #1, but in the oprofile results I can see 
samples from all other cores as well. I've added a sched_getcpu() call 
to every iteration of that infinite loop to check if it runs anywhere 
else than core #1, but it seems to be fine.
So my conclusion is that either the scheduler doesn't care about thread 
affinity and even sched_getcpu() can't see that, OR, Oprofile falsely 
accounts samples to the wrong CPU. Or to the wrong symbol, although I've 
added "__attribute__ ((noinline))" to every called function to make sure 
that inlineing doesn't screw up anything.
I'm running my tests on Ubuntu Servers with 14.04 with 3.13.0-32 kernel, 
the CPU is a desktop kind, i5-4570 @ 3.20GHz (no-HT!) with oprofile 0.9.9.
Anyone have a suggestion about what happens?

Regards,

Zoltan
