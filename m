Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3JaQyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:54:02 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:52015 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3JaQyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:54:00 -0400
MIME-Version: 1.0
In-Reply-To: <5271C5E5.6080606@asianux.com>
References: <5271C5E5.6080606@asianux.com>
Date: Thu, 31 Oct 2013 09:53:59 -0700
X-Google-Sender-Auth: QAbFl0mL70RmdojM5_MrfWQudwg
Message-ID: <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
From: Kees Cook <keescook@chromium.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 7:52 PM, Chen Gang <gang.chen@asianux.com> wrote:
> Need signed cast for it, the original author assume the type of 'block'
> is long, so just cast to long. The related warnings (with allmodconfig):
>
>   fs/befs/linuxvfs.c:136:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  fs/befs/linuxvfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index daa15d6..27e5179 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -133,7 +133,7 @@ befs_get_block(struct inode *inode, sector_t block,
>         befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
>                    inode->i_ino, block);
>
> -       if (block < 0) {
> +       if ((long)block < 0) {
>                 befs_error(sb, "befs_get_block() was asked for a block "
>                            "number less than zero: block %ld in inode %lu",
>                            block, inode->i_ino);

If block (type sector_t) is unsigned, we shouldn't cast it signed.
This entire code path should be removed. What is BEFS's expected
maximum block size? (Looks like even befs_blocknr_t is u64, so nothing
seems trivially in danger of wrapping.) I would also note that all the
format strings are wrong too (%ld instead of %lu).

-Kees

-- 
Kees Cook
Chrome OS Security
