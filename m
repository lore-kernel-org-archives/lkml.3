Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaFKU44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:56:56 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:36830 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaFKU4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:56:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: paulmck@linux.vnet.ibm.com
Cc: Dave Chiluk <chiluk@canonical.com>,
        Rafael Tinoco <rafael.tinoco@canonical.com>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
	<20140611194832.GL4581@linux.vnet.ibm.com>
Date: Wed, 11 Jun 2014 13:55:45 -0700
In-Reply-To: <20140611194832.GL4581@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Wed, 11 Jun 2014 12:48:32 -0700")
Message-ID: <87r42v2mjy.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18cZzwzRtHO78tX+O54wQC7VgH3OsS5/mU=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3640]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: Possible netns creation and execution performance/scalability regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Wed, Jun 11, 2014 at 01:27:07PM -0500, Dave Chiluk wrote:
>> On 06/11/2014 11:18 AM, Paul E. McKenney wrote:
>> > On Wed, Jun 11, 2014 at 10:46:00AM -0500, David Chiluk wrote:
>> >> Now think about what happens when a gateway goes down, the namespaces
>> >> need to be migrated, or a new machine needs to be brought up to replace
>> >> it.  When we're talking about 3000 namespaces, the amount of time it
>> >> takes simply to recreate the namespaces becomes very significant.
>> >>
>> >> The script is a stripped down example of what exactly is being done on
>> >> the neutron gateway in order to create namespaces.
>> > 
>> > Are the namespaces torn down and recreated one at a time, or is there some
>> > syscall, ioctl(), or whatever that allows bulk tear down and recreating?
>> > 
>> > 							Thanx, Paul
>> 
>> In the normal running case, the namespaces are created one at a time, as
>> new customers create a new set of VMs on the cloud.
>> 
>> However, in the case of failover to a new neutron gateway the namespaces
>> are created all at once using the ip command (more or less serially).
>> 
>> As far as I know there is no syscall or ioctl that allows bulk tear down
>> and recreation.  if such a beast exists that might be helpful.
>
> The solution might be to create such a beast.  I might be able to shave
> a bit of time off of this benchmark, but at the cost of significant
> increases in RCU's CPU consumption.  A bulk teardown/recreation API could
> reduce the RCU grace-period overhead by several orders of magnitude by
> having a single RCU grace period cover a few thousand changes.
>
> This is why other bulk-change syscalls exist.
>
> Just out of curiosity, what syscalls does the ip command use?

You can look in iproute2 ip/ipnetns.c

But rought ip netns add does:

unshare(CLONE_NEWNET);
mkdir /var/run/netns/<name>
mount --bind /proc/self/ns/net /var/run/netns/<name>

I don't know if there is any sensible way to batch that work.

(The unshare gets you into copy_net_ns in net/core/net_namespace.c
 and to find all of the code it can call you have to trace all
 of the register_pernet_subsys and register_pernet_device calls).

At least for creation I would like to see if we can make all of the
rcu_callback synchronize_rcu calls go away.  That seems preferable
to batching at creation time.

Eric
