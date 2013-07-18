Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab3GRNc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:32:58 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:63156 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990Ab3GRNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130718090835.GZ4165@ZenIV.linux.org.uk>
References: <20130718090835.GZ4165@ZenIV.linux.org.uk>
From: Peng Tao <bergwolf@gmail.com>
Date: Thu, 18 Jul 2013 21:32:34 +0800
Message-ID: <CA+a=Yy49WfQVJAYybUzVvigi9b--kuagqKxBEH+yy0RZSKVnQA@mail.gmail.com>
Subject: Re: [lustre mess] is mgc_fs_setup() reachable at all?
To: Al Viro <viro@zeniv.linux.org.uk>,
        "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Nathan Rutman <Nathan_Rutman@xyratex.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Thu, Jul 18, 2013 at 5:08 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> [nathan cc'd since he's the only person mentioned in mgc_request.c]
>
clusterfs is long gone. Add nathan's new mail address. Also add
Andreas Dilger. He is the maintainer of the Lustre code.

> One general observation: drivers/taging/lustre is highly reviewer-hostile...
>
sorry...

> Found by unrelated grep:
>
> drivers/staging/lustre/lustre/mgc/mgc_request.c:1040:           if (vallen != sizeof(struct super_block))
>
> Huh?  The code around that line looks so:
>         if (KEY_IS(KEY_SET_FS)) {
>                 struct super_block *sb = (struct super_block *)val;
>                 struct lustre_sb_info *lsi;
>                 if (vallen != sizeof(struct super_block))
>                         RETURN(-EINVAL);
>                 lsi = s2lsi(sb);
>                 rc = mgc_fs_setup(exp->exp_obd, sb, lsi->lsi_srv_mnt);
>                 if (rc) {
>                         CERROR("set_fs got %d\n", rc);
>                 }
>                 RETURN(rc);
>         }
> What is going on here?  We cast something to struct super_block *?
> Where does it come from?  The function it's in is
>
> int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
>                        obd_count keylen, void *key, obd_count vallen,
>                        void *val, struct ptlrpc_request_set *set)
>
> which says damn little, other than "multiplexor with no type safety".  Who
> calls that?
> ; git grep -n -w mgc_set_info_async
> drivers/staging/lustre/lustre/mgc/mgc_request.c:1001:int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
> drivers/staging/lustre/lustre/mgc/mgc_request.c:1836:   .o_set_info_async = mgc_set_info_async,
> ;
>
> Umm...  OK, looks like it's only called as a method.  Unfortunately, grep for
> o_set_info_async brings a lot of instances and no callers.  After a lot of
> cursing, the following antisocial Fine Piece Of Code had been located:
>
> #define OBP(dev, op)    (dev)->obd_type->typ_dt_ops->o_ ## op
>
> along with
>
>         rc = OBP(exp->exp_obd, set_info_async)(env, exp, keylen, key, vallen,
>                                                val, set);
>
> As far as I'm concerned, macros like that are equivalent to spitting into
> reviewers' eyes.  Sometimes out of malice, sometimes just because the authors
> felt like it would be a cute prank, either way it makes life really unpleasant -
> when you need to guess which part of method/function name is to be searched for
> to locate the call sites... it gets old very soon.
It caused a lot of trouble for many to follow the code...

Andreas, can we just drop such macros?

> Anyway, this thing is in
>
> static inline int obd_set_info_async(const struct lu_env *env,
>                                      struct obd_export *exp, obd_count keylen,
>                                      void *key, obd_count vallen, void *val,
>                                      struct ptlrpc_request_set *set)
>
> Again, the type safety is inexistent, but let's cross the fingers and look for
> callers (and hope they hadn't pulled a similar cute trick with ## here)
>
> ; git grep -n -w obd_set_info_async
> drivers/staging/lustre/lustre/include/obd_class.h:508:static inline int obd_set_info_async(const struct lu_env *env,
> drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c:522:            rc = obd_set_info_async(req->rq_svc_thread->t_env,
> drivers/staging/lustre/lustre/llite/dir.c:658:  rc = obd_set_info_async(NULL, mgc, sizeof(KEY_SET_INFO), KEY_SET_INFO,
> drivers/staging/lustre/lustre/llite/llite_lib.c:558:    err = obd_set_info_async(NULL, sbi->ll_dt_exp, sizeof(KEY_CHECKSUM),
> drivers/staging/lustre/lustre/llite/llite_lib.c:563:    err = obd_set_info_async(NULL, sbi->ll_dt_exp, sizeof(KEY_CACHE_SET),
> drivers/staging/lustre/lustre/llite/llite_lib.c:1964:   obd_set_info_async(NULL, sbi->ll_md_exp,
> drivers/staging/lustre/lustre/llite/llite_lib.c:1967:   obd_set_info_async(NULL, sbi->ll_dt_exp,
> drivers/staging/lustre/lustre/llite/llite_lib.c:2032:           err = obd_set_info_async(NULL, sbi->ll_md_exp,
> drivers/staging/lustre/lustre/llite/lproc_llite.c:437:          rc = obd_set_info_async(NULL, sbi->ll_dt_exp,
> drivers/staging/lustre/lustre/llite/lproc_llite.c:485:  rc = obd_set_info_async(NULL, sbi->ll_dt_exp, sizeof(KEY_CHECKSUM),
> drivers/staging/lustre/lustre/lmv/lmv_obd.c:281:                obd_set_info_async(NULL, tgt->ltd_exp, sizeof(KEY_INTERMDS),
> drivers/staging/lustre/lustre/lmv/lmv_obd.c:2239:                       err = obd_set_info_async(env, tgt->ltd_exp,
> drivers/staging/lustre/lustre/lov/lov_obd.c:638:                rc = obd_set_info_async(NULL, tgt->ltd_exp,
> drivers/staging/lustre/lustre/lov/lov_obd.c:2629:                       err = obd_set_info_async(env, tgt->ltd_exp,
> drivers/staging/lustre/lustre/lov/lov_obd.c:2633:                       err = obd_set_info_async(env, tgt->ltd_exp,
> drivers/staging/lustre/lustre/lov/lov_obd.c:2646:                       err = obd_set_info_async(env, tgt->ltd_exp, keylen,
> drivers/staging/lustre/lustre/lov/lov_obd.c:2655:                       err = obd_set_info_async(env, tgt->ltd_exp,
> drivers/staging/lustre/lustre/mdc/mdc_request.c:1767:           rc = obd_set_info_async(NULL, exp, strlen(KEY_CHANGELOG_CLEAR),
> drivers/staging/lustre/lustre/obdclass/genops.c:624:            rc2 = obd_set_info_async(NULL, obd->obd_self_export,
> drivers/staging/lustre/lustre/obdclass/obd_mount.c:277:         rc = obd_set_info_async(NULL, obd->obd_self_export,
> drivers/staging/lustre/lustre/obdclass/obd_mount.c:326:         rc = obd_set_info_async(NULL, obd->obd_self_export,
> drivers/staging/lustre/lustre/obdclass/obd_mount.c:425: rc = obd_set_info_async(NULL, obd->obd_self_export,
> drivers/staging/lustre/lustre/obdclass/obd_mount.c:437: rc = obd_set_info_async(NULL, obd->obd_self_export,
> ;
>
> Oh, joy... 23 call sites to sift through.  Which ones are we interested in?
> The test down in the FPOS that has started it all is also reviewer-hostile -
> KEY_IS(KEY_SET_FS) has no visible references to function arguments.  Oh, well...
>
> #define KEY_IS(str) \
>         (keylen >= (sizeof(str)-1) && memcmp(key, str, (sizeof(str)-1)) == 0)
> #define KEY_SET_FS              "set_fs"
>
> and KEY_SET_FS is _NOT_ mentioned anywhere outside that check.  Neither is
> "set_fs" as explicit string constant.  I would've assumed the whole thing
> to be dead code, but... what with the preprocessor tricks we'd already seen
> there, I wouldn't bet against that thing coming from string concat.  Or from
> macro stringifying set_fs (sans double quotes).  Or from any number of sick
> preprocessor tricks.  Oh, well - at least we can go through that list and
> drop the call sites that pass a different string constant.  A few minutes
> and curses later we are down to these 5:
>
>                         err = obd_set_info_async(env, tgt->ltd_exp,
>                                                  keylen, key, vallen, val, set);
> in lmv_set_info_async(),
> and
>                         err = obd_set_info_async(env, tgt->ltd_exp,
>                                          keylen, key, sizeof(int),
>                                          &mgi->group, set);
>                         err = obd_set_info_async(env, tgt->ltd_exp,
>                                          keylen, key, vallen,
>                                          ((struct obd_id_info*)val)->data, set);
>                         err = obd_set_info_async(env, tgt->ltd_exp, keylen,
>                                                  key, sizeof(*info->capa),
>                                                  info->capa, set);
>                         err = obd_set_info_async(env, tgt->ltd_exp,
>                                          keylen, key, vallen, val, set);
> in lov_set_info_async().
>
> ; git grep -n -w lmv_set_info_async
> drivers/staging/lustre/lustre/lmv/lmv_obd.c:2212:int lmv_set_info_async(const struct lu_env *env, struct obd_export *exp,
> drivers/staging/lustre/lustre/lmv/lmv_obd.c:2661:       .o_set_info_async       = lmv_set_info_async,
> ;
>
> IOW, this one is another o_set_info_async instance and key/keylen/val/vallen
> is passed from its caller as-is.
>
> ; git grep -n -w lov_set_info_async
> drivers/staging/lustre/lustre/lov/lov_obd.c:2559:static int lov_set_info_async(const struct lu_env *env, struct obd_export *exp,
> drivers/staging/lustre/lustre/lov/lov_obd.c:2850:       .o_set_info_async      = lov_set_info_async,
> ;
>
> ... and this one is also o_set_info_async instance.  In one of 4 call sites
> we appear to pass the arguments as-is, the rest... key/keylen is passed as-is,
> val/vallen isn't.  In any case, key must have originated in one of the
> call sites we'd already eliminated.
>
> So unless I've missed something in that paragon of good taste, there is no
> call chain that could've lead to mgc_set_info_async() with key being "set_fs".
> Incidentally, there is a couple of recursive loops in there that might or
> might not lead to stack overflows.
>
You analysis looks correct. After searching down the list on my own, I
agree with you that the piece of code is unreachable at all. But it is
better to get confirmed by Andreas or Nathan.

> Could somebody familiar with that thing confirm that this is, in fact, dead
> code?  As the matter of fact, could maintainers please stand up and put their
> names into MAINTAINERS?

Andreas, please?

Thanks,
Tao
