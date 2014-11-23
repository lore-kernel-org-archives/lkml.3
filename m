Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaKWNPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 08:15:41 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33030 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbaKWNPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 08:15:39 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109083657"
Date: Sun, 23 Nov 2014 14:15:37 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: Jaroslav Kysela <perex@perex.cz>, kernel-janitors@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] fix error return code
In-Reply-To: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <alpine.DEB.2.02.1411231415030.2261@localhost6.localdomain6>
References: <1416746890-22719-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops!!!  These are ancient patches.  I meant to send something else.  
Sorry for the noise.

julia

On Sun, 23 Nov 2014, Julia Lawall wrote:

> These patches fix cases where the return code appears to be unintentially
> nonnegative.
> 
> The complete semantic match that finds the problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @ok exists@
> identifier f,ret,i;
> expression e;
> constant c;
> @@
> 
> f(...) {
> <+...
> (
> return -c@i;
> |
> ret = -c@i;
> ... when != ret = e
> return ret;
> |
> if (ret < 0) { ... return ret; }
> )
> ...+> }
> 
> @r exists@
> identifier ret,l,ok.f;
> expression e1,e2,e3;
> statement S;
> position p1,p2,p3;
> @@
> 
> f(...) {
> ... when any
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> (
>  if (<+... ret = e3 ...+>) S
> |
>  if (<+... &ret ...+>) S
> |
> if@p2(...)
>  {
>   ... when != ret = e2
>       when forall
>  return@p3 ret;
> }
> )
> ... when any
> }
> 
> @bad exists@
> position r.p1,r.p2;
> statement S1,S2;
> identifier r.ret;
> expression e1;
> @@
> 
> (
> if@p1 (\(ret < 0\|ret != 0\)) S1
> |
> ret@p1 = 0
> )
> ... when any
> ret = e1
> ... when any
> if@p2(...) S2
> 
> @bad2@
> position r.p1,r.p2;
> identifier r.ret;
> expression e1;
> statement S2;
> @@
> 
> ret@p1 = 0
> ... when != if (...) { ... ret = e1 ... return ret; }
>     when any
> if@p2(...) S2
> 
> 
> @script:python depends on !bad && !bad2@
> p1 << r.p1;
> p2 << r.p2;
> p3 << r.p3;
> @@
> 
> cocci.print_main("",p1)
> cocci.print_secs("",p2)
> cocci.print_secs("",p3)
> // </smpl>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
