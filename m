Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbaJVVtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:49:13 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56440 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbaJVVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:49:11 -0400
MIME-Version: 1.0
In-Reply-To: <1414013060-137148-4-git-send-email-seth.forshee@canonical.com>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com> <1414013060-137148-4-git-send-email-seth.forshee@canonical.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Oct 2014 14:48:48 -0700
Message-ID: <CALCETrXzcOFLL0oM5HAsNH6r6dFmwTz7LM4uiZrCynxE7xhOQA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] fuse: Restrict allow_other to the superblock's
 namespace or a descendant
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 2:24 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> Unprivileged users are normally restricted from mounting with the
> allow_other option by system policy, but this could be bypassed
> for a mount done with user namespace root permissions. In such
> cases allow_other should not allow users outside the userns
> to access the mount as doing so would give the unprivileged user
> the ability to manipulate processes it would otherwise be unable
> to manipulate. Therefore access with allow_other should be
> restricted to users in the userns as the superblock or a
> descendant of that namespace.

Looks good to me.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  fs/fuse/dir.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 123db1e06c78..b23ec5c1ff18 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1091,8 +1091,14 @@ int fuse_allow_current_process(struct fuse_conn *fc)
>  {
>         const struct cred *cred;
>
> -       if (fc->flags & FUSE_ALLOW_OTHER)
> -               return 1;
> +       if (fc->flags & FUSE_ALLOW_OTHER) {
> +               struct user_namespace *ns;
> +               for (ns = current_user_ns(); ns; ns = ns->parent) {
> +                       if (ns == fc->user_ns)
> +                               return 1;
> +               }
> +               return 0;
> +       }
>
>         cred = current_cred();
>         if (uid_eq(cred->euid, fc->user_id) &&
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
