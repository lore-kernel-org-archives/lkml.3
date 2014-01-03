Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaACQBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:01:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaACQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:01:41 -0500
Message-ID: <52C6DEE0.20600@suse.cz>
Date: Fri, 03 Jan 2014 17:01:36 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Emil Medve <Emilian.Medve@Freescale.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix silent builds with make-4
References: <1386280583-2735-1-git-send-email-Emilian.Medve@Freescale.com>
In-Reply-To: <1386280583-2735-1-git-send-email-Emilian.Medve@Freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-05 22:56, Emil Medve wrote:
> make-4 changed the way/order it presents the command line options
> into MAKEFLAGS
> 
> In make-3.8x, '-s' would always be first into a group of options
> with the '-'/hyphen removed
> 
> $ make -p -s 2>/dev/null | grep ^MAKEFLAGS
> MAKEFLAGS = sp
> 
> In make-4, '-s' seems to always be last into a group of options
> with the '-'/hyphen removed
> 
> $ make -s -p 2>/dev/null | grep ^MAKEFLAGS
> MAKEFLAGS = ps
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> ---
>  Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 2c88e44..0332949 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -311,9 +311,15 @@ endif
>  # If the user is running make -s (silent mode), suppress echoing of
>  # commands
>  
> +ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
> +ifneq ($(filter %s -s%,$(MAKEFLAGS)),)

The -s% here is unnecessary for two reasons: as you say, s is always at
the end with make 4, and even if a long option is used, the hyphen is
omitted:

3.82:
$ make -s -p --no-print-directory | grep MAKEFLAGS
MAKEFLAGS =  --no-print-directory -sp
$ ./make/make -s -p --no-print-directory | grep MAKEFLAGS
GNUMAKEFLAGS :=
MAKEFLAGS = ps --no-print-directory

And according to
http://git.savannah.gnu.org/cgit/make.git/commit/?id=a674abe702cc0c017209a3186c32df050ff21f41,
the space character is always there, even if there are no single-letter
options. So we can do something like

ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)

and avoid accidentally matching things like --debug=jobs. Does the above
work for you?

Michal
