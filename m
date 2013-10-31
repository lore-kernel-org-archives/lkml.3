Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3JaTGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:06:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55560 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3JaTGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:06:15 -0400
Date: Thu, 31 Oct 2013 19:06:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Chen Gang <gang.chen@asianux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
Message-ID: <20131031190608.GH13318@ZenIV.linux.org.uk>
References: <5271C5E5.6080606@asianux.com>
 <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:53:59AM -0700, Kees Cook wrote:

> If block (type sector_t) is unsigned, we shouldn't cast it signed.
> This entire code path should be removed. What is BEFS's expected
> maximum block size? (Looks like even befs_blocknr_t is u64, so nothing
> seems trivially in danger of wrapping.) I would also note that all the
> format strings are wrong too (%ld instead of %lu).

FWIW, this
        res = befs_fblock2brun(sb, ds, block, &run);
        if (res != BEFS_OK) {
                befs_error(sb,
                           "<--- befs_get_block() for inode %lu, block "
                           "%ld ERROR", inode->i_ino, block);
                return -EFBIG;
        }
also looks wrong - ioctl(..., FIBMAP, ...) shouldn't be able to spew
printks on a valid fs and hitting it with block number greater than
file length will, AFAICS, trigger that.

I agree that this code needs fixing, but just making gcc STFU about the
comparison would only serve to hide the problem.  Anybody familiar with
befs or willing to learn it?
