Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3GVQ35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:29:57 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54208 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101Ab3GVQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:29:56 -0400
Message-ID: <1374510594.29650.1.camel@x61.thuisdomein>
Subject: Re: [PATCH 11/48] staging/lustre/ptlrpc: Translate between host and
 network errnos
From: Paul Bolle <pebolle@tiscali.nl>
To: Peng Tao <bergwolf@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Li Wei <wei.g.li@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Date: Mon, 22 Jul 2013 18:29:54 +0200
In-Reply-To: <1374509230-3324-12-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
	 <1374509230-3324-12-git-send-email-bergwolf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2013 16:29:54.0581 (UTC) FILETIME=[B28B5450:01CE86F8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 00:06 +0800, Peng Tao wrote:
> From: Li Wei <wei.g.li@intel.com>
> 
> Lustre puts system errors (e.g., ENOTCONN) on wire as numbers
> essentially specific to senders' architectures.  While this is fine
> for x86-only sites, where receivers share the same error number
> definition with senders, problems will arise, however, for sites
> involving multiple architectures with different error number
> definitions.  For instance, an ENOTCONN reply from a sparc server will
> be put on wire as -57, which, for an x86 client, means EBADSLT
> instead.
> 
> To solve the problem, this patch defines a set of network errors for
> on-wire or on-disk uses.  These errors correspond to a subset of the
> x86 system errors and share the same number definition, maintaining
> compatibility with existing x86 clients and servers.
> 
> Then, either error numbers could be translated at run time, or all
> host errors going on wire could be replaced with network errors in the
> code.  This patch does the former by introducing both generic and
> field-specific translation routines and calling them at proper places,
> so that translations for existing fields are transparent.
> (Personally, I tend to think the latter way might be worthwhile, as it
> is more straightforward conceptually.  Do we really need so many
> different errors?  Should errors returned by kernel routines really be
> passed up and eventually put on wire?  There could even be security
> implications in that.)
> 
> Thank Fujitsu for the original idea and their contributions that make
> this available upstream.
> 
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2743
> Lustre-change: http://review.whamcloud.com/5577
> Signed-off-by: Li Wei <wei.g.li@intel.com>
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> Reviewed-by: Hiroya Nozaki <nozaki.hiroya@jp.fujitsu.com>
> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  drivers/staging/lustre/lustre/Kconfig              |    5 +
>  .../lustre/lustre/include/lustre/lustre_errno.h    |  215 +++++++++++
>  .../lustre/lustre/include/lustre/lustre_idl.h      |    2 +
>  drivers/staging/lustre/lustre/include/lustre_net.h |   32 ++
>  drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    3 +-
>  drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    2 +
>  drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    6 +-
>  drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   10 +
>  drivers/staging/lustre/lustre/mdc/mdc_request.c    |    1 +
>  drivers/staging/lustre/lustre/osc/osc_request.c    |    2 +
>  drivers/staging/lustre/lustre/ptlrpc/Makefile      |    1 +
>  drivers/staging/lustre/lustre/ptlrpc/errno.c       |  382 ++++++++++++++++++++
>  drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |    3 +-
>  .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    3 +
>  14 files changed, 662 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
>  create mode 100644 drivers/staging/lustre/lustre/ptlrpc/errno.c
> 
> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
> index 0a8eb1ad..19a1c33 100644
> --- a/drivers/staging/lustre/lustre/Kconfig
> +++ b/drivers/staging/lustre/lustre/Kconfig
> @@ -59,3 +59,8 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
>  	  expensive checks that may have a performance impact.
>  
>  	  Use with caution. If unsure, say N.
> +
> +config LUSTRE_TRANSLATE_ERRNOS
> +	bool
> +	depends on LUSTRE_FS && !X86
> +	default true

Did you mean "default y"?


Paul Bolle

