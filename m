Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaA0NVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:21:44 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:33168 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaA0NVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:21:42 -0500
Message-ID: <52E65D62.9020504@6wind.com>
Date: Mon, 27 Jan 2014 14:21:38 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, stable <stable@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC: Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [BUG - v3.10.27] sit: Bad list pointer
References: <20140125133600.7482d428@gandalf.local.home>
In-Reply-To: <20140125133600.7482d428@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 25/01/2014 19:36, Steven Rostedt a écrit :
> On 3.10.27, loading and then unloading the sit module gives me the
> following bug:
>
> [   35.400878] sit: IPv6 over IPv4 tunneling driver
> [   36.959308] ------------[ cut here ]------------
> [   36.963983] WARNING: at /home/rostedt/work/git/linux-rt.git/lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
> [   36.973874] list_del corruption. prev->next should be ffff88011656d070, but was ffff880115fe5ea8
> [   36.982684] Modules linked in: sit(-) ip_tunnel tunnel4 bnep lockd bluetooth nf_conntrack_ipv4 ip6t_REJECT nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec tpm_infineon snd_hwdep hp_wmi rfkill tpm_tis tpm coretemp snd_seq lpc_ich snd_seq_device snd_pcm sparse_keymap uinput serio_raw pcspkr mfd_core tpm_bios i2c_i801 microcode wmi snd_page_alloc snd_timer snd soundcore i915 e1000e i2c_algo_bit ptp drm_kms_helper crc32c_intel drm pps_core i2c_core video sunrpc
> [   37.034430] CPU: 0 PID: 1071 Comm: rmmod Not tainted 3.10.27-test #143
> [   37.040972] Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
> [   37.049962]  ffffffff81a10e78 ffff880115fe5d18 ffffffff8161b3c7 ffff880115fe5d58
> [   37.057439]  ffffffff8104b2a0 ffff880115fe5dd8 ffff880115fe5df8 ffff88011656d070
> [   37.064911]  0000000000000080 0000000000000018 ffff880115cb4000 ffff880115fe5db8
> [   37.072405] Call Trace:
> [   37.074869]  [<ffffffff8161b3c7>] dump_stack+0x19/0x1b
> [   37.080031]  [<ffffffff8104b2a0>] warn_slowpath_common+0x70/0xa0
> [   37.086051]  [<ffffffff8104b386>] warn_slowpath_fmt+0x46/0x50
> [   37.091814]  [<ffffffff812f56a1>] __list_del_entry+0xa1/0xd0
> [   37.097491]  [<ffffffff815168a5>] unregister_netdevice_queue+0x35/0xa0
> [   37.104036]  [<ffffffffa038df82>] sit_exit_net+0xc2/0xf0 [sit]
> [   37.109893]  [<ffffffff81511278>] ops_exit_list.isra.4+0x38/0x60
> [   37.115917]  [<ffffffff815113d0>] unregister_pernet_operations+0x70/0xb0
> [   37.122633]  [<ffffffff8151143e>] unregister_pernet_device+0x2e/0x60
> [   37.129005]  [<ffffffffa038f86f>] sit_cleanup+0x2d/0x7be [sit]
> [   37.134864]  [<ffffffff810b0aee>] SyS_delete_module+0x19e/0x2a0
> [   37.140801]  [<ffffffff8162983b>] tracesys+0xdd/0xe2
> [   37.145779] ---[ end trace e45e22e840e55d00 ]---
> [   37.150427] ------------[ cut here ]------------
>
> Investigating differences between 3.10.27 and newer kernels, I found
> that the below change is not there. It was part of commit 205983c43700
> "sit: allow to use rtnl ops on fb tunnel" which happens to be
> backported to 3.10 but in 3.10 backport commit 20300db1bd1b9 this part
> of the commit is missing.
Thank you for fixing this. It's the same problem that commit 22c3ec552c29
("ip6tnl: fix use after free of fb_tnl_dev", branch linux-3.10.y).

The upstream commit 205983c43700 ("sit: allow to use rtnl ops on fb tunnel")
(backported into linux-3.10.y) left a bug which was fixed upstream by commit
9434266f2c64 ("sit: fix use after free of fb_tunnel_dev").

The problem is a bit different in linux-3.10.y, because there is no x-netns
support (upstream commit 5e6700b3bf98 ("sit: add support of x-netns")).
When sit.ko is unloaded, FB device is deleted by rtnl_link_unregister()
and then we try to delete it again in sit_exit_net().

>
> When I add this change, the removing of the module no longer gives this
> bug.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

>
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index 0491264..02300e8 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1592,7 +1592,6 @@ static void __net_exit sit_exit_net(struct net *net)
>
>   	rtnl_lock();
>   	sit_destroy_tunnels(sitn, &list);
> -	unregister_netdevice_queue(sitn->fb_tunnel_dev, &list);
>   	unregister_netdevice_many(&list);
>   	rtnl_unlock();
>   }
>
