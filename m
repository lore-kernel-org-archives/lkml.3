Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3GQNqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab3GQNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:46:34 -0400
Date: Wed, 17 Jul 2013 09:47:01 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: hung task while plugging in cfg80211
Message-ID: <20130717094701.03624329@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending with wider distribution list since my earlier email to
linux-wireless didn't get a response)

I updated the kernel on my fedora rawhide KVM guest, and noticed that
the ethernet interface wasn't coming up at all. While poking around, I
saw this stack trace pop up:

Jul 12 07:29:25 rawhide kernel: [  241.156196] INFO: task modprobe:501 blocked for more than 120 seconds.
Jul 12 07:29:25 rawhide kernel: [  241.157222] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 12 07:29:25 rawhide kernel: [  241.158379] modprobe        D ffff880118c526e0  4584   501    500 0x00000080
Jul 12 07:29:25 rawhide kernel: [  241.159458]  ffff8800d10c3ba8 0000000000000046 00000000001d5300 ffff8800d10c3fd8
Jul 12 07:29:25 rawhide kernel: [  241.160644]  ffff8800d10c3fd8 00000000001d5300 ffff8800d2ae4dc0 ffff8800d2ae4dc0
Jul 12 07:29:25 rawhide kernel: [  241.161875]  ffffffff81d0bfa0 ffffffff81d0bfa8 ffffffff00000000 ffffffff81d0bff0
Jul 12 07:29:25 rawhide kernel: [  241.163096] Call Trace:
Jul 12 07:29:25 rawhide kernel: [  241.163460]  [<ffffffff817377e9>] schedule+0x29/0x70
Jul 12 07:29:25 rawhide kernel: [  241.164235]  [<ffffffff817392ad>] rwsem_down_write_failed+0xed/0x1a0
Jul 12 07:29:25 rawhide kernel: [  241.165489]  [<ffffffff810bb600>] ? update_cpu_load_active+0xb0/0xb0
Jul 12 07:29:25 rawhide kernel: [  241.166267]  [<ffffffff8137d503>] call_rwsem_down_write_failed+0x13/0x20
Jul 12 07:29:25 rawhide kernel: [  241.166760]  [<ffffffff81736aad>] ? down_write+0x9d/0xb2
Jul 12 07:29:25 rawhide kernel: [  241.167189]  [<ffffffff8162d975>] ? genl_lock_all+0x15/0x30
Jul 12 07:29:25 rawhide kernel: [  241.167603]  [<ffffffff8162d975>] genl_lock_all+0x15/0x30
Jul 12 07:29:25 rawhide kernel: [  241.168036]  [<ffffffff8162ea83>] genl_register_family+0x53/0x1f0
Jul 12 07:29:25 rawhide kernel: [  241.168490]  [<ffffffffa015e000>] ? 0xffffffffa015dfff
Jul 12 07:29:25 rawhide kernel: [  241.168877]  [<ffffffff8162f520>] genl_register_family_with_ops+0x20/0x80
Jul 12 07:29:25 rawhide kernel: [  241.169406]  [<ffffffffa015e000>] ? 0xffffffffa015dfff
Jul 12 07:29:25 rawhide kernel: [  241.169802]  [<ffffffffa0101ec4>] nl80211_init+0x24/0xf0 [cfg80211]
Jul 12 07:29:25 rawhide kernel: [  241.170297]  [<ffffffffa015e000>] ? 0xffffffffa015dfff
Jul 12 07:29:25 rawhide kernel: [  241.170686]  [<ffffffffa015e043>] cfg80211_init+0x43/0xdb [cfg80211]
Jul 12 07:29:25 rawhide kernel: [  241.171230]  [<ffffffff810020fa>] do_one_initcall+0xfa/0x1b0
Jul 12 07:29:25 rawhide kernel: [  241.171651]  [<ffffffff8105cb93>] ? set_memory_nx+0x43/0x50
Jul 12 07:29:25 rawhide kernel: [  241.172099]  [<ffffffff810fa2bf>] load_module+0x1c6f/0x27f0
Jul 12 07:29:25 rawhide kernel: [  241.172515]  [<ffffffff810f59a0>] ? store_uevent+0x40/0x40
Jul 12 07:29:25 rawhide kernel: [  241.172933]  [<ffffffff810fafd6>] SyS_finit_module+0x86/0xb0
Jul 12 07:29:25 rawhide kernel: [  241.173379]  [<ffffffff81744019>] system_call_fastpath+0x16/0x1b

...on a hunch, I blacklisted the cfg80211 module, and that seems to
have worked around the problem for now. I suspect that NM was trying to
plug in this module and it hung, and it couldn't proceed any further to
configure the virtual ethernet interface.

In the fedora rawhide kernels, last known good one is
kernel-3.11.0-0.rc0.git3.1.fc20, and bad one is
kernel-3.11.0-0.rc0.git6.1.fc20. I haven't bisected it further.

-- 
Jeff Layton <jlayton@redhat.com>
