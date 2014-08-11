Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaHKOVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:21:55 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:58125
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbaHKOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:21:54 -0400
X-IronPort-AV: E=Sophos;i="5.01,841,1400018400"; 
   d="scan'208";a="74517462"
Date: Mon, 11 Aug 2014 16:21:23 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Srikrishan Malik <srikrishanmalik@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        Himangi Saraogi <himangi774@gmail.com>
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
In-Reply-To: <1407757007.20795.18.camel@joe-AO725>
Message-ID: <alpine.DEB.2.10.1408111619510.2518@hadrien>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>  <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>  <20140806201813.GE4856@mwanda> <20140807153136.GB4185@mordor.in.ibm.com>  <20140807160103.GG4856@mwanda>
 <1407429343.2736.28.camel@joe-AO725>  <20140811105706.GA17691@mordor.in.ibm.com> <1407757007.20795.18.camel@joe-AO725>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Aug 2014, Joe Perches wrote:

> On Mon, 2014-08-11 at 16:27 +0530, Srikrishan Malik wrote:
> > On Thu, Aug 07, 2014 at 09:35:43AM -0700, Joe Perches wrote:
> > > On Thu, 2014-08-07 at 19:01 +0300, Dan Carpenter wrote:
> > > > On Thu, Aug 07, 2014 at 09:01:36PM +0530, Srikrishan Malik wrote:
> > > > > On Wed, Aug 06, 2014 at 11:18:13PM +0300, Dan Carpenter wrote:
> > > > > > That looks silly before and after.  Everything is indented in a funny
> > > > > > way.
> > > > >
> > > > > Is this better:
> > > > >
> > > > > 	static const ldlm_policy_data_t lookup_policy = {
> > > > > 				.l_inodebits = { MDS_INODELOCK_LOOKUP }
> > > > > 	};
> > > > >
> > > >
> > > > That is indented too far.
> > > >
> > > > Honestly, I think it looks best on one line but in terms of real life we
> > > > can't ignore checkpatch warnings because eventually someone else will
> > > > try to "fix" it to not be on one line.
> []
> > > I think it looks odd to mix named and unnamed
> > > initializers for the typedef and its members.
> > >
> > > ldlm_policy_data_t is a union and it could be
> > > explicit instead of a typedef.
> > >
> > > Perhaps:
> > > 	static const union ldlm_policy_data lookup_policy = {
> > > 		.l_inodebits = {
> > > 			.bits = MDS_INODELOCK_LOOKUP,
> > > 		},
> > > 	};
> > >
> > > or maybe use another DECLARE_<foo> macro indirection.
> > >
> >
> > This patch set is aimed at removing checkpatch issues from files in
> > lustre/lustre/mdc.
>
> I think eliminating checkpatch identified issues should
> not be the primary goal but a secondary one to the
> overall goal of code style uniformity.
>
> Julia Lawall and Himangi Saraogi from coccinelle fame
> have created a "detypedef" script that is useful for
> structs, perhaps you could extend it for unions and
> run it over this lustre code.
>
> For instance:
> https://lkml.org/lkml/2014/8/9/104

The complete semantic patch is below.  It is in two parts: first for the
case where there is a name for the struct and the second for the case
where there is not.  The code could be extended to automatically drop the
_t's that are commonly put on typedefs.

julia

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

// ----------------------------------------------------------------------
// No name case

@tn1@
type td;
@@

typedef struct { ... } td;

@script:python tf@
td << tn1.td;
tdres;
@@

coccinelle.tdres = td

@@
type tn1.td;
identifier tf.tdres;
@@

-typedef
 struct
+  tdres
   { ... }
-td
 ;

@@
type tn1.td;
identifier tf.tdres;
@@

-td
+ struct tdres
