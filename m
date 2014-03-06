Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaCFRpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:45:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaCFRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:45:33 -0500
Date: Thu, 6 Mar 2014 18:45:31 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140306174531.GA30634@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at the printk call in
__timekeeping_inject_sleeptime(), introduced in cb5de2f8
(time: Catch invalid timespec sleep values in __timekeeping_inject_sleeptime)

Is it safe to call printk() while timekeeper_seq is held for
writing?

What about this call chain?
  printk
    vprintk_emit
      console_unlock
        up(&console_sem)
          __up
	    wake_up_process
	      try_to_wake_up
	        ttwu_do_activate
		  ttwu_activate
		    activate_task
		      enqueue_task
		        enqueue_task_fair
			  hrtick_update
			    hrtick_start_fair
			      hrtick_start_fair
			        get_time
				  ktime_get
				    --> endless loop on
				    read_seqcount_retry(&timekeeper_seq, ...)
		  

It looks like an unlikely but possible deadlock. 
Or did I overlook something?

Thanks!

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

