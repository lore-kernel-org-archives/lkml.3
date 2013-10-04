Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977Ab3JDExS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 00:53:18 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52575 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3JDExR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 00:53:17 -0400
MIME-Version: 1.0
In-Reply-To: <20131003165832.GA2436@ghostprotocols.net>
References: <1380788891-31908-1-git-send-email-artagnon@gmail.com> <20131003165832.GA2436@ghostprotocols.net>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 4 Oct 2013 10:22:36 +0530
Message-ID: <CALkWK0=Fdg9DE+kYqitrsrJJ+iWJn4CS-FBEefPo_sGpK86dLQ@mail.gmail.com>
Subject: Re: [PATCH] perf tool: more user-friendly errors from trace
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> [acme@zoo ~]$ mount | grep debugfs
> [acme@zoo ~]$
> [acme@zoo ~]$ perf trace usleep 1
> Is debugfs mounted? Try 'sudo mount -t debugfs nodev /sys/kernel/debug'
> [acme@zoo ~]$ sudo mkdir /d
> [acme@zoo ~]$ sudo mount -t debugfs nodev /d
> [acme@zoo ~]$ mount | grep debugfs
> nodev on /d type debugfs (rw,relatime)
> [acme@zoo ~]$
> [acme@zoo ~]$ perf trace usleep 1
> Couldn't access debugfs. Try 'sudo mount -o remount,mode=755 /d'
> [acme@zoo ~]$ sudo mount -o remount,mode=755 /d

On Arch, I just had to `chmod go+rx /sys/kernel/debug`, and add an
entry to fstab so it works across reboots. Remounting by hand works
too, but it's likely that users are more familiar with simple
filesystem permissions.

> + case ENOENT:
> + fputs("Is debugfs mounted? Try 'sudo mount -t debugfs nodev /sys/kernel/debug'\n", trace->output);

Doesn't an ENOENT indicate that the kernel was not compiled with
debugfs support in the first place? Isn't it systemd's job to check
the kernel for the feature and do the mounting?

> + case EACCES:
> + fprintf(trace->output,
> + "Couldn't access debugfs. Try 'sudo mount -o remount,mode=755 %s'\n",
> + debugfs_mountpoint);

Instead of giving a specific line to execute, I'd prefer if the error
described that the current user does not have permissions to read
$debugfs in words.

Your patch splits the error into two different bits, which I like. But
I prefer the wording in my original patch: so, I'll re-work my patch
and re-submit.

Thanks.
