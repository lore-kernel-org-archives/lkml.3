Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3JKCGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 22:06:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52744 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048Ab3JKCGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 22:06:43 -0400
X-Sasl-enc: k9+uw28CLEEaqwHPStUFEmZrXN1Viwh3bLJwLFxxtQJm 1381457201
Message-ID: <1381457199.2631.3.camel@perseus.fritz.box>
Subject: Re: NULL pointer dereference in autofs4_expire_wait
From: Ian Kent <raven@themaw.net>
To: David Ahern <dsahern@gmail.com>
Cc: autofs@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 10:06:39 +0800
In-Reply-To: <525736C7.9080400@gmail.com>
References: <525736C7.9080400@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 17:22 -0600, David Ahern wrote:
> Running 3.12-rc3 just hit BUG in autofs4_expire_wait

It doesn't look like this could be due to Al's change to the locking in
autos4_wait() and that the only change to autofs that I'm aware of.

Could you do a bisect please?

> 
> [787422.065405] BUG: unable to handle kernel NULL pointer dereference at 
> 0000000000000010
> [787422.065567] IP: [<ffffffff812722d8>] autofs4_expire_wait+0x38/0x120
> [787422.065659] PGD 163bdb067 PUD 163bbc067 PMD 0
> [787422.065744] Oops: 0000 [#1] SMP
> [787422.065825] Modules linked in: binfmt_misc nfsv3 rpcsec_gss_krb5 
> nfsv4 dns_resolver nfs fscache bridge stp llc ipt_MASQUERADE xt_nat 
> iptable_nat nf_nat_ipv4 nf_nat xt_physdev nf_conntrack_ipv4 
> nf_defrag_ipv4 xt_state nf_conntrack xt_multiport nfsd lockd nfs_acl 
> auth_rpcgss sunrpc ipmi_si ipmi_msghandler vhost_net iTCO_wdt macvtap 
> macvlan vhost iTCO_vendor_support pcspkr i7core_edac lpc_ich mfd_core 
> tun edac_core bnx2 hpwdt microcode acpi_power_meter oid_registry 
> kvm_intel kvm usb_storage hpsa ttm drm_kms_helper drm i2c_algo_bit i2c_core
> [787422.066557] CPU: 10 PID: 20498 Comm: sed Not tainted 3.12.0-rc3+ #8
> [787422.066640] Hardware name: HP ProLiant DL380 G6, BIOS P62 05/05/2011
> [787422.066722] task: ffff88030e941790 ti: ffff880182a16000 task.ti: 
> ffff880182a16000
> [787422.066872] RIP: 0010:[<ffffffff812722d8>]  [<ffffffff812722d8>] 
> autofs4_expire_wait+0x38/0x120
> [787422.067029] RSP: 0000:ffff880182a17aa8  EFLAGS: 00010246
> [787422.067121] RAX: 00000000b1acb1ac RBX: ffff8802e1056a80 RCX: 
> 0000000000000010
> [787422.067270] RDX: 000000000000b1ac RSI: ffffffff81c3e3e0 RDI: 
> ffff88060e187d98
> [787422.067457] RBP: ffff880182a17ad8 R08: 0000000000000000 R09: 
> ffffffff811a5748
> [787422.067607] R10: ff030306ff030001 R11: ffffffffffffffff R12: 
> ffff88060e187d00
> [787422.067758] R13: 0000000000000000 R14: 0000000000637461 R15: 
> ffff8802e1056a80
> [787422.067909] FS:  0000000000000000(0000) GS:ffff880313ca0000(0000) 
> knlGS:0000000000000000
> [787422.068061] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [787422.068141] CR2: 0000000000000010 CR3: 000000010f106000 CR4: 
> 00000000000027e0
> [787422.068302] Stack:
> [787422.068414]  ffff880182a17af8 ffffffff810768fe 0000000000000100 
> ffff8802e1056a80
> [787422.068575]  ffff88060e187dc0 ffff88060e187dc0 ffff880182a17b48 
> ffffffff8126f5fc
> [787422.068736]  0000000000000000 ffff880192afb890 ffff8802e1056ab8 
> 0000000392afb890
> [787422.068896] Call Trace:
> [787422.068976]  [<ffffffff810768fe>] ? prepare_to_wait+0x5e/0x90
> [787422.069060]  [<ffffffff8126f5fc>] do_expire_wait+0x17c/0x190
> [787422.069142]  [<ffffffff8126f9a4>] autofs4_d_manage+0xb4/0x170
> [787422.069227]  [<ffffffff8119af4d>] follow_managed+0xcd/0x2c0
> [787422.069323]  [<ffffffff8162a3f3>] lookup_slow+0x7b/0xaa
> [787422.069441]  [<ffffffff8119c4fa>] link_path_walk+0x34a/0x8d0
> [787422.069524]  [<ffffffff811a67d1>] ? dput+0x31/0x1f0
> [787422.069606]  [<ffffffff811aeac9>] ? mntput_no_expire+0x49/0x140
> [787422.069690]  [<ffffffff8119c0bc>] ? path_init+0x30c/0x400
> [787422.069772]  [<ffffffff8119cad8>] path_lookupat+0x58/0x740
> [787422.069856]  [<ffffffff8117a153>] ? kmem_cache_alloc+0x1c3/0x200
> [787422.069939]  [<ffffffff8117a12d>] ? kmem_cache_alloc+0x19d/0x200
> [787422.071815]  [<ffffffff8119d1f4>] filename_lookup+0x34/0xc0
> [787422.071898]  [<ffffffff811a0a59>] user_path_at_empty+0x59/0xa0
> [787422.071981]  [<ffffffff811a0b73>] ? do_filp_open+0x43/0xa0
> [787422.072064]  [<ffffffff811a0ab1>] user_path_at+0x11/0x20
> [787422.072146]  [<ffffffff81195761>] vfs_fstatat+0x51/0xb0
> [787422.072228]  [<ffffffff8119588b>] vfs_stat+0x1b/0x20
> [787422.072311]  [<ffffffff8104d6ca>] sys32_stat64+0x1a/0x40
> [787422.072453]  [<ffffffff8118f74a>] ? do_sys_open+0x1aa/0x220
> [787422.072539]  [<ffffffff8163cf49>] ia32_do_call+0x13/0x13
> [787422.072619] Code: 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 48 8b 
> 47 68 4c 8b 6f 78 4c 8b a0 00 03 00 00 49 8d bc 24 98 00 00 00 e8 78 0d 
> 3c 00 <41> f6 45 10 01 74 61 66 41 83 84 24 98 00 00 00 01 f6 05 52 4a
> [787422.073004] RIP  [<ffffffff812722d8>] autofs4_expire_wait+0x38/0x120
> [787422.073089]  RSP <ffff880182a17aa8>
> [787422.073164] CR2: 0000000000000010
> [787422.073595] ---[ end trace c75e278f6383bf9a ]---


