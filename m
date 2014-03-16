Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaCPQgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:36:25 -0400
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:38045 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755076AbaCPQgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:36:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4321:5007:7652:7903:9040:10004:10400:10848:11026:11473:11658:11914:12043:12296:12517:12519:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: word88_71d98eaa1c21e
X-Filterd-Recvd-Size: 1814
Message-ID: <1394987781.5689.23.camel@joe-AO722>
Subject: Re: [char-misc-next 2/5] mei: use cl_dbg where appropriate
From: Joe Perches <joe@perches.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 09:36:21 -0700
In-Reply-To: <1394973358-21690-3-git-send-email-tomas.winkler@intel.com>
References: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
	 <1394973358-21690-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 14:35 +0200, Tomas Winkler wrote:
> use cl_dbg for debug log messages in cl context

I think all the uses of cl_dbg and cl_err are odd.

from: client.h

#define cl_dbg(dev, cl, format, arg...) \
	dev_dbg(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)

#define cl_err(dev, cl, format, arg...) \
	dev_err(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)

dev is always passed separately from cl but
dev is set like:

	struct mei_device *dev;
[]
	dev = cl->dev;

So I think these should be converted to:

#define cl_dbg(cl, format, ...) \
	dev_dbg(&(cl)->dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##__VA_ARGS__)

and the uses from (as an example):

client.c:942:			cl_dbg(dev, cl, "Waking up reading client!\n");

to

client.c:942:			cl_dbg(cl, "Waking up reading client!\n");

This can also remove some used once declarations of dev

