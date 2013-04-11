Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161565Ab3DKIr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:47:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12541 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3DKIrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:47:23 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-2f-516678994919
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC] security: smack: add hash table for smack for quick label
 searching
Date: Thu, 11 Apr 2013 10:46:11 +0200
Message-id: <1365669972-21461-1-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAd2ZFWmBBidvG1icbXrDbnF51xw2
	iw89j9gs1h65y27xdtIKZot57S9ZHdg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2Px2TbG
	gvvGFfeXHmJsYNwn1sXIySEhYCLx48huJghbTOLCvfVsXYxcHEICixgl1h34zgThdDFJvJl4
	iR2kig2o49iSz4wgtoiApsSx6SAdnBzMAnMYJQ5ulu1i5OAQFgiRmH+CF8RkEVCVePRBGqSC
	V8BDYv37uWwQu+Qlnt7vY5vAyL2AkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRrDvn0nv
	YFzVYHGIUYCDUYmH90RDaqAQa2JZcWXuIUYJDmYlEV6unUAh3pTEyqrUovz4otKc1OJDjNIc
	LErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjAu/mW6PZGhdY798f7rVd5OOhx+vfllfPlFY
	8M0SW5u/oWeOfIzxcS6ZsWrCfXePBcIFJ9Rdds9hk5T/zHDulsal2b3enc2cvEe3NrqduWpk
	9rDnF4e9zpuXL5fpis88MqNoc1aVOF+doEbojMPS69vXs3w1+mP7K8GtW+3al9taV4QO/dt5
	8ZYSS3FGoqEWc1FxIgC5Rxln+QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
I am a developer working on optimization of the TIZEN system.
Recently, I've discovered a performance issue in SMACK subsystem.
I used the PERF tool to find performance bottlenecks.

The test scenario was simple. Run multiple applications and
see what the system does using the following command:

 perf record -a -g

Next, see the results with the command:

 perf report -s symbol -g graph,0.5

Among the many lines, the following ones are especially interesting:

     5.96%  [k] smk_find_entry                                                                         
            |          
            |--5.06%-- smk_access
            |          |          
            |           --4.99%-- smk_curacc
            |                     |          
            |                     |--3.79%-- smack_ptrace_access_check
            |                     |          security_ptrace_access_check
            |                     |          __ptrace_may_access
            |                     |          ptrace_may_access
            |                     |          |          
            |                     |           --3.78%-- mm_access
            |                     |                     mm_for_maps
            |                     |                     m_start
            |                     |                     seq_read
            |                     |                     vfs_read
            |                     |                     sys_read
            |                     |                     ret_fast_syscall
            |                     |                     |          
            |                     |                      --3.19%-- (nil)
            |                     |          
            |                      --0.71%-- smack_inode_permission
            |                                security_inode_permission
            |                                inode_permission
            |          
             --0.89%-- smack_to_secid
                       smack_socket_getpeersec_dgram
                       security_socket_getpeersec_dgram
                       |          
                        --0.54%-- unix_stream_sendmsg

     4.63%  [k] strcmp                                                                                 
            |          
            |--2.16%-- smk_find_entry
            |          |          
            |           --1.92%-- smk_access
            |                     |          
            |                      --1.85%-- smk_curacc
            |                                |          
            |                                 --1.20%-- smack_ptrace_access_check
            |                                           security_ptrace_access_check
            |                                           __ptrace_may_access
            |                                           ptrace_may_access
            |                                           mm_access
            |                                           mm_for_maps
            |                                           m_start
            |                                           seq_read
            |                                           vfs_read
            |                                           sys_read
            |                                           ret_fast_syscall
            |                                           |          
            |                                            --0.99%-- (nil)
            |          
             --2.14%-- smk_access
                       |          
                        --2.11%-- smk_curacc
                                  |          
                                   --1.75%-- smack_ptrace_access_check
                                             security_ptrace_access_check
                                             __ptrace_may_access
                                             ptrace_may_access
                                             |          
                                              --1.73%-- mm_access
                                                        mm_for_maps
                                                        m_start
                                                        seq_read
                                                        vfs_read
                                                        sys_read
                                                        ret_fast_syscall
                                                        |          
                                                         --1.40%-- (nil)

To sum up, the result indicates that the CPU spents circa 8% (2.16% + 5.96%)
of cycles searching for a SMACK label in the smk_find_entry function.
The function iterates through smack_known_list to find an entry.
The further analysis showed that the size of the list can reach even 600.
I measured that it takes circa 200 tries to find an entry on average.
The value was computed as a total number iterations in the smk_find_entry's
loop divided by the times smk_find_entry was called in a time-window of
the length of 10 seconds.

IMO, this is a serious performance issue which scales badly with
a complexity of the system.

I implemented a patch that makes a use of a hash table to quicken searching
for SMACK's labels.  The patch is rebased onto the latest v3.9-rc6 kernel.
The code is thread-safe (I hope) because it shares the RCU mechanism
and locks with smack_known_list.

There is still some place for improvements like:
a) using struct hlist_head instead of struct list_head to reduce
   the memory size of the hash table.

OR

b) use smack_known::list instead of introducing smack_known::htab_list
   and modify all smack_known_list related code to iterate over
   the hash table.

I decided to postpone the mentioned improvements for a sake of simplicity
of this RFC. After applying the patch, the smk_find_entry overhead was
reduced to mere 0.05% of CPU cycles.

I hope you find the measurement and the patch useful.
All comments are welcome.

Regards,
Tomasz Stanislawski


Tomasz Stanislawski (1):
  security: smack: add hash table for smack for quick label searching

 security/smack/smack.h        |    5 +++++
 security/smack/smack_access.c |   33 +++++++++++++++++++++++++++++++--
 security/smack/smack_lsm.c    |   21 +++++++++++++++------
 3 files changed, 51 insertions(+), 8 deletions(-)

-- 
1.7.9.5

