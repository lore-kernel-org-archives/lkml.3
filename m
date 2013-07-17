Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3GQLlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:41:49 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50644 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3GQLls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:41:48 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: zswap: How to determine whether it is compressing swap pages?
Date: Wed, 17 Jul 2013 13:41:44 +0200
Message-ID: <3337744.IgTT2hGPE5@merkaba>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc1-tp520+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51E6750A.9060900@oracle.com>
References: <1674223.HVFdAhB7u5@merkaba> <51E6750A.9060900@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Juli 2013, 18:42:18 schrieb Bob Liu:
> On 07/17/2013 06:04 PM, Martin Steigerwald wrote:
> > Hi Seth, hi everyone,
> >
> > Yesterday I build 3.11-rc1 with CONFIG_ZSWAP and wanted to test it.
> >
> > I added zswap.enabled=1 and get:
> >
> > martin@merkaba:~> dmesg | grep zswap
> > [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.11.0-rc1-tp520+
> > root=/dev/mapper/merkaba-debian ro rootflags=subvol=root init=/bin/systemd
> > cgroup_enable=memory threadirqs i915.i915_enable_rc6=7 zcache zswap.enabled=1
> > [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.11.0-rc1-tp520+
> > root=/dev/mapper/merkaba-debian ro rootflags=subvol=root init=/bin/systemd
> > cgroup_enable=memory threadirqs i915.i915_enable_rc6=7 zcache zswap.enabled=1
> > [    1.452443] zswap: loading zswap
> > [    1.452465] zswap: using lzo compressor
> >
> >
> > I did a stress -m 1 --vm-keep --vm-bytes 4G on this 8 GB ThinkPad T520 in
> > order to allocate some swap.
> >
> 
> Thank you for your testing.
> I'm glad to see there is new people interested with memory compression.
> 
> > Still I think zswap didn´t do anything:
> >
> > merkaba:/sys/kernel/debug/zswap> grep . *
> > duplicate_entry:0
> > pool_limit_hit:0
> > pool_pages:0
> > reject_alloc_fail:0
> > reject_compress_poor:0
> > reject_kmemcache_fail:0
> > reject_reclaim_fail:0
> > stored_pages:0
> > written_back_pages:0
> >
> >
> > However:
> >
> > merkaba:/sys/kernel/slab/zswap_entry> grep . *
> > aliases:9
> > align:8
> > grep: alloc_calls: Die angeforderte Funktion ist nicht implementiert
> > cache_dma:0
> > cpu_partial:0
> > cpu_slabs:4 N0=4
> > destroy_by_rcu:0
> > grep: free_calls: Die angeforderte Funktion ist nicht implementiert
> > hwcache_align:0
> > min_partial:5
> > objects:2550 N0=2550
> > object_size:48
> > objects_partial:0
> > objs_per_slab:85
> > order:0
> > partial:0
> > poison:0
> > reclaim_account:0
> > red_zone:0
> > remote_node_defrag_ratio:100
> > reserved:0
> > sanity_checks:0
> > slabs:30 N0=30
> > slabs_cpu_partial:0(0)
> > slab_size:48
> > store_user:0
> > total_objects:2550 N0=2550
> > trace:0
> >
> > It has some objects it seems.
> >
> >
> > How do I know whether zswap actually does something?
> >
> > Will zswap work even with zcache enabled? As I understand zcache compresses
> > swap device pages on the block device level in addition to compressing read
> > cache pages of usual filesystems. Which one takes precedence, zcache or zswap?
> > Can I disable zcache for swap device?
> >
> 
> Please disable zcache and try again.

Okay, this seemed to work.

Shortly after starting stress I got:

merkaba:/sys/kernel/debug/zswap> grep . *
duplicate_entry:0
pool_limit_hit:0
pool_pages:170892
reject_alloc_fail:0
reject_compress_poor:0
reject_kmemcache_fail:0
reject_reclaim_fail:0
stored_pages:341791
written_back_pages:0


then zcache reduced pool size again – while stress was still running:

merkaba:/sys/kernel/debug/zswap> grep . *
duplicate_entry:0
pool_limit_hit:0
pool_pages:38
reject_alloc_fail:0
reject_compress_poor:0
reject_kmemcache_fail:0
reject_reclaim_fail:0
stored_pages:66
written_back_pages:0


I assume that on heavy memory pressure zcache shrinks pool again in oder
to free memory for other activities? Is that correct?

So zswap would help most on moderate, not heavy and bulky memory pressure?


I was not able to reproduce above behavior even while watching with

merkaba:/sys/kernel/debug/zswap#130> while true; do date; grep . * ; sleep 1 ; done


Zswap just doesn´t seem to store packages on that workload anymore.

I will keep it running in regular workloads (two KDE sessions with Akonadi
and Nepomuk) and observe it a bit.


Is there any way to run zcache concurrently with zswap? I.e. use zcache only
for read caches for filesystem and zswap for swap?

What is better suited for swap? zswap or zcache?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
