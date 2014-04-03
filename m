Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162476AbaDCH5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:57:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22110 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162417AbaDCH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:57:21 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-9a-533d145fac87
From: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
To: "'Serge E. Hallyn'" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org,
        Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
References: <53304E00.3060405@samsung.com> <53312DE7.6040803@samsung.com>
 <20140329161612.GA25354@mail.hallyn.com>
In-reply-to: <20140329161612.GA25354@mail.hallyn.com>
Subject: RE: Fwd: [SMACK]Problem with user naespace
Date: Thu, 03 Apr 2014 09:57:00 +0200
Message-id: <05d001cf4f12$4c306780$e4913680$%pielaszkie@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9LajcY5y+cKFiER1ucL9zyNWvp4wBUzG2A
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7rxIrbBBte/cVkse7WO0eLyrjls
	FucvnGN3YPa4tjvSo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDIWnl/HUnDPp2LO55VMDYzv
	LboYOTkkBEwklmx5xwJhi0lcuLeerYuRi0NIYCmjxP3lW1khnEYmif6eiUwgVWwCphI3d0xm
	BLFFBLQkGpceZQexmQWCJQ5vugNmCwmUSMxruwhmcwLVL347E2yDsICxxJwPzUC9HBwsAqoS
	zzrkQMK8Ai4ST/7+Z4SwBSV+TL7HAjFSS2L9zuNMELa8xOY1b5lBWiUE1CUe/dWFuMBI4vul
	pVAl4hKTHjxkn8AoNAvJpFlIJs1CMmkWkpYFjCyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3
	MUKC/csOxsXHrA4xCnAwKvHwWkjZBAuxJpYVV+YeYpTgYFYS4b34BSjEm5JYWZValB9fVJqT
	WnyIkYmDU6qB0XNR4td54mpqS6XqTtv5KP+dwJ/p133PgNlk4/XqGYyz/Zrad0sbRWUv4Mj+
	07eUX/T9oWAXf4bPKb4LmpVm/JjiFG3xSEDw0+r5oioqphETHhsul513eFVojsJvPTv9fSun
	dbbebvSUvbHLdFJIel+dt4v6DsuCOdIupb5Ho5Yta/Vo62BWYinOSDTUYi4qTgQA7rjM8VQC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My comments below.

Best regards


Jacek Pielaszkiewicz
Samsung R&D Institute Poland
Samsung Electronics
Email: j.pielaszkie@samsung.com


> -----Original Message-----
> From: Serge E. Hallyn [mailto:serge@hallyn.com]
> Sent: Saturday, March 29, 2014 5:16 PM
> To: Jacek Pielaszkiewicz
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Fwd: [SMACK]Problem with user naespace
> 
> Quoting Jacek Pielaszkiewicz (j.pielaszkie@samsung.com):
> >
> > Hi
> >
> >     I have problem with starting lxc containers when SMACK is enabled
> > on the host. The issue appears when systemd try start user session in
> > the container. In such case systemd reports error that has not
> > permissions to set SMACK label. In my test configuration lxc
> container
> > has full separation (all namespaces are enabled - including user
> namespace).
> >     The issue is common. The problem is due to lack of permissions of
> > the task to write into /proc/self/sttr/current file even the task has
> > active CAP_MAC_ADMIN capability. Regarding to may tests the issue is
> > connected to user namespace.
> >
> >     I have prepared patch (see below). The patch was tested and
> > created on kernel 3.10.
> >
> > From 1d42d88fccafb7a9fa279588bc827163484a7852 Mon Sep 17 00:00:00
> 2001
> > From: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
> > Date: Mon, 24 Mar 2014 14:11:58 +0100
> > Subject: [PATCH] [PATCH] Enable user namespace in SMACK
> >
> > SMACK: Enable user namespace
> >
> > - Bug/Issue:
> > The issue has been found when we tried to setup lxc container.
> > We tried to setup the container with active all linux namespaces
> > (including user namespace). On the host as LSM was enabled SMACK.
> >
> > We have found that "systemd" was not able to setup user sessiondue to
> > lack of permissions to write into /proc/self/attr/currentfile.
> >
> > We have found general issue that any privileged process with enabled
> > CAP_MAC_ADMIN cannot write into /proc/self/attr/currentfile.
> >
> > - Cause:
> > SMACK to check the task capabilities uses capable().
> >
> > - Solution:
> > The fix replaces usage capable() by ns_capable().
> >
> > Becuase SMACK uses globally defined rules usage ns_capable() was
> > limited to places where requested by task operation are connected to
> > himself. All operation that modify global SMACK rules remain
> unchanged
> > - SMACK still to test capabilities calls capable(). It means that
> > operation on smackfs remain unchanged - operation are allowed only by
> > host.
> >
> > Change-Id: I0bb28fa02943dd7ccb38dda2c8a37dcce2d551b2
> > Signed-off-by: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
> > ---
> >  security/smack/smack.h        | 13 +++++++++++++
> >  security/smack/smack_access.c |  2 +-
> >  security/smack/smack_lsm.c    | 16 ++++++++--------
> >  3 files changed, 22 insertions(+), 9 deletions(-)
> >
> > diff --git a/security/smack/smack.h b/security/smack/smack.h index
> > d072fd3..9f9d5e7 100644
> > --- a/security/smack/smack.h
> > +++ b/security/smack/smack.h
> > @@ -319,6 +319,19 @@ static inline int smack_privileged(int cap)  }
> >
> >  /*
> > + * Is the task privileged and allowed to privileged
> > + * by the onlycap rule in user namespace.
> > + */
> > +static inline int smack_privileged_ns(int cap) {
> > +       if (!ns_capable(current_user_ns(), cap))
> > +               return 0;
> 
> As I responded on lxc-devel (sorry I had apparently missed this
> original mail),
> 
> This is an often seen, but very wrong, idiom.  This check means
> nothing, because any unprivileged user can create a new userns and pass
> this check.

I spent two days thinking how to fix the issue. I also discussed the issue
with
my colleagues. The issue seems not to be trivial. 
Generally the SMACK is not ready to support namespaces and definitely 
it was designed to work on host only (in root namespace only). 
Of course you are right - patch like my cause that any unprivileged process 
in his own user namespace can set any label, what from practical 
point of view means that "SMACK" is disabled.

>From my perspective the issue is caused by changed that was implemented 
in kernel 3.8. From this version and later any process can creates own 
user namespace. In the older kernels it was limited to privileged processes.

Perhaps this change should be rollback?

I will be grateful for some ideas how the issue should be resolved.

> 
> You're on the right track, but to do this right you'll need to do a bit
> more work.  For privilege over an inode, there is inode_capable().
> For the network access, check the userns of the struct net owning the
> socket.  etc.
> 
> > +       if (smack_onlycap == NULL || smack_onlycap ==
> smk_of_current())
> > +               return 1;
> > +       return 0;
> > +}
> > +
> > +/*
> >   * logging functions
> >   */
> >  #define SMACK_AUDIT_DENIED 0x1
> > diff --git a/security/smack/smack_access.c
> > b/security/smack/smack_access.c index 14293cd..07d25f5 100644
> > --- a/security/smack/smack_access.c
> > +++ b/security/smack/smack_access.c
> > @@ -230,7 +230,7 @@ int smk_curacc(char *obj_label, u32 mode, struct
> > smk_audit_info *a)
> >         /*
> >          * Allow for priviliged to override policy.
> >          */
> > -       if (rc != 0 && smack_privileged(CAP_MAC_OVERRIDE))
> > +       if (rc != 0 && smack_privileged_ns(CAP_MAC_OVERRIDE))
> >                 rc = 0;
> >
> >  out_audit:
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index cdbf92b..3cc6842 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -226,7 +226,7 @@ static int smack_syslog(int typefrom_file)
> >         int rc = 0;
> >         struct smack_known *skp = smk_of_current();
> >
> > -       if (smack_privileged(CAP_MAC_OVERRIDE))
> > +       if (smack_privileged_ns(CAP_MAC_OVERRIDE))
> >                 return 0;
> >
> >          if (smack_syslog_label != NULL && smack_syslog_label != skp)
> > @@ -842,7 +842,7 @@ static int smack_inode_setxattr(struct dentry
> > *dentry, const char *name,
> >             strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
> >             strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
> >             strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
> > -               if (!smack_privileged(CAP_MAC_ADMIN))
> > +               if (!smack_privileged_ns(CAP_MAC_ADMIN))
> >                         rc = -EPERM;
> >                 /*
> >                  * check label validity here so import wont fail on
> @@
> > -852,7 +852,7 @@ static int smack_inode_setxattr(struct dentry
> > *dentry, const char *name,
> >                     smk_import(value, size) == NULL)
> >                         rc = -EINVAL;
> >         } else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
> > -               if (!smack_privileged(CAP_MAC_ADMIN))
> > +               if (!smack_privileged_ns(CAP_MAC_ADMIN))
> >                         rc = -EPERM;
> >                 if (size != TRANS_TRUE_SIZE ||
> >                     strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
> > @@ -950,7 +950,7 @@ static int smack_inode_removexattr(struct dentry
> > *dentry, const char *name)
> >             strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
> >             strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
> >             strcmp(name, XATTR_NAME_SMACKMMAP)) {
> > -               if (!smack_privileged(CAP_MAC_ADMIN))
> > +               if (!smack_privileged_ns(CAP_MAC_ADMIN))
> >                         rc = -EPERM;
> >         } else
> >                 rc = cap_inode_removexattr(dentry, name); @@ -1342,7
> > +1342,7 @@ static int smack_file_send_sigiotask(struct task_struct
> > *tsk,
> >         /* we don't log here as rc can be overriden */
> >         skp = smk_find_entry(file->f_security);
> >         rc = smk_access(skp, tkp->smk_known, MAY_WRITE, NULL);
> > -       if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
> > +       if (rc != 0 && has_ns_capability(tsk, current_user_ns(),
> > CAP_MAC_OVERRIDE))
> >                 rc = 0;
> >
> >         smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK); @@ -2924,7
> > +2924,7 @@ static int smack_setprocattr(struct task_struct *p, char
> > *name,
> >         if (p != current)
> >                 return -EPERM;
> >
> > -       if (!smack_privileged(CAP_MAC_ADMIN))
> > +       if (!smack_privileged_ns(CAP_MAC_ADMIN))
> >                 return -EPERM;
> >
> >         if (value == NULL || size == 0 || size >= SMK_LONGLABEL) @@
> > -2980,7 +2980,7 @@ static int smack_unix_stream_connect(struct sock
> > *sock,
> >         smk_ad_setfield_u_net_sk(&ad, other);  #endif
> >
> > -       if (!smack_privileged(CAP_MAC_OVERRIDE)) {
> > +       if (!smack_privileged_ns(CAP_MAC_OVERRIDE)) {
> >                 skp = ssp->smk_out;
> >                 rc = smk_access(skp, osp->smk_in, MAY_WRITE, &ad);
> >         }
> > @@ -3018,7 +3018,7 @@ static int smack_unix_may_send(struct socket
> > *sock, struct socket *other)
> >         smk_ad_setfield_u_net_sk(&ad, other->sk);  #endif
> >
> > -       if (smack_privileged(CAP_MAC_OVERRIDE))
> > +       if (smack_privileged_ns(CAP_MAC_OVERRIDE))
> >                 return 0;
> >
> >         skp = ssp->smk_out;
> > --
> > 1.8.3.2
> >
> >
> > I will be grateful for comments
> >
> >
> > Best regards
> >
> > Jacek Pielaszkiewicz
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


