Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936157Ab3DKSE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:04:57 -0400
Received: from nm24-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.143]:28251
	"EHLO nm24-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936103Ab3DKSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:04:53 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2013 14:04:53 EDT
X-Yahoo-Newman-Id: 662784.30226.bm@smtp102.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _cm_o1AVM1kxxou4GMHU_VlMWgKqxGDxepWpytdsb0UXyb_
 aqWg1zwachy4kkI7BDTtVK6dEfap9sUY4DLkJh4AYr52okuQqgJPGa1okK_S
 jA7ujO6mBXuan6LLzgJZWbwtI_vm2J3R0rWm0.JQUPAk3.rTrJFfLPN4hlew
 SB56vHYE1AB2IRJi3wi_0bhKNSNHPynVMqph0I1kL00LafE7NuYj0CyWdQzx
 qlcX3H2zfX1ZlyEN5kYTHYS4OKrvbi046.8TyfA1sls14uMKyTKBy6_q7kCQ
 jQ.1bTpelXsRiACvZAwkHMnFDwxpwkvx3LuiQ8aAPZJw6SG4zrFeXsIAcWcF
 d.RmzntlLbU0zjmu8PVYBl4ZI.6UsIEHjgPUUKYUjj8pJWnNY1VUE0ZhIYRr
 lTDrWc05XJpAd5hXrrcqrhtXwFPBN90MloZKqiBRkOO5UrmzuOZGS57V3z18
 VlI2s
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.131.111.212 with plain)
        by smtp102.biz.mail.ne1.yahoo.com with SMTP; 11 Apr 2013 10:59:16 -0700 PDT
Message-ID: <5166F9FA.20003@schaufler-ca.com>
Date: Thu, 11 Apr 2013 10:59:22 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] security: smack: add hash table for smack for quick label
 searching
References: <1365669972-21461-1-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1365669972-21461-1-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2013 1:46 AM, Tomasz Stanislawski wrote:
> Hi everyone,
> I am a developer working on optimization of the TIZEN system.
> Recently, I've discovered a performance issue in SMACK subsystem.
> I used the PERF tool to find performance bottlenecks.
>
> The test scenario was simple. Run multiple applications and
> see what the system does using the following command:
>
>  perf record -a -g
>
> Next, see the results with the command:
>
>  perf report -s symbol -g graph,0.5
>
> Among the many lines, the following ones are especially interesting:
>
>      5.96%  [k] smk_find_entry                                                                         
>             |          
>             |--5.06%-- smk_access
>             |          |          
>             |           --4.99%-- smk_curacc
>             |                     |          
>             |                     |--3.79%-- smack_ptrace_access_check
>             |                     |          security_ptrace_access_check
>             |                     |          __ptrace_may_access
>             |                     |          ptrace_may_access
>             |                     |          |          
>             |                     |           --3.78%-- mm_access
>             |                     |                     mm_for_maps
>             |                     |                     m_start
>             |                     |                     seq_read
>             |                     |                     vfs_read
>             |                     |                     sys_read
>             |                     |                     ret_fast_syscall
>             |                     |                     |          
>             |                     |                      --3.19%-- (nil)
>             |                     |          
>             |                      --0.71%-- smack_inode_permission
>             |                                security_inode_permission
>             |                                inode_permission
>             |          
>              --0.89%-- smack_to_secid
>                        smack_socket_getpeersec_dgram
>                        security_socket_getpeersec_dgram
>                        |          
>                         --0.54%-- unix_stream_sendmsg
>
>      4.63%  [k] strcmp                                                                                 
>             |          
>             |--2.16%-- smk_find_entry
>             |          |          
>             |           --1.92%-- smk_access
>             |                     |          
>             |                      --1.85%-- smk_curacc
>             |                                |          
>             |                                 --1.20%-- smack_ptrace_access_check
>             |                                           security_ptrace_access_check
>             |                                           __ptrace_may_access
>             |                                           ptrace_may_access
>             |                                           mm_access
>             |                                           mm_for_maps
>             |                                           m_start
>             |                                           seq_read
>             |                                           vfs_read
>             |                                           sys_read
>             |                                           ret_fast_syscall
>             |                                           |          
>             |                                            --0.99%-- (nil)
>             |          
>              --2.14%-- smk_access
>                        |          
>                         --2.11%-- smk_curacc
>                                   |          
>                                    --1.75%-- smack_ptrace_access_check
>                                              security_ptrace_access_check
>                                              __ptrace_may_access
>                                              ptrace_may_access
>                                              |          
>                                               --1.73%-- mm_access
>                                                         mm_for_maps
>                                                         m_start
>                                                         seq_read
>                                                         vfs_read
>                                                         sys_read
>                                                         ret_fast_syscall
>                                                         |          
>                                                          --1.40%-- (nil)
>
> To sum up, the result indicates that the CPU spents circa 8% (2.16% + 5.96%)
> of cycles searching for a SMACK label in the smk_find_entry function.
> The function iterates through smack_known_list to find an entry.
> The further analysis showed that the size of the list can reach even 600.
> I measured that it takes circa 200 tries to find an entry on average.
> The value was computed as a total number iterations in the smk_find_entry's
> loop divided by the times smk_find_entry was called in a time-window of
> the length of 10 seconds.
>
> IMO, this is a serious performance issue which scales badly with
> a complexity of the system.
>
> I implemented a patch that makes a use of a hash table to quicken searching
> for SMACK's labels.  The patch is rebased onto the latest v3.9-rc6 kernel.
> The code is thread-safe (I hope) because it shares the RCU mechanism
> and locks with smack_known_list.
>
> There is still some place for improvements like:
> a) using struct hlist_head instead of struct list_head to reduce
>    the memory size of the hash table.
>
> OR
>
> b) use smack_known::list instead of introducing smack_known::htab_list
>    and modify all smack_known_list related code to iterate over
>    the hash table.
>
> I decided to postpone the mentioned improvements for a sake of simplicity
> of this RFC. After applying the patch, the smk_find_entry overhead was
> reduced to mere 0.05% of CPU cycles.
>
> I hope you find the measurement and the patch useful.
> All comments are welcome.

NAK

There will be no hash tables in Smack.

The correct solution is simple.

In the task_smack structure there are two Smack label pointers,
smk_task and smk_forked. Replace these fields with pointers to
the smack_known structures that contain the Smack label pointers
used today. This will require trivial changes throughout the
Smack code to accommodate the type change and a few logical twists
around smk_import. It will eliminate the need for smk_lookup_entry.
 

>
> Regards,
> Tomasz Stanislawski
>
>
> Tomasz Stanislawski (1):
>   security: smack: add hash table for smack for quick label searching
>
>  security/smack/smack.h        |    5 +++++
>  security/smack/smack_access.c |   33 +++++++++++++++++++++++++++++++--
>  security/smack/smack_lsm.c    |   21 +++++++++++++++------
>  3 files changed, 51 insertions(+), 8 deletions(-)
>

