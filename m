Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3HTRtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:49:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3HTRtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:49:04 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=WWWfXbpW1U4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=G5Vss12qNGkA:10 a=3nbZYyFuAAAA:8 a=qvKfzsYS1eiJEvllE8MA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=VKV9jnB5HeBIhUuT:21 a=e5d2Wlg_k4ukIKWG:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 13:49:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 07/11] [CLEANUP] trace-cmd: Split out binding a port
 and fork reader from open_udp()
Message-ID: <20130820134902.3a06e4d0@gandalf.local.home>
In-Reply-To: <20130819094637.26597.35505.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130819094637.26597.35505.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 18:46:37 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Split out binding a port and fork reader from open_udp() for avoiding duplicate
> codes between listen mode and virt-server mode.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> ---
>  trace-listen.c |   34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/trace-listen.c b/trace-listen.c
> index f29dd35..bf9ef9d 100644
> --- a/trace-listen.c
> +++ b/trace-listen.c
> @@ -228,13 +228,12 @@ static void process_udp_child(int sfd, const char *host, const char *port,
>  #define START_PORT_SEARCH 1500
>  #define MAX_PORT_SEARCH 6000
>  
> -static int open_udp(const char *node, const char *port, int *pid,
> -		    int cpu, int pagesize, int start_port)
> +static int udp_bind_a_port(int start_port, int *sfd)
>  {
>  	struct addrinfo hints;
>  	struct addrinfo *result, *rp;
> -	int sfd, s;
>  	char buf[BUFSIZ];
> +	int s;
>  	int num_port = start_port;
>  
>   again:
> @@ -250,15 +249,15 @@ static int open_udp(const char *node, const char *port, int *pid,
>  		pdie("getaddrinfo: error opening udp socket");
>  
>  	for (rp = result; rp != NULL; rp = rp->ai_next) {
> -		sfd = socket(rp->ai_family, rp->ai_socktype,
> -			     rp->ai_protocol);
> -		if (sfd < 0)
> +		*sfd = socket(rp->ai_family, rp->ai_socktype,
> +			      rp->ai_protocol);
> +		if (*sfd < 0)
>  			continue;
>  
> -		if (bind(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
> +		if (bind(*sfd, rp->ai_addr, rp->ai_addrlen) == 0)
>  			break;
>  
> -		close(sfd);
> +		close(*sfd);
>  	}
>  
>  	if (rp == NULL) {
> @@ -270,6 +269,12 @@ static int open_udp(const char *node, const char *port, int *pid,
>  
>  	freeaddrinfo(result);
>  
> +	return num_port;
> +}
> +
> +static void fork_udp_reader(int sfd, const char *node, const char *port,
> +			    int *pid, int cpu, int pagesize)
> +{
>  	*pid = fork();
>  
>  	if (*pid < 0)
> @@ -279,6 +284,19 @@ static int open_udp(const char *node, const char *port, int *pid,
>  		process_udp_child(sfd, node, port, cpu, pagesize);
>  
>  	close(sfd);
> +}
> +
> +static int open_udp(const char *node, const char *port, int *pid,
> +		    int cpu, int pagesize, int start_port)
> +{
> +	int sfd;
> +	int num_port;
> +
> +	num_port = udp_bind_a_port(start_port, &sfd);
> +	if (num_port < 0)
> +		return num_port;

I don't see how num_port could be less than zero.

-- Steve

> +
> +	fork_udp_reader(sfd, node, port, pid, cpu, pagesize);
>  
>  	return num_port;
>  }

