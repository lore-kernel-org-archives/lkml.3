Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaFLAZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:25:54 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47759 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaFLAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:25:53 -0400
MIME-Version: 1.0
In-Reply-To: <87bntzt24g.fsf@x220.int.ebiederm.org>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
	<874mzr41kf.fsf@x220.int.ebiederm.org>
	<20140611225228.GO4581@linux.vnet.ibm.com>
	<87ioo7vy5s.fsf@x220.int.ebiederm.org>
	<20140611234902.GQ4581@linux.vnet.ibm.com>
	<87bntzt24g.fsf@x220.int.ebiederm.org>
Date: Wed, 11 Jun 2014 21:25:52 -0300
Message-ID: <CAJE_dJzzj2uf+YEXhAngJDKev=Lc4O6fyKfHoO2PbzD90VuuVw@mail.gmail.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
From: Rafael Tinoco <rafael.tinoco@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chiluk <chiluk@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a kernel panic with your patch:

-- panic
-- mount_block_root
-- mount_root
-- prepare_namespace
-- kernel_init_freeable

It is giving me an unknown block device for the same config file i
used on other builds. Since my test is running on a kvm guest under a
ramdisk, i'm still checking if there are any differences between this
build and other ones but I think there aren't.

Any chances that "prepare_namespace" might be breaking mount_root ?

Tks

On Wed, Jun 11, 2014 at 9:14 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>
>> On Wed, Jun 11, 2014 at 04:12:15PM -0700, Eric W. Biederman wrote:
>>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>>>
>>> > On Wed, Jun 11, 2014 at 01:46:08PM -0700, Eric W. Biederman wrote:
>>> >> On the chance it is dropping the old nsproxy which calls syncrhonize_rcu
>>> >> in switch_task_namespaces that is causing you problems I have attached
>>> >> a patch that changes from rcu_read_lock to task_lock for code that
>>> >> calls task_nsproxy from a different task.  The code should be safe
>>> >> and it should be an unquestions performance improvement but I have only
>>> >> compile tested it.
>>> >>
>>> >> If you can try the patch it will tell is if the problem is the rcu
>>> >> access in switch_task_namespaces (the only one I am aware of network
>>> >> namespace creation) or if the problem rcu case is somewhere else.
>>> >>
>>> >> If nothing else knowing which rcu accesses are causing the slow down
>>> >> seem important at the end of the day.
>>> >>
>>> >> Eric
>>> >>
>>> >
>>> > If this is the culprit, another approach would be to use workqueues from
>>> > RCU callbacks.  The following (untested, probably does not even build)
>>> > patch illustrates one such approach.
>>>
>>> For reference the only reason we are using rcu_lock today for nsproxy is
>>> an old lock ordering problem that does not exist anymore.
>>>
>>> I can say that in some workloads setns is a bit heavy today because of
>>> the synchronize_rcu and setns is more important that I had previously
>>> thought because pthreads break the classic unix ability to do things in
>>> your process after fork() (sigh).
>>>
>>> Today daemonize is gone, and notify the parent process with a signal
>>> relies on task_active_pid_ns which does not use nsproxy.  So the old
>>> lock ordering problem/race is gone.
>>>
>>> The description of what was happening when the code switched from
>>> task_lock to rcu_read_lock to protect nsproxy.
>>
>> OK, never mind, then!  ;-)
>
> I appreciate you posting your approach.  I just figured I should do
> my homework, and verify my fuzzy memory.
>
> Who knows there might be different performance problems with my
> approach.  But I am hoping this is one of those happy instances where we
> can just make everything simpler.
>
> Eric



-- 
-- 
Rafael David Tinoco
Software Sustaining Engineer @ Canonical
Canonical Technical Services Engineering Team
# Email: rafael.tinoco@canonical.com (GPG: 87683FC0)
# Phone: +55.11.9.6777.2727 (Americas/Sao_Paulo)
# LP: ~inaddy | IRC: tinoco | Skype: rafael.tinoco
