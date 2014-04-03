Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaDCRuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:50:22 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:51286
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753143AbaDCRuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:50:15 -0400
Date: Thu, 3 Apr 2014 19:50:14 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
Cc: "'Serge E. Hallyn'" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        casey@schaufler-ca.com, lxc-devel@lists.linuxcontainers.org
Subject: Re: Fwd: [SMACK]Problem with user naespace
Message-ID: <20140403175014.GA4907@mail.hallyn.com>
References: <53304E00.3060405@samsung.com>
 <53312DE7.6040803@samsung.com>
 <20140329161612.GA25354@mail.hallyn.com>
 <05d001cf4f12$4c306780$e4913680$%pielaszkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05d001cf4f12$4c306780$e4913680$%pielaszkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jacek Pielaszkiewicz (j.pielaszkie@samsung.com):
> My comments below.
> 
> Best regards
> 
> 
> Jacek Pielaszkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> Email: j.pielaszkie@samsung.com
> 
> 
> > -----Original Message-----
> > From: Serge E. Hallyn [mailto:serge@hallyn.com]
> > Sent: Saturday, March 29, 2014 5:16 PM
> > To: Jacek Pielaszkiewicz
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: Fwd: [SMACK]Problem with user naespace
> > 
> > Quoting Jacek Pielaszkiewicz (j.pielaszkie@samsung.com):
> > >
> > > Hi
> > >
> > >     I have problem with starting lxc containers when SMACK is enabled
> > > on the host. The issue appears when systemd try start user session in
> > > the container. In such case systemd reports error that has not
> > > permissions to set SMACK label. In my test configuration lxc
> > container
> > > has full separation (all namespaces are enabled - including user
> > namespace).
> > >     The issue is common. The problem is due to lack of permissions of
> > > the task to write into /proc/self/sttr/current file even the task has
> > > active CAP_MAC_ADMIN capability. Regarding to may tests the issue is
> > > connected to user namespace.
> > >
> > >     I have prepared patch (see below). The patch was tested and
> > > created on kernel 3.10.
> > >
> > > From 1d42d88fccafb7a9fa279588bc827163484a7852 Mon Sep 17 00:00:00
> > 2001
> > > From: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
> > > Date: Mon, 24 Mar 2014 14:11:58 +0100
> > > Subject: [PATCH] [PATCH] Enable user namespace in SMACK
> > >
> > > SMACK: Enable user namespace
> > >
> > > - Bug/Issue:
> > > The issue has been found when we tried to setup lxc container.
> > > We tried to setup the container with active all linux namespaces
> > > (including user namespace). On the host as LSM was enabled SMACK.
> > >
> > > We have found that "systemd" was not able to setup user sessiondue to
> > > lack of permissions to write into /proc/self/attr/currentfile.
> > >
> > > We have found general issue that any privileged process with enabled
> > > CAP_MAC_ADMIN cannot write into /proc/self/attr/currentfile.
> > >
> > > - Cause:
> > > SMACK to check the task capabilities uses capable().
> > >
> > > - Solution:
> > > The fix replaces usage capable() by ns_capable().
> > >
> > > Becuase SMACK uses globally defined rules usage ns_capable() was
> > > limited to places where requested by task operation are connected to
> > > himself. All operation that modify global SMACK rules remain
> > unchanged
> > > - SMACK still to test capabilities calls capable(). It means that
> > > operation on smackfs remain unchanged - operation are allowed only by
> > > host.
> > >
> > > Change-Id: I0bb28fa02943dd7ccb38dda2c8a37dcce2d551b2
> > > Signed-off-by: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
> > > ---
> > >  security/smack/smack.h        | 13 +++++++++++++
> > >  security/smack/smack_access.c |  2 +-
> > >  security/smack/smack_lsm.c    | 16 ++++++++--------
> > >  3 files changed, 22 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/security/smack/smack.h b/security/smack/smack.h index
> > > d072fd3..9f9d5e7 100644
> > > --- a/security/smack/smack.h
> > > +++ b/security/smack/smack.h
> > > @@ -319,6 +319,19 @@ static inline int smack_privileged(int cap)  }
> > >
> > >  /*
> > > + * Is the task privileged and allowed to privileged
> > > + * by the onlycap rule in user namespace.
> > > + */
> > > +static inline int smack_privileged_ns(int cap) {
> > > +       if (!ns_capable(current_user_ns(), cap))
> > > +               return 0;
> > 
> > As I responded on lxc-devel (sorry I had apparently missed this
> > original mail),
> > 
> > This is an often seen, but very wrong, idiom.  This check means
> > nothing, because any unprivileged user can create a new userns and pass
> > this check.
> 
> I spent two days thinking how to fix the issue. I also discussed the issue
> with
> my colleagues. The issue seems not to be trivial. 
> Generally the SMACK is not ready to support namespaces and definitely 
> it was designed to work on host only (in root namespace only). 
> Of course you are right - patch like my cause that any unprivileged process 
> in his own user namespace can set any label, what from practical 
> point of view means that "SMACK" is disabled.
> 
> >From my perspective the issue is caused by changed that was implemented 
> in kernel 3.8. From this version and later any process can creates own 
> user namespace. In the older kernels it was limited to privileged processes.
> 
> Perhaps this change should be rollback?

?  The problem is that admins in a non-init userns cannot be
smack_capable() so you can't create an unprivileged container.
Right?  (Please correct me if I'm wrong).  So why would we
revert the ability for unprivileged users to unshare(CLONE_NEWUSER)?
If you don't want to use unprivileged containers, don't use
unprivileged containers.

Have you talked to Casey about this?  (cc:d)

As I said, it'll just take a bit more work to check for privilege over
the right things.

-serge
