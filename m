Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3JCUkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:40:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3JCUkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:40:45 -0400
Date: Thu, 3 Oct 2013 16:40:31 -0400
From: Dave Jones <davej@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        Linux Kernel <linux-kernel@vger.kernel.org>, eparis@redhat.com,
        james.l.morris@oracle.com, selinux@tycho.nsa.gov
Subject: Re: [PATCH] conditionally reschedule while loading selinux policy.
Message-ID: <20131003204031.GA25515@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Linux Kernel <linux-kernel@vger.kernel.org>, eparis@redhat.com,
	james.l.morris@oracle.com, selinux@tycho.nsa.gov
References: <20130916173036.GA17950@redhat.com>
 <5249B6F1.4050507@tycho.nsa.gov>
 <20130930211342.GA24001@redhat.com>
 <2297933.rECKfqAcWT@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2297933.rECKfqAcWT@sifl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 04:36:10PM -0400, Paul Moore wrote:
 > On Monday, September 30, 2013 05:13:42 PM Dave Jones wrote:
 > > On Mon, Sep 30, 2013 at 01:37:53PM -0400, Stephen Smalley wrote:
 > >  > > With that patch applied, the problem seems to have moved elsewhere..
 > >  >
 > >  > Sorry, what locks are we holding there?  You ought to be able to do a
 > >  > cond_resched() anywhere during policydb_read() AFAIK; it is loading the
 > >  > policy into a new structure that isn't being accessed by anything else
 > >  > yet and the policy_rwlock is only held by security_load_policy after
 > >  > calling policydb_read and only to switch it into place as the active
 > >  > policydb.
 > > 
 > > Hmm, I thought I had tried this already, and got a lot of spew, but it turns
 > > out for some reason I had previously patched hashtab_search instead.
 > > 
 > > I'll try running with this for a while..
 > 
 > Hi Dave,
 > 
 > Just checking to see if this patch solved your problem ... ?
 > 
 > > diff --git a/security/selinux/ss/hashtab.c b/security/selinux/ss/hashtab.c
 > > index 933e735..2cc4961 100644
 > > --- a/security/selinux/ss/hashtab.c
 > > +++ b/security/selinux/ss/hashtab.c
 > > @@ -6,6 +6,7 @@
 > >  #include <linux/kernel.h>
 > >  #include <linux/slab.h>
 > >  #include <linux/errno.h>
 > > +#include <linux/sched.h>
 > >  #include "hashtab.h"
 > > 
 > >  struct hashtab *hashtab_create(u32 (*hash_value)(struct hashtab *h, const
 > > void *key), @@ -40,6 +41,8 @@ int hashtab_insert(struct hashtab *h, void
 > > *key, void *datum) u32 hvalue;
 > >  	struct hashtab_node *prev, *cur, *newnode;
 > > 
 > > +	cond_resched();
 > > +
 > >  	if (!h || h->nel == HASHTAB_MAX_NODES)
 > >  		return -EINVAL;

I couldn't get a backtrace when I downgraded, and reupgraded my policy,
but that said, I didn't when I tested that way on my first patch either.
It wasn't until I got a newer policy that I saw the 2nd spew.
I was planning on sitting on this until the next policy update just
to confirm.

	Dave

