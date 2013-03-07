Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3CGAVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:21:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3CGAVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:21:36 -0500
Date: Wed, 6 Mar 2013 16:21:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fredrik Gustafsson <iveqy@iveqy.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Prevent use of unitialized variable
Message-Id: <20130306162133.c2b3027c5cf75582d4f84869@linux-foundation.org>
In-Reply-To: <1362354169-13369-1-git-send-email-iveqy@iveqy.com>
References: <1362354169-13369-1-git-send-email-iveqy@iveqy.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Mar 2013 00:42:49 +0100 Fredrik Gustafsson <iveqy@iveqy.com> wrote:

> Run checkpatch.pl -f kernel/fork.c in commit
> ecf02a607bd801e742d7bb35c6e40f7ca15edf03
> and checkpatch.pl will try to use an uninitialized variable.
> This patch fixes that.
> 

This isn't a good description of the problem you're seeing. 
ecf02a607bd801e7 is a merge commit and I see no perl problems running
"perl scripts/checkpatch.pl -f kernel/fork.c" with my setup, so it's
pretty mysterious.

It is best to quote the full error output when fixing errors.

That things work OK for me isn't surprising, as these things are quite
dependent upon the perl version.

> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3363,14 +3363,17 @@ sub process {
>  
>  			my $ms_addr = $2;
>  			my $ms_val = $7;
> -			my $ms_size = $12;
> -
> -			if ($ms_size =~ /^(0x|)0$/i) {
> -				ERROR("MEMSET",
> -				      "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
> -			} elsif ($ms_size =~ /^(0x|)1$/i) {
> -				WARN("MEMSET",
> -				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
> +
> +			if (defined $12) {
> +				my $ms_size = $12;
> +
> +				if ($ms_size =~ /^(0x|)0$/i) {
> +					ERROR("MEMSET",
> +						  "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
> +				} elsif ($ms_size =~ /^(0x|)1$/i) {
> +					WARN("MEMSET",
> +						 "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
> +				}
>  			}
>  		}

