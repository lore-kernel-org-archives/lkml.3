Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591Ab3GaTjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:39:33 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:57129 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab3GaTjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:39:31 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v14 3/6] LSM: Explicit individual LSM associations
Date: Wed, 31 Jul 2013 15:39:26 -0400
Message-ID: <2122972.gxaeSjOpon@sifl>
User-Agent: KMail/4.10.5 (Linux/3.10.2-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51F939BF.3010404@schaufler-ca.com>
References: <51F16CFB.6040603@schaufler-ca.com> <5154459.vWAL79RUx2@sifl> <51F939BF.3010404@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 31, 2013 09:22:23 AM Casey Schaufler wrote:
> On 7/30/2013 3:08 PM, Paul Moore wrote:
> > On Thursday, July 25, 2013 11:32:11 AM Casey Schaufler wrote:
> >> Subject: [PATCH v14 3/6] LSM: Explicit individual LSM associations
> >> 
> >> Expand the /proc/.../attr interface set to help include
> >> LSM specific entries as well as the traditional shared
> >> "current", "prev" and "exec" entries. Each LSM that uses
> >> one of the traditional interfaces gets it's own interface
> >> prefixed with the LSM name for the ones it cares about.
> >> Thus, we have "smack.current", "selinux.current" and
> >> "apparmor.current" in addition to "current".
> >> 
> >> Add two new interfaces under /sys/kernel/security.
> >> The lsm interface displays the comma seperated list of
> >> active LSMs. The present interface displays the name
> >> of the LSM providing the traditional /proc/.../attr
> >> interfaces. User space code should no longer have to
> >> grub around in odd places to determine what LSM is
> >> being used and thus what data is available to it.
> >> 
> >> Introduce feature specific security operation vectors
> >> for NetLabel, XFRM, secmark and presentation in the
> >> traditional /proc/.../attr interfaces. This allows
> >> proper handling of secids.
> > 
> > Maybe I missed something, can you elaborate on this, perhaps even provide
> > an example for us simple minded folk?
> 
> There are a set of facilities that (currently, at least)
> can't be shared by multiple LSMs ...

I should have been more specific.

Thanks for the explanation, but that I understand the problems of stacking 
LSM/secids, we've had that conversation a few times now.  The explanation I 
was hoping for had to do with this sentence:

 "Introduce feature specific security operation vectors for
  NetLabel, XFRM, secmark and presentation in the traditional
  /proc/.../attr interfaces."

Can you explain this a bit more?  When I looked at the patch - and maybe I'm 
missing something - I didn't see anything in /proc that dealt with NetLabel, 
XFRM, and/or Secmark.

> >> Add NetLabel interfaces that allow an LSM to request
> >> ownership of the NetLabel subsystem and to determine
> >> whether or not it has that ownership. These interfaces
> >> are intended to allow a future in which NetLabel can
> >> support multiple LSMs at the same time, although they
> >> do not do so now.
> >> 
> >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > ...
> > 
> >> --- a/include/net/netlabel.h
> >> +++ b/include/net/netlabel.h
> >> @@ -407,7 +407,9 @@ int netlbl_secattr_catmap_setrng(struct
> >> netlbl_lsm_secattr_catmap *catmap, /*
> >> 
> >>   * LSM protocol operations (NetLabel LSM/kernel API)
> >>   */
> >> 
> >> -int netlbl_enabled(void);
> >> +int netlbl_enabled(struct security_operations *lsm);
> >> +int netlbl_lsm_owner(struct security_operations *lsm);
> >> +int netlbl_lsm_register(struct security_operations *lsm);
> >> 
> >>  int netlbl_sock_setattr(struct sock *sk,
> >>  
> >>  			u16 family,
> >>  			const struct netlbl_lsm_secattr *secattr);
> >> 
> >> @@ -521,7 +523,11 @@ static inline int netlbl_secattr_catmap_setrng(
> >> 
> >>  {
> >>  
> >>  	return 0;
> >>  
> >>  }
> >> 
> >> -static inline int netlbl_enabled(void)
> >> +static inline int netlbl_lsm_register(struct security_operations *lsm)
> >> +{
> >> +	return 0;
> >> +}
> >> +static inline int netlbl_enabled(struct security_operations *lsm)
> >> 
> >>  {
> >>  
> >>  	return 0;
> >>  
> >>  }
> > 
> > Is it worth including a static inline for netlabel_lsm_owner() for the
> > sake of completeness?  I haven't looked closely enough yet to know if it
> > is strictly necessary or not.
> 
> I don't think it ever comes up, which would imply we don't need
> netlbl_enabled(), either.

Probably not, but I like the safety of having it defined.  I guess that is why 
I would prefer having netlabel_lsm_owner() defined here as well.

> >> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> >> index 00a2b2b..5ca352b 100644
> >> --- a/net/ipv4/cipso_ipv4.c
> >> +++ b/net/ipv4/cipso_ipv4.c
> >> @@ -1594,7 +1594,7 @@ static int cipso_v4_parsetag_loc(const struct
> >> cipso_v4_doi *doi_def, u32 secid;
> >> 
> >>  	secid = *(u32 *)&tag[2];
> >> 
> >> -	lsm_init_secid(&secattr->attr.secid, secid, 0);
> >> +	lsm_init_secid(&secattr->attr.secid, secid, lsm_netlbl_order());
> >> 
> >>  	secattr->flags |= NETLBL_SECATTR_SECID;
> > 
> > I still need to wrap my head around all the changes, but I *think* this
> > change may not be necessary since NetLabel isn't multi-LSM aware at the
> > moment.  If this change is necessary, then there are likely other changes
> > that need to be made as well, the NetLabel LSM cache would be my main
> > concern.
> 
> Using the NetLabel secid slot is necessary because when we get into
> the auditing code the secid needs to be in the right place to associate
> it with the right LSM.

Fair enough.

-- 
paul moore
www.paul-moore.com

