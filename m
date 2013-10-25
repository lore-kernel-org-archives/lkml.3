Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3JYBgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 21:36:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55213 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JYBgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 21:36:20 -0400
Message-ID: <5269CB06.5060101@jp.fujitsu.com>
Date: Fri, 25 Oct 2013 10:36:06 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: toshi.okajima@jp.fujitsu.com, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        eparis@redhat.com
Subject: Re: [BUG][PATCH] audit: audit_log_start running on auditd should
 not stop
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com> <5257C5D7.80308@cn.fujitsu.com> <5257EF15.6080209@jp.fujitsu.com> <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com> <525CE10A.90907@cn.fujitsu.com> <20131023195550.GA9109@madcap2.tricolour.ca>
In-Reply-To: <20131023195550.GA9109@madcap2.tricolour.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Thanks for your interest.

(2013/10/24 4:55), Richard Guy Briggs wrote:
> On Tue, Oct 15, 2013 at 02:30:34PM +0800, Gao feng wrote:
>> Hi Toshiyuki-san,
> 
> Toshiuki and Gao,
> 
>> On 10/15/2013 12:43 PM, Toshiyuki Okajima wrote:
>>> The backlog cannot be consumed when audit_log_start is running on auditd
>>> even if audit_log_start calls wait_for_auditd to consume it.
>>> The situation is a deadlock because only auditd can consume the backlog.
>>> If the other process needs to send the backlog, it can be also stopped 
>>> by the deadlock.
>>>
>>> So, audit_log_start running on auditd should not stop.
>>>
>>> You can see the deadlock with the following reproducer:
>>>  # auditctl -a exit,always -S all
>>>  # reboot
> 
>> Hmm, I see, There may be other code paths that auditd can call audit_log_start except
>> audit_log_config_change. so it's better to handle this problem in audit_log_start.
>>
>> but current task is only meaningful when gfp_mask & __GFP_WAIT is true.
>> so maybe the below patch is what you want.
> 
> I have been following this thread with interest.  I like the general
> evolution of this patch.  The first patch was a bit too abrupt, dropping
> too much, but this one makes much more sense.  I would be tempted to
> make the reserve even bigger.
> 
> I see that you should be using a kernel that has included commit
> 8ac1c8d5 (which made it into v3.12-rc3)
> 	audit: fix endless wait in audit_log_start()
> That was an obvious bug, but I was still concerned about the cause of
> the initial wait.  There are other fixes and ideas in the works that
> should alleviate some of the pressure to make the service more usable.
> 	https://lkml.org/lkml/2013/9/18/453
> 

> I have tested with and without this v3 patch and I don't see any
> significant difference with the reproducer provided above.  I'm also
> testing with a reproducer of the endless wait bug (readahead-collector).
> 
> What are your expected results?  What are your actual results in each
> case?  How are they different?
OK. I try to describe.

1) I found that the system cannot reboot smoothly because auditd daemon can stop for 60 seconds. 

2) As the result of my investigation of this problem, I found that audit_log_start executed
on auditd called wait_for_auditd and stopped for "audit_backlog_wait_time". 
Calling wait_for_auditd is to let auditd consume the backlog during this sleep.
However, when wait_for_auditd is called on auditd, the backlog cannot be consumed during this time.
In addition, audit_log_start called by other processes can also stop while auditd is stopping.
So, wait_for_auditd called on auditd is meaningless.

3) Therefore, I made the v3 patch that audit_log_start executed on auditd doesn't call wait_for_auditd. 

4) On my environment, I couldn't see the situation that auditd stopped for 60 seconds by using
this patch. 

5) So, I thought this problem could be fixed.


But after I received your comment, I encountered the other problem that auditd can stop for 
60 seconds when I tried this patch on the other environment installed "systemd".
So, I think you encountered the other problem that was the same as mine.

The following situation was occurred:
zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
PID: 1      TASK: ffff88007c7d8000  CPU: 0   COMMAND: "systemd"
 #0 [ffff88007c7758d8] __schedule at ffffffff815f231a
 #1 [ffff88007c775950] schedule at ffffffff815f2a79
 #2 [ffff88007c775960] schedule_timeout at ffffffff815f0f93
 #3 [ffff88007c775a10] audit_log_start at ffffffff810d7d09
 #4 [ffff88007c775ab0] audit_log_common_recv_msg at ffffffff810d8068
 #5 [ffff88007c775b00] audit_receive_msg at ffffffff810d8ca0
 #6 [ffff88007c775bb0] audit_receive at ffffffff810d8f98
 #7 [ffff88007c775be0] netlink_unicast at ffffffff8150bf31
 #8 [ffff88007c775c30] netlink_sendmsg at ffffffff8150c2b1
 #9 [ffff88007c775cc0] sock_sendmsg at ffffffff814ca3fc
#10 [ffff88007c775e50] sys_sendto at ffffffff814ccd6d
#11 [ffff88007c775f80] system_call_fastpath at ffffffff815fc259
    RIP: 00007fbee5653543  RSP: 00007fff23d684b8  RFLAGS: 00000246
    RAX: 000000000000002c  RBX: ffffffff815fc259  RCX: ffffffffffffffff
    RDX: 0000000000000078  RSI: 00007fff23d5d8c0  RDI: 0000000000000003
    RBP: 0000000000000003   R8: 00007fff23d5d8b0   R9: 000000000000000c
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000050
    R13: 00007fff23d66380  R14: 000000000000046b  R15: 0000000000000067
    ORIG_RAX: 000000000000002c  CS: 0033  SS: 002b

PID: 488    TASK: ffff880036edcbf0  CPU: 1   COMMAND: "auditd"
 #0 [ffff88007ba93a98] __schedule at ffffffff815f231a
 #1 [ffff88007ba93b10] schedule at ffffffff815f2a79
 #2 [ffff88007ba93b20] schedule_preempt_disabled at ffffffff815f2d0e
 #3 [ffff88007ba93b30] __mutex_lock_slowpath at ffffffff815f1903
 #4 [ffff88007ba93b90] mutex_lock at ffffffff815f143a
 #5 [ffff88007ba93bb0] audit_receive at ffffffff810d8f71
 #6 [ffff88007ba93be0] netlink_unicast at ffffffff8150bf31
 #7 [ffff88007ba93c30] netlink_sendmsg at ffffffff8150c2b1
 #8 [ffff88007ba93cc0] sock_sendmsg at ffffffff814ca3fc
 #9 [ffff88007ba93e50] sys_sendto at ffffffff814ccd6d
#10 [ffff88007ba93f80] system_call_fastpath at ffffffff815fc259
    RIP: 00007fc256ff16f3  RSP: 00007fffff6b39d8  RFLAGS: 00010202
    RAX: 000000000000002c  RBX: ffffffff815fc259  RCX: 0000000000000000
    RDX: 0000000000000030  RSI: 00007fffff6b3a00  RDI: 0000000000000003
    RBP: 0000000000000003   R8: 00007fffff6b39f0   R9: 000000000000000c
    R10: 0000000000000000  R11: 0000000000000293  R12: 0000000000000005
    R13: 00007fffff6ba3f0  R14: 00000000000003e9  R15: 0000000000000020
    ORIG_RAX: 000000000000002c  CS: 0033  SS: 002b

systemd                                    |auditd
-------------------------------------------+-----------------------------------
...                                        |
-> audit_receive                           |...
   -> mutex_lock(&audit_cmd_mutex)         |-> audit_receive
      ... -> audit_log_start               |   -> mutex_lock(&audit_cmd_mutex)
             -> wait_for_auditd            |      // wait for systemd
                -> schedule_timeout(60*HZ) |

zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz

V3 patch cannot fix the above problem. V3 patch only fixes the problem that audit_log_start
on auditd stops for 60 seconds in vain. The other problem is that auditd stops for 
about 60 seconds by the mutex lock which the other process gets.

If the other process is "systemd", changing V3 patch like the following fixes the other problem.
(I confirm that the new v3 patch can fix the other problem which I encountered on installed 
"systemd" environment.)
zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
@@ -1104,11 +1105,12 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	if (unlikely(audit_filter_type(type)))
 		return NULL;
 
-	if (gfp_mask & __GFP_WAIT)
-		reserve = 0;
-	else
-		reserve = 5; /* Allow atomic callers to go up to five
-				entries over the normal backlog limit */
+	if (gfp_mask & __GFP_WAIT) {
+		if (audit_pid && (current->pid == 1 || audit_pid == current->pid))
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+			gfp_mask &= ~__GFP_WAIT;
+		else
+			reserve = 0;
+	}
zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz

However, if the other process is not "systemd", another problem cannot be corrected by a 
simple correction. 
At present, a drastic method to fix the other problem doesn't occur to me. 

Regards,
Toshiyuki Okajima

> 
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 7b0e23a..10b4545 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -1095,7 +1095,9 @@ struct audit_buffer *audit_log_start(struct audit_context
>>         struct audit_buffer     *ab     = NULL;
>>         struct timespec         t;
>>         unsigned int            uninitialized_var(serial);
>> -       int reserve;
>> +       int reserve = 5; /* Allow atomic callers to go up to five
>> +                           entries over the normal backlog limit */
>> +
>>         unsigned long timeout_start = jiffies;
>>
>>         if (audit_initialized != AUDIT_INITIALIZED)
>> @@ -1104,11 +1106,12 @@ struct audit_buffer *audit_log_start(struct audit_contex
>>         if (unlikely(audit_filter_type(type)))
>>                 return NULL;
>>
>> -       if (gfp_mask & __GFP_WAIT)
>> -               reserve = 0;
>> -       else
>> -               reserve = 5; /* Allow atomic callers to go up to five
>> -                               entries over the normal backlog limit */
>> +       if (gfp_mask & __GFP_WAIT) {
>> +               if (audit_pid && audit_pid == current->pid)
>> +                       gfp_mask &= ~__GFP_WAIT;
>> +               else
>> +                       reserve = 0;
>> +       }
>>
>>         while (audit_backlog_limit
>>                && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserv
> 
> - RGB
> 
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer
> Kernel Security
> AMER ENG Base Operating Systems
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635
> Internal: (81) 32635
> Alt: +1.613.693.0684x3545
> 
> 


