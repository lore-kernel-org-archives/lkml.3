Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaH1Udv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:33:51 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42991 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaH1Udr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:33:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Kirby <sim@hostway.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20140820055855.GB5579@hostway.ca>
	<20140828192431.GF5001@linux.vnet.ibm.com>
	<20140828194422.GB8867@hostway.ca>
Date: Thu, 28 Aug 2014 15:33:42 -0500
In-Reply-To: <20140828194422.GB8867@hostway.ca> (Simon Kirby's message of
	"Thu, 28 Aug 2014 12:44:22 -0700")
Message-ID: <87oav4l5g9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/MgPXZu73mPfksONf8eVcVSKbNsXm9tB4=
X-SA-Exim-Connect-IP: 67.172.111.204
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Simon Kirby <sim@hostway.ca>
X-Spam-Relay-Country: 
Subject: Re: net_ns cleanup / RCU overhead
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Kirby <sim@hostway.ca> writes:

> On Thu, Aug 28, 2014 at 12:24:31PM -0700, Paul E. McKenney wrote:
>
>> On Tue, Aug 19, 2014 at 10:58:55PM -0700, Simon Kirby wrote:
>> > Hello!
>> > 
>> > In trying to figure out what happened to a box running lots of vsftpd
>> > since we deployed a CONFIG_NET_NS=y kernel to it, we found that the
>> > (wall) time needed for cleanup_net() to complete, even on an idle box,
>> > can be quite long:
>> > 
>> > #!/bin/bash
>> > 
>> > ip netns delete test >&/dev/null
>> > while ip netns add test; do
>> >         echo hi
>> >         ip netns delete test
>> > done
>> > 
>> > On my desktop and typical hosts, this prints at only around 4 or 6 per
>> > second. While this is happening, "vmstat 1" reports 100% idle, and there
>> > there are D-state processes with stacks similar to:
>> > 
>> > 30566 [kworker/u16:1] D wait_rcu_gp+0x48, synchronize_sched+0x2f, cleanup_net+0xdb, process_one_work+0x175, worker_thread+0x119, kthread+0xbb, ret_from_fork+0x7c, 0xffffffffffffffff
>> > 
>> > 32220 ip              D copy_net_ns+0x68, create_new_namespaces+0xfc, unshare_nsproxy_namespaces+0x66, SyS_unshare+0x159, system_call_fastpath+0x16, 0xffffffffffffffff
>> > 
>> > copy_net_ns() is waiting on net_mutex which is held by cleanup_net().
>> > 
>> > vsftpd uses CLONE_NEWNET to set up privsep processes. There is a comment
>> > about it being really slow before 2.6.35 (it avoids CLONE_NEWNET in that
>> > case). I didn't find anything that makes 2.6.35 any faster, but on Debian
>> > 2.6.36-5-amd64, I notice it does seem to be a bit faster than 3.2, 3.10,
>> > 3.16, though still not anything I'd ever want to rely on per connection.
>> > 
>> > C implementation of the above: http://0x.ca/sim/ref/tools/netnsloop.c
>> > 
>> > Kernel stack "top": http://0x.ca/sim/ref/tools/pstack
>> > 
>> > What's going on here?
>> 
>> That is a bit slow for many configurations, but there are some exceptions.
>> 
>> So, what is your kernel's .config?
>
> I was unable to find a config (or stock kernel) that was any different,
> but here's the one we're using: http://0x.ca/sim/ref/3.10/config-3.10.53
>
> How fast does the above test run for you?
>
> We've been running with the attached, which has helped a little, but it's
> still quite slow in our particular use case (vsftpd), and with the above
n> test. Should I enable RCU_TRACE or STALL_INFO with a low timeout or
> something?

I just want to add a little bit more analysis to this.

What we desire to be fast is the copy_net_ns, cleanup_net is batched and
asynchronous which nothing really cares how long it takes except that
cleanup_net holds the net_mutex and thus blocks copy_net_ns.

The puzzle is why and which rcu delays Simon is seeing in the network
namespace cleanup path, as it seems like the synchronize_rcu is not
the only one, and in the case of vsftp with trivail network namespaces
where nothing has been done we should not need to delay.

Eric


> Simon-
>
> -- >8 --
> Subject: [PATCH] netns: use synchronize_rcu_expedited instead of
>  synchronize_rcu
>
> Similar to ef323088, with synchronize_rcu(), we are only able to create
> and destroy about 4 or 7 net namespaces per second, which really puts a
> dent in the performance of programs attempting to use CLONE_NEWNET for
> privilege separation (vsftpd, chromium).
> ---
>  net/core/net_namespace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 85b6269..6dcb4b3 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -296,7 +296,7 @@ static void cleanup_net(struct work_struct *work)
>  	 * This needs to be before calling the exit() notifiers, so
>  	 * the rcu_barrier() below isn't sufficient alone.
>  	 */
> -	synchronize_rcu();
> +	synchronize_rcu_expedited();
>  
>  	/* Run all of the network namespace exit methods */
>  	list_for_each_entry_reverse(ops, &pernet_list, list)
