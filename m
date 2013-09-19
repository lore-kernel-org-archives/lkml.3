Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3ISHJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:09:05 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57117 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3ISHJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:09:04 -0400
X-Nat-Received: from [202.181.97.72]:54559 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379574493.8894
To: keescook@chromium.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, joe@perches.com,
        linux@horizon.com, dan.carpenter@oracle.com, JBeulich@suse.com,
        kosaki.motohiro@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130916155504.GC13318@ZenIV.linux.org.uk>
	<CAGXu5jK2d+9m0uA84nGbZ5E=s974NRn+Sxz3iRcTsFWqWFTGNQ@mail.gmail.com>
	<201309182214.IDD13060.FFOVJOLOFQtHSM@I-love.SAKURA.ne.jp>
	<CAGXu5jKztpsUwTCa0dMNHUS==dPQE02FvT=xjNfZLK80NSriXQ@mail.gmail.com>
	<201309191111.HEI73985.FMOVFHtQFLOOSJ@I-love.SAKURA.ne.jp>
In-Reply-To: <201309191111.HEI73985.FMOVFHtQFLOOSJ@I-love.SAKURA.ne.jp>
Message-Id: <201309191608.AGD69743.VOHFSJFMFLOOQt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 19 Sep 2013 16:08:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 18092013 #11098720, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the code to test is built into vmlinux, we could use run-time checking like

----------
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1601,6 +1601,11 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
 
+	if (!(__start_rodata <= fmt && fmt < __end_rodata)) {
+		static unsigned char warn = 100;
+		WARN(warn && warn--, "Format string is not in RODATA section.");
+	}
+
 	str = buf;
 	end = buf + size;
 
----------

which reports errors like below.

[    0.814121] ------------[ cut here ]------------
[    0.814985] WARNING: CPU: 0 PID: 1 at lib/vsprintf.c:1606 vsnprintf+0xb4/0x3f0()
[    0.816036] Format string is not in RODATA section.
[    0.816883] Modules linked in:
[    0.817490] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc1-00046-g9baa505-dirty #180
[    0.818974] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.820040]  00000646 00000000 df079dc0 c02eae66 df079dcc c02eaead c02f3684 df079df8
[    0.821538]  c01422a9 c061bc40 df079e28 00000001 c061bc31 00000646 c02f3684 df079e08
[    0.822995]  00000646 c061bc40 df079e14 c0142301 00000009 df079e08 c061bc40 df079e28
[    0.824676] Call Trace:
[    0.825124]  [<c02eae66>] __dump_stack+0x16/0x20
[    0.825922]  [<c02eaead>] dump_stack+0x3d/0x60
[    0.826691]  [<c02f3684>] ? vsnprintf+0xb4/0x3f0
[    0.827478]  [<c01422a9>] warn_slowpath_common+0x79/0xa0
[    0.828040]  [<c02f3684>] ? vsnprintf+0xb4/0x3f0
[    0.828917]  [<c0142301>] warn_slowpath_fmt+0x31/0x40
[    0.829798]  [<c02f3684>] vsnprintf+0xb4/0x3f0
[    0.830584]  [<c0199d2b>] ? trace_hardirqs_on+0xb/0x10
[    0.832050]  [<c02f70f4>] kvasprintf+0x24/0x60
[    0.832831]  [<c02ed1c1>] kobject_set_name_vargs+0x21/0x60
[    0.833850]  [<c02ed2c1>] kobject_add_varg+0x21/0x50
[    0.834750]  [<c02ed379>] kobject_init_and_add+0x29/0x30
[    0.835699]  [<c01f9fd3>] sysfs_slab_add+0x63/0xe0
[    0.836055]  [<c06ec630>] ? kmem_cache_init_late+0x10/0x10
[    0.837054]  [<c06ec6a7>] slab_sysfs_init+0x77/0x110
[    0.838025]  [<c06ec251>] ? procswaps_init+0x21/0x30
[    0.838958]  [<c0100472>] do_one_initcall+0x32/0xd0
[    0.840046]  [<c015fb60>] ? parse_one+0xc0/0xe0
[    0.840852]  [<c015fd0a>] ? parse_args+0x7a/0x170
[    0.841676]  [<c06cf410>] ? loglevel+0x30/0x30
[    0.842443]  [<c06cfb6a>] do_initcall_level+0x7a/0x90
[    0.843338]  [<c06cf410>] ? loglevel+0x30/0x30
[    0.844038]  [<c06cfb98>] do_initcalls+0x18/0x20
[    0.844960]  [<c06cfbc8>] do_basic_setup+0x28/0x30
[    0.845894]  [<c06cfc7f>] kernel_init_freeable+0x5f/0xf0
[    0.846907]  [<c04c523b>] kernel_init+0xb/0xe0
[    0.848045]  [<c04cc718>] ret_from_kernel_thread+0x1c/0x2c
[    0.849070]  [<c04c5230>] ? rest_init+0x140/0x140
[    0.849987] ---[ end trace c57fc7b42d34a992 ]---

----------
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5136,7 +5136,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	}
 
 	s->kobj.kset = slab_kset;
-	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, name);
+	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err) {
 		kobject_put(&s->kobj);
 		return err;
----------

But tools like sparse might find such bugs better?
