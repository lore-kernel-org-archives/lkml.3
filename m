Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbaIINhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:37:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:14190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaIINhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:37:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="596831471"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Julia Lawall <Julia.Lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hammond, John" <john.hammond@intel.com>
Subject: Re: [PATCH 6/7] staging: lustre: obdclass: expand the GOTO macro +
 break
Thread-Topic: [PATCH 6/7] staging: lustre: obdclass: expand the GOTO macro +
 break
Thread-Index: AQHPyrif93lgr7MQPk2T7454u0oyE5v5OjMAgAAMCoA=
Date: Tue, 9 Sep 2014 13:37:15 +0000
Message-ID: <07AB64A9-8D32-4E67-860A-4E8B3F3EF689@intel.com>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
 <20140909125410.GJ6549@mwanda>
In-Reply-To: <20140909125410.GJ6549@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.119.182]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA86BD7E7A1CE84C8EB26A774FAD7EA8@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Sep 9, 2014, at 8:54 AM, Dan Carpenter wrote:
>   460  #define OBD_CHECK_DT_OP(obd, op, err)                      \
>   461  do {                                                        \
>   462          if (!OBT(obd) || !OBP((obd), op)) {                  \
>   463                  if (err)                                        \
>   464                          CERROR("obd_" #op ": dev %d no operation\n",    \
>   465                                 obd->obd_minor);          \
>   466                  return err;                                 \
>   467          }                                                      \
>   468  } while (0)
> 
> Wow!  What a terrible macro!  None of the '\' are in a line.  There is

This is most likely an artifact of the way spaces were converted to tabs automatically by somebody.

> a hidden return statement in it which is a terrible thing and flow
> control statements are not allowed inside macros.
> 
> I can't tell what OBT() and OBP() because the names are very ambiguous.
> 
>   328  #define OBT(dev)        (dev)->obd_type
>   329  #define OBP(dev, op)    (dev)->obd_type->typ_dt_ops->o_ ## op
>   330  #define MDP(dev, op)    (dev)->obd_type->typ_md_ops->m_ ## op
> 
> Ok.  "OB" stands for "obd".  T stands for "type".  The "P" probably
> stands for pointer or operation.  MD is clear enough.
> 
> The OBP() macro adds an "o_" to the function pointer and the MDP() macro
> adds an "m_".  That totally sucks because it makes the function pointer
> hard to grep for.  There isn't another explanation, whoever wrote this
> code is just being ornery.

I guess I just became numb to this sort of thing over time dealing
with those functions (that frequently irritated me too at first, I guess.)

> So the obd_pool_new() function verifies that ->o_pool_new is non-NULL,
> it increments a counter and calls ->o_pool_new().  Let's take a look at
> which functions implement ->o_pool_new().
> 
> grep -w o_pool_new drivers/staging/lustre/ -R | egrep '\.[ch]:'
> 
> The only implementation of this function is lov_pool_new().  Why do
> we have a function pointer if there is only one implementation?  We
> should remove this.

Well, of course in reality you are only looking at half the code (the client),
and client and server share quite a bit of common glue (used to share
if we are talking about upstream client). There are other implementors of
this method on the server side (not that we care about it here).
There all these different obd layers that do similar operations and
could be (or used to be able to be) stacked on top of each able.

Old (long abandoned idea) was such that you should be able to stack these layers
in almost any order on each other. That never worked out because there
were ever so slight changes to stuff you pass down to the next layer.
But all the supporting infrastructure remained in place. Some of it
still being used and some being there since old times even though
layer order became fixed. After working with lustre sufficiently long
it's just engraved into your head that e.g. "oh, llite always calls into
lov_xxx and lov always calls into osc_xxx via these obd macroses.
Still on the other hand obd is really like an object, it not only has
the methods called in this convoluted manner, but also data fields.
It needs to be seen if things will become even worse if we start calling
these methods directly, and pass around strangely derived structure pointers
with data.

> The lov_pool_new() function definitely can fail unexpectedly with
> -ENOMEM.
> 
> Let's go back to the original code and see how the error should be
> handled...  Oh...  Apparently this is an optional thing so we would
> just ignore the error and continue.  The code is fine.
> 
> In any other subsystem it would have taken 30 seconds to read the code
> because cscope would work and there wouldn't be the layers of
> indirection.
> 
> I'm not convinced that having a function counter for calls to
> lov_pool_new() is useful.  We could get the same information from ftrace
> or other tools.  In my view, we could get rid of all the horrible macros

The counter thing was already noticed by Greg separately and it's in the TODO
list for the perf tracking integration of some sort to replace the obd calls
accounting (see - the "object" benefit, you implement an obd method and
magically there's all this call tracking and other goodies for you that
you can use without even thinking).

> and the function pointers and the splitting names into half and the
> layers of indirection and the debugging code and just call
> lov_pool_new() directly.

I guess the reason for this somewhat apologetic response is to ask to be
a bit more careful and not to throw the baby with the water or something.

Losing ENTRY/EXIT/GOTO was hard enough as I still have not figured out
how do I trace back what happened on a 1000+ node cluster from a
vague "something bad happened" condition with standard tools
without knowing in advance what node was the reason for the badness
(so I cannot just activate a couple of tracepoints).

Bye,
    Oleg

