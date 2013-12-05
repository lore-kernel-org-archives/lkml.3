Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab3LEODI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:03:08 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37759 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3LEODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:03:04 -0500
MIME-Version: 1.0
Date: Thu, 5 Dec 2013 09:03:02 -0500
X-Google-Sender-Auth: 7-JLEIawGcUa1ugjajUgwwR9Cig
Message-ID: <CA+5PVA5sEmrAbDfqeApnMdv1mGq8KJeKTdA09PrJtv1BST2iqQ@mail.gmail.com>
Subject: scatterlist.h backtrace from crypto ccm module
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a report [1] of the backtrace below on the latest rawhide
kernel, which is essentially Linus' tree as of yesterday.  We aren't
carrying any patches to crypto at the moment.  It's basically hitting
the second BUG_ON in the sg_page function:

static inline struct page *sg_page(struct scatterlist *sg)
{
#ifdef CONFIG_DEBUG_SG
        BUG_ON(sg->sg_magic != SG_MAGIC);
        BUG_ON(sg_is_chain(sg));
#endif
        return (struct page *)((sg)->page_link & ~0x3);
}

Any ideas on this one?

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1038472

josh

[   89.317139] ------------[ cut here ]------------
[   89.317210] kernel BUG at include/linux/scatterlist.h:99!
[   89.317272] invalid opcode: 0000 [#1] SMP
[   89.317326] Modules linked in: ccm ip6t_REJECT bnep bluetooth
xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter
ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
amd_freq_sensitivity kvm crct10dif_pclmul crc32_pclmul arc4
crc32c_intel rtl8188ee rtl_pci rtlwifi ghash_clmulni_intel mac80211
microcode snd_hda_codec_conexant cfg80211 joydev snd_hda_codec_hdmi
serio_raw alx snd_hda_intel edac_core edac_mce_amd mdio k10temp
fam15h_power snd_hda_codec snd_hwdep toshiba_acpi sparse_keymap
snd_seq rfkill snd_seq_device wmi snd_pcm snd_page_alloc snd_timer snd
shpchp soundcore video
[   89.318322]  i2c_piix4 acpi_cpufreq binfmt_misc radeon i2c_algo_bit
drm_kms_helper ttm drm i2c_core
[   89.318441] CPU: 3 PID: 809 Comm: cryptomgr_test Not tainted
3.13.0-0.rc2.git3.1.fc21.x86_64 #1
[   89.318535] Hardware name: TOSHIBA Satellite L75D-A/Larne, BIOS
1.10 05/16/2013
[   89.318616] task: ffff88003725cd70 ti: ffff880192ef2000 task.ti:
ffff880192ef2000
[   89.318697] RIP: 0010:[<ffffffff81335a1e>]  [<ffffffff81335a1e>]
scatterwalk_pagedone+0xbe/0xc0
[   89.318803] RSP: 0018:ffff880192ef3940  EFLAGS: 00010202
[   89.318862] RAX: 0000000087654321 RBX: ffff880192ef39d0 RCX: 0000000000000000
[   89.318940] RDX: ffff8800ac3649f1 RSI: 0000000000000000 RDI: ffff880192ef39f0
[   89.319017] RBP: ffff880192ef3940 R08: 00000000000001a0 R09: ffff8800b16071c8
[   89.319094] R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000017
[   89.319170] R13: 0000000000000010 R14: ffff880192ef3a08 R15: ffff880192ef3a90
[   89.319248] FS:  00007f2fb512b740(0000) GS:ffff880198c00000(0000)
knlGS:0000000000000000
[   89.319335] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.319398] CR2: 00000032b540e930 CR3: 0000000001c0c000 CR4: 00000000000407e0
[   89.319474] Stack:
[   89.319499]  ffff880192ef3950 ffffffff81335a5d ffff880192ef3990
ffffffff813389f3
[   89.319594]  ffff880185c33588 0000000000000010 ffff880192ef3990
ffff880192ef3c88
[   89.319686]  ffff8800b16071a0 0000000000000000 ffff880192ef3a70
ffffffff81345461
[   89.319779] Call Trace:
[   89.319814]  [<ffffffff81335a5d>] scatterwalk_done+0x3d/0x50
[   89.319881]  [<ffffffff813389f3>] blkcipher_walk_done+0x83/0x230
[   89.319952]  [<ffffffff81345461>] crypto_ctr_crypt+0x121/0x2b0
[   89.320023]  [<ffffffff8106c0d0>] ? aes_decrypt+0xa0/0xa0
[   89.320087]  [<ffffffff81337e2d>] async_encrypt+0x3d/0x40
[   89.320150]  [<ffffffff81337e2d>] ? async_encrypt+0x3d/0x40
[   89.320218]  [<ffffffffa06aa270>] crypto_ccm_encrypt+0x2d0/0x320 [ccm]
[   89.320293]  [<ffffffff81336c23>] ? setkey+0xb3/0xd0
[   89.320351]  [<ffffffff8133e715>] __test_aead+0x445/0x1170
[   89.320417]  [<ffffffff813333f5>] ? __crypto_alloc_tfm+0x45/0x170
[   89.323746]  [<ffffffff81334bb5>] ? crypto_spawn_tfm+0x45/0x80
[   89.327078]  [<ffffffff813334b1>] ? __crypto_alloc_tfm+0x101/0x170
[   89.330412]  [<ffffffff8133f467>] test_aead+0x27/0xb0
[   89.333704]  [<ffffffff8133f537>] alg_test_aead+0x47/0xb0
[   89.336976]  [<ffffffff8133d30f>] alg_test+0x12f/0x390
[   89.340233]  [<ffffffff81758700>] ? __schedule+0x350/0x970
[   89.343456]  [<ffffffff8133be20>] ? crypto_unregister_pcomp+0x20/0x20
[   89.346687]  [<ffffffff8133be61>] cryptomgr_test+0x41/0x50
[   89.349915]  [<ffffffff8109ffdf>] kthread+0xff/0x120
[   89.353110]  [<ffffffff8109fee0>] ? insert_kthread_work+0x80/0x80
[   89.356287]  [<ffffffff8176797c>] ret_from_fork+0x7c/0xb0
[   89.359440]  [<ffffffff8109fee0>] ? insert_kthread_work+0x80/0x80
[   89.362583] Code: 65 87 48 39 42 28 75 1e 48 8b 52 30 f6 c2 01 75
1a 48 83 e2 fc eb 97 66 0f 1f 44 00 00 31 d2 eb 8d e8 17 fe ff ff e8
2b f2 41 00 <0f> 0b 66 66 66 66 90 44 8b 47 08 4c 8b 0f 55 44 89 c0 48
89 e5
[   89.369485] RIP  [<ffffffff81335a1e>] scatterwalk_pagedone+0xbe/0xc0
[   89.372881]  RSP <ffff880192ef3940>
[   89.395650] ---[ end trace 96ffcb2518654453 ]---
