Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3IHV0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 17:26:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60299 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3IHVZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 17:25:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com>
	<20130830144232.GA18281@mail.hallyn.com>
	<87hae6vh0w.fsf_-_@xmission.com> <20130908175602.GA3172@redhat.com>
	<20130908180137.GA4915@redhat.com>
Date: Sun, 08 Sep 2013 14:25:50 -0700
In-Reply-To: <20130908180137.GA4915@redhat.com> (Oleg Nesterov's message of
	"Sun, 8 Sep 2013 20:01:37 +0200")
Message-ID: <87bo43gg4h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX186QBkmYNgQRXbbga8JDd25K1vuCZsI1gY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2954]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: free_pid() && PIDNS_HASH_ADDING
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 09/08, Oleg Nesterov wrote:
>>
>> Off topic. What if the first alloc_pid() succeeds and then later
>> copy_process() fails. In this case free_pid() is called but
>> PIDNS_HASH_ADDING was not cleared, we miss kern_unmount(), no?
>
> Perhaps something like below?

I am thinking more:

diff --git a/kernel/pid.c b/kernel/pid.c
index ab75add..ef59516 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -273,6 +273,10 @@ void free_pid(struct pid *pid)
                         */
                        wake_up_process(ns->child_reaper);
                        break;
+               case PIDNS_HASH_ADDING:
+                       /* Handle a fork failure of the first process */
+                       ns->nr_hashed = 0;
+                       /* fall through */
                case 0:
                        schedule_work(&ns->proc_work);
                        break;

At which point I ask myself what of the pathlogocical case where the
first fork fails but because we created the pid namespace with unshare
there is a concurrent fork from another process into the pid namespace
that succeeds.  Resulting in one pid in the pid namespace that is not
the reaper.

So we also need something like this.

@@ -324,6 +328,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
        spin_lock_irq(&pidmap_lock);
        if (!(ns->nr_hashed & PIDNS_HASH_ADDING))
                goto out_unlock;
+       if (!is_child_reaper(pid) && !ns->child_reaper)
+               goto out_unlock;
        for ( ; upid >= pid->numbers; --upid) {
                hlist_add_head_rcu(&upid->pid_chain,
                                &pid_hash[pid_hashfn(upid->nr, upid->ns)]);

but I think my locking is wrong to safely test ns->child_reaper.

Perhaps I should prevent setns if there is no reaper?

Ideas?

Eric
