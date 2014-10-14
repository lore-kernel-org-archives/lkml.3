Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaJNOdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:33:31 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:43639 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932121AbaJNOda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:33:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3873:4250:4321:4605:5007:6119:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13095:13161:13229:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tail70_1e2c133e1684e
X-Filterd-Recvd-Size: 3104
Message-ID: <1413297205.3269.11.camel@joe-AO725>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Joe Perches <joe@perches.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: dedekind1@gmail.com, ezequiel.garcia@free-electrons.com,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 14 Oct 2014 07:33:25 -0700
In-Reply-To: <543D304C.5000607@codeaurora.org>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <543D304C.5000607@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 17:16 +0300, Tanya Brokhman wrote:
> On 10/14/2014 5:13 PM, Tanya Brokhman wrote:
> > If there is more then one UBI device mounted, there is no way to
> > distinguish between messages from different UBI devices.
> > Add device number to all ubi layer message types.
[]
> > diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
[]
> > @@ -206,7 +208,7 @@ static int validate_vid_hdr(const struct ubi_vid_hdr *vid_hdr,
> >   		 */
> >
> >   		if (vol_id != av->vol_id) {
> > -			ubi_err("inconsistent vol_id");
> > +			ubi_err(ubi, "inconsistent vol_id");
> >   			goto bad;
> >   		}
> >

If you are going to change all the ubi_<level> calls,
can you also please add a terminating newline to all
the uses for consistency with all the other
pr_<level>/dev_<level>/<etc>_<level> calls?

(and remove the newline from the ubi_<level> macros)

> > diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
[]
> > @@ -50,13 +50,14 @@
> >   #define UBI_NAME_STR "ubi"
> >
> >   /* Normal UBI messages */
> > -#define ubi_msg(fmt, ...) pr_notice("UBI: " fmt "\n", ##__VA_ARGS__)
> > +#define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
> > +				 ubi->ubi_num, __func__, ##__VA_ARGS__)
> >   /* UBI warning messages */
> > -#define ubi_warn(fmt, ...) pr_warn("UBI warning: %s: " fmt "\n",  \
> > -				   __func__, ##__VA_ARGS__)
> > +#define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n",  \
> > +				   ubi->ubi_num, __func__, ##__VA_ARGS__)
> >   /* UBI error messages */
> > -#define ubi_err(fmt, ...) pr_err("UBI error: %s: " fmt "\n",      \
> > -				 __func__, ##__VA_ARGS__)
> > +#define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n",      \
> > +				 ubi->ubi_num, __func__, ##__VA_ARGS__)

Converting these macros to functions using "%pV"
will save quite a bit of text space by removing
a lot of "UBI-%d <foo>: " duplication.

Using ubi_notice instead of ubi_msg would be a
lot more standard too.


