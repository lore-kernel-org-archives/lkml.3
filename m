Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3HOKpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:45:21 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39127 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579Ab3HOKpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:45:20 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367964000"; 
   d="scan'208";a="29428161"
Date: Thu, 15 Aug 2013 12:45:17 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Wolfram Sang <wsa@the-dreams.de>
cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr
Subject: Re: [PATCH] scripts/coccinelle/api: remove
 devm_request_and_ioremap.cocci
In-Reply-To: <1376562633-16204-1-git-send-email-wsa@the-dreams.de>
Message-ID: <alpine.DEB.2.02.1308151245040.2958@localhost6.localdomain6>
References: <1376562633-16204-1-git-send-email-wsa@the-dreams.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>

On Thu, 15 Aug 2013, Wolfram Sang wrote:

> Use of this function is discouraged in favour of
> devm_ioremap_resource(). Don't advertise it.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  .../coccinelle/api/devm_request_and_ioremap.cocci  |  105 --------------------
>  1 file changed, 105 deletions(-)
>  delete mode 100644 scripts/coccinelle/api/devm_request_and_ioremap.cocci
> 
> diff --git a/scripts/coccinelle/api/devm_request_and_ioremap.cocci b/scripts/coccinelle/api/devm_request_and_ioremap.cocci
> deleted file mode 100644
> index 562ec88..0000000
> --- a/scripts/coccinelle/api/devm_request_and_ioremap.cocci
> +++ /dev/null
> @@ -1,105 +0,0 @@
> -/// Reimplement a call to devm_request_mem_region followed by a call to ioremap
> -/// or ioremap_nocache by a call to devm_request_and_ioremap.
> -/// Devm_request_and_ioremap was introduced in
> -/// 72f8c0bfa0de64c68ee59f40eb9b2683bffffbb0.  It makes the code much more
> -/// concise.
> -///
> -///
> -// Confidence: High
> -// Copyright: (C) 2011 Julia Lawall, INRIA/LIP6.  GPLv2.
> -// Copyright: (C) 2011 Gilles Muller, INRIA/LiP6.  GPLv2.
> -// URL: http://coccinelle.lip6.fr/
> -// Comments:
> -// Options: --no-includes --include-headers
> -
> -virtual patch
> -virtual org
> -virtual report
> -virtual context
> -
> -@nm@
> -expression myname;
> -identifier i;
> -@@
> -
> -struct platform_driver i = { .driver = { .name = myname } };
> -
> -@depends on patch@
> -expression dev,res,size;
> -@@
> -
> --if (!devm_request_mem_region(dev, res->start, size,
> --                              \(res->name\|dev_name(dev)\))) {
> --   ...
> --   return ...;
> --}
> -... when != res->start
> -(
> --devm_ioremap(dev,res->start,size)
> -+devm_request_and_ioremap(dev,res)
> -|
> --devm_ioremap_nocache(dev,res->start,size)
> -+devm_request_and_ioremap(dev,res)
> -)
> -... when any
> -    when != res->start
> -
> -// this rule is separate from the previous one, because a single file can
> -// have multiple values of myname
> -@depends on patch@
> -expression dev,res,size;
> -expression nm.myname;
> -@@
> -
> --if (!devm_request_mem_region(dev, res->start, size,myname)) {
> --   ...
> --   return ...;
> --}
> -... when != res->start
> -(
> --devm_ioremap(dev,res->start,size)
> -+devm_request_and_ioremap(dev,res)
> -|
> --devm_ioremap_nocache(dev,res->start,size)
> -+devm_request_and_ioremap(dev,res)
> -)
> -... when any
> -    when != res->start
> -
> -
> -@pb depends on org || report || context@
> -expression dev,res,size;
> -expression nm.myname;
> -position p1,p2;
> -@@
> -
> -*if
> -  (!devm_request_mem_region@p1(dev, res->start, size,
> -                              \(res->name\|dev_name(dev)\|myname\))) {
> -   ...
> -   return ...;
> -}
> -... when != res->start
> -(
> -*devm_ioremap@p2(dev,res->start,size)
> -|
> -*devm_ioremap_nocache@p2(dev,res->start,size)
> -)
> -... when any
> -    when != res->start
> -
> -@script:python depends on org@
> -p1 << pb.p1;
> -p2 << pb.p2;
> -@@
> -
> -cocci.print_main("INFO: replace by devm_request_and_ioremap",p1)
> -cocci.print_secs("",p2)
> -
> -@script:python depends on report@
> -p1 << pb.p1;
> -p2 << pb.p2;
> -@@
> -
> -msg = "INFO: devm_request_mem_region followed by ioremap on line %s can be replaced by devm_request_and_ioremap" % (p2[0].line)
> -coccilib.report.print_report(p1[0],msg)
> -- 
> 1.7.10.4
> 
> 
