Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaCCQo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:44:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbaCCQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:44:27 -0500
Date: Mon, 3 Mar 2014 17:43:56 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: prarit@redhat.com, riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        alex.shi@intel.com, Igor Mammedov <imammedo@redhat.com>, hpa@zytor.com
Subject: deadlock between cpu_stopper &
 native_flush_tlb_others()->smp_call_function_many()
Message-ID: <20140303174356.082ec348@nial.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like I hit a deadlock between smp_call_function_many() and
cpu_stopper threads.

Where smp_call_function_many() on CPU1 called from
native_flush_tlb_others() waits on call to be complete on
CPU2 while CPU2 waits on state synchronization in
multi_cpu_stop() which can't be completed until stop work
queued on CPU1 is completed, which can't be done since  CPU1
is busy looping in smp_call_function_many().


CPU1                                       CPU2
stop_machine()
 queue stop work on cpu 1&2

native_flush_tlb_others()
   smp_call_function_many()
      ...
---------------------------------------------------------
                                    cpu_stopper_thread()
                                       multi_cpu_stop()
                                          do {
                                             ...
                                             msdata->state == MULTI_STOP_PREPARE
                                             msdata->active_cpus == 0110
                                             msdata->thread_ack == 1
                                          } while (curstate != MULTI_STOP_EXIT)
                                    waiting until CPU1 ACKs state, i.e. thread_ack == 0
---------------------------------------------------------                                    
      ...
      if (wait) {
         for_cpu(0110) {
           csd_lock_wait(csd);
waiting until call on CPU2 is completed

Are there any suggestions on how to fix this nicely?
