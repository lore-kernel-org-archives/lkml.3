Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaEHUyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:54:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaEHUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:54:05 -0400
Date: Thu, 8 May 2014 13:54:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH V2] kernel/res_counter.c: replace simple_strtoull by
 kstrtoull
Message-Id: <20140508135404.8e836ca4be368fd60d3b08e7@linux-foundation.org>
In-Reply-To: <20140508190043.19dc5b4c127b5566b087eea6@skynet.be>
References: <20140508190043.19dc5b4c127b5566b087eea6@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014 19:00:43 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> ...
>
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -186,8 +186,8 @@ int res_counter_memparse_write_strategy(const char *buf,
>  
>  	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
>  	if (*buf == '-') {
> -		res = simple_strtoull(buf + 1, &end, 10);
> -		if (res != 1 || *end != '\0')
> +		int rc = kstrtoull(buf + 1, 10, &res);
> +		if ((res != 1) || rc)
>  			return -EINVAL;
>  		*resp = RES_COUNTER_MAX;

Two more things!

- there should be a newline after definitions, before code.

- we shouldn't overwrite the kstrtoull() return value.  In this case it
  might have returned -ERANGE but this code will replace that with EINVAL.

--- a/kernel/res_counter.c~kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix
+++ a/kernel/res_counter.c
@@ -189,7 +189,10 @@ int res_counter_memparse_write_strategy(
 	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
 	if (*buf == '-') {
 		int rc = kstrtoull(buf + 1, 10, &res);
-		if ((res != 1) || rc)
+
+		if (rc)
+			return rc;	
+		if (res != 1)
 			return -EINVAL;
 		*resp = RES_COUNTER_MAX;
 		return 0;
_

