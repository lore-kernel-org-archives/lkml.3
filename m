Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab3LIIPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:15:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3LIIPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:15:30 -0500
Date: Sun, 8 Dec 2013 16:25:31 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Clark Williams <williams@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [BUG] stable v3.10.16+ introduced by "ip6tnl: allow to use rtnl
 ops on fb tunnel"
Message-ID: <20131209002531.GB14382@kroah.com>
References: <20131113211430.1ad3bb7d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113211430.1ad3bb7d@gandalf.local.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 09:14:30PM -0500, Steven Rostedt wrote:
> In our test labs we discovered a bug with the latest 3.10-rt kernel.
> When investigating, I found that it was actually a bug in the 3.10.18
> kernel that we based on. With that, I bisected it down to this commit:
> 
> commit 506cdb8909a1a739c7585c680c6bd4b3d1247564
> Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Date:   Tue Oct 1 18:05:00 2013 +0200
> 
>     ip6tnl: allow to use rtnl ops on fb tunnel
>     
>     [ Upstream commit bb8140947a247b9aa15652cc24dc555ebb0b64b0 ]
>     
>     rtnl ops where introduced by c075b13098b3 ("ip6tnl: advertise tunnel param
>     rtnl"), but I forget to assign rtnl ops to fb tunnels.
>     
>     Now that it is done, we must remove the explicit call to
>     unregister_netdevice_queue(), because  the fallback tunnel is added to the
>     in ip6_tnl_destroy_tunnels() when checking rtnl_link_ops of all netdevices
>     is valid since commit 0bd8762824e7 ("ip6tnl: add x-netns support")).
> 
> 
> The bug we see is caused by simply loading and unloading the ip6_tunnel
> module.
> 
> 	modprobe ip6_tunnel; rmmod ip6_tunnel
> 
> Which causes the following oops:
> 
> [   43.423028] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [   43.424010] IP: [<ffffffffa0534f51>] ip6_tnl_exit_net+0x71/0x93 [ip6_tunnel]
> [   43.424010] PGD 776f4067 PUD 7810a067 PMD 0 
> [   43.424010] Oops: 0000 [#1] PREEMPT SMP 
> [   43.424010] Modules linked in: ip6_tunnel(-) tunnel6 ipt_MASQUERADE sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables uinput snd_hda_codec_idt kvm_i
> ntel snd_hda_intel snd_hda_codec kvm snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd shpchp i2c_i801 soundcore microcode pata_acpi firewire_ohci firewire_core
>  crc_itu_t ata_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
> [   43.424010] CPU: 1 PID: 2731 Comm: rmmod Not tainted 3.10.15-test+ #105
> [   43.424010] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
> [   43.424010] task: ffff880078b01460 ti: ffff880077bf4000 task.ti: ffff880077bf4000
> [   43.424010] RIP: 0010:[<ffffffffa0534f51>]  [<ffffffffa0534f51>] ip6_tnl_exit_net+0x71/0x93 [ip6_tunnel]
> [   43.424010] RSP: 0018:ffff880077bf5e08  EFLAGS: 00010246
> [   43.424010] RAX: 0000000000000000 RBX: 0000000000000100 RCX: 0000000000000003
> [   43.424010] RDX: ffff88007d480000 RSI: ffff880077bf5e08 RDI: ffff880077bf4000
> [   43.424010] RBP: ffff880077bf5e38 R08: ffff880077bf5d68 R09: ffffffff81aa20d0
> [   43.424010] R10: ffffffff81aa20d0 R11: ffffffff81aa20d0 R12: 0000000000000000
> [   43.424010] R13: ffff88007794b400 R14: ffff880077bf5e08 R15: 0000000000000001
> [   43.424010] FS:  00007fbc2ee27700(0000) GS:ffff88007d480000(0000) knlGS:0000000000000000
> [   43.424010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   43.424010] CR2: 0000000000000008 CR3: 0000000077bd0000 CR4: 00000000000007e0
> [   43.424010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   43.424010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   43.424010] Stack:
> [   43.424010]  ffff880077bf5e08 ffff880077bf5e08 ffffffffa0536f50 ffffffff81aa0900
> [   43.424010]  ffff880077bf5e78 0000000000000000 ffff880077bf5e68 ffffffff81408df4
> [   43.424010]  0000000000000000 ffffffffa0536f50 ffffffff81aa1820 ffff880077bf5e78
> [   43.424010] Call Trace:
> [   43.424010]  [<ffffffff81408df4>] ops_exit_list+0x27/0x50
> [   43.424010]  [<ffffffff814090ba>] unregister_pernet_operations+0x61/0x93
> [   43.424010]  [<ffffffff81409122>] unregister_pernet_device+0x36/0x47
> [   43.424010]  [<ffffffffa05367d4>] ip6_tunnel_cleanup+0x70/0x72 [ip6_tunnel]
> [   43.424010]  [<ffffffff81083ef5>] SyS_delete_module+0x20b/0x27d
> [   43.424010]  [<ffffffff81244cae>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> [   43.424010]  [<ffffffff81503902>] system_call_fastpath+0x16/0x1b
> [   43.424010] Code: 24 08 4c 89 f6 e8 8c 88 ed e0 4d 8b 24 24 4d 85 e4 75 ea 48 83 c3 08 48 81 fb 00 01 00 00 75 d6 49 8b 85 08 01 00 00 48 8d 75 d0 <48> 8b 78 08 e8 62 88 ed e0 48 8d 7d d0 e8 84 77 ed e0 e8 90 62 
> [   43.424010] RIP  [<ffffffffa0534f51>] ip6_tnl_exit_net+0x71/0x93 [ip6_tunnel]
> [   43.424010]  RSP <ffff880077bf5e08>
> [   43.424010] CR2: 0000000000000008
> [   43.708059] ---[ end trace ea2c125633de7c64 ]---
> 
> 
> (gdb) li *ip6_tnl_exit_net+0x71
> 0xf51 is in ip6_tnl_exit_net (/home/rostedt/work/git/linux-trace.git/net/ipv6/ip6_tunnel.c:1715).
> 1710                            t = rtnl_dereference(t->next);
> 1711                    }
> 1712            }
> 1713
> 1714            t = rtnl_dereference(ip6n->tnls_wc[0]);
> 1715            unregister_netdevice_queue(t->dev, &list);
> 1716            unregister_netdevice_many(&list);
> 1717    }
> 1718
> 1719    static int __net_init ip6_tnl_init_net(struct net *net)
> 
> Thus, this got called with ip6n->tnsl_wc[0] as NULL.
> 
> I ran the following trace command on this:
> 
> # modprobe ip6_tunnel
> # trace-cmd start -p function_graph -g SyS_delete_module
> # rmmod ip6_tunnel
> 
> and traced the flow of functions that lead up to the crash: Full dump
> can be found here: http://rostedt.homelinux.com/private/ip6_tunnel.trace
> 
> 
> ip6_tnl_dev_uninit() which is called by rollback_registered_many() sets
> tnls_wc[0] to NULL. Later unregistered_pernet_device() gets called,
> which eventually calls ip6_tnl_exit_net() which references the
> tnls_wc[0] unconditionally. This looks to be where the bug happens.
> 
> Finally, after digging through all this, I looked at the original
> commit that was backported to 3.10 and noticed that the backport
> doesn't include the entire change. It also has:
> 
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1731,8 +1731,6 @@ static void __net_exit ip6_tnl_destroy_tunnels(struct ip
>                 }
>         }
>  
> -       t = rtnl_dereference(ip6n->tnls_wc[0]);
> -       unregister_netdevice_queue(t->dev, &list);
>         unregister_netdevice_many(&list);
>  }
>  
> 
> Which, when applied to 3.10.18, fixes the bug. Was there a reason that
> this part of the commit wasn't backported? or was this just an oversight?

It looks like it was left out to me as well.

David, any objection to me making this fixup in the 3.10-stable tree?

thanks,

greg k-h
