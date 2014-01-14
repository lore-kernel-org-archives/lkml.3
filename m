Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaANWMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:12:01 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:55297 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaANWL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:11:59 -0500
X-Nat-Received: from [202.181.97.72]:49686 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389737476.24311
To: miklos@szeredi.hu
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 04/11] vfs: add renameat2 syscall
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-5-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1389219015-10980-5-git-send-email-miklos@szeredi.hu>
Message-Id: <201401150711.AHB52169.VMSFFLtHQFOOOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 15 Jan 2014 07:11:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14012014 #7327380, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> +
> +	if (flags)
> +		return -EOPNOTSUPP;
> +

If (at least for now) only ext4 interprets renameat2() flags,
I think adding a new member to "struct inode_operations" and
check it like

	if (!old_dir->i_op->swapname)
		return -EOPNOTSUPP;

or

	if (!(old_dir->i_op->supported_features & flags))
		return -EOPNOTSUPP;

earlier is smarter than scattering


	if (flags)
		return -EOPNOTSUPP;

into individual rename function.
If we do above change, LSM can omit checking permission for cross rename
operation which after all fails with -EOPNOTSUPP.
