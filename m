Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaIIMye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:54:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39717 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaIIMyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:54:32 -0400
Date: Tue, 9 Sep 2014 15:54:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH 6/7] staging: lustre: obdclass: expand the GOTO macro +
 break
Message-ID: <20140909125410.GJ6549@mwanda>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 06:18:34PM +0200, Julia Lawall wrote:
> diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
> index f41695d..8a9752f 100644
> --- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
> +++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
> @@ -1226,25 +1226,25 @@ int class_process_config(struct lustre_cfg *lcfg)
>  	}
>  	case LCFG_POOL_NEW: {
>  		err = obd_pool_new(obd, lustre_cfg_string(lcfg, 2));
> -		GOTO(out, err = 0);
> -		break;
> +		err = 0;
> +		goto out;

[ Warning:  this email is long and not related to your code.  It's just
  the frustrations of dealing with lustre.  ]

So now the code reads:

		err = obd_pool_new(obd, lustre_cfg_string(lcfg, 2));
		err = 0;

That was there in the original code, and your patch is correct to leave
the suspicous looking code as is.  We used to have a GCC warning for
this but the linux kernel source has too much bad code so we had to
disable the warning.

I wonder what happens if obd_pool_new() fails?  Unfortunately "make
cscope" and "vim -t obd_pool_new" doesn't work with lustre so you have
to grep for it.

grep obd_pool_new drivers/staging/lustre/ -R |egrep '\.[ch]:'

This is the only caller so we can't compare with the other callers to
see if they check the return value.

Here is how the obd_pool_new() function is implemented.

  1051  static inline int obd_pool_new(struct obd_device *obd, char *poolname)
  1052  {
  1053          int rc;
  1054  
  1055          OBD_CHECK_DT_OP(obd, pool_new, -EOPNOTSUPP);
  1056          OBD_COUNTER_INCREMENT(obd, pool_new);
  1057  
  1058          rc = OBP(obd, pool_new)(obd, poolname);
  1059          return rc;
  1060  }

This whole function is just macros.  Let's see what they do:

   460  #define OBD_CHECK_DT_OP(obd, op, err)                      \
   461  do {                                                        \
   462          if (!OBT(obd) || !OBP((obd), op)) {                  \
   463                  if (err)                                        \
   464                          CERROR("obd_" #op ": dev %d no operation\n",    \
   465                                 obd->obd_minor);          \
   466                  return err;                                 \
   467          }                                                      \
   468  } while (0)

Wow!  What a terrible macro!  None of the '\' are in a line.  There is
a hidden return statement in it which is a terrible thing and flow
control statements are not allowed inside macros.

I can't tell what OBT() and OBP() because the names are very ambiguous.

   328  #define OBT(dev)        (dev)->obd_type
   329  #define OBP(dev, op)    (dev)->obd_type->typ_dt_ops->o_ ## op
   330  #define MDP(dev, op)    (dev)->obd_type->typ_md_ops->m_ ## op

Ok.  "OB" stands for "obd".  T stands for "type".  The "P" probably
stands for pointer or operation.  MD is clear enough.

The OBP() macro adds an "o_" to the function pointer and the MDP() macro
adds an "m_".  That totally sucks because it makes the function pointer
hard to grep for.  There isn't another explanation, whoever wrote this
code is just being ornery.

Summary so far:  OBD_CHECK_DT_OP() checks to see if a function pointer
is NULL.

Let's see what OBD_COUNTER_INCREMENT() does.

   361  #define OBD_COUNTER_INCREMENT(obdx, op)                    \
   362          if ((obdx)->obd_stats != NULL) {                          \
   363                  unsigned int coffset;                        \
   364                  coffset = (unsigned int)((obdx)->obd_cntr_base) + \
   365                          OBD_COUNTER_OFFSET(op);            \
   366                  LASSERT(coffset < (obdx)->obd_stats->ls_num);     \
   367                  lprocfs_counter_incr((obdx)->obd_stats, coffset); \
   368          }
   369  

That's a densely packed block of messy code but it basically does what
you'd expect from the name.  Fair enough.

So the obd_pool_new() function verifies that ->o_pool_new is non-NULL,
it increments a counter and calls ->o_pool_new().  Let's take a look at
which functions implement ->o_pool_new().

grep -w o_pool_new drivers/staging/lustre/ -R | egrep '\.[ch]:'

The only implementation of this function is lov_pool_new().  Why do
we have a function pointer if there is only one implementation?  We
should remove this.

The lov_pool_new() function definitely can fail unexpectedly with
-ENOMEM.

Let's go back to the original code and see how the error should be
handled...  Oh...  Apparently this is an optional thing so we would
just ignore the error and continue.  The code is fine.

In any other subsystem it would have taken 30 seconds to read the code
because cscope would work and there wouldn't be the layers of
indirection.

I'm not convinced that having a function counter for calls to
lov_pool_new() is useful.  We could get the same information from ftrace
or other tools.  In my view, we could get rid of all the horrible macros
and the function pointers and the splitting names into half and the
layers of indirection and the debugging code and just call
lov_pool_new() directly.

regards,
dan carpenter

