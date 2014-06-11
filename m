Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbaFKSqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:46:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaFKSqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:46:49 -0400
Date: Wed, 11 Jun 2014 19:46:44 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
Message-ID: <20140611184644.GA5442@hercules>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
 <20140512003203.088027167@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140512003203.088027167@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

On Mon, May 12, 2014 at 02:32:59AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 

During Ubuntu Lucid kernel regression testing, after the merge of
2.6.32.62, we found problems with the following patches

[ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
           (Upstream commit 651e92716aaae60fc41b9652f54cb6803896e0da)

[ 065/143] net: check net.core.somaxconn sysctl values
           (Upstream commit 5f671d6b4ec3e6d66c2a868738af2cdea09e7509)

The following two stack traces were found in kernel logs:

[    0.199908] sysctl table check failed: /net/core/somaxconn .3.1.18 Missing strategy
[    0.201100] Pid: 1, comm: swapper Not tainted 2.6.32-02063262-generic #201405200837
[    0.202173] Call Trace:
[    0.202523]  [<ffffffff8108e419>] set_fail+0x59/0x60
[    0.203213]  [<ffffffff8108e74b>] sysctl_check_table+0x16b/0x4b0
[    0.204065]  [<ffffffff8108e75c>] sysctl_check_table+0x17c/0x4b0
[    0.204879]  [<ffffffff8108e75c>] sysctl_check_table+0x17c/0x4b0
[    0.205697]  [<ffffffff810712dd>] __register_sysctl_paths+0x11d/0x360
[    0.206709]  [<ffffffff8108e75c>] ? sysctl_check_table+0x17c/0x4b0
[    0.207552]  [<ffffffff81528af1>] register_net_sysctl_table+0x61/0x70
[    0.208425]  [<ffffffff814566d5>] sysctl_core_net_init+0x45/0xb0
[    0.209297]  [<ffffffff81455af8>] register_pernet_operations+0x48/0x100
[    0.210119]  [<ffffffff8187b6ee>] ? sysctl_core_init+0x0/0x38
[    0.210867]  [<ffffffff81455c5c>] register_pernet_subsys+0x2c/0x50
[    0.211699]  [<ffffffff8187b724>] sysctl_core_init+0x36/0x38
[    0.212448]  [<ffffffff8100a04c>] do_one_initcall+0x3c/0x1a0
[    0.213324]  [<ffffffff818446d1>] do_basic_setup+0x54/0x66
[    0.214563]  [<ffffffff818447f1>] kernel_init+0x10e/0x156
[    0.215766]  [<ffffffff810131ea>] child_rip+0xa/0x20
[    0.216882]  [<ffffffff818446e3>] ? kernel_init+0x0/0x156
[    0.218099]  [<ffffffff810131e0>] ? child_rip+0x0/0x20

and

[    0.398433] sysctl table check failed: /net/ipv4/ip_no_pmtu_disc .3.5.39 Missing strategy
[    0.398437] Pid: 1, comm: swapper Not tainted 2.6.32-02063262-generic #201405200837
[    0.398438] Call Trace:
[    0.398444]  [<ffffffff8108e419>] set_fail+0x59/0x60
[    0.398446]  [<ffffffff8108e74b>] sysctl_check_table+0x16b/0x4b0
[    0.398447]  [<ffffffff8108e75c>] sysctl_check_table+0x17c/0x4b0
[    0.398449]  [<ffffffff8108e75c>] sysctl_check_table+0x17c/0x4b0
[    0.398452]  [<ffffffff810712dd>] __register_sysctl_paths+0x11d/0x360
[    0.398455]  [<ffffffff811a21d8>] ? __proc_create+0xd8/0x130
[    0.398459]  [<ffffffff8187d106>] ? sysctl_ipv4_init+0x0/0x4e
[    0.398461]  [<ffffffff8107154b>] register_sysctl_paths+0x2b/0x30
[    0.398463]  [<ffffffff8187d122>] sysctl_ipv4_init+0x1c/0x4e
[    0.398466]  [<ffffffff8100a04c>] do_one_initcall+0x3c/0x1a0
[    0.398469]  [<ffffffff818446d1>] do_basic_setup+0x54/0x66
[    0.398470]  [<ffffffff818447f1>] kernel_init+0x10e/0x156
[    0.398473]  [<ffffffff810131ea>] child_rip+0xa/0x20
[    0.398474]  [<ffffffff818446e3>] ? kernel_init+0x0/0x156
[    0.398476]  [<ffffffff810131e0>] ? child_rip+0x0/0x20

and here's a bug link:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1326473

For the Ubuntu Lucid kernel, we ended up reverting the offending
commits.  Since I was able to reproduce this problem with a vanilla
2.6.32.62, you may want to take a similar action for the next 2.6.32
release.

Cheers,
--
Luís

> ------------------
> 
> From: Michal Tesar <mtesar@redhat.com>
> 
> [ Upstream commit 651e92716aaae60fc41b9652f54cb6803896e0da ]
> 
> Limit the min/max value passed to the
> /proc/sys/net/ipv4/tcp_syn_retries.
> 
> Signed-off-by: Michal Tesar <mtesar@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  net/ipv4/sysctl_net_ipv4.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 2dcf04d..910fa54 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -23,6 +23,8 @@
>  
>  static int zero;
>  static int tcp_retr1_max = 255;
> +static int tcp_syn_retries_min = 1;
> +static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
>  static int ip_local_port_range_min[] = { 1, 1 };
>  static int ip_local_port_range_max[] = { 65535, 65535 };
>  
> @@ -237,7 +239,9 @@ static struct ctl_table ipv4_table[] = {
>  		.data		= &ipv4_config.no_pmtu_disc,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &tcp_syn_retries_min,
> +		.extra2		= &tcp_syn_retries_max
>  	},
>  	{
>  		.ctl_name	= NET_IPV4_NONLOCAL_BIND,
> -- 
> 1.7.12.2.21.g234cd45.dirty
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
