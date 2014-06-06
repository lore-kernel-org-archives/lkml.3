Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaFFPmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbaFFPmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:42:40 -0400
Date: Fri, 6 Jun 2014 11:42:31 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: net: llc: NULL ptr deref in llc_ui_sendmsg
Message-ID: <20140606154231.GA7629@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <5391D971.4030001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5391D971.4030001@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:08:33AM -0400, Sasha Levin wrote:
 > Hi all,
 > 
 > While fuzzing with trinity inside a KVM tools guest running the latest -next
 > kernel I've stumbled on the following spew:
 > 
 > [  269.531162] BUG: unable to handle kernel NULL pointer dereference at 000000000000021e
 > [  269.531217] IP: llc_ui_sendmsg (net/llc/af_llc.c:912)

 905         /* must bind connection to sap if user hasn't done it. */
 906         if (sock_flag(sk, SOCK_ZAPPED)) {
 907                 /* bind to sap with null dev, exclusive. */
 908                 rc = llc_ui_autobind(sock, addr);
 909                 if (rc)
 910                         goto release;
 911         }
 912         hdrlen = llc->dev->hard_header_len + llc_ui_header_len(sk, addr);

looks like llc->dev was null, (understandable, given Trinity doesn't really know
how to set up llc beyond random socket()/setsockopt() calls).

llc_ui_autobind returns -ENODEV in that case, so it looks like the SOCK_ZAPPED test
was false. Something like the patch below maybe ? It feels ugly to be duplicating that
test there, but if this is agreed upon I'll resubmit this properly.

	Dave

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 0080d2b0a8ae..9b192db9883b 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -908,6 +908,11 @@ static int llc_ui_sendmsg(struct kiocb *iocb, struct socket *sock,
 		rc = llc_ui_autobind(sock, addr);
 		if (rc)
 			goto release;
+	} else {
+		if (!llc->dev) {
+			rc = -ENODEV;
+			goto release;
+		}
 	}
 	hdrlen = llc->dev->hard_header_len + llc_ui_header_len(sk, addr);
 	size = hdrlen + len;
