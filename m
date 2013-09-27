Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3I0Pk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:40:56 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:53101 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752155Ab3I0Pky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:40:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3874:4321:5007:6119:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12663:12740:13069:13095:13160:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steel00_41ca83f83f611
X-Filterd-Recvd-Size: 2430
Message-ID: <1380296451.17366.116.camel@joe-AO722>
Subject: Re: [PATCH] RFC: Introduce FW_INFO* functions
From: Joe Perches <joe@perches.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
Date: Fri, 27 Sep 2013 08:40:51 -0700
In-Reply-To: <1380288157-25248-1-git-send-email-prarit@redhat.com>
References: <1380288157-25248-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 09:22 -0400, Prarit Bhargava wrote:
> I'm proposing with this patch to do something similar to the WARN()
> mechanism that is currently implemented in the kernel.  This
> patchset introduces FW_INFO() and FW_INFO_DEV() which logs output

My first thought was "how ugly".
There must be a better way than scraping dmesg output.

> diff --git a/kernel/panic.c b/kernel/panic.c
[]
> @@ -445,6 +446,29 @@ void warn_slowpath_fmt_taint(const char *file, int line,
>  }
>  EXPORT_SYMBOL(warn_slowpath_fmt_taint);
>  
> +void warn_slowpath_fmt_dev(const char *file, int line,
> +			   struct device *dev, const char *fmt, ...)
> +{
> +	struct slowpath_args args;
> +
> +	pr_info("[Firmware Info]: ");
> +	if (dev)
> +		pr_cont("%s %s: ",
> +			dev_driver_string(dev), dev_name(dev));
> +	pr_cont("at %s:%d ", file, line);
> +
> +	args.fmt = fmt;
> +	va_start(args.args, fmt);
> +	vprintk(args.fmt, args.args);
> +	va_end(args.args);
> +	if (dump_hardware_arch_desc())
> +		pr_info("[Firmware Info]: %s\n", dump_hardware_arch_desc());
> +	else
> +		pr_info("[Firmware Info]: Hardware Unidentified\n");
> +}
> +EXPORT_SYMBOL(warn_slowpath_fmt_dev);

This bit should just use %pV and a single printk to
avoid any possible message interleaving.

{
	struct va_format vaf;
	va_list args;

	va_start(args, fmt)

	vaf.fmt = fmt;
	vaf.va = &args;

	if (dev)
		pr_info("[Firmware Info]: %s %s at %s:%d %pV",
			dev_driver_string(dev), dev_name(dev),
			file, line, &vaf);
	else
		pr_info("[Firmware Info]: at %s:%d %pV",
			file, line, &vaf);

	etc...


