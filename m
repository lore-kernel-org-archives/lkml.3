Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3HTRSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:18:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3HTRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:18:16 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Hl3G0_NUOaAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Zs1hDUIlwvQA:10 a=3nbZYyFuAAAA:8 a=oCcaPWc0AAAA:8 a=8JalM-NcBhEenCMidGEA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 13:18:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 05/11] [CLEANUP] trace-cmd: Split out the connect
 waiting loop from do_listen()
Message-ID: <20130820131815.6555e730@gandalf.local.home>
In-Reply-To: <20130819094632.26597.59570.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130819094632.26597.59570.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 18:46:32 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Split out the connect waiting loop from do_listen() for avoiding duplicate codes
> between listen mode and virt-server mode.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> ---
>  trace-listen.c |   45 ++++++++++++++++++++++++++-------------------
>  1 file changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/trace-listen.c b/trace-listen.c
> index 6c1bcac..c741fa4 100644
> --- a/trace-listen.c
> +++ b/trace-listen.c
> @@ -580,14 +580,35 @@ static void clean_up(int sig)
>  	} while (ret > 0);
>  }
>  
> +static void do_accept_loop(int sfd)
> +{
> +	struct sockaddr_storage peer_addr;
> +	socklen_t peer_addr_len;
> +	int cfd, pid;
> +
> +	peer_addr_len = sizeof(peer_addr);
> +
> +	do {
> +		cfd = accept(sfd, (struct sockaddr *)&peer_addr,
> +			     &peer_addr_len);

I'm also not that strict on the 80 character limit. This is fine, but
so is one line. If you go over a few characters, it's not the end of
the world. Like, by joining this line, it's only 81 characters.

-- Steve

> +		printf("connected!\n");
> +		if (cfd < 0 && errno == EINTR)
> +			continue;
> +		if (cfd < 0)
> +			pdie("connecting");
> +
> +		pid = do_connection(cfd, &peer_addr, peer_addr_len);
> +		if (pid > 0)
> +			add_process(pid);
> +
> +	} while (!done);

