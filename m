Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaKPTbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:31:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:43983 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751435AbaKPTbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:31:43 -0500
Date: Sun, 16 Nov 2014 14:31:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 2/2] kernel-trace: Less calls for iput() in
 create_trace_uprobe() after error detection
Message-ID: <20141116143120.44421df2@gandalf.local.home>
In-Reply-To: <5468F96E.4090903@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5468ABBD.6000903@users.sourceforge.net>
	<alpine.DEB.2.10.1411161656340.2364@hadrien>
	<5468F756.8070807@users.sourceforge.net>
	<5468F96E.4090903@users.sourceforge.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2014 20:22:22 +0100
SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 16 Nov 2014 19:49:39 +0100
> 
> The iput() function was called in three cases by the create_trace_uprobe()
> function during error handling even if the passed variable contained still
> a null pointer. This implementation detail could be improved by the
> introduction of another jump label.

The first patch is fine, and the only reason is to save the few bytes
that the branch check might take. It's in a path that is unlikely to be
hit so it is not a performance issue at all.

This patch is useless. I rather not apply any patch than to create
another jump that skips over the freeing of iput() just because we know
inode is null. That's why we had the if (inode) in the first place.

So Nack on this patch and I'll contemplate applying the first one. I
probably will as it seems rather harmless.

Thanks,

-- Steve


> 
> Suggested-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  kernel/trace/trace_uprobe.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index ec002c0..a0288f2 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -434,19 +434,24 @@ static int create_trace_uprobe(int argc, char **argv)
>  	arg = strchr(argv[1], ':');
>  	if (!arg) {
>  		ret = -EINVAL;
> -		goto fail_address_parse;
> +		goto fail_address_parse2;
>  	}
>  
>  	*arg++ = '\0';
>  	filename = argv[1];
>  	ret = kern_path(filename, LOOKUP_FOLLOW, &path);
>  	if (ret)
> -		goto fail_address_parse;
> +		goto fail_address_parse2;
>  
>  	inode = igrab(path.dentry->d_inode);
>  	path_put(&path);
>  
> -	if (!inode || !S_ISREG(inode->i_mode)) {
> +	if (!inode) {
> +		ret = -EINVAL;
> +		goto fail_address_parse2;
> +	}
> +
> +	if (!S_ISREG(inode->i_mode)) {
>  		ret = -EINVAL;
>  		goto fail_address_parse;
>  	}
> @@ -554,6 +559,7 @@ error:
>  fail_address_parse:
>  	iput(inode);
>  
> +fail_address_parse2:
>  	pr_info("Failed to parse address or file.\n");
>  
>  	return ret;

