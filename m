Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbaDJLzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:55:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53162 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935530AbaDJLzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:55:05 -0400
X-Nat-Received: from [202.181.97.72]:54035 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1397130877.10489
To: iamjoonsoo.kim@lge.com
Cc: ak@linux.intel.com, penberg@iki.fi, linux-kernel@vger.kernel.org
Subject: Re: [3.15-rc1 slab] Oops when reading /proc/slab_allocators
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201404092036.CEF21247.VFSQFFMLOJOOtH@I-love.SAKURA.ne.jp>
	<20140410073918.GB8204@js1304-P5Q-DELUXE>
In-Reply-To: <20140410073918.GB8204@js1304-P5Q-DELUXE>
Message-Id: <201404102054.BJI60908.OOFVLQFOSFHMJt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 10 Apr 2014 20:54:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10042014 #7811107, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim wrote:
> There was another report about this problem and I have already fixed
> it, although it wasn't reviewed and merged. See following link.
> 
> https://lkml.org/lkml/2014/3/11/119

OK. That patch fixes this problem.

Commit b1cb0982 changed the way of walking objects, didn't it? Then,
it could happen that slab leak detector code walking all objects
triggers an oops.

> In that time, I thought that this problem wasn't related to my patches,
> but your bisect report say that it is from my patches. I will dig into
> the problem more deeply as soon as possible and make proper fix.

I see. Here is a minimal kernel config and test script for qemu on CentOS 6.5.
http://I-love.SAKURA.ne.jp/tmp/config-pre-3.15-rc1-min

---------- test.sh start ----------
#!/bin/sh
mkdir -p tmp/
cc -Wall -O3 --static -o tmp/init -x c - << "EOF"
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mount.h>
#include <sys/reboot.h> 
#include <linux/reboot.h> 

int main(int argc, char **argv)
{
	FILE *fp;
	mkdir("/proc", 0755);
	mount(NULL, "/proc", "proc", 0, NULL);
	fp = fopen("/proc/slab_allocators", "r");
	if (fp) {
		char buffer[4096];
		printf("Reading /proc/slab_allocators\n");
		while (fgets(buffer, sizeof(buffer), fp));
		fclose(fp);
	}
	printf("Shutting down.\n");
	reboot(LINUX_REBOOT_CMD_POWER_OFF);
	return 0;
}
EOF
(cd tmp; echo init | cpio -o -H newc | gzip -9) > initrd
exec /usr/libexec/qemu-kvm --kernel arch/x86/boot/bzImage --initrd initrd --nographic --append "console=ttyS0,115200n8"
---------- test.sh end ----------
