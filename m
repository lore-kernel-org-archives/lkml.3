Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3LNG5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 01:57:52 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:54147 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391Ab3LNG5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 01:57:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2110:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:6691:7652:9025:9149:9388:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12438:12517:12519:12555:12740:13025:13071:13868:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meat71_272ca7d351651
X-Filterd-Recvd-Size: 4882
Message-ID: <1387004267.2276.7.camel@joe-AO722>
Subject: Re: bnx2x_sriov.c: Missing switch/case breaks?
From: Joe Perches <joe@perches.com>
To: Yuval Mintz <yuvalmin@broadcom.com>
Cc: Ariel Elior <ariele@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 13 Dec 2013 22:57:47 -0800
In-Reply-To: <979A8436335E3744ADCD3A9F2A2B68A52AF1A735@SJEXCHMB10.corp.ad.broadcom.com>
References: <1386975703.2479.48.camel@joe-AO722>
	 <979A8436335E3744ADCD3A9F2A2B68A52AF1A735@SJEXCHMB10.corp.ad.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-14 at 06:16 +0000, Yuval Mintz wrote:
> > Hi Ariel.
> > 
> > I wrote a little checkpatch script to look for missing
> > switch/case breaks.
> > 
> > http://www.kernelhub.org/?msg=379933&p=2
> > 
> > There are _many_ instances of case blocks in sriov.c
> > that could be missing breaks as they use fall-throughs.
> > 
> > It would be good if these are actually intended to be
> > fall-throughs to add a /* fall-through */ comment between
> > each case block.
> > 
> > For instance:
> > 
> > static void bnx2x_vfop_qctor(struct bnx2x *bp, struct bnx2x_virtf *vf)
> > {
> > [...]
> > 	switch (state) {
> > 	case BNX2X_VFOP_QCTOR_INIT:
> > 
> > 		/* has this queue already been opened? */
> > 		if (bnx2x_get_q_logical_state(bp, q_params->q_obj) ==
> > 		    BNX2X_Q_LOGICAL_STATE_ACTIVE) {
> > 			DP(BNX2X_MSG_IOV,
> > 			   "Entered qctor but queue was already up. Aborting
> > gracefully\n");
> > 			goto op_done;
> > 		}
> > 
> > 		/* next state */
> > 		vfop->state = BNX2X_VFOP_QCTOR_SETUP;
> > 
> > 		q_params->cmd = BNX2X_Q_CMD_INIT;
> > 		vfop->rc = bnx2x_queue_state_change(bp, q_params);
> > 
> > 		bnx2x_vfop_finalize(vf, vfop->rc, VFOP_CONT); 
> 
> Hi Joe,

Hi Yuval.

> The `vfop' part of the code contains a lot of usage of the `bnx2x_vfop_finalize()',
> which either goto or return at the end of almost every case.
> "Normal" analysis tools/scripts fail to recognize them as  valid case breaks.
> 
> Adding `fallthrough' comments would make little sense, as this is not the real
> behavior; Perhaps we need some alternative comment? (something in the line
> of `macro case break')

No idea.  It's certainly an ugly macro.

This does have a fallthrough path though when
(rc == 0  && next == VFOP_VERIFY_PEND) so
maybe there should be a break after most all
uses of this macro anyway.  When next is
VFOP_VERIFY_PEND, then a "fall-through" comment
would be appropriate.

cheers, Joe

drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h:#define bnx2x_vfop_finalize(vf, rc, next) do {                                \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-              if ((rc) < 0)                                           \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      goto op_err;                                    \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-              else if ((rc) > 0)                                      \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      goto op_pending;                                \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-              else if ((next) == VFOP_DONE)                           \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      goto op_done;                                   \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-              else if ((next) == VFOP_VERIFY_PEND)                    \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      BNX2X_ERR("expected pending\n");                \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-              else {                                                  \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      DP(BNX2X_MSG_IOV, "no ramrod. Scheduling\n");   \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      atomic_set(&vf->op_in_progress, 1);             \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      queue_delayed_work(bnx2x_wq, &bp->sp_task, 0);  \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-                      return;                                         \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-              }                                                       \
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-      } while (0)
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h-


