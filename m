Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaKJQK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:10:29 -0500
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:45315 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858AbaKJQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:10:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:981:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4037:4250:4321:4605:5007:6119:6261:7875:7903:10004:10400:10848:11026:11232:11233:11473:11658:11914:12296:12438:12517:12519:12740:13095:13161:13229:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rub21_771e97dbc6906
X-Filterd-Recvd-Size: 3869
Message-ID: <1415635817.8868.6.camel@perches.com>
Subject: Re: [PATCH] UBI: Extend UBI layer debug/messaging capabilities -
 cosmetics
From: Joe Perches <joe@perches.com>
To: dedekind1@gmail.com
Cc: Tanya Brokhman <tlinder@codeaurora.org>, hujianyang@huawei.com,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 10 Nov 2014 08:10:17 -0800
In-Reply-To: <1415625297.22887.108.camel@sauron.fi.intel.com>
References: <1415531185-2343-1-git-send-email-tlinder@codeaurora.org>
	 <1415621918.22887.80.camel@sauron.fi.intel.com>
	 <5460B553.5060401@codeaurora.org>
	 <1415625297.22887.108.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 15:14 +0200, Artem Bityutskiy wrote:
> On Mon, 2014-11-10 at 14:53 +0200, Tanya Brokhman wrote:
> > On 11/10/2014 2:18 PM, Artem Bityutskiy wrote:
> > > On Sun, 2014-11-09 at 13:06 +0200, Tanya Brokhman wrote:
> > >>
> > >>   /* Normal UBI messages */
> > >>   #define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
> > >> -                                        ubi->ubi_num, __func__, ##__VA_ARGS__)
> > >> +                               (ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
> > >> +                               __func__, ##__VA_ARGS__)
> > >>   /* UBI warning messages */
> > >>   #define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n", \
> > >> -                                       ubi->ubi_num, __func__, ##__VA_ARGS__)
> > >> +                               (ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
> > >> +                               __func__, ##__VA_ARGS__)
> > >>   /* UBI error messages */
> > >>   #define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n", \
> > >> -                                     ubi->ubi_num, __func__, ##__VA_ARGS__)
> > >> +                               (ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
> > >> +                               __func__, ##__VA_ARGS__)
> > >
> > > Why did you make these changes? It is preferable to not add another 'if'
> > > statement to this macro to handle one or 2 cases - much bloat, little
> > > gain.
> > >
> > > Could we please avoid this?
> > 
> > I just wanted to be on the safe side and prevent this macro being called 
> > with ubi=NULL that may crash the system. If you still prefer the "if" 
> > removed will do.
> 
> On the other hand, these are macros, and this if gets duplicated in many
> places and translate into few additional assembly instructions per
> message.

The thing that will make these uses smaller is to
convert them to functions.

There is a lot of extra duplicated "UBI-%s <msg_type>: "
constant string .text added.

Using a function uses a single copy of each prefix.

The __func__ variable can also be removed.
__builtin_return_address(0) may be substituted to save
a few more bytes per instance.

Something like:

(prototype)
__printf(2, 3)
void ubi_warn(struct ubi *ubi, const char *fmt, ...);

(implementation)
__printf(2, 3)
void ubi_warn(struct ubi *ubi, const char *fmt, ...)
{
	struct va_format vaf;
	va_list args;
	int device;

	va_start(args, format);

	vaf.fmt = format;
	vaf.va = &args;

	if (!ubi)
		device = UBI_MAX_DEVICE;
	else
		device = ubi->ubi_num;

	pr_warn("UBI-%d warning: %pf: %pV",
		device, __builtin_return_address(0), &vaf);

	va_end(args);
}


