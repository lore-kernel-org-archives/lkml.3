Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaLALp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:45:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaLALp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:45:27 -0500
Date: Mon, 1 Dec 2014 11:45:22 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 22/48] net: sendmsg: fix NULL pointer dereference
Message-ID: <20141201114522.GC6874@hercules>
References: <28c765bc23bd4bae1611534e510f49f8@local>
 <20141116215329.569150542@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141116215329.569150542@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 10:53:50PM +0100, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> 
> [ Upstream commit 40eea803c6b2cfaab092f053248cbeab3f368412 ]
> 
> Sasha's report:
> 	> While fuzzing with trinity inside a KVM tools guest running the latest -next
> 	> kernel with the KASAN patchset, I've stumbled on the following spew:
> 	>
> 	> [ 4448.949424] ==================================================================
> 	> [ 4448.951737] AddressSanitizer: user-memory-access on address 0
> 	> [ 4448.952988] Read of size 2 by thread T19638:
> 	> [ 4448.954510] CPU: 28 PID: 19638 Comm: trinity-c76 Not tainted 3.16.0-rc4-next-20140711-sasha-00046-g07d3099-dirty #813
> 	> [ 4448.956823]  ffff88046d86ca40 0000000000000000 ffff880082f37e78 ffff880082f37a40
> 	> [ 4448.958233]  ffffffffb6e47068 ffff880082f37a68 ffff880082f37a58 ffffffffb242708d
> 	> [ 4448.959552]  0000000000000000 ffff880082f37a88 ffffffffb24255b1 0000000000000000
> 	> [ 4448.961266] Call Trace:
> 	> [ 4448.963158] dump_stack (lib/dump_stack.c:52)
> 	> [ 4448.964244] kasan_report_user_access (mm/kasan/report.c:184)
> 	> [ 4448.965507] __asan_load2 (mm/kasan/kasan.c:352)
> 	> [ 4448.966482] ? netlink_sendmsg (net/netlink/af_netlink.c:2339)
> 	> [ 4448.967541] netlink_sendmsg (net/netlink/af_netlink.c:2339)
> 	> [ 4448.968537] ? get_parent_ip (kernel/sched/core.c:2555)
> 	> [ 4448.970103] sock_sendmsg (net/socket.c:654)
> 	> [ 4448.971584] ? might_fault (mm/memory.c:3741)
> 	> [ 4448.972526] ? might_fault (./arch/x86/include/asm/current.h:14 mm/memory.c:3740)
> 	> [ 4448.973596] ? verify_iovec (net/core/iovec.c:64)
> 	> [ 4448.974522] ___sys_sendmsg (net/socket.c:2096)
> 	> [ 4448.975797] ? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> 	> [ 4448.977030] ? lock_release_holdtime (kernel/locking/lockdep.c:273)
> 	> [ 4448.978197] ? lock_release_non_nested (kernel/locking/lockdep.c:3434 (discriminator 1))
> 	> [ 4448.979346] ? check_chain_key (kernel/locking/lockdep.c:2188)
> 	> [ 4448.980535] __sys_sendmmsg (net/socket.c:2181)
> 	> [ 4448.981592] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
> 	> [ 4448.982773] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
> 	> [ 4448.984458] ? syscall_trace_enter (arch/x86/kernel/ptrace.c:1500 (discriminator 2))
> 	> [ 4448.985621] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
> 	> [ 4448.986754] SyS_sendmmsg (net/socket.c:2201)
> 	> [ 4448.987708] tracesys (arch/x86/kernel/entry_64.S:542)
> 	> [ 4448.988929] ==================================================================
> 
> This reports means that we've come to netlink_sendmsg() with msg->msg_name == NULL and msg->msg_namelen > 0.
> 
> After this report there was no usual "Unable to handle kernel NULL pointer dereference"
> and this gave me a clue that address 0 is mapped and contains valid socket address structure in it.
> 
> This bug was introduced in f3d3342602f8bcbf37d7c46641cb9bca7618eb1c
> (net: rework recvmsg handler msg_name and msg_namelen logic).
> Commit message states that:
> 	"Set msg->msg_name = NULL if user specified a NULL in msg_name but had a
> 	 non-null msg_namelen in verify_iovec/verify_compat_iovec. This doesn't
> 	 affect sendto as it would bail out earlier while trying to copy-in the
> 	 address."
> But in fact this affects sendto when address 0 is mapped and contains
> socket address structure in it. In such case copy-in address will succeed,
> verify_iovec() function will successfully exit with msg->msg_namelen > 0
> and msg->msg_name == NULL.
> 
> This patch fixes it by setting msg_namelen to 0 if msg_name == NULL.
> 
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: <stable@vger.kernel.org>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  net/compat.c     | 9 +++++----
>  net/core/iovec.c | 6 +++---
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/net/compat.c b/net/compat.c
> index e9672c8..71ed839 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -83,7 +83,7 @@ int verify_compat_iovec(struct msghdr *kern_msg, struct iovec *kern_iov,
>  {
>  	int tot_len;
>  
> -	if (kern_msg->msg_namelen) {
> +	if (kern_msg->msg_namelen && kern_msg->msg_namelen) {

I know my review is already too late for the release, but the above
line isn't correct -- it's checking msg_namelen twice, instead of
checking msg_name as well:

	if (kern_msg->msg_name && kern_msg->msg_namelen)

Cheers,
--
Luís

>  		if (mode==VERIFY_READ) {
>  			int err = move_addr_to_kernel(kern_msg->msg_name,
>  						      kern_msg->msg_namelen,
> @@ -91,10 +91,11 @@ int verify_compat_iovec(struct msghdr *kern_msg, struct iovec *kern_iov,
>  			if (err < 0)
>  				return err;
>  		}
> -		if (kern_msg->msg_name)
> -			kern_msg->msg_name = kern_address;
> -	} else
> +		kern_msg->msg_name = kern_address;
> +	} else {
>  		kern_msg->msg_name = NULL;
> +		kern_msg->msg_namelen = 0;
> +	}
>  
>  	tot_len = iov_from_user_compat_to_kern(kern_iov,
>  					  (struct compat_iovec __user *)kern_msg->msg_iov,
> diff --git a/net/core/iovec.c b/net/core/iovec.c
> index 39369e9..3face24 100644
> --- a/net/core/iovec.c
> +++ b/net/core/iovec.c
> @@ -40,17 +40,17 @@ int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address,
>  {
>  	int size, ct, err;
>  
> -	if (m->msg_namelen) {
> +	if (m->msg_name && m->msg_namelen) {
>  		if (mode == VERIFY_READ) {
>  			err = move_addr_to_kernel(m->msg_name, m->msg_namelen,
>  						  address);
>  			if (err < 0)
>  				return err;
>  		}
> -		if (m->msg_name)
> -			m->msg_name = address;
> +		m->msg_name = address;
>  	} else {
>  		m->msg_name = NULL;
> +		m->msg_namelen = 0;
>  	}
>  
>  	size = m->msg_iovlen * sizeof(struct iovec);
> -- 
> 1.7.12.2.21.g234cd45.dirty
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
