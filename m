Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3I3RiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:38:21 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:59963 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754637Ab3I3RiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:38:20 -0400
X-TM-IMSS-Message-ID: <515d04db0001b811@nsa.gov>
Message-ID: <5249B6F1.4050507@tycho.nsa.gov>
Date: Mon, 30 Sep 2013 13:37:53 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        eparis@redhat.com, james.l.morris@oracle.com,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] conditionally reschedule while loading selinux policy.
References: <20130916173036.GA17950@redhat.com> <52374350.1090403@tycho.nsa.gov> <20130916184030.GA15800@redhat.com> <20130930172447.GA10562@redhat.com>
In-Reply-To: <20130930172447.GA10562@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 01:24 PM, Dave Jones wrote:
> On Mon, Sep 16, 2013 at 02:40:30PM -0400, Dave Jones wrote:
>  > On a slow machine (with debugging enabled), upgrading selinux policy may take
>  > a considerable amount of time. Long enough that the softlockup detector
>  > gets triggered.
>  > 
>  > The backtrace looks like this..
>  > 
>  >  > BUG: soft lockup - CPU#2 stuck for 23s! [load_policy:19045]
>  >  > Call Trace:
>  >  >  [<ffffffff81221ddf>] symcmp+0xf/0x20
>  >  >  [<ffffffff81221c27>] hashtab_search+0x47/0x80
>  >  >  [<ffffffff8122e96c>] mls_convert_context+0xdc/0x1c0
>  >  >  [<ffffffff812294e8>] convert_context+0x378/0x460
>  >  >  [<ffffffff81229170>] ? security_context_to_sid_core+0x240/0x240
>  >  >  [<ffffffff812221b5>] sidtab_map+0x45/0x80
>  >  >  [<ffffffff8122bb9f>] security_load_policy+0x3ff/0x580
>  
> With that patch applied, the problem seems to have moved elsewhere..
> 
> BUG: soft lockup - CPU#3 stuck for 22s! [load_policy:8119]
>  irq event stamp: 1590886
>  hardirqs last  enabled at (1590885): [<ffffffff8152c3dd>] __slab_alloc.constprop.78+0x4c0/0x4d7
>  hardirqs last disabled at (1590886): [<ffffffff8153e06a>] apic_timer_interrupt+0x6a/0x80
>  softirqs last  enabled at (1590336): [<ffffffff810480d9>] __do_softirq+0x169/0x200
>  softirqs last disabled at (1590331): [<ffffffff8104839d>] irq_exit+0x11d/0x140
>  RIP: 0010:[<ffffffff81223182>]  [<ffffffff81223182>] hashtab_insert+0x62/0x110
> 
> Call Trace:
>  [<ffffffff812283b5>] policydb_read+0xc25/0x1200
>  [<ffffffff810b1639>] ? is_module_text_address+0x19/0x40
>  [<ffffffff8122cefe>] security_load_policy+0x10e/0x580
>  [<ffffffff81078878>] ? sched_clock_cpu+0xa8/0x100
>  [<ffffffff810786ad>] ? sched_clock_local+0x1d/0x80
>  [<ffffffff81078878>] ? sched_clock_cpu+0xa8/0x100
>  [<ffffffff810786ad>] ? sched_clock_local+0x1d/0x80
>  [<ffffffff81078878>] ? sched_clock_cpu+0xa8/0x100
>  [<ffffffff8103098a>] ? __change_page_attr_set_clr+0x82a/0xa50
>  [<ffffffff81078878>] ? sched_clock_cpu+0xa8/0x100
>  [<ffffffff8153669c>] ? retint_restore_args+0xe/0xe
>  [<ffffffff810a196d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
>  [<ffffffff8127b07e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff810d2958>] ? rcu_irq_exit+0x68/0xb0
>  [<ffffffff8153669c>] ? retint_restore_args+0xe/0xe
>  [<ffffffff8121ff97>] sel_write_load+0xa7/0x770
>  [<ffffffff811394c3>] ? vfs_write+0x1c3/0x200
>  [<ffffffff812124de>] ? security_file_permission+0x1e/0xa0
>  [<ffffffff811393bb>] vfs_write+0xbb/0x200
>  [<ffffffff81158337>] ? fget_light+0x397/0x4b0
>  [<ffffffff81139ab7>] SyS_write+0x47/0xa0
>  [<ffffffff8153d634>] tracesys+0xdd/0xe2
> 
> We're holding a bunch of locks here, so we can't just cond_resched.  Thoughts ?

Sorry, what locks are we holding there?  You ought to be able to do a
cond_resched() anywhere during policydb_read() AFAIK; it is loading the
policy into a new structure that isn't being accessed by anything else
yet and the policy_rwlock is only held by security_load_policy after
calling policydb_read and only to switch it into place as the active
policydb.
