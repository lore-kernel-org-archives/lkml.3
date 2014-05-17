Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbaEQPoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192AbaEQPoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:44:38 -0400
Date: Sat, 17 May 2014 17:44:28 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Manuel =?utf-8?Q?Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Cleanup string initializations (char[] instead of
 char *)
Message-ID: <20140517154427.GB1939@mguzik.redhat.com>
References: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 05:00:18PM +0200, Manuel Schölling wrote:
> Initializations like 'char *foo = "bar"' will create two variables: a static
> string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> will declare a single variable and will end up in shorter
> assembly (according to Jeff Garzik on the KernelJanitor's TODO list).
> 

This is a greatly oversimplifying things, this may or may not happen.

Out of curiosity I checked my kernel on x86-64 and it has this
optimized:

0xffffffffa00a9629 <bm_entry_read+121>: movabs $0x203a7367616c66,%rcx
crash> ascii 0x203a7367616c66
00203a7367616c66: flags: <NUL>


>  fs/binfmt_misc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index b605003..2a10529 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -419,7 +419,7 @@ static void entry_status(Node *e, char *page)
>  {
>  	char *dp;
>  	char *status = "disabled";
> -	const char * flags = "flags: ";
> +	const char flags[] = "flags: ";
>  
>  	if (test_bit(Enabled, &e->flags))
>  		status = "enabled";

This particular function would be better of with removing this variable
and replacing all pairs like:
sprintf(dp, ...);
dp += strlen(...)

with:
dp += sprintf(dp, ...);

-- 
Mateusz Guzik
