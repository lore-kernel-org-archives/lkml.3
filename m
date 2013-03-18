Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3CRRG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab3CRRGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:06:24 -0400
Date: Mon, 18 Mar 2013 13:05:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com,
        akpm@linux-foundation.org, ebiederm@xmission.com
Subject: Re: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
Message-ID: <20130318170552.GG20743@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
 <1363379758-10071-4-git-send-email-vgoyal@redhat.com>
 <51438EDB.3050300@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51438EDB.3050300@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 02:12:59PM -0700, Casey Schaufler wrote:
> On 3/15/2013 1:35 PM, Vivek Goyal wrote:
> > Create a new capability CAP_SIGNED which can be given to signed executables.
> 
> This would drive anyone who is trying to use
> capabilities as the privilege mechanism it is
> intended to be absolutely crazy.

Will calling it CAP_SIGNED_SERVICES help. I intend to use it as
capability (and not just as a flag for task attribute).

I think primary difference here is that this capability is controlled
by kernel and only validly signed processes get it.

> 
> Capabilities aren't just random attribute bits. They
> indicate that a task has permission to violate a
> system policy (e.g. change the mode bits of a file
> the user doesn't own). Think about how this will
> interact with programs using file based capabilities.

It is a separate capability. I am not sure why it would
interfere with other capabilities or functionality out there.

Thanks
Vivek

> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  include/uapi/linux/capability.h |   12 +++++++++++-
> >  kernel/cred.c                   |    7 +++++++
> >  security/commoncap.c            |    2 ++
> >  3 files changed, 20 insertions(+), 1 deletions(-)
> >
> > diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> > index ba478fa..1bbe671 100644
> > --- a/include/uapi/linux/capability.h
> > +++ b/include/uapi/linux/capability.h
> > @@ -343,7 +343,17 @@ struct vfs_cap_data {
> >  
> >  #define CAP_BLOCK_SUSPEND    36
> >  
> > -#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
> > +/*
> > + * Allow certain kernel services with secureboot enabled. One of such
> > + * service is sys_kexec() which can be invoked by process only if it
> > + * has CAP_SIGNED capability (with secureboot enabled).
> > + *
> > + * This capability is given by kernel automatically if executable
> > + * file is validly signed.
> > + */
> > +#define CAP_SIGNED    37
> > +
> > +#define CAP_LAST_CAP         CAP_SIGNED
> >  
> >  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
> >  
> > diff --git a/kernel/cred.c b/kernel/cred.c
> > index e0573a4..f554d1b 100644
> > --- a/kernel/cred.c
> > +++ b/kernel/cred.c
> > @@ -555,6 +555,12 @@ void revert_creds(const struct cred *old)
> >  }
> >  EXPORT_SYMBOL(revert_creds);
> >  
> > +static void remove_cap_signed_init_cred(void)
> > +{
> > +	cap_lower((&init_cred)->cap_bset, CAP_SIGNED);
> > +	cap_lower((&init_cred)->cap_permitted, CAP_SIGNED);
> > +}
> > +
> >  /*
> >   * initialise the credentials stuff
> >   */
> > @@ -563,6 +569,7 @@ void __init cred_init(void)
> >  	/* allocate a slab in which we can store credentials */
> >  	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
> >  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> > +	remove_cap_signed_init_cred();
> >  }
> >  
> >  /**
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index c44b6fe..4190eb9 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -272,6 +272,8 @@ int cap_capset(struct cred *new,
> >  	new->cap_effective   = *effective;
> >  	new->cap_inheritable = *inheritable;
> >  	new->cap_permitted   = *permitted;
> > +	if (cap_raised(old->cap_effective, CAP_SIGNED))
> > +		cap_raise(new->cap_effective, CAP_SIGNED);
> >  	return 0;
> >  }
> >  
