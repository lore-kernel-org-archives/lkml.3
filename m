Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3JaWw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:52:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3JaWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:52:55 -0400
Date: Thu, 31 Oct 2013 15:52:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Du, Changbin" <changbin.du@gmail.com>
Cc: jbaron@akamai.com, joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dynamic_debug: add wildcard support to filter
 files/functions/modules
Message-Id: <20131031155253.79a21d6a126be11a64153d8b@linux-foundation.org>
In-Reply-To: <1382974150-7392-1-git-send-email-changbin.du@gmail.com>
References: <51F73A17.2090208@akamai.com>
	<1382974150-7392-1-git-send-email-changbin.du@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 23:29:10 +0800 "Du, Changbin" <changbin.du@gmail.com> wrote:

> This patch add wildcard '*'(matches zero or more characters) and '?'
> (matches one character) support when qurying debug flags.
> 
> Now we can open debug messages using keywords. eg:
> 1. open debug logs in all usb drivers
>     echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
> 2.  open debug logs for usb xhci code
>     echo "file *xhci* +p" > <debugfs>/dynamic_debug/control

This patch would be a lot easier to understand (and hence review) if
you had remembered to update Documentation/dynamic-debug-howto.txt!

> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -127,6 +127,41 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
>  		 query->first_lineno, query->last_lineno);
>  }
>  
> +/* check if the string matches given pattern which includes wildcards */
> +static int match_pattern(const char *pattern, const char *string)

No, something like this should be in lib/ so that other callers can use
it.  We already have at least one copy handy in
drivers/ata/libata-core.c:glob_match().  A better approach would be to
move that glob_match() into lib/glob_match.c then teach dynamic_debug
to use it.

There are probably other private globbing functions lying around the
kernel, but it's rather a hard thing to grep for...
