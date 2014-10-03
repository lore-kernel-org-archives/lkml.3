Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaJCBld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 21:41:33 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:37177 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965AbaJCBlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 21:41:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:7514:7652:7903:8603:9036:9108:10004:10400:10848:10967:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13071:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: air83_4721e90ce414e
X-Filterd-Recvd-Size: 3665
Message-ID: <1412300487.3247.91.camel@joe-AO725>
Subject: Re: [PATCH] Fixed all coding style issues for
 drivers/staging/media/lirc/
From: Joe Perches <joe@perches.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Amber Thrall <amber.rose.thrall@gmail.com>, jarod@wilsonet.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 18:41:27 -0700
In-Reply-To: <542DE6B5.1060906@iki.fi>
References: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
	 <20141002102938.2b762583@recife.lan> <1412268351.3247.68.camel@joe-AO725>
	 <542DE6B5.1060906@iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 02:58 +0300, Antti Palosaari wrote:
> On 10/02/2014 07:45 PM, Joe Perches wrote:
> > On Thu, 2014-10-02 at 10:29 -0300, Mauro Carvalho Chehab wrote:
> >> Em Wed, 01 Oct 2014 21:40:02 -0700 Amber Thrall <amber.rose.thrall@gmail.com> escreveu:
> >>> Fixed various coding style issues, including strings over 80 characters long and many
> >>> deprecated printk's have been replaced with proper methods.
> > []
> >>> diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
> > []
> >>> @@ -623,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
> >>>   	if (debug) {
> >>>   		dev_info(dev, "raw packet: ");
> >>>   		for (i = 0; i < len; ++i)
> >>> -			printk("%02x ", buf[i]);
> >>> -		printk("\n");
> >>> +			dev_info(dev, "%02x ", buf[i]);
> >>> +		dev_info(dev, "\n");
> >>>   	}
> >>
> >> This is wrong, as the second printk should be printk_cont.
> >>
> >> The best here would be to change all above to use %*ph.
> >> So, just:
> >>
> >> 	dev_debug(dev, "raw packet: %*ph\n", len, buf);
> >
> > Not quite.
> >
> > %*ph is length limited and only useful for lengths < 30 or so.
> > Even then, it's pretty ugly.
> >
> > print_hex_dump_debug() is generally better.
> 
> That is place where you print 8 debug bytes, which are received remote 
> controller code. IMHO %*ph format is just what you like in that case.

Hi Antti.

I stand by my statement as I only looked at the
patch snippet itself, not any function real code.

In the actual code, there's a test above it:

	if (len != 8) {
		dev_warn(dev, "imon %s: invalid incoming packet size (len = %d, intf%d)\n",
			__func__, len, intf);
		return;
	}

So in my opinion, this would be better/smaller as:

	dev_dbg(dev, "raw packet: %8ph\n", urb->transfer_buffer);

> Why print_hex_dump_debug() is better? IIRC it could not be even 
> controlled like those dynamic debug printings.

Nope, it is. (from printk.h)

#if defined(CONFIG_DYNAMIC_DEBUG)
#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
			     groupsize, buf, len, ascii)	\
	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
			 groupsize, buf, len, ascii)
#else
#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,		\
			     groupsize, buf, len, ascii)		\
	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
		       groupsize, buf, len, ascii)
#endif /* defined(CONFIG_DYNAMIC_DEBUG) */

It prints multiple lines when the length is > 16.
It prints the ascii along with the hex if desired.

cheers, Joe

