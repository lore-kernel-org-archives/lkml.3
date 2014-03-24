Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaCXMSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:18:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:6090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaCXMSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:18:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,720,1389772800"; 
   d="scan'208";a="505398358"
From: Imre Deak <imre.deak@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dcache: fix dpath buffer corruption for too small buffers
Date: Mon, 24 Mar 2014 14:17:43 +0200
Message-Id: <1395663463-4366-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1394666986-24727-1-git-send-email-imre.deak@intel.com>
References: <1394666986-24727-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During dentry path lookups we can end up corrupting memory if the
destination path buffer is too small. This is because prepend_path()
and prepend() adjust the passed buffer length unconditionally, allowing
for the buffer length to go negative. Then a later prepend_name() call
will receive a negative length and convert this to unsigned before
comparing it against the source string length leading to a possible
memory corruption preceeding the destination buffer.

v2:
- Fix this by doing the same as prepend() and subtract the qstr length
  unconditionally from *buflen. All the callers know already how to
  properly treat a negative *buflen (Al Viro).

This fixes the following core dumping for me:

evolution[16162]: segfault at 0 ip 00007faadd0e7609 sp 00007ffffd63e780 error 4 in libevolution-mail.so.0.0.0[7faadd05a000+c7000]
BUG: unable to handle kernel paging request at ffffc900000f5000
IP: [<ffffffff812e04fa>] memmove+0x4a/0x1a0
PGD 41d80e067 PUD 41d80f067 PMD 41d820067 PTE 0
Oops: 0002 [#1] PREEMPT SMP
Modules linked in: nbd vfat fat nls_utf8 fuse rfcomm bnep bluetooth rfkill snd_hda_codec_hdmi snd_hda_codec_realtek kvm_intel kvm crc32c_intel snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss ftdi_sio usbserial snd_pcm cdc_acm snd_seq_dummy snd_page_alloc snd_seq_oss microcode serio_raw i915 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_seq_device snd_timer snd cfbfillrect soundcore cfbimgblt i2c_algo_bit cfbcopyarea drm_kms_helper lpc_ich drm mfd_core usb_storage usbhid
CPU: 1 PID: 16162 Comm: evolution Tainted: G        W    3.13.0-imre+ #327
Hardware name: Dell Inc. XPS 8300  /0Y2MRG, BIOS A03 02/15/2011
task: ffff8804157a8000 ti: ffff8803e0afa000 task.ti: ffff8803e0afa000
RIP: 0010:[<ffffffff812e04fa>]  [<ffffffff812e04fa>] memmove+0x4a/0x1a0
RSP: 0000:ffff8803e0afba70  EFLAGS: 00010283
RAX: ffffc900000f5000 RBX: 00000000ffffffdd RCX: ffffc900000f5000
RDX: ffffffffffffffe3 RSI: ffffc900000f4ffd RDI: ffffc900000f5000
RBP: ffff8803e0afbc30 R08: 312e302e6f732e30 R09: 2e332d6b74677469
R10: 6b62657762696c2f R11: 62696c2f7273752f R12: 0000000000000023
R13: ffff880415cb7790 R14: ffffc900000f5023 R15: ffffc900000e7370
FS:  00007faafb750a40(0000) GS:ffff88042fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900000f5000 CR3: 0000000043388000 CR4: 00000000000407e0
Stack:
 ffffffff811e4a3d ffffffff811e4757 ffff8804157a8000 0000000000007558
 000004e5000004e5 ffff880400014000 ffff880100007558 ffff8801668bfb00
 ffffffff81c226a0 ffff8803e0afbce0 ffffc900000e8558 ffffc900000e1000
Call Trace:
 [<ffffffff811e4a3d>] ? elf_core_dump+0xb3d/0x1400
 [<ffffffff811e4757>] ? elf_core_dump+0x857/0x1400
 [<ffffffff811e9b9a>] do_coredump+0xbda/0xf90
 [<ffffffff8109890d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81061ec6>] get_signal_to_deliver+0x5c6/0x6b0
 [<ffffffff81002378>] do_signal+0x48/0x560
 [<ffffffff811d359f>] ? fsnotify+0x8f/0x340
 [<ffffffff816ac7d1>] ? retint_signal+0x11/0x90
 [<ffffffff810028c5>] do_notify_resume+0x35/0x80
 [<ffffffff816ac806>] retint_signal+0x46/0x90
Code: 00 00 48 81 fa a8 02 00 00 72 05 40 38 fe 74 41 48 83 ea 20 48 83 ea 20 4c 8b 1e 4c 8b 56 08 4c 8b 4e 10 4c 8b 46 18 48 8d 76 20 <4c> 89 1f 4c 89 57 08 4c 89 4f 10 4c 89 47 18 48 8d 7f 20 73 d4
RIP  [<ffffffff812e04fa>] memmove+0x4a/0x1a0
 RSP <ffff8803e0afba70>
CR2: ffffc900000f5000

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 fs/dcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 265e0ce..ca02c13 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2833,9 +2833,9 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
 
-	if (*buflen < dlen + 1)
-		return -ENAMETOOLONG;
 	*buflen -= dlen + 1;
+	if (*buflen < 0)
+		return -ENAMETOOLONG;
 	p = *buffer -= dlen + 1;
 	*p++ = '/';
 	while (dlen--) {
-- 
1.8.4

