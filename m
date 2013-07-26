Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3GZE3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:29:37 -0400
Received: from countercultured.net ([209.51.175.25]:44771 "HELO
	countercultured.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750793Ab3GZE3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:29:33 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2013 00:29:32 EDT
References: <20130726134823.e4c0a1b7bad087c12b3ce782@canb.auug.org.au>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130726134823.e4c0a1b7bad087c12b3ce782@canb.auug.org.au>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <06EC4DE7-7DC5-4C80-BA1D-2A96527CA7BF@countercultured.net>
Cc: Eric Paris <eparis@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Quigley <dpquigl@davequigley.com>,
        "Matthew N. Dodd" <Matthew.Dodd@sparta.com>,
        Miguel Rodel Felipe <Rodel_FM@dsi.a-star.edu.sg>,
        Phua Eu Gene <PHUA_Eu_Gene@dsi.a-star.edu.sg>,
        Khin Mi Mi Aung <Mi_Mi_AUNG@dsi.a-star.edu.sg>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
X-Mailer: iPhone Mail (10B350)
From: David Quigley <merlin@countercultured.net>
Subject: Re: linux-next: manual merge of the selinux tree with Linus' tree
Date: Thu, 25 Jul 2013 21:22:48 -0700
To: Stephen Rothwell <sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess my signed off got stripped somewhere. Originally I maintained those commits but Steve Dickson from red hat picked them up and they then made it into trond's tree and then into Linus'.

I unfortunately don't have my davequigley.com identities on my iPhone but you can add a sign off by dpquigl@davequigley.com for the commit.

Sent from my iPhone

On Jul 25, 2013, at 8:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Eric,
> 
> Today's linux-next merge of the selinux tree got a conflict in
> security/selinux/hooks.c between commit eb9ae686507b ("SELinux: Add new
> labeling type native labels") from Linus' tree and commits 40d3d0b85fa2
> ("SELinux: remove crazy contortions around proc") and a64c54cf0811
> ("SELinux: pass a superblock to security_fs_use") from the selinux tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> P.S. Unusually, that commit from Linus' tree has no Signed-off-by from
> its purported author (David Quigley).
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> diff --cc security/selinux/hooks.c
> index a5091ec,4fbf2c5..0000000
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@@ -680,21 -702,14 +712,19 @@@ static int selinux_set_mnt_opts(struct 
>      if (strcmp(sb->s_type->name, "proc") == 0)
>          sbsec->flags |= SE_SBPROC;
> 
> -    /* Determine the labeling behavior to use for this filesystem type. */
> -    rc = security_fs_use(sb);
> -    if (rc) {
> -        printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
> -               __func__, sb->s_type->name, rc);
> -        goto out;
> +    if (!sbsec->behavior) {
> +        /*
> +         * Determine the labeling behavior to use for this
> +         * filesystem type.
> +         */
> -        rc = security_fs_use((sbsec->flags & SE_SBPROC) ?
> -                    "proc" : sb->s_type->name,
> -                    &sbsec->behavior, &sbsec->sid);
> ++        rc = security_fs_use(sb);
> +        if (rc) {
> +            printk(KERN_WARNING
> +                "%s: security_fs_use(%s) returned %d\n",
> +                    __func__, sb->s_type->name, rc);
> +            goto out;
> +        }
>      }
> -
>      /* sets the context of the superblock for the fs being mounted. */
>      if (fscontext_sid) {
>          rc = may_context_mount_sb_relabel(fscontext_sid, sbsec, cred);
> @@@ -2629,11 -2589,15 +2659,11 @@@ static int selinux_inode_init_security(
>          isec->initialized = 1;
>      }
> 
> -    if (!ss_initialized || !(sbsec->flags & SE_SBLABELSUPP))
> +    if (!ss_initialized || !(sbsec->flags & SBLABEL_MNT))
>          return -EOPNOTSUPP;
> 
> -    if (name) {
> -        namep = kstrdup(XATTR_SELINUX_SUFFIX, GFP_NOFS);
> -        if (!namep)
> -            return -ENOMEM;
> -        *name = namep;
> -    }
> +    if (name)
> +        *name = XATTR_SELINUX_SUFFIX;
> 
>      if (value && len) {
>          rc = security_sid_to_context_force(newsid, &context, &clen);
