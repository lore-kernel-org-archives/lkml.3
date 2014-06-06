Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaFFRxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:53:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45128 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaFFRxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:53:12 -0400
Message-ID: <5391FFFE.8000100@oracle.com>
Date: Fri, 06 Jun 2014 13:53:02 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: net: llc: NULL ptr deref in llc_ui_sendmsg
References: <5391D971.4030001@oracle.com> <20140606154231.GA7629@redhat.com>
In-Reply-To: <20140606154231.GA7629@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 11:42 AM, Dave Jones wrote:
> On Fri, Jun 06, 2014 at 11:08:33AM -0400, Sasha Levin wrote:
>  > Hi all,
>  > 
>  > While fuzzing with trinity inside a KVM tools guest running the latest -next
>  > kernel I've stumbled on the following spew:
>  > 
>  > [  269.531162] BUG: unable to handle kernel NULL pointer dereference at 000000000000021e
>  > [  269.531217] IP: llc_ui_sendmsg (net/llc/af_llc.c:912)
> 
>  905         /* must bind connection to sap if user hasn't done it. */
>  906         if (sock_flag(sk, SOCK_ZAPPED)) {
>  907                 /* bind to sap with null dev, exclusive. */
>  908                 rc = llc_ui_autobind(sock, addr);
>  909                 if (rc)
>  910                         goto release;
>  911         }
>  912         hdrlen = llc->dev->hard_header_len + llc_ui_header_len(sk, addr);
> 
> looks like llc->dev was null, (understandable, given Trinity doesn't really know
> how to set up llc beyond random socket()/setsockopt() calls).
> 
> llc_ui_autobind returns -ENODEV in that case, so it looks like the SOCK_ZAPPED test
> was false. Something like the patch below maybe ? It feels ugly to be duplicating that
> test there, but if this is agreed upon I'll resubmit this properly.

I figured it's something more complicated than that since trinity stumbled on it only
now and I don't see any code changes in that area. I'll test it with the patch.


Thanks,
Sasha
