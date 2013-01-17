Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3AQXoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:44:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3AQXoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:44:14 -0500
Date: Thu, 17 Jan 2013 18:43:21 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: Bcache v. whatever
Message-ID: <20130117234320.GA22200@redhat.com>
References: <20130114223202.GV26407@google.com>
 <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com>
 <20130115205912.GA26407@google.com>
 <1358291738.10591.23.camel@dabdike.int.hansenpartnership.com>
 <20130115233347.GD26407@google.com>
 <20130116012914.GA27245@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116012914.GA27245@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15 2013 at  8:29pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Tue, Jan 15, 2013 at 03:33:47PM -0800, Kent Overstreet wrote:
> > I haven't been active on dm-devel, besides the occasional cross
> > posting... not sure what activity you're referring to on the dm list,
>  
> A caching framework based on dm has been proposed by Joe Thornber (the
> original author of dm).
> 
> Mike Snitzer is trying to adapt the performance tests for this dm-based
> framework to include the latest bcache code that you just posted to
> start to give us an idea of the circumstances in which each of them work
> well (or badly).

Unfortunately, the first automated test in the thinp-test-suite that I
ported to work with Bcache fails, here is a shell script that reproduces
the problem (having bcache use a small SSD is key to reproducing):

## /dev/spindle/data is a 16G linear LV on a SAS spindle
## /dev/stec/256m_lv is a 256M linear LV on a PCI-e SSD
## (larger SSD volume doesn't have this problem; because the working set fits better?)
make-bcache -B /dev/spindle/data -C /dev/stec/256m_lv --cache_replacement_policy=fifo -w 4096 --writeback --discard
echo /dev/spindle/data > /sys/fs/bcache/register
echo /dev/stec/256m_lv > /sys/fs/bcache/register
DM_DEV_NAME=$(basename `readlink /dev/mapper/spindle-data`)
BCACHE_DEV=$(basename `readlink /sys/block/${DM_DEV_NAME}/bcache/dev`)
mkfs.ext4 -E lazy_itable_init=1 /dev/${BCACHE_DEV}
mkdir ./kernel_builds
mount /dev/${BCACHE_DEV} ./kernel_builds -o discard
cd ./kernel_builds
## /root/linux-github is a local clone of linus' git repo
git clone /root/linux-github linux
cd linux
git checkout v2.6.12
sync
echo 3 > /proc/sys/vm/drop_caches


The drop_caches hangs (sh spins eating cpu), and ./kernel_builds cannot
be unmounted:

# ps auwwx | grep spin_bcache
root     18148 98.4  0.0 106208  1320 pts/2    R+   17:42  49:39 /bin/sh /root/bin/spin_bcache

spin_bcache     R  running task        0 18148   4886 0x00000000
 00000000154d154d 0000000000000000 ffff8802edc00d90 ffff88032d395e48
 0000000000000001 ffffffffffffff10 0000000000000018 ffff8802f9802800
 ffff88032d395d28 ffffffff8116b8d5 ffff88032de6f000 ffff880332682800
Call Trace:
 [<ffffffff814f67e2>] ? _raw_spin_lock+0x12/0x30
 [<ffffffff8116b8d5>] ? put_super+0x25/0x40
 [<ffffffff8116ba65>] ? grab_super_passive+0x25/0xa0
 [<ffffffff8116bb3f>] ? prune_super+0x5f/0x1a0
 [<ffffffff8111d131>] ? shrink_slab+0xa1/0x2c0
 [<ffffffff8111d096>] ? shrink_slab+0x6/0x2c0
 [<ffffffff81194b22>] ? drop_caches_sysctl_handler+0x62/0x90
 [<ffffffff811d7f56>] ? proc_sys_call_handler+0x96/0xd0
 [<ffffffff811d7fa4>] ? proc_sys_write+0x14/0x20
 [<ffffffff81169194>] ? vfs_write+0xb4/0x130
 [<ffffffff8116993f>] ? sys_write+0x5f/0xa0
 [<ffffffff814ff119>] ? system_call_fastpath+0x16/0x1b
