Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaC2QZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 12:25:19 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:51579
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751580AbaC2QZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 12:25:16 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Mar 2014 12:25:16 EDT
Date: Sat, 29 Mar 2014 17:16:12 +0100
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: [SMACK]Problem with user naespace
Message-ID: <20140329161612.GA25354@mail.hallyn.com>
References: <53304E00.3060405@samsung.com>
 <53312DE7.6040803@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53312DE7.6040803@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jacek Pielaszkiewicz (j.pielaszkie@samsung.com):
> 
> Hi
> 
>     I have problem with starting lxc containers when SMACK is enabled
> on the host. The issue appears when systemd try start user session in
> the container. In such case systemd reports error that has not
> permissions to set SMACK label. In my test configuration lxc container
> has full separation (all namespaces are enabled - including user namespace).
>     The issue is common. The problem is due to lack of permissions of
> the task to write into /proc/self/sttr/current file even the task has
> active CAP_MAC_ADMIN capability. Regarding to may tests the issue is
> connected to user namespace.
> 
>     I have prepared patch (see below). The patch was tested and created
> on kernel 3.10.
> 
> From 1d42d88fccafb7a9fa279588bc827163484a7852 Mon Sep 17 00:00:00 2001
> From: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
> Date: Mon, 24 Mar 2014 14:11:58 +0100
> Subject: [PATCH] [PATCH] Enable user namespace in SMACK
> 
> SMACK: Enable user namespace
> 
> - Bug/Issue:
> The issue has been found when we tried to setup lxc container.
> We tried to setup the container with active all linux namespaces
> (including user namespace). On the host as LSM was enabled SMACK.
> 
> We have found that "systemd" was not able to setup user sessiondue
> to lack of permissions to write into /proc/self/attr/currentfile.
> 
> We have found general issue that any privileged process with
> enabled CAP_MAC_ADMIN cannot write into /proc/self/attr/currentfile.
> 
> - Cause:
> SMACK to check the task capabilities uses capable().
> 
> - Solution:
> The fix replaces usage capable() by ns_capable().
> 
> Becuase SMACK uses globally defined rules usage ns_capable()
> was limited to places where requested by task operation
> are connected to himself. All operation that modify global SMACK
> rules remain unchanged - SMACK still to test capabilities
> calls capable(). It means that operation on smackfs remain
> unchanged - operation are allowed only by host.
> 
> Change-Id: I0bb28fa02943dd7ccb38dda2c8a37dcce2d551b2
> Signed-off-by: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
> ---
>  security/smack/smack.h        | 13 +++++++++++++
>  security/smack/smack_access.c |  2 +-
>  security/smack/smack_lsm.c    | 16 ++++++++--------
>  3 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index d072fd3..9f9d5e7 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -319,6 +319,19 @@ static inline int smack_privileged(int cap)
>  }
> 
>  /*
> + * Is the task privileged and allowed to privileged
> + * by the onlycap rule in user namespace.
> + */
> +static inline int smack_privileged_ns(int cap)
> +{
> +       if (!ns_capable(current_user_ns(), cap))
> +               return 0;

As I responded on lxc-devel (sorry I had apparently missed this
original mail),

This is an often seen, but very wrong, idiom.  This check means
nothing, because any unprivileged user can create a new userns
and pass this check.

You're on the right track, but to do this right you'll need to do a bit
more work.  For privilege over an inode, there is inode_capable().
For the network access, check the userns of the struct net owning
the socket.  etc.

> +       if (smack_onlycap == NULL || smack_onlycap == smk_of_current())
> +               return 1;
> +       return 0;
> +}
> +
> +/*
>   * logging functions
>   */
>  #define SMACK_AUDIT_DENIED 0x1
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 14293cd..07d25f5 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -230,7 +230,7 @@ int smk_curacc(char *obj_label, u32 mode, struct
> smk_audit_info *a)
>         /*
>          * Allow for priviliged to override policy.
>          */
> -       if (rc != 0 && smack_privileged(CAP_MAC_OVERRIDE))
> +       if (rc != 0 && smack_privileged_ns(CAP_MAC_OVERRIDE))
>                 rc = 0;
> 
>  out_audit:
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index cdbf92b..3cc6842 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -226,7 +226,7 @@ static int smack_syslog(int typefrom_file)
>         int rc = 0;
>         struct smack_known *skp = smk_of_current();
> 
> -       if (smack_privileged(CAP_MAC_OVERRIDE))
> +       if (smack_privileged_ns(CAP_MAC_OVERRIDE))
>                 return 0;
> 
>          if (smack_syslog_label != NULL && smack_syslog_label != skp)
> @@ -842,7 +842,7 @@ static int smack_inode_setxattr(struct dentry
> *dentry, const char *name,
>             strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
>             strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
>             strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
> -               if (!smack_privileged(CAP_MAC_ADMIN))
> +               if (!smack_privileged_ns(CAP_MAC_ADMIN))
>                         rc = -EPERM;
>                 /*
>                  * check label validity here so import wont fail on
> @@ -852,7 +852,7 @@ static int smack_inode_setxattr(struct dentry
> *dentry, const char *name,
>                     smk_import(value, size) == NULL)
>                         rc = -EINVAL;
>         } else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
> -               if (!smack_privileged(CAP_MAC_ADMIN))
> +               if (!smack_privileged_ns(CAP_MAC_ADMIN))
>                         rc = -EPERM;
>                 if (size != TRANS_TRUE_SIZE ||
>                     strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
> @@ -950,7 +950,7 @@ static int smack_inode_removexattr(struct dentry
> *dentry, const char *name)
>             strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
>             strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
>             strcmp(name, XATTR_NAME_SMACKMMAP)) {
> -               if (!smack_privileged(CAP_MAC_ADMIN))
> +               if (!smack_privileged_ns(CAP_MAC_ADMIN))
>                         rc = -EPERM;
>         } else
>                 rc = cap_inode_removexattr(dentry, name);
> @@ -1342,7 +1342,7 @@ static int smack_file_send_sigiotask(struct
> task_struct *tsk,
>         /* we don't log here as rc can be overriden */
>         skp = smk_find_entry(file->f_security);
>         rc = smk_access(skp, tkp->smk_known, MAY_WRITE, NULL);
> -       if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
> +       if (rc != 0 && has_ns_capability(tsk, current_user_ns(),
> CAP_MAC_OVERRIDE))
>                 rc = 0;
> 
>         smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
> @@ -2924,7 +2924,7 @@ static int smack_setprocattr(struct task_struct
> *p, char *name,
>         if (p != current)
>                 return -EPERM;
> 
> -       if (!smack_privileged(CAP_MAC_ADMIN))
> +       if (!smack_privileged_ns(CAP_MAC_ADMIN))
>                 return -EPERM;
> 
>         if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
> @@ -2980,7 +2980,7 @@ static int smack_unix_stream_connect(struct sock
> *sock,
>         smk_ad_setfield_u_net_sk(&ad, other);
>  #endif
> 
> -       if (!smack_privileged(CAP_MAC_OVERRIDE)) {
> +       if (!smack_privileged_ns(CAP_MAC_OVERRIDE)) {
>                 skp = ssp->smk_out;
>                 rc = smk_access(skp, osp->smk_in, MAY_WRITE, &ad);
>         }
> @@ -3018,7 +3018,7 @@ static int smack_unix_may_send(struct socket
> *sock, struct socket *other)
>         smk_ad_setfield_u_net_sk(&ad, other->sk);
>  #endif
> 
> -       if (smack_privileged(CAP_MAC_OVERRIDE))
> +       if (smack_privileged_ns(CAP_MAC_OVERRIDE))
>                 return 0;
> 
>         skp = ssp->smk_out;
> -- 
> 1.8.3.2
> 
> 
> I will be grateful for comments
> 
> 
> Best regards
> 
> Jacek Pielaszkiewicz
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
