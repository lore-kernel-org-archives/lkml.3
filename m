Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3LLOp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:45:26 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:35502 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3LLOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:45:22 -0500
Date: Thu, 12 Dec 2013 11:21:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Anton Blanchard <anton@samba.org>
Cc: cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, mpe@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf symbols: symbol-minimal.c causes random fd to be
 closed
Message-ID: <20131212142121.GA8164@ghostprotocols.net>
References: <20131212134725.4dacdd06@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212134725.4dacdd06@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 12, 2013 at 01:47:25PM +1100, Anton Blanchard escreveu:
> 
> I hit a cryptic failure when testing a recent version
> of perf:
> 
>   # perf report
>   write failure on standard output: Bad file descriptor
> 
> The issue is in commit b68e2f91 (perf symbols: Introduce symsrc
> structure). symsrc__destroy() does a close(ss->fd) but
> ss->fd is only initialised in the symbol-elf.c case and
> not for symbol-minimal.c.
> 
> The issue has been around for a while however most people
> will build with libelf which wont use the symbol-minimal.c
> code.
> 
> Cc: stable@vger.kernel.org # v3.8+
> Signed-off-by: Anton Blanchard <anton@samba.org>

This was fixed recently, yeah, should go to stable as well:

commit 779e24e2c777bffa9a6e3d5e821859e67008c98b
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Wed Dec 4 16:23:01 2013 +0200

    perf symbols: Fix random fd closing with no libelf

> ---
> 
> diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
> index 2d2dd05..3528204 100644
> --- a/tools/perf/util/symbol-minimal.c
> +++ b/tools/perf/util/symbol-minimal.c
> @@ -254,6 +254,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso __maybe_unused,
>  		goto out_close;
>  
>  	ss->type = type;
> +	ss->fd = fd;
>  
>  	return 0;
>  out_close:
