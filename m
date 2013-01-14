Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3ANXAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:00:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3ANXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:00:43 -0500
Date: Mon, 14 Jan 2013 15:00:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: slava@dubeyko.com, splavgm@gmail.com, linux-nilfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nilfs2: fix very long mount time issue
Message-Id: <20130114150041.d57e5e03.akpm@linux-foundation.org>
In-Reply-To: <20130113.160723.135185368.konishi.ryusuke@lab.ntt.co.jp>
References: <1358004888.2130.18.camel@slavad-ubuntu-12.04>
	<20130113.160723.135185368.konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2013 16:07:23 +0900 (JST)
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> On Sat, 12 Jan 2013 19:34:48 +0400, Vyacheslav Dubeyko wrote:
> > From: Vyacheslav Dubeyko <slava@dubeyko.com>
> > Subject: [PATCH] nilfs2: fix very long mount time issue
> > 
> > DESCRIPTION:
> > It exists situation when GC can work in background alone without any other filesystem activity during significant time. The nilfs_clean_segments() method calls nilfs_segctor_construct() that updates superblocks in the case of NILFS_SC_SUPER_ROOT and THE_NILFS_DISCONTINUED flags are set. But when GC is working alone the nilfs_clean_segments() is called with unset THE_NILFS_DISCONTINUED flag. As a result, the update of superblocks doesn't occurred all this time and in the case of SPOR superblocks keep very old values of last super root placement.
> > 
> > SYMPTOMS:
> > Trying to mount a NILFS2 volume after SPOR in such environment ends with very long mounting time (it can achieve about several hours in some cases).
> > 
> > REPRODUCING PATH:
> > 1. It needs to use external USB HDD, disable automount and doesn't make any additional filesystem activity on the NILFS2 volume.
> > 2. Generate temporary file with size about 100 - 500 GB (for example, dd if=/dev/zero of=<file_name> bs=1073741824 count=200). The size of file defines duration of GC working.
> > 3. Then it needs to delete file.
> > 4. Start GC manually by means of command "nilfs-clean -p 0". When you start GC by means of such way then, at the end, superblocks is updated by once. So, for simulation of SPOR, it needs to wait sometime (15 - 40 minutes) and simply switch off USB HDD manually.
> > 5. Switch on USB HDD again and try to mount NILFS2 volume. As a result, NILFS2 volume will mount during very long time.
> > 
> > REPRODUCIBILITY: 100%
> > 
> > FIX:
> > This patch adds checking that superblocks need to update and set THE_NILFS_DISCONTINUED flag before nilfs_clean_segments() call.
> > 
> > Reported-by: Sergey Alexandrov <splavgm@gmail.com>
> > Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
> > Tested-by: Vyacheslav Dubeyko <slava@dubeyko.com>
> 
> Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> 
> Thanks, Vyacheslav.  I confirmed the issue and could reproduce it.
> Your patch fixed it.
> 
> Andrew, please apply.

I added a Cc:stable so the fix will be backported into earlier kernels.
40 minutes mount time is pretty bad!
