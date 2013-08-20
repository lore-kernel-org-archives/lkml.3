Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3HTRPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:15:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3HTRPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:15:19 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Hl3G0_NUOaAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Zs1hDUIlwvQA:10 a=3nbZYyFuAAAA:8 a=8JalM-NcBhEenCMidGEA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 13:15:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 05/11] [CLEANUP] trace-cmd: Split out the connect
 waiting loop from do_listen()
Message-ID: <20130820131517.73d2b8a8@gandalf.local.home>
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

Just an FYI, and I don't really care too much. But my personal
preference, is to only join variables that are being used the same way.
That is, multiple file descriptors sure:

	int sfd, s, cfd;

But I prefer to keep file descriptors separate from pid.

	int cfd;
	int pid;

But as I said, this is only a preference and I don't really care that
much about it to even bother to change the patch.

-- Steve
